//
//  BTSyncViewController.h
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BarChartView;

@interface BTPhysicSportViewController : UIViewController
@property (strong, nonatomic)BarChartView *barChart;//柱形图
@property (strong, nonatomic)UILabel *totalStep;//一共走了多少步
@property (strong, nonatomic)UILabel *realStep;//实际走了多少步
@end
