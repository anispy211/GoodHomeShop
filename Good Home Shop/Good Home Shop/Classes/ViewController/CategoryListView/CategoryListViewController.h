//
//  CategoryListViewController.h
//  Good Home Shop
//
//  Created by Aniruddha  on 16/03/14.
//  Copyright (c) 2014 Aniruddha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *sectionContentDict;
    NSMutableArray      *arrayForBool;
}
@property (nonatomic,strong) IBOutlet UITableView * categoryListView;
@end
