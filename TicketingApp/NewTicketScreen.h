//
//  NewTicketScreen.h
//  TicketingApp
//
//  Created by Nikhil Mehta on 2/20/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTicketScreen : UIViewController {
    
    IBOutlet UITextField *rowNumberField;
    IBOutlet UITextField *seatNumberField;
    IBOutlet UITextField *priceField;
    IBOutlet UITextField *sectionNumberField;
    IBOutlet UILabel *eventNumberLabel;
    
    IBOutlet UIBarButtonItem* btnFinish;
    IBOutlet UISegmentedControl *requestOrSell;

}

@property (nonatomic, strong) NSString *eventCode;

@end
