//
//  CustomTableViewCell.m
//  TicketingApp
//
//  Created by Nikhil Mehta on 2/20/16.
//  Copyright © 2016 MehtaiPhoneApps. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
/*
- (instancetype)init {
    self = [super init];
    if (self) {
        [
    }
}
 */

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.bounds = CGRectMake(0,0,375,176);
    self.imageView.frame = CGRectMake(0,0,375,176);
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    
    // self.imageView
    [self.contentView sendSubviewToBack:self.imageView];
    
    
    /*self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 120, 50, 80)];
    self.priceLabel.textColor = [UIColor whiteColor];
    self.priceLabel.backgroundColor = [UIColor clearColor];
    //self.priceLabel.tag = (indexPath.row + 600);
    self.priceLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.priceLabel];
     */
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
