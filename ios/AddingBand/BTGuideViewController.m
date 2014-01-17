//
//  WZGuideViewController.m
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import "BTGuideViewController.h"
#import "LayoutDef.h"
@interface BTGuideViewController ()

@end

@implementation BTGuideViewController

@synthesize animating = _animating;

@synthesize pageScroll = _pageScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -

- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
	}
	return frame;
}

- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
		[BTGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[BTGuideViewController sharedGuide].view];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		[BTGuideViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideShown
{
	_animating = NO;
}

- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[BTGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideHidden
{
	_animating = NO;
	[[[BTGuideViewController sharedGuide] view] removeFromSuperview];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

+ (void)show
{
    [[BTGuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[BTGuideViewController sharedGuide] showGuide];
}

+ (void)hide
{
	[[BTGuideViewController sharedGuide] hideGuide];
}

#pragma mark - 

+ (BTGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static BTGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}


- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *imageNameArray = [NSArray arrayWithObjects:@"guide_iphone5earlier1", @"guide_iphone5earlier2", @"guide_iphone5earlier3",nil];
    if (IPHONE_5_OR_LATER) {
        imageNameArray = [NSArray arrayWithObjects:@"guide_iphone5later1", @"guide_iphone5later2", @"guide_iphone5later3",nil];
    }
    
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.delegate = self;
    self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * imageNameArray.count, self.view.frame.size.height);
    self.pageScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.pageScroll];
    
    NSString *imgName = nil;
    UIView *view;
    for (int i = 0; i < imageNameArray.count; i++) {
        imgName = [imageNameArray objectAtIndex:i];
        view = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i), 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imgName]];
        [self.pageScroll addSubview:view];
        
        if (i == imageNameArray.count - 1) {            
            
            UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 160.f, 35.f)];
            [enterButton setCenter:CGPointMake(self.view.center.x, view.frame.size.height - 60)];
            [enterButton setBackgroundColor:[UIColor clearColor]];
            [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:enterButton];
            
            
            UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake((enterButton.frame.size.width - 140)/2, (enterButton.frame.size.height - 30)/2, 140, 30)];
            buttonLabel.font = [UIFont systemFontOfSize:24];
            buttonLabel.backgroundColor = [UIColor clearColor];
            buttonLabel.textColor = [UIColor whiteColor];
            buttonLabel.text = @"立即进入";
            buttonLabel.textAlignment = NSTextAlignmentCenter;
            [enterButton addSubview:buttonLabel];
            
            UIImageView *accessorImage = [[UIImageView alloc] initWithFrame:CGRectMake((enterButton.frame.size.width - 20), (enterButton.frame.size.height - 38/2)/2, 25/2, 38/2)];
            accessorImage.image = [UIImage imageNamed:@"guide_accessory"];
            [enterButton addSubview:accessorImage];

        }
    }
    
    
    self.pagePotControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 220)/2, self.view.frame.size.height - 100, 220, 30)];
    if (IOS7_OR_LATER) {
        self.pagePotControl.frame = CGRectMake((self.view.frame.size.width - 220)/2, self.view.frame.size.height - 130, 220, 30);
    }
    _pagePotControl.numberOfPages = imageNameArray.count;
   // _pagePotControl.pageIndicatorTintColor = [UIColor yellowColor];
    _pagePotControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [_pagePotControl addTarget:self
                     action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pagePotControl];
  
}
- (void)changePage:(UIPageControl *)pageContol
{
    [self.pageScroll setContentOffset:CGPointMake(320*pageContol.currentPage, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //图片滚动  pageCtroll滚动
    CGFloat harfWidth = scrollView.frame.size.width/2;
    int page = (scrollView.contentOffset.x - harfWidth)/320 + 1;
    _pagePotControl.currentPage = page;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
