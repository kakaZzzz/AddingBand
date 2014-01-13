//
//  BTFetalDailyViewController.h
//  AddingBand
//
//  Created by wangpeng on 13-12-12.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTScrollViewController.h"
@class BTRecordFetalView;
@class PNChart;
@interface BTFetalDailyViewController : BTScrollViewController
//视图布局
@property(nonatomic,strong)BTRecordFetalView *recordVC;
@property(nonatomic,strong)UILabel *lastTimeLabel;//胎动记录时间
@property(nonatomic,strong)UILabel *lastCountLabel;//胎动次数
@property(nonatomic,strong)UILabel *fetalConditionTitle;//胎动记录情况标题


@property(nonatomic,strong)UIButton *startButton;
@property(nonatomic,strong)PNChart * lineChart;
@property(nonatomic,strong)UIScrollView *lineScrollView;
//数据
@property(nonatomic,strong)NSMutableArray *arrayBarXValue;//柱状遮挡的x坐标数组
@property(nonatomic,strong)NSMutableArray *lineYValues;//绘制折线图使用
@end
