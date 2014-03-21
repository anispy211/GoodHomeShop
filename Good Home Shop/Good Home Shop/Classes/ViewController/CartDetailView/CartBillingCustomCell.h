//
//  CartBillingCustomCell.h
//  Good Home Shop
//
//  Created by Aniruddha  on 16/03/14.
//  Copyright (c) 2014 Aniruddha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartBillingCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton * placeOrderButton;
@property (strong, nonatomic) IBOutlet UIView * grandTotalBGView;


@property (strong, nonatomic) IBOutlet UILabel * subTotallabel;
@property (strong, nonatomic) IBOutlet UILabel * taxesLbl;
@property (strong, nonatomic) IBOutlet UILabel * packagingLbl;
@property (strong, nonatomic) IBOutlet UILabel * diliveryChargeLbl;
@property (strong, nonatomic) IBOutlet UILabel * discountLbl;
@property (strong, nonatomic) IBOutlet UILabel * grandTotalLbl;


@end
