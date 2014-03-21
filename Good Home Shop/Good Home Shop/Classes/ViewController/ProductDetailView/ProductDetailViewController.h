//
//  ProductDetailViewController.h
//  Good Home Shop
//
//  Created by Aniruddha  on 16/03/14.
//  Copyright (c) 2014 Aniruddha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController<UIAlertViewDelegate>
{
  

}
@property (nonatomic,strong) IBOutlet UIImageView *productImageView;
@property (nonatomic,strong) IBOutlet UILabel *pricelabel;
@property (nonatomic,strong) IBOutlet UILabel *descripttionLabel;
@property (nonatomic,strong) IBOutlet UIButton *nextButton;
@property (nonatomic,strong) IBOutlet UIButton *prevButton;
@property (nonatomic,strong) NSString * prodCategorey;

- (IBAction)nextPageButtonAction:(UIButton *)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productList:(NSArray *)productArray;
@end
