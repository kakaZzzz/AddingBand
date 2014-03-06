//
//  BTCloseToBleViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-21.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTCloseToBleViewController.h"

static BTCloseToBleViewController *closetoBleVC = nil;

@interface BTCloseToBleViewController ()

@end

@implementation BTCloseToBleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//单例
+ (BTCloseToBleViewController *)shareCloseToBleview
{
    @synchronized(self)//单例标准写法 防止多线程访问单例出错
    {
        if (closetoBleVC == nil) {
            closetoBleVC = [[BTCloseToBleViewController alloc]init];
            
        }
        return closetoBleVC;
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"closeto_ble_bg@2x"]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
