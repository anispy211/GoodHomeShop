//
//  CartBillingCustomCell.m
//  Good Home Shop
//
//  Created by Aniruddha  on 16/03/14.
//  Copyright (c) 2014 Aniruddha. All rights reserved.
///

#import "CartBillingCustomCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CartBillingCustomCell
@synthesize placeOrderButton;
@synthesize grandTotalBGView;
@synthesize subTotallabel;
@synthesize taxesLbl;
@synthesize packagingLbl;
@synthesize discountLbl;
@synthesize grandTotalLbl;
@synthesize diliveryChargeLbl;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
             
        // Initialization code
    }
    return self;
}




@end
