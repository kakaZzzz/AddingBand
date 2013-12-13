//
//  BTPhysicalViewController.h
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

/**
 *  此页面为体征页面
 */
#import <UIKit/UIKit.h>
#import "MHTabBarController.h"
@class CircularProgressView;
@class BarChartView;
@class PICircularProgressView;

@interface BTPhysicalViewController : UIViewController<UIScrollViewDelegate,
MHTabBarControllerDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property (strong, nonatomic) CircularProgressView *circularGrade;//总分数进度条
@property (strong, nonatomic) CircularProgressView *circularSport;//运动量进度条
@property (strong, nonatomic) UILabel *gradeLabel;//总分数Label
@property (strong, nonatomic) UILabel *sportLabel;//运动量Label



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

//视图布局
@property(strong, nonatomic) UIImageView * aImageView;//粉红色背景图片
@property(strong, nonatomic) UIImageView * useTimeImage;//上次同步时间背景图片
@property(strong, nonatomic) UILabel * useTimeLabel;//上次同步时间背景图片
//分数圆圈
@property (strong, nonatomic)PICircularProgressView *progressView;
@property (strong, nonatomic)NSTimer *timer;
@property(nonatomic,assign)float progress;

@property(nonatomic,strong)MHTabBarController *tabBarController;//一定要用属性，不然就dealloc了
@property(nonatomic,strong)UITableView *tableView;//一定要用属性，不然就dealloc了

@end
