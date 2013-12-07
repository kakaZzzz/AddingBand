//
//  CircularProgressView.h
//  CircularProgressView
//
//  Created by wangpeng on 13-11-3.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol CircularProgressDelegate;

@interface CircularProgressView : UIView


- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth;


- (void)updateProgressCircle:(int)start withTotal:(int)total;


@end