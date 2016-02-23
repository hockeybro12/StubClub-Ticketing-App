//
//  InterfaceController.m
//  TicketingWatchKit Extension
//
//  Created by Nikhil Mehta on 2/21/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import "InterfaceController.h"
//#import "API.h"
#import "SellingViewController.h"


@interface InterfaceController()

@end


@implementation InterfaceController
@synthesize watchKitTable;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    [super willActivate];
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        
    }
    
    
    
}

- (void) session:(nonnull WCSession *)session didReceiveApplicationContext:(nonnull NSDictionary<NSString *,id> *)applicationContext {
    
    NSArray *resultArray = [applicationContext objectForKey:@"result"];
    tableData = [[NSMutableArray alloc] initWithArray:resultArray];
    
    [self configureTableWithData:tableData];
    
    
    //NSString *item1 = [applicationContext objectForKey:@"firstItem"];
    //int item2 = [[applicationContext objectForKey:@"secondItem"] intValue];
}

- (void)configureTableWithData:(NSArray*)dataObjects {
    
    NSLog(@"%@", dataObjects);
    
    [watchKitTable setNumberOfRows:[dataObjects count] withRowType:@"mainRowType"];
    
    for (int i = 0; i < dataObjects.count; i++) {
        NSDictionary* photo = [dataObjects objectAtIndex:i];
        NSString *price = [photo objectForKey:@"TicketPrice"];
        NSString *eventName = [photo objectForKey:@"EventCategory"];
        
        NSString *finalString = [NSString stringWithFormat:@"%@ $%@", eventName, price];
        
         SellingViewController *theRow = [watchKitTable rowControllerAtIndex:i];
        
        theRow.label.text = finalString;
    }
    
    
    
    
}


- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



