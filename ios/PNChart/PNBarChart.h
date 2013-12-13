//
//  PNBarChart.h
//  PNChartDemo
//
//  Created by wangpeng on 11/7/13.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define charBartMargin     10
//#define xBarLabelMargin    15
//#define yLabelHeight    11

@interface PNBarChart : UIView

/**
 * This method will call and troke the line in animation
 */

-(void)strokeChartWithXLabels:(NSArray *)xLabelArray;

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;

@property (nonatomic) CGFloat xLabelWidth;

@property (nonatomic) int yValueMax;

@property (nonatomic, strong) UIColor * strokeColor;


@end
