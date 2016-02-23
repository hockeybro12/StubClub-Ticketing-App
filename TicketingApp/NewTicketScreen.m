//
//  NewTicketScreen.m
//  TicketingApp
//
//  Created by Nikhil Mehta on 2/20/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import "NewTicketScreen.h"
#import "API.h"

@interface NewTicketScreen ()

@end

@implementation NewTicketScreen
@synthesize eventCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    eventNumberLabel.text = eventCode;
    

    
    btnFinish = [[UIBarButtonItem alloc] initWithTitle:@"Finish" style:UIBarButtonItemStylePlain target:self action:@selector(sendRequest)];
    
    
    self.navigationItem.rightBarButtonItem = btnFinish;
    // Do any additional setup after loading the view.
}

-(void)sendRequest {
    NSString *session = [NSString stringWithFormat:@"%d", [[[[API sharedInstance] user] objectForKey:@"IdUser"] intValue]];
    
    NSString *part = [requestOrSell titleForSegmentAtIndex:requestOrSell.selectedSegmentIndex];

    if (rowNumberField.text && rowNumberField.text.length > 0 && seatNumberField.text.length > 0 && priceField.text.length > 0 && sectionNumberField.text.length > 0 && ([part isEqualToString:@"Selling"])) {
        [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"upload", @"command", eventCode, @"EventCode", sectionNumberField.text, @"SectionNumber", seatNumberField.text, @"SeatNumber", rowNumberField.text, @"RowNumber", priceField.text, @"Price", session, @"IdUser", nil] onCompletion:^(NSDictionary *json){
            //completion
            if (![json objectForKey:@"error"]) {
                [[[UIAlertView alloc]initWithTitle:@"Success!"
                                           message:@"Your ticket has been posted"
                                          delegate:nil
                                 cancelButtonTitle:@"Yay!"
                                 otherButtonTitles: nil] show];
            } else {
                
                NSLog(@"Hello");
                NSString *errorMsg = [json objectForKey:@"error"];
                [[[UIAlertView alloc]initWithTitle:@"Error!"
                                           message:errorMsg
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles: nil] show];
                if ([@"Authorization required" compare:errorMsg]== NSOrderedSame) {
                    [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
                }
            }
        }];
    } else if (priceField.text.length > 0 && sectionNumberField.text.length > 0 && ([part isEqualToString:@"Requesting"])) {
        [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"requestUpload", @"command", eventCode, @"EventCode", sectionNumberField.text, @"SectionNumber", priceField.text, @"Price", session, @"IdUser", nil] onCompletion:^(NSDictionary *json){
            //completion
            if (![json objectForKey:@"error"]) {
                [[[UIAlertView alloc]initWithTitle:@"Success!"
                                           message:@"Your ticket request has been posted"
                                          delegate:nil
                                 cancelButtonTitle:@"Yay!"
                                 otherButtonTitles: nil] show];
            } else {
                
                NSLog(@"Hello");
                NSString *errorMsg = [json objectForKey:@"error"];
                [[[UIAlertView alloc]initWithTitle:@"Error!"
                                           message:errorMsg
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles: nil] show];
                if ([@"Authorization required" compare:errorMsg]== NSOrderedSame) {
                    [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
                }
            }
        }];
    } else {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some text field is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [error show];
    }
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

@end
