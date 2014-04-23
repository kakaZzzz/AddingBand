//
//  BTSyncccViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-20.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTSyncccViewController.h"
#import "BTBluetoothLinkCell.h"
#import "BTBluetoothConnectedCell.h"
#import "LayoutDef.h"
#import "BTBluetoothFindCell.h"
#import "BTSyncTwoViewController.h"//自动连接上设备页面
#import "BTPastLinkViewController.h"//搜索到上次连接过设备 但未连接上
#import "BTGetData.h"
#import "BTUserData.h"
#import "BTSettingSectionCell.h"
#import "DDIndicator.h"
#import "BTColor.h"
#import "BTConstants.h"//存放外设设备的各种宏的头文件
#import "BTCloseToBleViewController.h"//靠近设备 提示页面
#import "BTBleOffViewController.h"//蓝牙开关未打开

#define kBackgroundViewX 0
#define kBackgroundViewY 20
#define kBackgroundViewWidth 320
#define kBackgroundViewHeight 44

#define kTitleX 20
#define kTitleY 0
#define kTitleWidth 100
#define kTitleHeight 44

#define kTableViewX 0
#define kTableViewY (kBackgroundViewY + kBackgroundViewHeight)
#define kTableViewWidth 320
#define kTableViewHeight 200

#define kWarningLableX 10
#define kWarningLableY (kTableViewHeight + 20)
#define kWarningLableWidth 250
#define kWarningLableHeight 30

static int battery = 0;
@interface BTSyncccViewController ()
@property (nonatomic, strong) NSTimer *timerAnimation;
@property(nonatomic,strong)NSTimer *linkOutTimer;
@end

@implementation BTSyncccViewController

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HANDLETOSYNCNOTICE object:nil];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //
        _isBreak = NO;
        //初始化
        self.g = [BTGlobals sharedGlobals];
        self.bc = [BTBandCentral sharedBandCentral];
        
        //连接超时的block回调
        // __weak BTSyncccViewController *syncVC = self;
        self.bc.timeoutBlock = ^(void){
            
            //            UIAlertView *timeoutAlart = [[UIAlertView alloc] initWithTitle:@"连接超时" message:@"妈妈，请删除此设备，我们将为您重新扫描" delegate:syncVC cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            //            timeoutAlart.tag = 102;
            //            [timeoutAlart show];
            
        };
        
        //监听设备变化
        [self.g addObserver:self forKeyPath:@"bleListCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
        [self.g addObserver:self forKeyPath:@"displayBleList" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
        [self.g addObserver:self forKeyPath:@"connectedBleStatus" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        //搜索是否超时
        if (!self.timerAnimation.isValid) {
            self.timerAnimation =[NSTimer timerWithTimeInterval:SCAN_PERIPHERAL_TIMEOUT target:self selector:@selector(stopIndicatorAnimation) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:self.timerAnimation forMode:NSRunLoopCommonModes];
        }
        
        
        self.peripheralArray = [NSMutableArray arrayWithCapacity:1];
        
        
        //启动计时器 监控上次更新时间   反复调用会不会出现什么意外情况？？？
        [self observeLastSyncTime];
        [NSTimer scheduledTimerWithTimeInterval:UPDATE_PREVIOUSSYNC_TIME target:self selector:@selector(observeLastSyncTime) userInfo:nil repeats:YES];
        //
        self.g.bleListCount += 0;
        
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleToSycn) name:HANDLETOSYNCNOTICE object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //菊花
    self.indicator = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    // _indicator.labelText = @"正在搜索";
    [self.navigationController.view addSubview:_indicator];
    // [_indicator show:YES];
    
    //加载scrollview
    self.aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height)];
    _aScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 100);
    _aScrollView.backgroundColor = [UIColor whiteColor];
    _aScrollView.showsVerticalScrollIndicator = NO;
    _aScrollView.scrollEnabled = NO;
    [self.view addSubview:_aScrollView];
    //加载tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kTableViewX, kTableViewY, kTableViewWidth,kTableViewHeight)];
    if (IPHONE_5_OR_LATER) {
        self.tableView.frame = CGRectMake(kTableViewX, kTableViewY, kTableViewWidth,380);
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_aScrollView addSubview:_tableView];
    
    //连接蓝牙设备提示语句
    [self addLinkBLELabel];
    
    //设置导航栏上的右边按钮
    [self configureNavigationbar];
    
    
    //如果设备蓝牙没有打开 加载打开蓝牙页面
    if (self.bc.isBleOFF) {
        NSLog(@"蓝牙开关没有打开");
        [self addBluetoothNotpowerView];
    }
	// Do any additional setup after loading the view.
}
#pragma mark - 加载蓝牙没有打开的页面
- (void)addBluetoothNotpowerView
{
    if (self.offBleVC == nil) {
        self.offBleVC = [[BTBleOffViewController alloc] initWithWarntext:@"请打开手机的蓝牙功能" aImageName:@"bluetooth_icon" bImageName:@"bluetooth_setting_icon"];
        _offBleVC.view.frame = CGRectMake(0, 0, _offBleVC.view.frame.size.width, _offBleVC.view.frame.size.height);
        
        [self.view addSubview:_offBleVC.view];
        [self.indicator hide:YES];
    }
}
#pragma mark - 加载提醒用户将手环靠近手机的页面
- (void)addBangleCloseToPhoneView
{
    if (self.offBleVC == nil) {
        _offBleVC = [[BTBleOffViewController alloc] initWithWarntext:@"请您将手环与手机靠近" aImageName:@"Bangle_warn_icon" bImageName:@"phone_warn_icon"];
        _offBleVC.view.frame = CGRectMake(0, 0, _offBleVC.view.frame.size.width, _offBleVC.view.frame.size.height);
        [self.view addSubview:_offBleVC.view];
        [self.indicator hide:YES];
        
    }
}

