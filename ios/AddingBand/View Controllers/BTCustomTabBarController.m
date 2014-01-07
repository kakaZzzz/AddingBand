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
#import "BTSyncccViewController.h"
#import "BTColor.h"
#import "LayoutDef.h"
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
////配置 tabBar
//- (void)configureTabBar
//{
//    BTMainViewController *mainVC = [[BTMainViewController alloc] init];
//    BTNavicationController *mainNav = [[BTNavicationController alloc] initWithRootViewController:mainVC];
//    // mainNav.tabBarItem.title = @"主线";
//    mainVC.navigationItem.title = @"主线";
//    [mainNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"home_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"home_unselected.png"]];
//
//
//    BTPhysicalViewController * physicalVC = [[BTPhysicalViewController alloc] init];
//    BTNavicationController *physicalNav = [[BTNavicationController alloc] initWithRootViewController:physicalVC];
//   // physicalNav.tabBarItem.title = @"体征";
//    physicalVC.navigationItem.title = @"体征";
//    [physicalNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"physical_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"physical_unselected.png"]];
//
//
//    BTSyncccViewController *syncVC = [[BTSyncccViewController alloc] init];
//    BTNavicationController *syncNav = [[BTNavicationController alloc] initWithRootViewController:syncVC];
//   // syncNav.tabBarItem.title = @"同步";
//    syncVC.navigationItem.title = @"同步";
//    [syncNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"sync_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"sync_unselected.png"]];
//
//
//    BTMineViewController *mineVC = [[BTMineViewController alloc] init];
//    BTNavicationController *mineNav = [[BTNavicationController alloc] initWithRootViewController:mineVC];
//   // mineNav.tabBarItem.title = @"我的";
//    mineVC.navigationItem.title = @"设置";
//    [mineNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"shezhi_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"shezhi_unselected.png"]];
//
//
//    self.viewControllers = [NSArray arrayWithObjects:mainNav,physicalNav,syncNav,mineNav,nil];
//    //
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//    if (IOS7_OR_LATER) {
//        self.tabBar.barStyle = UIBarStyleBlack;
//        self.tabBar.translucent = YES;
//    }
//#endif
//    self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabbar_sel.png"];
//     self.tabBar.backgroundImage =  [UIImage imageNamed:@"tabbar_bg.png"];
//
//
//
//}

//配置 tabBar
- (void)configureTabBar
{
    BTMainViewController *mainVC = [[BTMainViewController alloc] init];
    BTNavicationController *mainNav = [[BTNavicationController alloc] initWithRootViewController:mainVC];
    mainVC.navigationItem.title = @"主线";
   // mainNav.tabBarItem.badgeValue = @"2";
    
    //ios7上这样用
    if (IOS7_OR_LATER) {
        mainNav.tabBarItem.title = @"主页";
        [mainNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"home_selected1.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"home_unselected1.png"]];
        
        //5.0之后新特性
        [mainNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kContentTextColor, nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor, nil]] forState:UIControlStateNormal];
        [mainNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kGlobalColor, nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,nil]] forState:UIControlStateSelected];
        
    }
    
    else
    {
        [mainNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"home_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"home_unselected.png"]];
        
    }
    
    BTPhysicalViewController * physicalVC = [[BTPhysicalViewController alloc] init];
    BTNavicationController *physicalNav = [[BTNavicationController alloc] initWithRootViewController:physicalVC];
    
    
   // physicalNav.tabBarItem.badgeValue = @"";
    physicalVC.navigationItem.title = @"体征";
    //ios7上这样用
    if (IOS7_OR_LATER) {
        physicalNav.tabBarItem.title = @"体征";
        [physicalNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"physical_selected1.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"physical_unselected1.png"]];
        //5.0之后新特性
        [physicalNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kContentTextColor, nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor, nil]] forState:UIControlStateNormal];
        [physicalNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kGlobalColor, nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,nil]] forState:UIControlStateSelected];
        
    }
    
    else
    {
        [physicalNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"physical_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"physical_unselected.png"]];
        
    }
    
    BTSyncccViewController *syncVC = [[BTSyncccViewController alloc] init];
    BTNavicationController *syncNav = [[BTNavicationController alloc] initWithRootViewController:syncVC];
    // syncNav.tabBarItem.title = @"同步";
    syncVC.navigationItem.title = @"同步";
    // syncNav.tabBarItem.badgeValue = @"1";
    //ios7上这样用
    if (IOS7_OR_LATER) {
        syncNav.tabBarItem.title = @"同步";
        [syncNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"sync_selected1.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"sync_unselected1.png"]];
        //5.0之后新特性
        [syncNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kContentTextColor, nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor, nil]] forState:UIControlStateNormal];
        [syncNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kGlobalColor, nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,nil]] forState:UIControlStateSelected];
        
    }
    
    else
    {
        [syncNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"sync_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"sync_unselected.png"]];
        
    }
    
    
    BTMineViewController *mineVC = [[BTMineViewController alloc] init];
    BTNavicationController *mineNav = [[BTNavicationController alloc] initWithRootViewController:mineVC];
    // mineNav.tabBarItem.title = @"我的";
    mineVC.navigationItem.title = @"设置";
    //    [mineNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"shezhi_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"shezhi_unselected.png"]];
    if (IOS7_OR_LATER) {
        mineNav.tabBarItem.title = @"设置";
        [mineNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"shezhi_selected1.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"shezhi_unselected1.png"]];        //5.0之后新特性
        [mineNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kContentTextColor, nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor, nil]] forState:UIControlStateNormal];
        [mineNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kGlobalColor, nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,nil]] forState:UIControlStateSelected];
        
    }
    
    else
    {
        [mineNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"shezhi_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"shezhi_unselected.png"]];
        
    }
    
    
    
    
    //  self.viewControllers = [NSArray arrayWithObjects:mainNav,physicalNav,syncNav,mineNav,nil];
    self.viewControllers = [NSArray arrayWithObjects:mainNav,physicalNav,syncNav,mineNav,nil];
    
    //
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IOS7_OR_LATER) {
        self.tabBar.barStyle = UIBarStyleBlack;
        self.tabBar.translucent = NO;
    }
#endif
    
    if (IOS7_OR_EARLIER) {
         self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabbar_sel.png"];
    }
   
    self.tabBar.backgroundImage =  [UIImage imageNamed:@"tabbar_bg.png"];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
