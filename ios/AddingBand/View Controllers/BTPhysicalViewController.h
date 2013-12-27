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
#import "BTScrollViewController.h"
@class CircularProgressView;
@class BarChartView;
@class PICircularProgressView;
@class BTPhysicalCollectionView;
@interface BTPhysicalViewController : BTScrollViewController<UIScrollViewDelegate,
MHTabBarControllerDelegate,
UITableViewDataSource,
UITableViewDelegate>

//视图布局
@property(nonatomic,strong)UIView *navigationBgView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)BTPhysicalCollectionView *physicalView;
@property(strong, nonatomic) UIImageView * gradeImage;//上次同步时间背景图片
@property (strong, nonatomic)PICircularProgressView *progressView;//分数圆圈
@property(nonatomic,strong)MHTabBarController *tabBarController;//一定要用属性，不然就dealloc了
@property(nonatomic,strong)UITableView *tableView;//表视图
@property (strong, nonatomic)NSTimer *timer;
//数据
@property(nonatomic,assign)float progress;//进度
@property(nonatomic,strong)NSMutableArray *dataArray;//数据数组
@end