#pragma mark - 移除提醒页面
- (void)removeWarnningViewFromSuperview
{
    if (self.offBleVC) {
        [_offBleVC.view removeFromSuperview];
        self.offBleVC = nil;
    }
}



#pragma mark - 连接蓝牙设备提示语句 “可连接设备”
- (void)addLinkBLELabel
{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(kBackgroundViewX, kBackgroundViewY, self.view.frame.size.width, self.tableView.rowHeight)];
    bgView.backgroundColor = kTableViewSectionColor;
    [self.aScrollView addSubview:bgView];
    
    
    self.labelSection = [[UILabel alloc]initWithFrame:CGRectMake(kTitleX, kTitleY ,kTitleWidth,self.tableView.rowHeight)];
    _labelSection.backgroundColor = [UIColor clearColor];
    _labelSection.font = [UIFont systemFontOfSize:16.0];
    _labelSection.textColor = [BTColor getColor:titleLabelColor];
    _labelSection.text = @"可连接设备";
    _labelSection.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:_labelSection];
    
    UIImageView *separativieLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seperator_line"]];
    separativieLine.frame = CGRectMake(0, _labelSection.frame.origin.y + _labelSection.frame.size.height, 320, kSeparatorLineHeight);
    [bgView addSubview:separativieLine];
    //系统菊花
    
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activeView.frame = CGRectMake(_labelSection.frame.origin.x + _labelSection.frame.size.width + 3, _labelSection.frame.origin.y + 23, 1.0, 1.0);
    [bgView addSubview:activeView];
    [activeView startAnimating];
    //下面加一道线
    //    UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sep_line.png"]];
    //    lineImage.frame = CGRectMake(0, _labelSection.frame.origin.y + _labelSection.frame.size.height -2 , 320, 2);
    //    [self.aScrollView addSubview:lineImage];
    
    
    
    
    
    UILabel *warnLabel = [[UILabel alloc]initWithFrame:CGRectMake((320 - kWarningLableWidth)/2, kWarningLableY,kWarningLableWidth,self.tableView.frame.size.height)];
    warnLabel.backgroundColor = [UIColor clearColor];
    warnLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    warnLabel.textColor = [BTColor getColor:contentLabelColor];
    warnLabel.text = @"请通过产品号选择你的设备";
    warnLabel.attributedText = [self illuminatedString:warnLabel.text];
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    warnLabel.numberOfLines= 0;
    [self.aScrollView addSubview:warnLabel];
    
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, self.aScrollView.frame.size.height - 49 - 100/2 - 30, 320, 100/2)];
    if (IOS7_OR_LATER) {
        aView.frame = CGRectMake(0, self.aScrollView.frame.size.height - 49 - 100/2 - 50, 320, 100/2);
    }
    
    aView.backgroundColor = kGlobalColor;
    //  [self.aScrollView addSubview:aView];
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(24/2, (aView.frame.size.height - 30)/2 , 150, 30)];
    aLabel.textColor = [UIColor whiteColor];
    aLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    aLabel.text = @"连接加丁胎动手环";
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textAlignment = NSTextAlignmentLeft;
    aLabel.numberOfLines= 0;
    [aView addSubview:aLabel];
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailButton.frame = CGRectMake((320 - 224/2), 0, 224/2, 100/2);
    [detailButton setBackgroundImage:[UIImage imageNamed:@"detain_button_unselected"] forState:UIControlStateNormal];
    [detailButton setBackgroundImage:[UIImage imageNamed:@"detain_button_selected"] forState:UIControlStateSelected];
    [detailButton setBackgroundImage:[UIImage imageNamed:@"detain_button_selected"] forState:UIControlStateHighlighted];
    [aView addSubview:detailButton];
    
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake((detailButton.frame.size.width - 70)/2, (detailButton.frame.size.height - 30)/2, 70, 30)];
    buttonLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    buttonLabel.backgroundColor = [UIColor clearColor];
    buttonLabel.textColor = [UIColor whiteColor];
    buttonLabel.text = @"了解详情";
    buttonLabel.textAlignment = NSTextAlignmentCenter;
    [detailButton addSubview:buttonLabel];
    
    UIImageView *accessorImage = [[UIImageView alloc] initWithFrame:CGRectMake((detailButton.frame.size.width - 20), (detailButton.frame.size.height - 20/2)/2, 12/2, 20/2)];
    accessorImage.image = [UIImage imageNamed:@"accessory_white"];
    [detailButton addSubview:accessorImage];
    
    
}

