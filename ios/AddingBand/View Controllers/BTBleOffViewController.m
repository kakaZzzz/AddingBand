//
//  BTBleOffViewController.m
//  AddingBand
//
//  Created by wangpeng on 14-1-8.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import "BTBleOffViewController.h"

@interface BTBleOffViewController ()

@end

@implementation BTBleOffViewController

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
    //
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-270/2)/2, 20, 270/2, 270/2)];
    aImageView.image = [UIImage imageNamed:@"bluetooth_icon"];
    [self.view addSubview:aImageView];
    
    
    
    UIImageView *bImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-270/2)/2, 100, 270/2, 270/2)];
    bImageView.image = [UIImage imageNamed:@"bluetooth_setting_icon"];
    [self.view addSubview:bImageView];

    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
