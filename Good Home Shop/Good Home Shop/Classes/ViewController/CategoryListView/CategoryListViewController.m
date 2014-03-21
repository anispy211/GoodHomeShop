//
//  CategoryListViewController.m
//  Good Home Shop
//
//  Created by Aniruddha  on 16/03/14.
//  Copyright (c) 2014 Aniruddha. All rights reserved.
//

#import "CategoryListViewController.h"
#import "ProductDetailViewController.h"
#import "Utility.h"
#import "CartModelManger.h"

@interface CategoryListViewController ()
{
    NSDictionary * categoryListDict;
    NSIndexPath * preVIndexSelected;

}
@end

@implementation CategoryListViewController

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

    [self checkLocalDBForRestoringCart];  // Restore Cart from local storage if any
    
    [self getAllCategorys];  // Getting List of Categories from PList
    [self configureView];
    
  
    
}

#pragma mark - Restore Cart from local storage if any
 
- (void)checkLocalDBForRestoringCart
 {
     
     NSArray * tempArr = [[CartModelManger sharedInstance] getAllCartData];
     
     if ([tempArr count] > 0) {
         
         [[Utility sharedInstance] setCurrentbadgeValue:[NSString stringWithFormat:@"%d",[tempArr count]]];
         [[Utility sharedInstance] updateBadgeValue];
     }
     
 }



#pragma mark - Configure View

- (void)configureView
{
    if ([[categoryListDict allKeys] count]>0) {
        
        arrayForBool    = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[categoryListDict allKeys] count]; i++)
        {
            [arrayForBool addObject:[NSNumber numberWithBool:NO]];
        }
        
        sectionContentDict  = [[NSMutableDictionary alloc] init];
        
        NSMutableArray * menuarray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[categoryListDict allKeys] count]; i++) {
            
            NSDictionary * dict = [categoryListDict valueForKey:[[categoryListDict allKeys] objectAtIndex:i]];
            [menuarray addObject:dict];
        }

        
        for (int j = 0; j < [[categoryListDict allKeys] count]; j++)
        {
            [sectionContentDict setObject:[menuarray objectAtIndex:j] forKey:[[categoryListDict allKeys] objectAtIndex:j]];
        }
        
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data Method - Utility

- (void)getAllCategorys
{
   categoryListDict = [[Utility sharedInstance] readproductInfoPlist];

}

- (NSString *)getCellDataforIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * dict = [categoryListDict valueForKey:[[categoryListDict allKeys] objectAtIndex:indexPath.section]];
    
    NSArray * arr = [dict allKeys];
    
    NSString * str = nil;
    str = [arr objectAtIndex:indexPath.row];

    return str;
}


#pragma mark -  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[categoryListDict allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        NSDictionary *content = [sectionContentDict valueForKey:[[categoryListDict allKeys] objectAtIndex:section]];
        
        return [[content allKeys] count];
    }
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    if (!manyCells) {
        
        // Configure the cell...

        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        
        
        return cell;
    }
    
    if (manyCells) {
    
    
    static NSString *cellIdentifier1 = @"SubItemCell";
    //3
    UITableViewCell *tablecell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (tablecell == nil) {
        tablecell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            tablecell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    NSDictionary *content = [sectionContentDict valueForKey:[[categoryListDict allKeys]  objectAtIndex:indexPath.section]];
    
    tablecell.textLabel.text = [[content allKeys] objectAtIndex:indexPath.row];

    
    return tablecell;
        
    }
    
    return nil;
 
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 35;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _categoryListView.frame.size.width, 45)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor whiteColor];
    UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _categoryListView.frame.size.width-20-50, 40)];
    BOOL manyCells                  = [[arrayForBool objectAtIndex:section] boolValue];
    
    
    if (!manyCells) {
        headerString.text =  [[categoryListDict allKeys] objectAtIndex:section];  // @"click to expand";
    }else{
        headerString.text = [[categoryListDict allKeys] objectAtIndex:section]; // @"click again to collapse";
    }
    headerString.textAlignment      = NSTextAlignmentLeft;
    headerString.textColor          = [UIColor blackColor];
    headerString.font = [UIFont boldSystemFontOfSize:18];
    [headerView addSubview:headerString];
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [headerView addGestureRecognizer:headerTapped];
    
    //up or down arrow depending on the bool
    UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:manyCells ? [UIImage imageNamed:@"upArrowBlack"] : [UIImage imageNamed:@"downArrowBlack"]];
    upDownArrow.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin;
    upDownArrow.frame               = CGRectMake(self.view.frame.size.width-40, 15, 22, 13);
    [headerView addSubview:upDownArrow];
    
    return headerView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * dict = [categoryListDict valueForKey:[[categoryListDict allKeys] objectAtIndex:indexPath.section]];
    
    NSArray * productArray = [dict valueForKey:[[dict allKeys] objectAtIndex:indexPath.row]];
    
    ProductDetailViewController * prodVC = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil productList:productArray];
    NSDictionary *content = [sectionContentDict valueForKey:[[categoryListDict allKeys]  objectAtIndex:indexPath.section]];
    [prodVC setProdCategorey:[[categoryListDict allKeys] objectAtIndex:indexPath.section]];
    [prodVC setTitle:[[content allKeys] objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:prodVC animated:YES];
}


#pragma mark - Header Gesture tapped

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        
        
        
        
        if (indexPath.section != preVIndexSelected.section) {
            
            BOOL collapsed  = [[arrayForBool objectAtIndex:preVIndexSelected.section] boolValue];
            collapsed       = NO;
            [arrayForBool replaceObjectAtIndex:preVIndexSelected.section withObject:[NSNumber numberWithBool:collapsed]];
            
            //reload specific section animated
            NSRange range   = NSMakeRange(preVIndexSelected.section, 1);
            NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
            
            [self.categoryListView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
        
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        collapsed       = !collapsed;
        [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
        
        //reload specific section animated
        NSRange range   = NSMakeRange(indexPath.section, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        
        [self.categoryListView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
        //   [self.categoryListView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        preVIndexSelected = indexPath;
        
    }
}




@end
