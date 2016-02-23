//
//  FirstViewController.m
//  TicketingApp
//
//  Created by Nikhil Mehta on 2/19/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import "FirstViewController.h"
#import "API.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
    
    if (![[API sharedInstance] isAuthorized]) {
        
        [self performSegueWithIdentifier:@"ShowLoginFirst" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
