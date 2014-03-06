//
//  BTBabyWeightViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-6.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBabyWeightViewController.h"
#import "BTUtils.h"
@interface BTBabyWeightViewController ()

@end

@implementation BTBabyWeightViewController

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
    self.navigationItem.title = @"胎儿体重";
     self.view.backgroundColor = [UIColor whiteColor];//有时候，白色的底色也是需要设置的哦
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    // 跟手机设置同一个时区
    // 以后如果加表功能，没有坑
    [df setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate* date2000 = [df dateFromString:@"2000/01/01 00:00:00"];

    NSLog(@"cececececece%@",date2000);
    NSNumber *year = [BTUtils getYear:date2000];
    NSNumber *dar = [BTUtils getDay:date2000];
    NSNumber *hour = [BTUtils getHour:date2000];
    
    
    NSLog(@"cececec%@  %@  %@",year,dar,hour);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
