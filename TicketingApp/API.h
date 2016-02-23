//
//  API.h
//  TicketingApp
//
//  Created by Nikhil Mehta on 2/19/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"


//block which receives an nsdictionary containing json info as a parameter. use it for calls to api since server always returns a json response
typedef void (^JSONResponseBlock)(NSDictionary* json);

@interface API : AFHTTPSessionManager {
    
}

//hold user data
@property (strong, nonatomic) NSDictionary* user;

//check if authorized user
-(BOOL)isAuthorized;

//send an api command to server
-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;

//allow class to be able to be used from all screens in the app
+(API*)sharedInstance;

//give us back the URL of an image on the server by getting the ID of the photo you want to load
-(NSURL*)urlForImageWithId:(NSNumber*)IdPhoto isThumb:(BOOL)isThumb;


@end

