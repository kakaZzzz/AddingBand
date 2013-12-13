//
//  BTBadgeManager.m
//  AddingBand
//
//  Created by wangpeng on 13-12-9.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBadgeManager.h"
#import "BTAppDelegate.h"
#import "BTCustomTabBarController.h"
#import "LayoutDef.h"
#import "BTCustomBadge.h"


#define BADGE_LEFT 50
#define BADGE_TOP 5
#define BADGE_WIDTH 25
#define BADGE_HEIGHT 25
@implementation BTBadgeManager

+ (void)showBadgeAtIndex:(int)tabIndex
{
    BTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    BTCustomTabBarController *tabbarController = (BTCustomTabBarController *)appDelegate.window.rootViewController;
    UIImageView *image =(UIImageView *)[tabbarController.tabBar viewWithTag:1000 + tabIndex];
    //如果没有小红点 则创建一个小红点
    if (image == nil) {
        UIImageView *aImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_badge.png"]];
        aImageView.frame = CGRectMake(BADGE_LEFT + 80 * tabIndex, BADGE_TOP, BADGE_WIDTH, BADGE_HEIGHT);
        aImageView.tag = 1000 + tabIndex;
        [tabbarController.tabBar addSubview:aImageView];
        [tabbarController.tabBar bringSubviewToFront:aImageView];//将小圆点永远显示在最前面
    }


}

+ (void)removeBadgeAtIndex:(int)tabIndex
{
    BTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    BTCustomTabBarController *tabbarController = (BTCustomTabBarController *)appDelegate.window.rootViewController;
    UIImageView *image =(UIImageView *)[tabbarController.tabBar viewWithTag:1000 + tabIndex];
    //如果小红点存在 则移除小红点
    if (image) {
        [image removeFromSuperview];
    }
  
}

+ (void)showBadgeAtIndex:(NSUInteger)tabIndex badgeValue:(NSString*)badgeValue
{
    
    BTCustomBadge *barde = [BTCustomBadge customBadgeWithString:badgeValue];
    barde.tag = 2000 + tabIndex;
   
    [barde autoBadgeSizeWithString:badgeValue];
    NSLog(@"barde is %@",NSStringFromCGRect(barde.frame));
    
    BTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    BTCustomTabBarController *tabbarController = (BTCustomTabBarController *)appDelegate.window.rootViewController;

    if ([badgeValue length] >= 3) {
        barde.frame = CGRectMake(BADGE_LEFT + 80 * tabIndex, barde.frame.origin.y, barde.frame.size.width-15, barde.frame.size.height);
    }
    else if([badgeValue length] >0 && [badgeValue length] <=2){
        barde.frame = CGRectMake(BADGE_LEFT + 80 * tabIndex, barde.frame.origin.y, barde.frame.size.width, barde.frame.size.height);
    }
    [tabbarController.tabBar addSubview:barde];

    
    [tabbarController.tabBar bringSubviewToFront:barde];//将小圆点永远显示在最前面

}

+ (void)removeBadgeWithValueAtIndex:(int)tabIndex
{   BTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    BTCustomTabBarController *tabbarController = (BTCustomTabBarController *)appDelegate.window.rootViewController;

    BTCustomBadge * badgeView = (BTCustomBadge*)[tabbarController.tabBar viewWithTag:2000 + tabIndex];
    if (badgeView) {
        [badgeView removeFromSuperview];
    }
    
}
@end