- (NSMutableAttributedString *)illuminatedString:(NSString *)text
{
    
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [mutaString beginEditing];
    [mutaString addAttribute:NSForegroundColorAttributeName
                       value:kGlobalColor
                       range:NSMakeRange(3, 3)];
    
    [mutaString endEditing];
    
    return mutaString;
}

#pragma mark - 手动重新搜索设备
- (void)restartScanBySelf
{
    
    
    [self.bc restartScan];
}
#pragma mark - 设置导航栏上面的按钮
- (void)configureNavigationbar
{
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _deleteButton.frame = CGRectMake(250, 5, 50, 24);
    
    [_deleteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _deleteButton.tag = 198;
    _deleteButton.hidden = YES;
    [_deleteButton addTarget:self action:@selector(breakConnect) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_button_unselected"] forState:UIControlStateNormal];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_button_selected"] forState:UIControlStateSelected];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_button_selected"] forState:UIControlStateHighlighted];
    _deleteButton.tintColor = [UIColor colorWithRed:70/255.0 green:163/255.0 blue:210/255.0 alpha:1];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)_deleteButton];
}

#pragma mark - 通知方法 methods
- (void)handleToSycn
{
    self.syncTwoVC.linkLabel.text = @"正在搜索...";
    self.deleteButton.hidden = YES;
}
//检测上次更新时间 同步时间
- (void)observeLastSyncTime
{
    //读取一下对更新时间的描述
    _lastSyncTime = [self.bc getLastSyncDesc:MAM_BAND_MODEL];
    NSString *subString = [self.syncTwoVC.linkLabel.text substringToIndex:4];
    if ([subString isEqualToString:LASTSYNC_TEXT]) {
     self.syncTwoVC.linkLabel.text = _lastSyncTime;
   
    }
   
    //计算使用时间
    int k = [[self.bc getBpByModel:MAM_BAND_MODEL] setupDate];
    NSString *str = [BTGetData getBLEuseTime:k];//得到外围设备使用时间
    self.syncTwoVC.useTimeLabel.text = [NSString stringWithFormat:@"%@",str];
    
    
}
//监控参数，更新显示  当连接  断开的时候也会调用此方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"监听设备数量变化");
    
    if([keyPath isEqualToString:@"bleListCount"])
    {
        NSLog(@"ble count---: %d", self.g.bleListCount);
        
        if (self.g.bleListCount == 0) {
            
            
            [self.tableView reloadData];
    
            
        }
        if (self.g.bleListCount > 0) {
            
            [self.indicator hide:YES];
            [self removeWarnningViewFromSuperview];
            
            [self.tableView reloadData];
            
          
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
        _syncTwoVC.syncProgress.text = [NSString stringWithFormat:@"进度:%f",bp.dlPercent];
        //  NSDictionary *dicProgress = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:bp.dlPercent] forKey:@"progress"];
        
        if (bp.dlPercent == 1) {
            
            
            
            //同步完成逻辑
            //在这里发送通知  刷新需要显示运动量之类页面的数据 包括进度条  label  柱形图
            //同步完成之后要通知数据页面进行数据刷新
            //    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATACIRCULARPROGRESSNOTICE object:nil userInfo:dicProgress];//接受通知页面必须存在
        }
        
    }
    
    if([keyPath isEqualToString:@"displayBleList"])
    {
        NSLog(@"!!!---!!! dis: %d", self.g.displayBleList);
    }
    
    
    if ([keyPath isEqualToString:@"connectedBleStatus"]) {
        
        
        NSLog(@"哈哈哈哈哈哈");
        if (self.g.connectedBleStatus == CONNECTED_BLE_HAS_GONE) {
            
            if (!self.timerAnimation.isValid) {
                self.timerAnimation =[NSTimer timerWithTimeInterval:SCAN_PERIPHERAL_TIMEOUT target:self selector:@selector(stopIndicatorAnimation) userInfo:nil repeats:NO];
                [[NSRunLoop currentRunLoop] addTimer:self.timerAnimation forMode:NSRunLoopCommonModes];
            }
            
            
        }
        if (self.g.connectedBleStatus == CONNECTED_BLE_FINED) {
            
            
            [self.timerAnimation invalidate];
        }
    }
}
#pragma mark - 断开连接
//导航栏上的断开按钮触发断开事件  断开时将syncTwoVC.view从父视图上移除  导航栏上按钮隐藏,当再次连接的时候再显示出来
- (void)breakConnect
{
    NSLog(@"立即断开");
    
    //弹出提醒框
    UIAlertView *aLart = [[UIAlertView alloc] initWithTitle:@"删除此设备" message:@"您确定要删除此设备吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    aLart.tag = BREAK_CONNECT_ALERT;
    [aLart show];
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    //  [self.indicator startAnimating];
    
    if (alertView.tag == BREAK_CONNECT_ALERT) {
        if (buttonIndex == 0) {
            
            //断开连接
            _isBreak = YES;
            [self.bc removePeripheralByModel:MAM_BAND_MODEL];
            // [self.bc removePeripheralByName:bpName];
            //
            _deleteButton.hidden = YES;
            //[self.navigationItem.rightBarButtonItem setEnabled:NO];
            [self removeWarnningViewFromSuperview];
            [self.syncTwoVC.view removeFromSuperview];
            
            // self.indicator.labelText = @"正在搜索设备";
            // [self.indicator show:YES];
            
            
            //移除页面
            [self.pastVC.view removeFromSuperview];
            _deleteButton.hidden = YES;
            
            
            
        }
    }
    
    if (alertView.tag == TIME_OUT_ALERT) {
        [self.bc restartScan];
        [self.bc cleanBLECache];
        [self.indicator hide:YES];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 连接超时 或者 搜索超时 都走这个方法
- (void)stopIndicatorAnimation
{
    
    if (!self.bc.isBleOFF) {
        
        [self removeWarnningViewFromSuperview];
        [self addBangleCloseToPhoneView];
    }
    else
    {
        [self addBluetoothNotpowerView];
    }
    [self.indicator hide:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    //    return [self.peripheralArray count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.g.bleListCount ;
}


//动态改变每一行的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//     BTBandPeripheral*bp = nil;
//    if ([self.bc.allPeripherals count] > 0) {
//        bp  = [self.bc getBpByIndex:indexPath.row];
//
//    }
//
//    //BTBandPeripheral*bp  = [self.bc getBpByModel:@"A1"];
//    //是否发现
//    BOOL isWaitforSync = self.bc.waitForNextSync;
//    BOOL isDisplayBleList = self.g.displayBleList;
//    Boolean isFinded = bp.isFinded;
//    //是否连接
//    Boolean isConnected = bp.isConnected;
//
//    //是否正在连接中
//    BOOL isConnecting = bp.isConnecting;
//
//    if (isConnecting && !isConnected) {
//
//
//    }
//    if (isConnected && isConnecting) {
//    }
//    if (isDisplayBleList && isFinded && !isConnected && !isConnecting) {
//        NSLog(@"发现未连接  %d",isConnecting);
//        return 50;
//           }
//    return 50;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    
    //根据index找到对应的peripheral
    BTBandPeripheral*bp = nil;
    if ([self.bc.allPeripherals count] > 0) {
        bp  = [self.bc getBpByIndex:indexPath.row];
        
    }
    // BTBandPeripheral*bp  = [self.bc getBpByModel:@"A1"];
    //是否发现
    Boolean isFinded = bp.isFinded;
    
    //是否连接
    Boolean isConnected = bp.isConnected;
    
    //是否正在连接中
    BOOL isConnecting = bp.isConnecting;
    
    BOOL isWaitforSync = self.bc.waitForNextSync;
    
    BOOL isDisplayBleList = self.g.displayBleList;
    
    NSLog(@"isFinded %d \n isConnected=%d \n isConnecting=%d \n isWaitforSync=%d \n isDisplayBleList=%d",isFinded,isConnected,isConnecting,isWaitforSync,isDisplayBleList);

    //设备名称
    NSString* name = bp.name;
    
    //电池电量
    uint8_t d = 0;
    NSData *battRaw = [bp.allValues objectForKey:[CBUUID UUIDWithString:UUID_BATTERY_LEVEL]];
    if (battRaw) {
        [battRaw getBytes:&d];
    }
    NSNumber *batteryLevel = [NSNumber numberWithInt:d];
    
    NSLog(@"外围设备电量是--%d",[batteryLevel intValue]);
    
    //创建Cell 根据外围设备状态 创建不同的Cell用于显示
    static NSString *CellIdentifierFind = @"CellFind";
    static NSString *CellIdentifierConnect = @"CellConnect";
    
    
    
    BTBluetoothFindCell *cellFind = [tableView dequeueReusableCellWithIdentifier:CellIdentifierFind];
    BTBluetoothConnectedCell *cellConnet = [tableView dequeueReusableCellWithIdentifier:CellIdentifierConnect];
    
    NSLog(@"是否找到 %d  是否连接%d",isFinded,isConnected);
    NSLog(@"外围设备名称是 %@",name);
    
    NSLog(@"----display: %hhd", self.g.displayBleList);
    
    //发现设备 但是木有连接 新设备
    if (isDisplayBleList) {
        
        NSLog(@"收到新设备。。。。。。。。。。。。");
        if (cellFind == nil) {
            cellFind = [[BTBluetoothFindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierFind];
        }
        cellFind.titleLabel.text = [NSString stringWithFormat:@"%@",name];
        
        if (isConnecting) {
            //[self addLinkSuccessfulView];
        }
        [self.indicator hide:YES];
        [self removeWarnningViewFromSuperview];
        return cellFind;
    }
    
    else{
        if (cellConnet == nil) {
            
            cellConnet = [[BTBluetoothConnectedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierConnect tatget:self];
        }
        
        
        //isWaitforSync 为yes的时候是三种状态  等待同步  同步中  正在搜索
        if (isWaitforSync) {
            
            if (isFinded) {
                if(isConnecting){
                    [self removeWarnningViewFromSuperview];
                    [self addLinkSuccessfulView];
                    self.syncTwoVC.batteryLabel.text = [NSString stringWithFormat:@"电量:%@%@",batteryLevel,@"%"];
                    
                    if ([batteryLevel intValue] != 0) {
                        battery = [batteryLevel intValue];
                    }
                    
                    [self changeBatteryIconWithBattery:battery];
                    self.syncTwoVC.linkLabel.text = [NSString stringWithFormat:@"正在同步...."];
                    self.syncTwoVC.peripheralName.text = bp.name;
                    //  self.syncTwoVC.syncButton.userInteractionEnabled = NO;//手动同步按钮不可用
                    self.syncTwoVC.syncButton.userInteractionEnabled = YES;//手动同步按钮不可用
                    //开始动画
                    [self.syncTwoVC.syncIcon startAnimating];
                    
                    _deleteButton.hidden = YES ;//导航栏上的按钮可按
                    
                    
                }
                else{
                    [self removeWarnningViewFromSuperview];
                    [self addLinkSuccessfulView];
                    self.syncTwoVC.linkLabel.text = [NSString stringWithFormat:@"等待同步"];
                    self.syncTwoVC.peripheralName.text = bp.name;
                    self.syncTwoVC.batteryLabel.text = [NSString stringWithFormat:@"电量:%@%@",batteryLevel,@"%"];
                    [self changeBatteryIconWithBattery:battery];
                    self.syncTwoVC.syncButton.userInteractionEnabled = NO;//手动同步按钮可用
                    // self.syncTwoVC.batteryLabel.text = [NSString stringWithFormat:@"电量:%@%@",batteryLevel,@"%"];
                    //停止动画
                    [self.syncTwoVC.syncIcon stopAnimating];
                    
                    _deleteButton.hidden = YES ;//导航栏上的按钮可按
                    
                }
            }
            else{
                
                [self removeWarnningViewFromSuperview];
                [self addLinkSuccessfulView];
                self.syncTwoVC.linkLabel.text = [NSString stringWithFormat:@"正在搜索.."];
                self.syncTwoVC.peripheralName.text = bp.name;
                self.syncTwoVC.syncButton.userInteractionEnabled = NO;//手动同步按钮可用
                self.syncTwoVC.batteryLabel.text = [NSString stringWithFormat:@"电量:%@%@",batteryLevel,@"%"];
                [self changeBatteryIconWithBattery:battery];
                // self.syncTwoVC.batteryLabel.text = [NSString stringWithFormat:@"电量:%@%@",batteryLevel,@"%"];
                //停止动画
                [self.syncTwoVC.syncIcon stopAnimating];
                
                _deleteButton.hidden = YES ;//导航栏上的按钮可按
                //同时开启一个计时器 10秒的计时器 超时了 加载靠近引导页面
                if (!self.timerAnimation.isValid) {
                    self.timerAnimation =[NSTimer timerWithTimeInterval:SCAN_PERIPHERAL_TIMEOUT target:self selector:@selector(stopIndicatorAnimation) userInfo:nil repeats:NO];
                    [[NSRunLoop currentRunLoop] addTimer:self.timerAnimation forMode:NSRunLoopCommonModes];
                }
                
                
            }
            
        }
        
        else{
            [self removeWarnningViewFromSuperview];
            [self addLinkSuccessfulView];
            _lastSyncTime = [self.bc getLastSyncDesc:MAM_BAND_MODEL];
            self.syncTwoVC.linkLabel.text = _lastSyncTime;//上次同步
            self.syncTwoVC.peripheralName.text = bp.name;
            //到这里之所以不改变电量图标 是为了不让用户感觉到又断开了连接
            //  self.syncTwoVC.batteryLabel.text = [NSString stringWithFormat:@"电量:%@%@",batteryLevel,@"%"];
             [self changeBatteryIconWithBattery:battery];
            
            self.syncTwoVC.syncButton.userInteractionEnabled = YES;//手动同步按钮可用
            //停止动画
            [self.syncTwoVC.syncIcon stopAnimating];
            
            _deleteButton.hidden = NO ;//导航栏上的按钮可按
            
        }
        return cellConnet;
        
    }
    
    
    
}
#pragma mark - 根据电量调整电量图标
- (void)changeBatteryIconWithBattery:(int)battery
{
    
    if (battery == 0) {
        self.syncTwoVC.batteryImage.image = [UIImage imageNamed:@"battery_icon_unknown"];
    }
    else if (battery > 0 && battery <10)
    {
        self.syncTwoVC.batteryImage.image = [UIImage imageNamed:@"battery_icon1"];
    }
    else{
        self.syncTwoVC.batteryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"battery_icon%d",(battery/10)]];
        
    }
    
}
#pragma mark - tabelview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BTBluetoothFindCell *findCell = (BTBluetoothFindCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    findCell.backgroundColor = [UIColor grayColor];
    findCell.contentView.backgroundColor =  [UIColor blueColor];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.bc connectPeripheralByName:findCell.titleLabel.text];//根据设备名字连接设备
    });
    
    //菊花显示
    self.indicator.labelText = @"正在连接设备";
    [self.indicator show:YES];
    
    //连接是否超时
    if (!self.linkOutTimer.isValid) {
        self.linkOutTimer =[NSTimer timerWithTimeInterval:LINkBLE_TIMEOUT target:self selector:@selector(linkBleTimout) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.linkOutTimer forMode:NSRunLoopCommonModes];
    }
    
    
}
#pragma mark - 连接超时
- (void)linkBleTimout
{
    //弹出提醒框
    UIAlertView *aLart = [[UIAlertView alloc] initWithTitle:@"连接超时" message:@"请检查设备,靠近您的手机和手环,并重新连接" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    aLart.tag = TIME_OUT_ALERT;
    [aLart show];
    
}
//判断是否是历史设备
- (BOOL)isPastBL
{
    //删除coredata里的这条数据
    [BTGetData getAppContex];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTBleList" inManagedObjectContext:[BTGetData getAppContex]];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError* error;
    
    NSArray *resultArray = [[BTGetData getAppContex] executeFetchRequest:request error:&error];
    
    for (BTBleList* old in resultArray) {
        if ([old.name isEqualToString:@"Adding A1-6ECEA7"]){
            return YES;
        }
        
        
    }
    return NO;
}

#pragma mark - 点击按钮 触发事件
//Cell上面按钮的触发事件 同步数据 蛋疼
- (void)toSync:(UIButton *)button event:(id)event
{
    NSLog(@"同步数据");
    //进行同步 这里也得判断设备是哪个设备啊
    
    [self.bc sync:MAM_BAND_MODEL];
    
}
//Cell上面按钮的触发事件 连接外围设备 蛋疼
- (void)toConnect:(UIButton *)button event:(id)event
{
    //连接或者断开断开
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    //点击完之后让按钮不可点击 否则就会crash
    button.userInteractionEnabled = NO;
    self.g.selectedRow = indexPath.row;//记录选择的设备是第几行
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.bc togglePeripheralByIndex:[indexPath row]];
    });
    
    
}

