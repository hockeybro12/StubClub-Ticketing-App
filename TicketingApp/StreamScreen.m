//
//  StreamScreen.m
//  TicketingApp
//
//  Created by Nikhil Mehta on 2/19/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import "StreamScreen.h"
#import "API.h"
#import "CustomTableViewCell.h"
#include <CommonCrypto/CommonDigest.h>
#import "NewTicketScreen.h"

#define kSalt @"adlfu3489tyh2jnkLIUGI&%EV(&0982cbgrykxjnk8855"

@interface StreamScreen ()

@end

@implementation StreamScreen
@synthesize tableData;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedRow = false;
    
    self.navigationItem.title = @"sharks021916";
        
    btnCompose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newTicket)];
    
    btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTableView)];

    self.navigationItem.rightBarButtonItem = btnCompose;
    self.navigationItem.leftBarButtonItem = btnRefresh;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)newTicket {
    
    
    [self performSegueWithIdentifier:@"NewTicket" sender:nil];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"NewTicket"]) {
        NewTicketScreen *vc = segue.destinationViewController;
        vc.eventCode = self.navigationItem.title;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
    if (![[API sharedInstance] isAuthorized]) {
        NSString *savedUsername = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"username"];
        NSString *savedPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
        
        if (savedPassword == nil || savedUsername == nil) {
            [self performSegueWithIdentifier:@"ShowLoginFirst" sender:nil];
            
        } else {
            
            
            NSString* saltedPassword = [NSString stringWithFormat:@"%@%@", savedPassword, kSalt];
            
            //hashedPassword will hold the string of the hashed and salted password
            NSString *hashedPassword = nil;
            //plain C style array to be used as an intermediate storage for hashed data
            unsigned char hashedPasswordData[CC_SHA1_DIGEST_LENGTH];
            
            //hash the password
            //get data bytes from the salted password
            NSData *data = [saltedPassword dataUsingEncoding: NSUTF8StringEncoding];
            if (CC_SHA1([data bytes], [data length], hashedPasswordData)) {
                hashedPassword = [[NSString alloc] initWithBytes:hashedPasswordData length:sizeof(hashedPasswordData) encoding:NSASCIIStringEncoding];
            } else {
                UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password can't be sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [error show];
            }
            
            
            //check whether it is a login or register
            NSString* command = @"login";
            //build the dictionary with username, password, command keys
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:command, @"command", savedUsername, @"username", savedPassword, @"password", nil];
            
            //make the call to the web api
            [[API sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
                //handle response
                //as defined in php, json is a dictionary and holds a result key. fetch another dicitonary from within this key.
                
                NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
                
                if ([json objectForKey:@"error"]==nil && [[res objectForKey:@"IdUser"] intValue]>0) {
                    //success
                    [[API sharedInstance] setUser: res];
                    [self refreshTableView];
                    
                } else {
                    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [error show];
                }
            }];

        }
        
    } else {
        [self refreshTableView];
    }
}

-(void)refreshTableView {
    if ([[API sharedInstance] isAuthorized]) {
        [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"stream", @"command", self.navigationItem.title, @"EventName", nil] onCompletion:^(NSDictionary *json){
            if (![json objectForKey:@"error"]) {
                NSArray *resultArray = [json objectForKey:@"result"];
                                
                tableData = [[NSMutableArray alloc] initWithArray:resultArray];
                
                //sectionNumberList = [tableData valueForKey:@"SectionNumber"];
                //priceList = [tableData valueForKey:@"TicketPrice"];
                //photoIdList = [tableData valueForKey:@"IdPhoto"];

                
                //NSLog(@"%@", tableData);
                
                [self.tableView reloadData];
                

            } else {
                NSLog(@"%@", [json objectForKey:@"error"]);
                [[[UIAlertView alloc]initWithTitle:@"Error"
                                           message:@"There was an error."
                                          delegate:nil
                                 cancelButtonTitle:@"Okay"
                                 otherButtonTitles: nil] show];
                

            }
        }];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedIndexPath && indexPath.row == selectedIndexPath.row && selectedRow == true) {
        return 300;
    }
    
    return 178;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (selectedRow == false) {
        selectedRow = true;
        selectedIndexPath = indexPath;
        [tableView beginUpdates];
        [buyTicket removeFromSuperview];
        
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        buyTicket = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 200, 80)];
        buyTicket.backgroundColor = [UIColor clearColor];
        [buyTicket setTitle:@"Buy Ticket" forState:UIControlStateNormal];
        [buyTicket setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        buyTicket.tag = 1000;
        [cell.contentView addSubview:buyTicket];
        [buyTicket addTarget:self action:@selector(buyATicketNow) forControlEvents:UIControlEventTouchUpInside];
        [tableView endUpdates];

        
        return;
    }
    if (indexPath == selectedIndexPath) {
        selectedRow = false;

        [tableView beginUpdates];
        [buyTicket removeFromSuperview];
        [tableView endUpdates];

        return;
    } else {
        selectedIndexPath = indexPath;
        selectedRow = true;
        [tableView beginUpdates];
        [buyTicket removeFromSuperview];
        
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        buyTicket = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 200, 80)];
        buyTicket.backgroundColor = [UIColor clearColor];
        [buyTicket setTitle:@"Buy Ticket" forState:UIControlStateNormal];
        [buyTicket setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        buyTicket.tag = 1000;
        [buyTicket addTarget:self action:@selector(buyATicketNow) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:buyTicket];
        [tableView endUpdates];

        return;
    }

}

