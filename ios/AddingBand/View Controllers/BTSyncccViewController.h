//
//  BTSyncccViewController.h
//  AddingBand
//
//  Created by kaka' on 13-11-20.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//


/**
 *  此页面是同步页面
 */
#import <UIKit/UIKit.h>
#import "BTBandCentral.h"
@class BTSyncTwoViewController;
@class BTPastLinkViewController;
@class BTCloseToBleViewController;
@class DDIndicator;
@class BTBleOffViewController;
@interface BTSyncccViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
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
//@property(nonatomic,strong)BTCloseToBleViewController *closeToBleVC;//搜索超时 加载靠近设备提示页面
@property(nonatomic,strong)BTBleOffViewController *offBleVC;//搜索超时 加载靠近设备提示页面,或者蓝牙没有打开页面
@property(nonatomic,strong)UIButton *deleteButton;

@property(nonatomic,assign)int selectedRow;//选择的设备行数
@property(nonatomic,strong)NSManagedObjectContext *context;

@property(nonatomic,strong)DDIndicator *indicator;//加载指示图
@property(nonatomic,strong)UITableView *tableView;//
@property(nonatomic,strong)UIScrollView *aScrollView;//背景视图要是一个可以滚动的视图


//提示语句
@property(nonatomic,strong)UILabel *label1;//
@property(nonatomic,strong)UILabel *label2;//
@property(nonatomic,strong)UILabel *label3;//
//可连接设备label
@property(nonatomic,strong)UILabel *labelSection;//
//重新搜索button
@property(nonatomic,strong)UIButton *refreshButton;

@end
