//
//  MainTabBarViewController.m
//  Good Home Shop
//
//  Created by Aniruddha  on 16/03/14.
//  Copyright (c) 2014 Aniruddha. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "CategoryListViewController.h"
#import "CartDetailViewController.h"
#import "Utility.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeValue) name:UpdateBadge object:nil];
    
    // Do any additional setup after loading the view from its nib.
    

    self.tabBarController = [[UITabBarController alloc] init];
    
    CategoryListViewController * categoryListVC = [[CategoryListViewController alloc] initWithNibName:@"CategoryListViewController" bundle:nil];
    [categoryListVC setTitle:@"Good Home Shop"];
    
    UINavigationController * navVC1 = [[UINavigationController alloc] initWithRootViewController:categoryListVC];
    
    CartDetailViewController * cartDetailVC = [[CartDetailViewController alloc] initWithNibName:@"CartDetailViewController" bundle:nil];
    [cartDetailVC setTitle:@"Cart"];
    
    UINavigationController * navVC2 = [[UINavigationController alloc] initWithRootViewController:cartDetailVC];

    [self.tabBarController.view setFrame:self.view.frame];
    
    
    UITabBarItem *tabHome = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage  imageNamed:@"menu.png"] selectedImage:[UIImage  imageNamed:@"menu.png"]];
    tabHome.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    
    UITabBarItem *tabCart = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"cart.png"] selectedImage:[UIImage imageNamed:@"cart.png"]];
    tabCart.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    [navVC1 setTabBarItem:tabHome];
    [navVC2 setTabBarItem:tabCart];

    [self.view addSubview:self.tabBarController.view];
    [self.tabBarController.tabBar setTintColor:[UIColor blackColor]];
    
    [self.tabBarController setViewControllers:@[navVC1,navVC2]];
    [categoryListVC.view setTintColor:[UIColor blackColor]];
    [cartDetailVC.view setTintColor:[UIColor blackColor]];
    [navVC1.navigationBar setTintColor:[UIColor blackColor]];
    //[[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];

    [self updateBadgeValue];
    
    
}


#pragma mark -  BadgeValue Notification method
- (void) updateBadgeValue
{
    
    if ([[[Utility sharedInstance] currentbadgeValue] intValue] > 0)
    {
        [[[[self.tabBarController tabBar]items]objectAtIndex:1] setEnabled:TRUE];
    [[[[[self tabBarController] viewControllers] objectAtIndex: 1] tabBarItem] setBadgeValue:[[Utility sharedInstance] currentbadgeValue]];
    }
    else
    {
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
        
        // Set Seleted Tab to Menu on Tab bar
        [self.tabBarController setSelectedIndex:0];
        [[[[[self tabBarController] viewControllers] objectAtIndex: 1] tabBarItem] setBadgeValue:nil];

    }


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
