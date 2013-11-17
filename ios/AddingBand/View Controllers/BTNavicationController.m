//
//  BTNavicationController.m
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTNavicationController.h"
#import <QuartzCore/QuartzCore.h>
#import "BTColor.h"
@interface BTNavicationController ()
@property(nonatomic,strong) CALayer *animationLayer;
@end

@implementation BTNavicationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //设置NavigationBar的毛玻璃效果
        [self setNavigationBarStyle];
    }
    return self;
}

#pragma mark - 设置NavigationBar
//设置NavigationBar
- (void)setNavigationBarStyle
{
    // Set Navigation Bar style
    CGRect rect = CGRectMake(0.0f, 0.0f, 320, 44.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[BTColor getColor:@"EE4966"] CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];
    
 
  //  [[UINavigationBar appearance] setTintColor: [UIColor redColor]];
  //  [[UINavigationBar appearance] setTitleVerticalPositionAdjustment: 1.0f forBarMetrics: UIBarMetricsDefault];
    
   // UIColor *titleColor = [UIColor colorWithRed: 150.0f/255.0f green: 149.0f/255.0f blue: 149.0f/255.0f alpha: 1.0f];
    UIColor *titleColor = [UIColor whiteColor];

    UIColor* shadowColor = [UIColor colorWithWhite: 1.0 alpha: 1.0];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];
    
//   [[UINavigationBar appearance] setTitleTextAttributes: @{UITextAttributeTextColor: titleColor,
//                                                            UITextAttributeFont: [UIFont boldSystemFontOfSize: 23.0f],
//                                                            UITextAttributeTextShadowColor: shadowColor,
//                                                            UITextAttributeTextShadowOffset: [NSValue valueWithCGSize: CGSizeMake(0.0, 1.0)]}];
    
//    [[UINavigationBar appearance] setTitleTextAttributes: @{UITextAttributeTextColor: titleColor,
//                                     UITextAttributeFont: [UIFont systemFontOfSize:20.0]}];
   
    self.navigationBar.translucent =NO;

}
#pragma mark - push 和 pop 动画效果
-(void)loadLayerWithImage
{
    
    
    UIGraphicsBeginImageContext(self.visibleViewController.view.bounds.size);
    [self.visibleViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    [_animationLayer setContents: (id)viewImage.CGImage];
    [_animationLayer setHidden:NO];
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _animationLayer = [CALayer layer] ;
    CGRect layerFrame = self.view.frame;
    layerFrame.size.height = self.view.frame.size.height-self.navigationBar.frame.size.height;
    layerFrame.origin.y = self.navigationBar.frame.size.height+20;
    _animationLayer.frame = layerFrame;
    _animationLayer.masksToBounds = YES;
    [_animationLayer setContentsGravity:kCAGravityBottomLeft];
    [self.view.layer insertSublayer:_animationLayer atIndex:0];
    _animationLayer.delegate = self;
    
    
}
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    id<CAAction> action = (id)[NSNull null];
    return action;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect layerFrame = self.view.bounds;
    layerFrame.size.height = self.view.bounds.size.height-self.navigationBar.frame.size.height;
    layerFrame.origin.y = self.navigationBar.frame.size.height+20;
    _animationLayer.frame = layerFrame;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [_animationLayer removeFromSuperlayer];
    [self.view.layer insertSublayer:_animationLayer atIndex:0];
    if(animated)
    {
        [self loadLayerWithImage];
        
        
        
        UIView * toView = [viewController view];
        
        
        //推进的页面的动画效果
        CABasicAnimation *Animation  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / 1000;
        rotationAndPerspectiveTransform = CATransform3DMakeTranslation(self.view.frame.size.width, 0, 0);
        [Animation setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.view.bounds.size.width, 0, 0)]];
        [Animation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)]];
        [Animation setDuration:0.3];
        Animation.delegate = self;
        Animation.removedOnCompletion = NO;
        Animation.fillMode = kCAFillModeBoth;
        
        [toView.layer addAnimation:Animation forKey:@"fromRight"];
        
        //原来页面的动画效果
        CABasicAnimation *Animation1  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform1 = CATransform3DIdentity;
        rotationAndPerspectiveTransform1.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform1 = CATransform3DMakeScale(1.0, 1.0, 1.0);
        [Animation1 setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [Animation1 setDuration:0.3];
        Animation1.delegate = self;
        Animation1.removedOnCompletion = NO;
        Animation1.fillMode = kCAFillModeBoth;
        [_animationLayer addAnimation:Animation1 forKey:@"scale"];
    }
    [super pushViewController:viewController animated:NO];
}
-(UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    [_animationLayer removeFromSuperlayer];
    [self.view.layer insertSublayer:_animationLayer above:self.view.layer];
    if(animated)
    {
        [self loadLayerWithImage];
        
        
        
        UIView * toView = [[self.viewControllers objectAtIndex:[self.viewControllers indexOfObject:self.visibleViewController]-1] view];
        
        
        
        
        CABasicAnimation *Animation  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform = CATransform3DMakeTranslation(self.view.frame.size.width, 0, 0);
        [Animation setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [Animation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.view.bounds.size.width, 0, 0)]];
        [Animation setDuration:0.3];
        Animation.delegate = self;
        Animation.removedOnCompletion = NO;
        Animation.fillMode = kCAFillModeBoth;
        [_animationLayer addAnimation:Animation forKey:@"scale"];
        
        
        CABasicAnimation *Animation1  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform1 = CATransform3DIdentity;
        rotationAndPerspectiveTransform1.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform1 = CATransform3DMakeScale(1.0, 1.0, 1.0);
        [Animation1 setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [Animation1 setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [Animation1 setDuration:0.3];
        Animation1.delegate = self;
        Animation1.removedOnCompletion = NO;
        Animation1.fillMode = kCAFillModeBoth;
        [toView.layer addAnimation:Animation1 forKey:@"scale"];
        
    }
    return [super popViewControllerAnimated:NO];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_animationLayer setContents:nil];
    [_animationLayer removeAllAnimations];
    [self.visibleViewController.view.layer removeAllAnimations];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
