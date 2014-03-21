//
//  CartOrderDetailCustomCell.m
//  TastyKhana
//
//  Created by Aniruddha  on 14/10/13.
//  Copyright (c) 2013 Tasty Khana. All rights reserved.
//

#import "CartOrderDetailCustomCell.h"

@implementation CartOrderDetailCustomCell
@synthesize menuItemNameLbl;
@synthesize qtyOfitemLbl;
@synthesize priceOfItemLbl;
@synthesize totalpriceOfMenuItemLbl;
@synthesize deleteItemButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
