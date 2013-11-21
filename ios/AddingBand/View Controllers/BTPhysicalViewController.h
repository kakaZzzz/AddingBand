//
//  BTPhysicalViewController.h
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircularProgressView;
@class PCLineChartView;
@class BarChartView;
@interface BTPhysicalViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) CircularProgressView *circularGrade;//总分数进度条
@property (strong, nonatomic) CircularProgressView *circularSport;//运动量进度条
@property (strong, nonatomic) UILabel *gradeLabel;//总分数Label
@property (strong, nonatomic) UILabel *sportLabel;//运动量Label
@property (nonatomic, strong) PCLineChartView *lineChartView;//折线图


//演示用柱形图
@property (strong, nonatomic)BarChartView *barChart;//柱形图
//柱形图Y值
@property(strong, nonatomic) NSArray *barYValue;
//柱形图X值
@property(strong, nonatomic) NSArray *barXValue;
//柱形图柱子颜色
@property(strong, nonatomic) NSMutableArray *barColors;
//柱形图下横坐标颜色
@property(strong, nonatomic) NSMutableArray *barLabelColors;


@end
