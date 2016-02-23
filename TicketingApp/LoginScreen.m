//
//  LoginScreen.m
//  TicketingApp
//
//  Created by Nikhil Mehta on 2/19/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import "LoginScreen.h"
#import "API.h"
#include <CommonCrypto/CommonDigest.h>

//salt string to make passwords more difficult to hack
#define kSalt @"adlfu3489tyh2jnkLIUGI&%EV(&0982cbgrykxjnk8855"

@interface LoginScreen ()

@end

@implementation LoginScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [fldUsername becomeFirstResponder];
    fldPassword.secureTextEntry = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)btnLoginRegisterTapped:(UIButton*)sender
{
    //original check
    if (fldUsername.text.length < 4 || fldPassword.text.length < 4) {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username and Password must be longer than 4 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [error show];
        return;
    }
    
    NSString* saltedPassword = [NSString stringWithFormat:@"%@%@", fldPassword.text, kSalt];
    
    //hashedPassword will hold the string of the hashed and salted password
    NSString *hashedPassword = nil;
    //plain C style array to be used as an intermediate storage for hashed data
    unsigned char hashedPasswordData[CC_SHA1_DIGEST_LENGTH];
    
    //hash the password
    //get data bytes from the salted password
    NSData *data = [saltedPassword dataUsingEncoding: NSUTF8StringEncoding];
    if (CC_SHA1([data bytes], [data length], hashedPasswordData)) {
        hashedPassword = [[NSString alloc] initWithBytes:hashedPasswordData length:sizeof(hashedPasswordData) encoding:NSASCIIStringEncoding];
    } else {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password can't be sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [error show];
    }
    
    //check whether it is a login or register
    NSString* command = (sender.tag==1)?@"register":@"login";
    //build the dictionary with username, password, command keys
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:command, @"command", fldUsername.text, @"username", fldPassword.text, @"password", nil];
    
    //make the call to the web api
    [[API sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        //handle response
        //as defined in php, json is a dictionary and holds a result key. fetch another dicitonary from within this key.
        NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
        
        if ([json objectForKey:@"error"]==nil && [[res objectForKey:@"IdUser"] intValue]>0) {
            //success
            [[API sharedInstance] setUser: res];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
            //show message to the user
            [[[UIAlertView alloc] initWithTitle:@"Logged in"
                                        message:[NSString stringWithFormat:@"Welcome %@",[res objectForKey:@"username"] ]
                                       delegate:nil
                              cancelButtonTitle:@"Close"
                              otherButtonTitles: nil] show];
        } else {
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [error show];
        }
    }];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:fldUsername.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:fldPassword.text forKey:@"password"];
    
    
    
    
}

-(IBAction)btnRegisterTapped:(UIButton*)sender {
    
    [self performSegueWithIdentifier:@"ShowRegister" sender:[NSNumber numberWithInt:sender.tag]];
    
}




@end
