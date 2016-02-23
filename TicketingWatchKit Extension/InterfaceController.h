//
//  InterfaceController.h
//  TicketingWatchKit Extension
//
//  Created by Nikhil Mehta on 2/21/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>


@interface InterfaceController : WKInterfaceController <WCSessionDelegate> {
    NSMutableArray *tableData;
}

@property (strong, nonatomic) IBOutlet WKInterfaceTable *watchKitTable;

@end
