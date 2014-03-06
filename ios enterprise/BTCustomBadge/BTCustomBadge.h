//
//  BTBadgeManager.h
//  AddingBand
//
//  Created by wangpeng on 13-12-9.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTCustomBadge : UIView

@property (strong, nonatomic) NSString *badgeText;
@property (strong, nonatomic) UIColor *badgeTextColor;
@property (strong, nonatomic) UIColor *badgeInsetColor;
@property (strong, nonatomic) UIColor *badgeFrameColor;

@property (assign, nonatomic) BOOL badgeFrame;
@property (assign, nonatomic) BOOL badgeShining;
@property (assign, nonatomic) BOOL badgeShadow;

@property (assign, nonatomic) CGFloat badgeCornerRoundness;
@property (assign, nonatomic) CGFloat badgeScaleFactor;

+ (BTCustomBadge *)customBadgeWithString:(NSString *)badgeString;

+ (BTCustomBadge *)customBadgeWithString:(NSString *)badgeString
                         withStringColor:(UIColor*)stringColor
                          withInsetColor:(UIColor*)insetColor
                          withBadgeFrame:(BOOL)badgeFrameYesNo
                     withBadgeFrameColor:(UIColor*)frameColor
                               withScale:(CGFloat)scale
                             withShining:(BOOL)shining
                              withShadow:(BOOL)shadow;

// Use to change the badge text after the first rendering
- (void)autoBadgeSizeWithString:(NSString *)badgeString;

@end
