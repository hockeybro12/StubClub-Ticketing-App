//
//  StreamScreen.h
//  TicketingApp
//
//  Created by Nikhil Mehta on 2/19/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamScreen : UITableViewController {
    
    IBOutlet UIBarButtonItem* btnCompose;
    
    IBOutlet UIBarButtonItem *btnRefresh;
    
    NSIndexPath *selectedIndexPath;
    Boolean selectedRow;
    
    UIButton *buyTicket;

}

@property (nonatomic, strong) NSMutableArray *tableData;



@end
