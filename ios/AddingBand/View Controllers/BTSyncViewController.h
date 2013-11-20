//
//  BTSyncViewController.h
//  AddingBand
//
//  Created by kaka' on 13-11-4.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBandCentral.h"
@class BTSyncTwoViewController;
@class BTPastLinkViewController;
@class DDIndicator;
@interface BTSyncViewController : UITableViewController<UIAlertViewDelegate>
//存放外设备
@property (strong, nonatomic) NSMutableArray *peripheralArray;
//全局变量
@property(strong, nonatomic) BTGlobals* g;
//中央设备 即您的iPhone
@property(strong, nonatomic) BTBandCentral* bc;
//正在连接指示条
//@property(strong, nonatomic) UIActivityIndicatorView * indicator;
//断开操作标示符
@property(assign, nonatomic) BOOL isBreak;
//上次同步时间
@property(nonatomic,strong)NSString *lastSyncTime;

@property(nonatomic,strong)BTSyncTwoViewController *syncTwoVC;//连接完成之后的视图控制器
@property(nonatomic,strong)BTPastLinkViewController *pastVC;//发现历史设备但是没有连接的视图控制器
@property(nonatomic,strong)UIButton *syncButton;

@property(nonatomic,assign)int selectedRow;//选择的设备行数
@property(nonatomic,strong)NSManagedObjectContext *context;

@property(nonatomic,strong)DDIndicator *indicator;//加载指示图
@end
