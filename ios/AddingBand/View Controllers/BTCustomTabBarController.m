//
//  BTCustomTabBarController.m
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTCustomTabBarController.h"
#import "Head.h"
#import "RBParallaxTableVC.h"
@interface BTCustomTabBarController ()

@end

@implementation BTCustomTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //配置 tabBar
        [self configureTabBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}
//配置 tabBar
- (void)configureTabBar
{
    BTMainViewController *mainVC = [[BTMainViewController alloc] init];
    BTNavicationController *mainNav = [[BTNavicationController alloc] initWithRootViewController:mainVC];
    mainVC.navigationController.navigationBar.translucent = YES;
    mainNav.tabBarItem.title = @"主线";
    mainVC.navigationItem.title = @"主线";
    //[homeNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_home_sel.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_home.png"]];
    
    
    BTPhysicalViewController * physicalVC = [[BTPhysicalViewController alloc] init];
    BTNavicationController *physicalNav = [[BTNavicationController alloc] initWithRootViewController:physicalVC];
    physicalVC.navigationController.navigationBar.translucent = YES;
    physicalNav.tabBarItem.title = @"体征";
    physicalVC.navigationItem.title = @"体征";
    // [categoryNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_category_sel.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_category.png"]];
    
    
    BTSyncViewController *syncVC = [[BTSyncViewController alloc] init];
    BTNavicationController *syncNav = [[BTNavicationController alloc] initWithRootViewController:syncVC];
    syncVC.navigationController.navigationBar.translucent = YES;
    syncNav.tabBarItem.title = @"同步";
    syncVC.navigationItem.title = @"同步";
    // [orderNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_order_sel.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_order.png"]];
    
    
    BTMineViewController *mineVC = [[BTMineViewController alloc] init];
    BTNavicationController *mineNav = [[BTNavicationController alloc] initWithRootViewController:mineVC];
    mineVC.navigationController.navigationBar.translucent = YES;
    mineNav.tabBarItem.title = @"我的";
    mineVC.navigationItem.title = @"我的";
    // [moreNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_more_sel.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_more.png"]];
    
    
    self.viewControllers = [NSArray arrayWithObjects:mainNav,physicalNav,syncNav,mineNav,nil];
    
    // self.tabBar.backgroundImage =  [UIImage imageNamed:@"toolbar_bg.png"];
    self.tabBar.backgroundColor = [UIColor redColor];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
