//
//  BTBabyFetalViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-6.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBabyFetalViewController.h"

@interface BTBabyFetalViewController ()

@end

@implementation BTBabyFetalViewController

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
    self.navigationItem.title = @"胎心监测";
     self.view.backgroundColor = [UIColor whiteColor];//有时候，白色的底色也是需要设置的哦
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
