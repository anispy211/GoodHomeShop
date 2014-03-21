//
//  CartDetailViewController.m
//  Good Home Shop
//
//  Created by Aniruddha  on 16/03/14.
//  Copyright (c) 2014 Aniruddha. All rights reserved.
//

#import "CartDetailViewController.h"
#import "Utility.h"
#import "CartModelManger.h"
#import "CartBillingCustomCell.h"
#import "CartOrderDetailCustomCell.h"

@interface CartDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * cartArray;
    IBOutlet UITableView * cartListTableView;
    NSString * subTotalStr,*grandTotalStr,*taxAmountStr;
    
}
@end

@implementation CartDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem * trashBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteCart)];
    [trashBarBtn setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = trashBarBtn;
    
}

- (void)viewWillAppear:(BOOL)animated
{
        // Get Data from Database

        [self getCatDataFromDB];

}


- (void)getCatDataFromDB
{
    cartArray = [[CartModelManger sharedInstance] getAllCartData];
    
    [self calculateCharges]; // Calculate charges applied  (Ex: total,tax,discount,grandtotal)
    
    if ([cartArray count]>0) {
       
        [cartListTableView reloadData];
    }
}


// Calculate Charges for Cart

- (void)calculateCharges
{
    if (cartArray) {
        
        int amount = 0;
        
        for (int i = 0; i < [cartArray count]; i++)
        {
            NSDictionary * dict = [cartArray objectAtIndex:i];

            amount = [[dict valueForKey:@"prodquantity"] integerValue] * [[dict valueForKey:@"prodprice"] integerValue];
            
        }
        
        subTotalStr = [NSString stringWithFormat:@"%d",amount];
        
        int taxAmount = amount * (5/100);
        
        taxAmountStr = [NSString stringWithFormat:@"%d",taxAmount];
        
        // Packaging amount is "0" so not considered for this charge
        
        amount = [DELIVERYCHARGE integerValue]  + amount +taxAmount - [DISCOUNT integerValue];
        grandTotalStr = [NSString stringWithFormat:@"%d",amount];
        
    }
    
}


#pragma mark - UItableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
         return [cartArray count];
    }
    
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Configure the cell...

    
    if (indexPath.section == 0) {
        
       CartOrderDetailCustomCell * cartOrderDetailCustomCell = (CartOrderDetailCustomCell *)[tableView dequeueReusableCellWithIdentifier:@"CartOrderDetailCell"];
        
        if (!cartOrderDetailCustomCell){
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CartOrderDetailCustomCell" owner:cartOrderDetailCustomCell options:nil];
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cartOrderDetailCustomCell =  (CartOrderDetailCustomCell *) currentObject;
                    break;
                }
            }
        }
        
        cartOrderDetailCustomCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary * dict = [cartArray objectAtIndex:indexPath.row];
        
        cartOrderDetailCustomCell.menuItemNameLbl.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"prodname"]];
        cartOrderDetailCustomCell.qtyOfitemLbl.text = [NSString stringWithFormat:@"%@ x",[dict valueForKey:@"prodquantity"]];
        cartOrderDetailCustomCell.priceOfItemLbl.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"prodprice"] ];
        int total = [[dict valueForKey:@"prodquantity"] integerValue] * [[dict valueForKey:@"prodprice"] integerValue];
        cartOrderDetailCustomCell.totalpriceOfMenuItemLbl.text = [NSString stringWithFormat:@"%d",total];
        [cartOrderDetailCustomCell.deleteItemButton setTag:indexPath.row];
        [cartOrderDetailCustomCell.deleteItemButton addTarget:self action:@selector(deleteItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
       
        
        return cartOrderDetailCustomCell;
    }
    
    
    if (indexPath.section == 1) {
        CartBillingCustomCell * cartBillingCustomCell = (CartBillingCustomCell *)[tableView dequeueReusableCellWithIdentifier:@"CartCell"];
        
        if (!cartBillingCustomCell){
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CartBillingCustomCell" owner:cartBillingCustomCell options:nil];
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cartBillingCustomCell =  (CartBillingCustomCell *) currentObject;
                    break;
                }
            }
            [cartBillingCustomCell.placeOrderButton addTarget:self action:@selector(placeOrderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        
        cartBillingCustomCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cartBillingCustomCell;
    }
   
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    
    return cell;

}



#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        return 275;
    }
    
    return 57;
    
}


#pragma mark - Cell button Action

- (void)placeOrderButtonAction:(UIButton *)button
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Coming Soon" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)deleteItemButtonAction:(UIButton *)button
{
    NSDictionary * dict = [cartArray objectAtIndex:button.tag];
    
    
    // Delete item from cart: If success full reload cart
    if ([[CartModelManger sharedInstance] deleteEntryFromLocalDb:dict])
        [self getCatDataFromDB];
    
}



#pragma - mark Cart Method

- (void)deleteCart
{
    
    // Check if User is sure to delete cart
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Are you sure" message:@"This will clear your cart" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
    
}

#pragma - mark AlertView Button Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[CartModelManger sharedInstance] flushDatabase]; // Flush Cart data from local DB
        
        // Update badge value to 0
        [[Utility sharedInstance] setCurrentbadgeValue:[NSString stringWithFormat:@"0"]];
        [[Utility sharedInstance] updateBadgeValue];
        
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