-(void)buyATicketNow  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Buy ticket" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil]; [alert show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSDictionary* data = [tableData objectAtIndex:[selectedIndexPath row]];
       // NSLog(@"%@", data);
        
        NSString *session = [NSString stringWithFormat:@"%d", [[[[API sharedInstance] user] objectForKey:@"IdUser"] intValue]];
        NSString *ticketID = [data objectForKey:@"TicketID"];
        
        NSLog(@"%@ %@", session, ticketID);
        
        if ([[API sharedInstance] isAuthorized]) {
            [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"purchase", @"command", session, @"IdUser", ticketID, @"TicketID", nil] onCompletion:^(NSDictionary *json){
                if (![json objectForKey:@"error"]) {
                    
                    NSLog(@"%@", json);
                    
                    selectedRow = false;
                    
                    [self.tableView beginUpdates];
                    [buyTicket removeFromSuperview];
                    [self.tableView endUpdates];
                    
                    [self refreshTableView];
                    
                    [[[UIAlertView alloc]initWithTitle:@"Congrats"
                                               message:@"You have bought the ticket!"
                                              delegate:nil
                                     cancelButtonTitle:@"Okay"
                                     otherButtonTitles: nil] show];
                } else {
                    NSLog(@"%@", [json objectForKey:@"error"]);
                    [[[UIAlertView alloc]initWithTitle:@"Error"
                                               message:@"There was an error."
                                              delegate:nil
                                     cancelButtonTitle:@"Okay"
                                     otherButtonTitles: nil] show];
                    
                    
                }
            }];
            
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UILabel *label;
    UILabel *priceLabel;
    
    if (cell == nil) {
        //initiialize the cell created above called "Cell"
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
       
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 120, 50, 80)];
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.tag = (600);
        priceLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
        priceLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:priceLabel];
        
        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 200, 80)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.tag = (200);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:@"Helvetica" size:18];
        [cell.contentView addSubview:label];
        
        buyTicket = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 200, 80)];
        buyTicket.backgroundColor = [UIColor clearColor];
        [buyTicket setTitle:@"Buy Ticket" forState:UIControlStateNormal];
        [buyTicket setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        buyTicket.tag = 1000;
        [cell.contentView addSubview:buyTicket];
         
        
    } else {
        label = (UILabel*)[cell.contentView viewWithTag:(200)];
        priceLabel = (UILabel*)[cell.contentView viewWithTag:(600)];
        buyTicket = (UIButton*)[cell.contentView viewWithTag:(1000)];
    }
    //NSString *currentValue = [tableData objectAtIndex:[indexPath row]];
    
    [buyTicket setHidden:YES];
    
    NSDictionary* photo = [tableData objectAtIndex:[indexPath row]];
    
    /*UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 120, 50, 80)];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.backgroundColor = [UIColor clearColor];
    //priceLabel.tag = (indexPath.row + 600);
    priceLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    priceLabel.textAlignment = NSTextAlignmentRight;
     */
    
    NSString *price = [photo objectForKey:@"TicketPrice"];
    NSString *realPrice = [NSString stringWithFormat:@"$%@", price];
    //UILabel *newPriceLabel = (UILabel*)[cell.contentView viewWithTag:(indexPath.row + 600)];
    //[cell.contentView bringSubviewToFront:newPriceLabel];
    //newPriceLabel.text = realPrice;
    
    priceLabel.text = realPrice;

    [cell setNeedsLayout];
    
    
    //start setting up the image view
    API* api = [API sharedInstance];
    int IdPhoto = [[photo objectForKey:@"IdPhoto"] intValue];
    
    NSURL* imageURL = [api urlForImageWithId:[NSNumber numberWithInt: IdPhoto] isThumb:NO];
    
    
    AFHTTPRequestOperation* imageOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:imageURL]];
    imageOperation.responseSerializer = [AFImageResponseSerializer serializer];
    
    
    [imageOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIImage* image = (UIImage*) responseObject;
        /*UIImageView *newImageView = (UIImageView*)[cell.contentView viewWithTag:(indexPath.row + 600)];
        newImageView.image = image;
        //newImageView.frame = CGRectMake(0,0,375,375);
        newImageView.contentMode = UIViewContentModeScaleAspectFit;
         */
       // NSLog(@"Hey");
        
        CGSize itemSize = CGSizeMake(375, 176);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.imageView.clipsToBounds = YES;
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        

        
        cell.imageView.image = image;
        
       // CGFloat widthScale = 375 / image.size.width;
        //CGFloat heightScale =  176 / image.size.height;
        //this line will do it!
        //cell.imageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        [cell setNeedsLayout];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure
        NSLog(@"Failed");
    }];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:imageOperation];

    // Configure the cell...
    
    //label = (UILabel*)[cell.contentView viewWithTag:(indexPath.row + 200)];
    NSString *sectionNumber = [photo objectForKey:@"SectionNumber"];
    NSString *realSectionText = [NSString stringWithFormat:@"Section Number: %@", sectionNumber];
    label.text = realSectionText;
    [cell.contentView bringSubviewToFront:label];
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
