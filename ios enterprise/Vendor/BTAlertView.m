//
//  BTAlertView.h
//  MoreLikers
//
//  Created by wangpeng on 13-12-25.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import "BTAlertView.h"
#import "BTAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "LayoutDef.h"

#define kAlertWidth 245.0f
#define kAlertHeight 160.0f

@interface BTAlertView ()
{
    BOOL _leftLeave;
}

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *backImageView;

@end

@implementation BTAlertView

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define kTitleXOffset 10.0f
#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f

- (id)initWithTitle:(NSString *)title
          iconImage:(UIImage *)iconImage
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init]) {
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kTitleXOffset, kTitleYOffset, 44/2, 44/2)];
        _iconImage.backgroundColor = [UIColor clearColor];
        _iconImage.image = iconImage;
        [self addSubview:_iconImage];
        
        
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleXOffset +kTitleHeight, kTitleYOffset, kAlertWidth - kTitleHeight -kTitleXOffset, kTitleHeight)];
        self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        self.alertTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.alertTitleLabel.textColor = kBigTextColor;
        [self addSubview:self.alertTitleLabel];
        
        CGFloat contentLabelWidth = kAlertWidth - 16;
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame), contentLabelWidth, 60)];
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textAlignment = NSTextAlignmentCenter;
        self.alertContentLabel.textColor = kBigTextColor;
        self.alertContentLabel.font = [UIFont systemFontOfSize:17.0f];
        [self addSubview:self.alertContentLabel];
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 107.0f
#define kButtonHeight 40.0f
#define kButtonBottomOffset 10.0f
        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }
        //颜色 按钮颜色
//        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87.0/255.0 green:135.0/255.0 blue:173.0/255.0 alpha:1]] forState:UIControlStateNormal];
         
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];

        [self.leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:227.0/255.0 green:100.0/255.0 blue:83.0/255.0 alpha:1]] forState:UIControlStateNormal];
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:kBigTextColor forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        self.alertTitleLabel.text = title;
        self.alertContentLabel.text = content;
        
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
       // [self addSubview:xButton];
        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)leftBtnClicked:(id)sender
{
    _leftLeave = YES;
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock();
    }
}

- (void)show
{
    UIWindow *shareWindow =((BTAppDelegate *)[[UIApplication sharedApplication] delegate]).window;
    self.frame = CGRectMake((CGRectGetWidth(shareWindow.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, kAlertWidth, kAlertHeight);
    [shareWindow addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIWindow *shareWindow =((BTAppDelegate *)[[UIApplication sharedApplication] delegate]).window;
    CGRect afterFrame = CGRectMake((CGRectGetWidth(shareWindow.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(shareWindow.bounds), kAlertWidth, kAlertHeight);
    
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        if (_leftLeave) {
            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        }else {
            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
   UIWindow *shareWindow =((BTAppDelegate *)[[UIApplication sharedApplication] delegate]).window;
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:shareWindow.bounds];
    }
    self.backImageView.backgroundColor = [UIColor blackColor];
    self.backImageView.alpha = 0.6f;
    [shareWindow addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(shareWindow.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(shareWindow.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}

@end

@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
