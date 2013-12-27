//
//  BTUCViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-27.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTUCViewController.h"

@interface BTUCViewController ()

@end

@implementation BTUCViewController

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
    self.navigationItem.title = @"宫缩";
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
