//
//  BTPhysicQuickeningViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-6.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTPhysicQuickeningViewController.h"
#import "CircularProgressView.h"
@interface BTPhysicQuickeningViewController ()

@end

@implementation BTPhysicQuickeningViewController

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
    self.navigationItem.title = @"MAMA胎动";
    self.view.backgroundColor = [UIColor blueColor];
    [self addCircleProgress];
	// Do any additional setup after loading the view.
}
//加载 圆形进度条
- (void)addCircleProgress
{
    //set backcolor & progresscolor
    UIColor *backColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *progressColor = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    
    //alloc CircularProgressView instance
    self.circularProgressView = [[CircularProgressView alloc] initWithFrame:CGRectMake(25, 77, 270, 270) backColor:backColor progressColor:progressColor lineWidth:10];
    //圆形进度条 进度
    [self.circularProgressView updateProgressCircle:1000 withTotal:12000];
    //add CircularProgressView
    [self.view addSubview:self.circularProgressView];
    
     
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
