//
//  BTSyncViewController.h
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBandCentral.h"
#import "MHTabBarController.h"
@class BarChartView;
@class BTGlobals;
@class MHTabBarController;
@interface BTPhysicSportViewController : UIViewController<MHTabBarControllerDelegate>
@property (strong, nonatomic)BarChartView *barChart;//柱形图
@property (strong, nonatomic)UILabel *totalStep;//一共走了多少步
@property (strong, nonatomic)UILabel *realStep;//实际走了多少步

@property(strong, nonatomic) NSManagedObjectContext* context;
@property (strong, nonatomic) NSMutableArray* dailyData;
@property (assign, nonatomic) int stepCount;

@property(strong, nonatomic) BTGlobals* g;
@property(strong, nonatomic) BTBandCentral* bc;
//柱形图Y值
@property(strong, nonatomic) NSArray *barYValue;
//柱形图X值
@property(strong, nonatomic) NSArray *barXValue;
//柱形图柱子颜色
@property(strong, nonatomic) NSMutableArray *barColors;
//柱形图下横坐标颜色
@property(strong, nonatomic) NSMutableArray *barLabelColors;

@property(nonatomic,strong)MHTabBarController *tabBarController;//一定要用属性，不然就dealloc了
@end
