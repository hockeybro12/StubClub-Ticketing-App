//
//  RequestsStreamScreen.h
//  TicketingApp
//
//  Created by Nikhil Mehta on 2/20/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestsStreamScreen : UITableViewController {
    
    IBOutlet UIBarButtonItem* btnCompose;
    
    IBOutlet UIBarButtonItem *btnRefresh;
    
    NSIndexPath *selectedIndexPath;
    Boolean selectedRow;
    
    UIButton *buyTicket;
}

@property (nonatomic, strong) NSMutableArray *tableData;


@end
