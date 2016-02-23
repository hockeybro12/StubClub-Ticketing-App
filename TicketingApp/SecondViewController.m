//
//  SecondViewController.m
//  TicketingApp
//
//  Created by Nikhil Mehta on 2/19/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import "SecondViewController.h"
#import "API.h"
#import <WatchConnectivity/WatchConnectivity.h>


@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)updateWatch:(id)sender {
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        NSLog(@"Session available");
        [session activateSession];
    }
    
    if ([[WCSession defaultSession] isReachable]) {
        NSLog(@"SESSION REACHABLE");
    }
    
    WCSession *session = [WCSession defaultSession];
    
    
    NSString *sessionUser = [NSString stringWithFormat:@"%d", [[[[API sharedInstance] user] objectForKey:@"IdUser"] intValue]];

    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"ownership",@"command", sessionUser, @"IdUser",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   
                                   //logged out from server
                                   NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:json];
                                   
                                   

                                   NSError *error;
                                   [session updateApplicationContext:json error:&error];

                                   NSLog(@"%@", json);
                                   //[session sendMessageData:myData replyHandler:nil errorHandler:nil];
                                   
                               }];
}

-(IBAction)logout:(id)sender {
    
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"logout",@"command",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   
                                   //logged out from server
                                   [API sharedInstance].user = nil;
                                   [self performSegueWithIdentifier:@"ShowLoginNow" sender:nil];
                               }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
