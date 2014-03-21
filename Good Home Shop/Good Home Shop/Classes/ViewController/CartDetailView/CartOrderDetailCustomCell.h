//
//  CartOrderDetailCustomCell.h
//  TastyKhana
//
//  Created by Aniruddha  on 14/10/13.
//  Copyright (c) 2013 Tasty Khana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartOrderDetailCustomCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel * menuItemNameLbl;
@property (nonatomic, weak) IBOutlet UILabel * qtyOfitemLbl;
@property (nonatomic, weak) IBOutlet UILabel * priceOfItemLbl;
@property (nonatomic, weak) IBOutlet UILabel * totalpriceOfMenuItemLbl;
@property (nonatomic, strong) IBOutlet UIButton * deleteItemButton;

@end
