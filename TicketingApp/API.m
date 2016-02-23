//
//  API.m
//  TicketingApp
//
//  Created by Nikhil Mehta on 2/19/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import "API.h"

//host of machine
//#define kAPIHost @"http://localhost/~nikhilmehta/"
//#define kAPIHost @"http://104.45.155.184:4200/"
#define kAPIHost @"http://tinkerbell.cloudapp.net/"
//#define kAPIHost @"http://104.45.155.184:4200/"

//path to get to php files
//#define kAPIPath @"TicketingApp/"
#define kAPIPath @""
//#define kAPIPath @"events/"
//#define kApiPath @""
//singleton is a kind of class where only one instance exists for the entire process
//restricts instantiation of a class to one object

@implementation API
@synthesize user;

//creates an instance of the API class the first time it's called.
//any future calls to the method will return that instance
+(API*)sharedInstance {
    //sharedInstance variable from API class set to nil. Only used in this file.
    static API *sharedInstance = nil;
    
    //predicates return true or false
    //apply a predicate to the list when you have a list of objects that you want to filter
    //in this case, the predicate will track the "once"
    static dispatch_once_t oncePredicate;
    
    //dispatch once makes sure it's only created once
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
    });
    
    sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    return sharedInstance;
}


-(BOOL)isAuthorized {
    //if login/register call returned anything, then authorization was successful so return TRUE
    // NSLog(@"%d", [[user objectForKey:@"IdUser"] intValue]);
    return [[user objectForKey:@"IdUser"] intValue]>0;
}

//initialize the API class with the destination host name
-(API*)init {
    self = [super init];
    if (self != nil) {
        //initialize user dictionary object
        user = nil;
        
        
        //[self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //only accept json responses
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //set value for http headers set in requests made by http client
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //[self.requestSerializer setValue:@"Accept" forHTTPHeaderField:@"application/json"];
        
        
        
    }
    return self;
}

-(NSURL*)urlForImageWithId:(NSNumber*)IdPhoto isThumb:(BOOL)isThumb {
    NSString* urlString = [NSString stringWithFormat:@"%@/%@upload/%@%@.jpg",
                           kAPIHost, kAPIPath, IdPhoto, (isThumb)?@"-thumb":@""
                           ];
    //  NSString* urlString = [NSString stringWithFormat:@"%@/%@upload/%@.jpg",
    //                     kAPIHost, kAPIPath, IdPhoto];
    return [NSURL URLWithString:urlString];
}

-(void)commandWithParams:(NSMutableDictionary *)params onCompletion:(JSONResponseBlock)completionBlock {
    
    NSData *uploadFile = nil;
    //if the API command got a 'file' parameter
    if ([params objectForKey:@"file"]) {
        ///take the file parameter out of the params dictionary and store it separately
        //do this since all other parameters will be sent as POST request variables, photo contents are sent as multipart attachments
        uploadFile = (NSData*)[params objectForKey:@"file"];
        [params removeObjectForKey:@"file"];
    }
    
    //http://tinkerbell.cloudapp.net/
    //http://localhost/~nikhilmehta/TicketingApp/
    
    //create a NSMutableURLRequest instance using parameters you want to send via POST
    NSMutableURLRequest *apiRequest = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:@"http://tinkerbell.cloudapp.net/" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>formData)  {
        //attach file if needed
        if (uploadFile) {
            //add binary contents of the file, a name of request variable, file name of the attachment, and a mime type to the request to send to server
            [formData appendPartWithFileData:uploadFile
                                        name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }
        
    }];
    
    //create operation to handle network communication in the background and initialize it with the POST request apiRequest
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:apiRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    
    //    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    //set two blocks to execute on success and failure.
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success
        //if successful, pass in the JSON response to the operation
        //completionBlock passed in
        completionBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure
        NSLog(@"Failed");
        
        NSLog(@"%@", error);
        
        NSLog(@"%@", operation.responseString);
        
        [[[UIAlertView alloc]initWithTitle:@"Error!"
                                   message:operation.responseString
                                  delegate:nil
                         cancelButtonTitle:@"Ok"
                         otherButtonTitles: nil] show];
        
        
        //pass the error as a response
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    //start operation and at this point AFNetworking begins
    [operation start];
    
    
}


@end
