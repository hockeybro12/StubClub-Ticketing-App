//
//  LoginScreen.h
//  TicketingApp
//
//  Created by Nikhil Mehta on 2/19/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginScreen : UIViewController {
    
    IBOutlet UITextField* fldUsername;
    IBOutlet UITextField* fldPassword;
    
}

-(IBAction)btnLoginRegisterTapped:(id)sender;
-(IBAction)btnRegisterTapped:(UIButton*)sender;

@end
