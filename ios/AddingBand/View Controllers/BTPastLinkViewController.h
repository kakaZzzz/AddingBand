//
//  BTPastLinkViewController.h
//  AddingBand
//
//  Created by kaka' on 13-11-19.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BTGlobals;
@class BTBandCentral;
@interface BTPastLinkViewController : UIViewController<UIAlertViewDelegate>
@property(strong, nonatomic) NSManagedObjectContext *context;
//全局变量
@property(strong, nonatomic) BTGlobals* g;
//中央设备 即您的iPhone
@property(strong, nonatomic) BTBandCentral* bc;

@property(nonatomic,strong)UIButton *refreshButton;

//视图布局
@property(strong, nonatomic) UIImageView * aImageView;//粉红色背景图片
@property(strong, nonatomic) UIImageView * aIconImage;//手环图标
@property(strong, nonatomic) UIImageView * asynctimeImage;//上次同步时间背景图片
@property(nonatomic,strong)UILabel *lastSyncTime;//设备上次同步时间
@property(nonatomic,strong)UIButton *syncButton;//同步按钮按钮
@property(nonatomic,strong)UIImageView * syncIcon;//同步图标

@property(nonatomic,strong)UILabel *batteryLabel;//电量
@property(nonatomic,strong)UILabel *nameLabel;//设备名称
@property(nonatomic,strong)UILabel *linkLabel;//连接状态

//单例
+ (BTPastLinkViewController *)sharePastLinkview;
@end