- (void)breakConnect:(UIButton *)button event:(id)event
{
    //连接或者断开断开
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    
    //点击完之后让按钮不可点击 否则就会crash
    button.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.bc togglePeripheralByIndex:[indexPath row]];
    });
}

#pragma mark - viewControllers
- (void)viewWillAppear:(BOOL)animated
{
    
    
}

#pragma mark - 加载发现历史设备但是未连接页面 和 连接成功页面
//连接成功页面
- (void)addLinkSuccessfulView
{
    NSLog(@"加载连接成功页面...");
    self.syncTwoVC = [BTSyncTwoViewController shareSyncTwoview];
    _syncTwoVC.view.frame = CGRectMake(0, 0, _syncTwoVC.view.frame.size.width, _syncTwoVC.view.frame.size.height);
    self.syncTwoVC.linkLabel.text = @"等待同步";
    for (id aView in [self.view subviews]) {
        if (aView ==self.syncTwoVC.view ) {
            return;
        }
    }
    [self.view addSubview:_syncTwoVC.view];
    [self.indicator hide:YES];
    _deleteButton.hidden = NO;
    //停止连接超时的计时器
    if ([self.linkOutTimer isValid]) {
        [self.linkOutTimer invalidate];
    }
    
}
//发现历史设备 但是未连接成功
- (void)addFindPastView
{
    self.syncTwoVC = [BTSyncTwoViewController shareSyncTwoview];
    _syncTwoVC.view.frame = CGRectMake(0, 0, _syncTwoVC.view.frame.size.width, _syncTwoVC.view.frame.size.height);
    [self.view addSubview:_syncTwoVC.view];
    
    self.syncTwoVC.linkLabel.text = @"等待同步";
    
}
@end
