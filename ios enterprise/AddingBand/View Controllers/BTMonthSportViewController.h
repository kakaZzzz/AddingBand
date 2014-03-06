//
//  BTMonthSportViewController.h
//  AddingBand
//
//  Created by wangpeng on 13-12-12.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarView.h"
@class BarChartView;
@interface BTMonthSportViewController : UIViewController
@property (strong, nonatomic)BarChartView *barChart;//柱形图
@property (strong, nonatomic)NSArray *xLableArray;//柱形图x轴数组
@property (strong, nonatomic)NSMutableArray *yValueArray;//柱形图y轴数组
@property (strong,nonatomic)NSArray *barColorsArray;//柱子颜色
@property (strong,nonatomic)NSArray *labelColorsArray;//横坐标颜色

@property(nonatomic,strong)UIScrollView *lineScrollView;

@end
