//
//  BTChartViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-4.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTChartViewController.h"

@interface BTChartViewController ()

@end

@implementation BTChartViewController

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
    self.view.backgroundColor = [UIColor orangeColor];
	// Do any additional setup after loading the view.
}
//配置返回按钮
- (void)createBackButton
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
