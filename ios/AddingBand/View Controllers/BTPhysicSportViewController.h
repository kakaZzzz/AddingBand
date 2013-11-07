//
//  BTSyncViewController.h
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBandCentral.h"

@class BarChartView;
@class BTGlobals;
@interface BTPhysicSportViewController : UIViewController
@property (strong, nonatomic)BarChartView *barChart;//柱形图
@property (strong, nonatomic)UILabel *totalStep;//一共走了多少步
@property (strong, nonatomic)UILabel *realStep;//实际走了多少步

@property(strong, nonatomic) NSManagedObjectContext* context;
@property (strong, nonatomic) NSMutableArray* dailyData;
@property (assign, nonatomic) int stepCount;

@property(strong, nonatomic) BTGlobals* g;
@property(strong, nonatomic) BTBandCentral* bc;

+(BTPhysicSportViewController *)sharedPhysicSportViewController;

@end
