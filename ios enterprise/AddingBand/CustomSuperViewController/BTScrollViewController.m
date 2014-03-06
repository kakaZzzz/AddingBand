//
//  BTScrollViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-18.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTScrollViewController.h"

@interface BTScrollViewController ()

@end

@implementation BTScrollViewController

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
    [self addScrollView];
	// Do any additional setup after loading the view.
}
- (void)addScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 50);
    [self.view addSubview:_scrollView];
    
    [self configureNavigationbar];
}
#pragma mark - 设置导航栏上面的按钮
- (void)configureNavigationbar
{
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(250, 5, 100/2, 48/2);
    [_backButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_unselected"] forState:UIControlStateNormal];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_selected"] forState:UIControlStateHighlighted];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_selected"] forState:UIControlStateSelected];
    [_backButton addTarget:self action:@selector(backToUpperView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)_backButton];

}
- (void)backToUpperView:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
    [self backToPreviousViewController];
}
- (void)backToPreviousViewController
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
