//
//  BTNavicationController.m
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTNavicationController.h"

@interface BTNavicationController ()

@end

@implementation BTNavicationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //设置NavigationBar的毛玻璃效果
        [self setNavigationBarStyle];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
#pragma mark - 设置NavigationBar的毛玻璃效果
//设置NavigationBar的毛玻璃效果
- (void)setNavigationBarStyle
{
    // Set Navigation Bar style
    CGRect rect = CGRectMake(0.0f, 0.0f, 320, 44.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite: 0.8 alpha:0.8f] CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor: [UIColor redColor]];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment: 1.0f forBarMetrics: UIBarMetricsDefault];
    
    UIColor *titleColor = [UIColor colorWithRed: 150.0f/255.0f green: 149.0f/255.0f blue: 149.0f/255.0f alpha: 1.0f];
    UIColor* shadowColor = [UIColor colorWithWhite: 1.0 alpha: 1.0];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{UITextAttributeTextColor: titleColor,
                                                            UITextAttributeFont: [UIFont boldSystemFontOfSize: 23.0f],
                                                            UITextAttributeTextShadowColor: shadowColor,
                                                            UITextAttributeTextShadowOffset: [NSValue valueWithCGSize: CGSizeMake(0.0, 1.0)]}];
    self.navigationBar.translucent =NO;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
