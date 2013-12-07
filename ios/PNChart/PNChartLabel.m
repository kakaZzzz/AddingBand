//
//  PNChartLabel.m
//  PNChart
//
//  Created by kevin on 28/11/13.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import "PNChartLabel.h"

#define LABEL_TEXT_COLOR  [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0f]
@implementation PNChartLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setLineBreakMode:NSLineBreakByWordWrapping];
        [self setMinimumScaleFactor:11.0f];
        [self setNumberOfLines:0];
        [self setFont:[UIFont boldSystemFontOfSize:11.0f]];
        [self setTextColor:LABEL_TEXT_COLOR];//LABEL颜色
        self.backgroundColor = [UIColor clearColor];
        [self setTextAlignment:NSTextAlignmentLeft];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
