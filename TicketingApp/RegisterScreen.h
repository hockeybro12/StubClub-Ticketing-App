//
//  RegisterScreen.h
//  TicketingApp
//
//  Created by Nikhil Mehta on 2/19/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterScreen : UIViewController {
    
    IBOutlet UITextField* fldUsername;
    IBOutlet UITextField* fldPassword;
    IBOutlet UITextField* fldEmailAddress;
    IBOutlet UITextField* fldCreditCardNumber;
    
}

-(IBAction)btnRegisterTapped:(UIButton*)sender;


@end