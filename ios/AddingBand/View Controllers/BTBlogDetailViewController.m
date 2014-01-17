//
//  BTBlogDetailViewController.m
//  AddingBand
//
//  Created by wangpeng on 14-1-15.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import "BTBlogDetailViewController.h"
#import "LayoutDef.h"
@interface BTBlogDetailViewController ()
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation BTBlogDetailViewController

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
    self.navigationItem.title = @"知识详情";
    [self.scrollView removeFromSuperview];
    

    
  NSURL *strUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HTTP_HEADER,self.blogHash]];
   

    [self addWebViewWithUrl:strUrl];
    

	// Do any additional setup after loading the view.
}

- (void)addWebViewWithUrl:(NSURL *)url
{
    

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height- 44)];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    self.webView.suppressesIncrementalRendering = YES;
    [self.view addSubview:self.webView];
 
    

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50)/2, self.view.center.y - 70, 50, 50)];
    _imageView.image = [UIImage imageNamed:@"loading1.png"];
    NSMutableArray * imageArray = [NSMutableArray arrayWithCapacity:1];
    for (int i=1;i<6;i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d",i]];
        [imageArray addObject:image];
    }
    _imageView.animationImages = imageArray;
    _imageView.animationDuration = 1.5;
    [self.view addSubview:_imageView];


}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
    NSLog(@"shouldStartLoadWithRequest");
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"ViewDidStartLoad---");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //  [_activityIndicatorView startAnimating];
    [_imageView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad---");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    

    [_imageView stopAnimating];
    [_imageView removeFromSuperview];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError---");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
