//
//  BTSyncTwoViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-19.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTSyncTwoViewController.h"
#import "BTGlobals.h"
#import "BTBandCentral.h"

#define kImageBgX 0
#define kImageBgY 0
#define kImageBgWidth 320
#define kImageBgHeight 200

#define kIconImageX 10
#define kIconImageY (kImageBgHeight - 75)/2
#define kIconImageWidth 75
#define kIconImageHeight 75

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

static BTSyncTwoViewController *syncTwoVC = nil;
@interface BTSyncTwoViewController ()

@end

@implementation BTSyncTwoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
          self.g = [BTGlobals sharedGlobals];
         self.bc = [BTBandCentral sharedBandCentral];
        //监听设备变化
        [self.g addObserver:self forKeyPath:@"bleListCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
    }
    return self;
}
+ (BTSyncTwoViewController *)shareSyncTwoview
{
    @synchronized(self)//单例标准写法 防止多线程访问单例出错
    {
        if (syncTwoVC == nil) {
            syncTwoVC = [[BTSyncTwoViewController alloc]init];
            
        }
        return syncTwoVC;
        
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
  
    
    //
    [self addSubviews];
  	// Do any additional setup after loading the view.
}
- (void)shuchu
{
    NSLog(@"点击了测试按钮");
     NSLog(@"同步数据");
    //进行同步 这里也得判断设备是哪个设备啊
    [self.bc sync:MAM_BAND_MODEL];

    
}
- (void)addSubviews
{
    //背景粉红图
    if (iPhone5) {
         self.aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageBgX, kImageBgY, kImageBgWidth, kImageBgHeight + 50)];
    }
    else
    {
    self.aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageBgX, kImageBgY, kImageBgWidth, kImageBgHeight)];
    }
    _aImageView.image = [UIImage imageNamed:@"red_bg.png"];
    [self.view addSubview:_aImageView];
    //手环icon
    self.aIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageWidth, kIconImageHeight)];
    _aIconImage.image = [UIImage imageNamed:@"家丁手环icon.png"];
    [_aImageView addSubview:_aIconImage];
    //上次同步时间背景图
    self.asynctimeImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 140, (kImageBgHeight - 50)/2, 140, 50)];
    _asynctimeImage.image = [UIImage imageNamed:@"透明层.png"];
    [_aImageView addSubview:_asynctimeImage];
    
    //上次同步时间
    self.lastSyncTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _asynctimeImage.frame.size.width,_asynctimeImage.frame.size.height)];
    _lastSyncTime.backgroundColor = [UIColor clearColor];
    _lastSyncTime.font = [UIFont systemFontOfSize:16];
    _lastSyncTime.textColor = [UIColor whiteColor];
    _lastSyncTime.textAlignment = NSTextAlignmentCenter;
    _lastSyncTime.lineBreakMode = NSLineBreakByTruncatingTail;
    _lastSyncTime.numberOfLines= 0;
    [self.asynctimeImage addSubview:_lastSyncTime];

    //电量
    
    self.batteryLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, _aIconImage.frame.origin.y - 5, 90,30)];
    NSLog(@"电量标签的坐标%@", NSStringFromCGRect(_batteryLabel.frame));
    _batteryLabel.backgroundColor = [UIColor clearColor];
   
    _batteryLabel.font = [UIFont systemFontOfSize:15];
    _batteryLabel.textColor = [UIColor whiteColor];
    _batteryLabel.textAlignment = NSTextAlignmentCenter;
    _batteryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _batteryLabel.numberOfLines= 0;
    [self.view addSubview:_batteryLabel];

    //设备名称
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_batteryLabel.frame.origin.x, _batteryLabel.frame.origin.y + _batteryLabel.frame.size.height,_batteryLabel.frame.size.width,_batteryLabel.frame.size.height)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:20];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = @"加丁手环";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLabel.numberOfLines= 0;
    [self.view addSubview:_nameLabel];

    //连接状态
    self.linkLabel = [[UILabel alloc]initWithFrame:CGRectMake(_batteryLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height,_nameLabel.frame.size.width,_nameLabel.frame.size.height)];
    _linkLabel.backgroundColor = [UIColor clearColor];
    _linkLabel.font = [UIFont systemFontOfSize:15];
    _linkLabel.textColor = [UIColor whiteColor];
    _linkLabel.text = @"连接成功";
    _linkLabel.textAlignment = NSTextAlignmentCenter;
    _linkLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _linkLabel.numberOfLines= 0;
    [self.view addSubview:_linkLabel];

    //设备使用时间背景
  
    self.useTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,_aImageView.frame.size.height - 50, 320, 50)];
    _useTimeImage.image = [UIImage imageNamed:@"uestime_bg.png"];

     [_aImageView   addSubview:_useTimeImage];
    

    //使用时间标签
    self.useTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, _useTimeImage.frame.size.height)];
    _useTimeLabel.backgroundColor = [UIColor clearColor];
    _useTimeLabel.text = @"使用时间:---";
    _useTimeLabel.textColor = [UIColor whiteColor];
    [_useTimeImage addSubview:_useTimeLabel];
    //同步按钮
    self.testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   // [_testButton setTitle:@"测试按钮" forState:UIControlStateNormal];
    _testButton.frame = CGRectMake((self.view.frame.size.width - 95)/2, self.view.frame.size.height - 210, 95, 120);
    if (iPhone5) {
        _testButton.frame = CGRectMake((self.view.frame.size.width - 95)/2, self.view.frame.size.height - 260, 95, 120);
    }
    [_testButton setBackgroundImage:[UIImage imageNamed:@"sync_btn.png"] forState:UIControlStateNormal];
    [_testButton setBackgroundImage:[UIImage imageNamed:@"sync_btn_sel.png"] forState:UIControlStateHighlighted];
    [_testButton addTarget:self action:@selector(shuchu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_testButton];

    //同步旋转图标
    self.syncIcon = [[UIImageView alloc] initWithFrame:CGRectMake(29, 20, 40, 34)];
    _syncIcon.image = [UIImage imageNamed:@"sync_icon.png"];
    [_testButton addSubview:_syncIcon];

}
//监控参数，更新显示  当连接  断开的时候也会调用此方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"监听设备数量变化3333");
    
    if([keyPath isEqualToString:@"bleListCount"])
    {
        NSLog(@"ble count: %d", self.g.bleListCount);
        
        //行数变化时，重新加载列表
        //todo 等于0的时候处理成“查找中”
        if (self.g.bleListCount == 0) {
            //加载动画显示
            }
        if (self.g.bleListCount > 0) {
            BTBandPeripheral*bp  = [self.bc getBpByIndex:0];
            
            //是否发现
            Boolean isFinded = bp.isFinded;
            
            //是否连接
            Boolean isConnected = bp.isConnected;
            
            //是否正在连接中
            BOOL isConnecting = bp.isConnecting;
            
            if (isConnected) {
                NSLog(@"隐藏测试按钮");
                self.testButton.hidden = NO;
                
            }

            
           }
        
        if ([self.bc isConnectedByModel:MAM_BAND_MODEL]){
            NSLog(@"oh oh fuck");
            
            [[self.bc getBpByModel:MAM_BAND_MODEL] addObserver:self forKeyPath:@"dlPercent" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        }
    }
    
    //侦听 同步进度
    if([keyPath isEqualToString:@"dlPercent"])
    {
        BTBandPeripheral *bp = [self.bc getBpByModel:MAM_BAND_MODEL];
        //bp.dlPercent表示同步进度
        NSLog(@"dl: %f", bp.dlPercent);
        //  NSDictionary *dicProgress = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:bp.dlPercent] forKey:@"progress"];
        
        if (bp.dlPercent == 1) {
            
            
            
            //同步完成逻辑
            //在这里发送通知  刷新需要显示运动量之类页面的数据 包括进度条  label  柱形图
            //同步完成之后要通知数据页面进行数据刷新
            //    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATACIRCULARPROGRESSNOTICE object:nil userInfo:dicProgress];//接受通知页面必须存在
        }
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
