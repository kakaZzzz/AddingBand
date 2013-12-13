//
//  PNLineChart.h
//  PNChartDemo
//
//  Created by wangpeng on 11/7/13.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define xLabelMargin    20.0f//x轴最左边数值距离折线图最左端的距离
#define yLabelMargin    15.0f//y轴最顶上数值距离折线图顶端的距离
#define yLabelHeight    11.0f//y坐标指示label的高度


@interface PNLineChart : UIView

/**
 * This method will call and troke the line in animation
 */

//-(void)strokeChart;

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;

@property (nonatomic) CGFloat xLabelWidth;

@property (nonatomic) int yValueMax;

@property (nonatomic,strong) CAShapeLayer * chartLine;

@property (nonatomic, strong) UIColor * strokeColor;


@end
