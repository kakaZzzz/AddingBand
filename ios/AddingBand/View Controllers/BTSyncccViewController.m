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


#define kTitleX 10
#define kTitleY 20
#define kTitleWidth 250
#define kTitleHeight 50

#define kTableViewX 0
#define kTableViewY 70
#define kTableViewWidth 320
#define kTableViewHeight 200

#define kWarningLableX 10
#define kWarningLableY (kTableViewHeight + 50)
#define kWarningLableWidth 250
#define kWarningLableHeight 30
@interface BTSyncccViewController ()
@property (nonatomic, strong) NSTimer *timerAnimation;
@end

@implementation BTSyncccViewController

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
        
        //菊花
        self.indicator = [[DDIndicator alloc] initWithFrame:CGRectMake((self.view.frame.size.width - _indicator.frame.size.width - 50)/2 , 150, 50, 50)];
        [self.view addSubview:_indicator];
        _indicator.hidden = YES;
        [_indicator startAnimating];
        //动画是否超时
        if (!self.timerAnimation.isValid) {
            self.timerAnimation =[NSTimer timerWithTimeInterval:50 target:self selector:@selector(stopIndicatorAnimation) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:self.timerAnimation forMode:NSRunLoopCommonModes];
        }

        
        self.peripheralArray = [NSMutableArray arrayWithCapacity:1];
        
        
        //启动计时器 监控上次更新时间   反复调用会不会出现什么意外情况？？？
        [self observeLastSyncTime];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(observeLastSyncTime) userInfo:nil repeats:YES];
        //
        self.g.bleListCount += 0;
        
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadmData) name:@"reloadData" object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //加载scrollview
    self.aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height)];
    _aScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 100);
    //  _aScrollView.backgroundColor = [UIColor redColor];
    _aScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_aScrollView];
    //加载tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kTableViewX, kTableViewY, kTableViewWidth,kTableViewHeight)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_aScrollView addSubview:_tableView];
    
    //连接蓝牙设备提示语句
    [self addLinkBLELabel];
    
    //设置导航栏上的右边按钮
    [self configureNavigationbar];
	// Do any additional setup after loading the view.
}
#pragma mark - 连接蓝牙设备提示语句 “可连接设备”
- (void)addLinkBLELabel
{
    self.labelSection = [[UILabel alloc]initWithFrame:CGRectMake(kTitleX, kTitleY ,kTitleWidth,kTitleHeight)];
    // _labelSection.backgroundColor = [UIColor blueColor];
    _labelSection.font = [UIFont systemFontOfSize:20];
    _labelSection.textColor = [BTColor getColor:titleLabelColor];
    _labelSection.text = @"可连接设备";
    _labelSection.textAlignment = NSTextAlignmentLeft;
    [self.aScrollView addSubview:_labelSection];
    //下面加一道线
    UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sep_line.png"]];
    lineImage.frame = CGRectMake(0, _labelSection.frame.origin.y + _labelSection.frame.size.height -2 , 320, 2);
    [self.aScrollView addSubview:lineImage];
    
    
    
    
    
    self.label1 = [[UILabel alloc]initWithFrame:CGRectMake( kWarningLableX, kWarningLableY,kWarningLableWidth,kWarningLableHeight)];
    _label1.backgroundColor = [UIColor clearColor];
    _label1.font = [UIFont systemFontOfSize:15];
    _label1.textColor = [BTColor getColor:contentLabelColor];
    _label1.text = @"1.将手机放在距离设备近一些的地方";
    _label1.textAlignment = NSTextAlignmentLeft;
    _label1.lineBreakMode = NSLineBreakByTruncatingTail;
    _label1.numberOfLines= 0;
    [self.aScrollView addSubview:_label1];
    
    self.label2 = [[UILabel alloc]initWithFrame:CGRectMake( kWarningLableX, _label1.frame.origin.y + _label1.frame.size.height ,kWarningLableWidth,kWarningLableHeight)];
    _label2.backgroundColor = [UIColor clearColor];
    _label2.font = [UIFont systemFontOfSize:15];
    _label2.textColor = [BTColor getColor:contentLabelColor];
    _label2.text = @"2.打开设备上的按钮";
    _label2.textAlignment = NSTextAlignmentLeft;
    _label2.lineBreakMode = NSLineBreakByTruncatingTail;
    _label2.numberOfLines= 0;
    [self.aScrollView addSubview:_label2];
    
    
    self.label3 = [[UILabel alloc]initWithFrame:CGRectMake( kWarningLableX, _label2.frame.origin.y + _label2.frame.size.height ,kWarningLableWidth,kWarningLableHeight)];
    _label3.backgroundColor = [UIColor clearColor];
    _label3.font = [UIFont systemFontOfSize:15];
    _label3.textColor = [BTColor getColor:contentLabelColor];
    _label3.text = @"3.打开手机上的蓝牙";
    _label3.textAlignment = NSTextAlignmentLeft;
    _label3.lineBreakMode = NSLineBreakByTruncatingTail;
    _label3.numberOfLines= 0;
    [self.aScrollView addSubview:_label3];
    
    
    //重新搜索蓝牙设备按钮
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_refreshButton setTitle:@"重新搜索" forState:UIControlStateNormal];
    [_refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    if (IPHONE_5_OR_LATER) {
        _refreshButton.frame = CGRectMake((320 - 200)/2, _label3.frame.origin.y + _label3.frame.size.height + 5, 200, 50);
        
    }
    else
    {
        _refreshButton.frame = CGRectMake((320 - 200)/2, _label3.frame.origin.y + _label3.frame.size.height, 200, 50);
    }
    [_refreshButton setBackgroundImage:[UIImage imageNamed:@"refresh_btn.png"] forState:UIControlStateNormal];
    [_refreshButton setBackgroundImage:[UIImage imageNamed:@"refresh_btn_sel.png"] forState:UIControlStateHighlighted];
    
    [_refreshButton addTarget:self action:@selector(restartScanBySelf) forControlEvents:UIControlEventTouchUpInside];
    [_aScrollView addSubview:_refreshButton];
    [self.aScrollView addSubview:_refreshButton];

}
#pragma mark - 手动重新搜索设备
- (void)restartScanBySelf
{
    
    [self.indicator startAnimating];
    //动画是否超时
    if (!self.timerAnimation.isValid) {
        self.timerAnimation =[NSTimer timerWithTimeInterval:50 target:self selector:@selector(stopIndicatorAnimation) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timerAnimation forMode:NSRunLoopCommonModes];
    }

    [self.bc restartScan];
}
#pragma mark - 设置导航栏上面的按钮
- (void)configureNavigationbar
{
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _deleteButton.frame = CGRectMake(250, 5, 65, 30);
    
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];//title的值根据定位和和选择而改变
    [_deleteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _deleteButton.tag = 198;
    _deleteButton.hidden = YES;
   // [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(breakConnect) forControlEvents:UIControlEventTouchUpInside];
   // [_deleteButton setBackgroundImage:[UIImage imageNamed:@"透明.png"] forState:UIControlStateNormal];
    _deleteButton.tintColor = [UIColor colorWithRed:70/255.0 green:163/255.0 blue:210/255.0 alpha:1];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)_deleteButton];
}

- (void)reloadmData
{
    NSLog(@"收到刷新列表的通知");
    self.g.bleListCount = 0;//把列表行数置为空
    [self.tableView reloadData];
}
//检测上次更新时间 同步时间
- (void)observeLastSyncTime
{
    //读取一下对更新时间的描述
    _lastSyncTime = [self.bc getLastSyncDesc:MAM_BAND_MODEL];
    //    NSLog(@"上次同步时间是：%@",_lastSyncTime);
    self.syncTwoVC.lastSyncTime.text = _lastSyncTime;
    self.pastVC.lastSyncTime.text = _lastSyncTime;
    //计算使用时间
    int k = [[self.bc getBpByModel:MAM_BAND_MODEL] setupDate];
    //    NSLog(@"使用了多少秒%d",k);
    NSString *str = [BTGetData getBLEuseTime:k];//得到外围设备使用时间
    self.syncTwoVC.useTimeLabel.text = [NSString stringWithFormat:@"%@",str];

    // self.pastVC.useTimeLabel.text = [NSString stringWithFormat:@"%@",str];
    // [self.tableView reloadData];
    
}
//监控参数，更新显示  当连接  断开的时候也会调用此方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"监听设备数量变化");
    
    if([keyPath isEqualToString:@"bleListCount"])
    {
        NSLog(@"ble count---: %d", self.g.bleListCount);
        
        //行数变化时，重新加载列表
        //todo 等于0的时候处理成“查找中”
        if (self.g.bleListCount == 0) {
            //加载动画显示
            _isBreak = NO;
            NSLog(@"准备加个搜索动画呢啊");
            //   [self.indicator startAnimating];
            //   [self.tableView reloadData];
        }
        if (self.g.bleListCount > 0) {
            
            [self.indicator stopAnimating];
            [self.timerAnimation invalidate];
            
            //reloaddata的条件还得加以判断，为了防止ios7上的奇葩问题
            if (_isBreak == NO) {
                [self.tableView reloadData];
                
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
        _syncTwoVC.syncProgress.text = [NSString stringWithFormat:@"进度:%f",bp.dlPercent];
        //  NSDictionary *dicProgress = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:bp.dlPercent] forKey:@"progress"];
        
        if (bp.dlPercent == 1) {
            
            
            
            //同步完成逻辑
            //在这里发送通知  刷新需要显示运动量之类页面的数据 包括进度条  label  柱形图
            //同步完成之后要通知数据页面进行数据刷新
            //    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATACIRCULARPROGRESSNOTICE object:nil userInfo:dicProgress];//接受通知页面必须存在
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
            NSString *bpName = nil;
            self.context =[BTGetData getAppContex];
            NSArray *data1 = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserData" sortKey:nil];
            if (data1.count > 0) {
                BTUserData *userData = [data1 objectAtIndex:0];
                bpName = userData.selectedName;
            }
            self.bc = [BTBandCentral sharedBandCentral];
            BTBandPeripheral* bp = [self.bc getBpByName:bpName];
            //如果是正在连接的设备就断开连接
            if (bp.isConnected) {
                // [self.bc togglePeripheralByIndex:i];
                [self.bc removePeripheralByModel:MAM_BAND_MODEL];
                // [self.bc removePeripheralByName:bpName];
                //
                _deleteButton.hidden = YES;
                //[self.navigationItem.rightBarButtonItem setEnabled:NO];
                [self.syncTwoVC.view removeFromSuperview];
                [self.pastVC.view removeFromSuperview];
                //菊花显示
                self.indicator.contentLabel.text = @"正在搜索设备";
                [self.indicator startAnimating];//加载动画
                //动画是否超时
                if (!self.timerAnimation.isValid) {
                    self.timerAnimation =[NSTimer timerWithTimeInterval:50 target:self selector:@selector(stopIndicatorAnimation) userInfo:nil repeats:NO];
                    [[NSRunLoop currentRunLoop] addTimer:self.timerAnimation forMode:NSRunLoopCommonModes];
                }
            }
            
            
            
            //在设备因为意外情况断开的情况下删除设备时 走介个方法
            else{
                
                //以下为删除设备
                //往coredata里面存放选择的设备行数
                
                //根据index找到对应的peripheral
                self.bc = [BTBandCentral sharedBandCentral];
                
                //删除coredata里的这条数据
                _context = [BTGetData getAppContex];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTBleList" inManagedObjectContext:_context];
                
                NSFetchRequest* request = [[NSFetchRequest alloc] init];
                [request setEntity:entity];
                
                NSError* error;
                
                NSArray *resultArray = [_context executeFetchRequest:request error:&error];
                
                for (BTBleList* old in resultArray) {
                    NSLog(@"设备名称%@",bp.name);
                    if ([old.name isEqualToString:bpName]){
                        [self.bc.allPeripherals removeObjectForKey:bpName];//缓存清除
                        [_context deleteObject:old];//存放连接上设备的coredata清除
                        NSLog(@"!!!2222222");
                    }
                    
                    
                    //及时保存
                    NSError* err;
                    if(![_context save:&err]){
                        NSLog(@"%@", [err localizedDescription]);
                    }
                    
                    [self.bc scan];//重新搜索设备
                }
                
                //移除页面
                [self.pastVC.view removeFromSuperview];
                _deleteButton.hidden = YES;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadData" object:nil];
                //菊花开始做动画
                //菊花显示
                self.indicator.contentLabel.text = @"正在搜索设备";
                [self.indicator startAnimating];
                if (!self.timerAnimation.isValid) {
                    self.timerAnimation =[NSTimer timerWithTimeInterval:50 target:self selector:@selector(stopIndicatorAnimation) userInfo:nil repeats:NO];
                    [[NSRunLoop currentRunLoop] addTimer:self.timerAnimation forMode:NSRunLoopCommonModes];
                }
                
                
                
            }
        }
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
    UIAlertView *aLart = [[UIAlertView alloc] initWithTitle:@"超时了亲 " message:@"请检查设备" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    aLart.tag = TIME_OUT_ALERT;
    [aLart show];
    
    [self.indicator stopAnimating];
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
    
    //刚开始没有连接上设备的时候 每个设备下面只有一行  显示“立即连接” ;当连接上的时候 设备下面变成两行 显示“上次同步时间” “立即同步”
    //当同步完的时候 怎么做？？？
    return self.g.bleListCount ;
}


//动态改变每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    NSLog(@"heightForRowAtIndexPath");
    //根据index找到对应的peripheral
    // BTBandPeripheral*bp  = [self.bc getBpByIndex:indexPath.row];
    BTBandPeripheral*bp = nil;
    if ([self.bc.allPeripherals count] > 0) {
        bp  = [self.bc getBpByIndex:indexPath.row];
        
    }
    
    //BTBandPeripheral*bp  = [self.bc getBpByModel:@"A1"];
    //是否发现
    Boolean isFinded = bp.isFinded;
    //是否连接
    Boolean isConnected = bp.isConnected;
    
    //是否正在连接中
    BOOL isConnecting = bp.isConnecting;
    
    //    NSLog(@"设备是否正在连接  %d",isConnecting);
    //
    if (isConnecting && !isConnected) {
        NSLog(@"开始连接动画");
        self.indicator.contentLabel.text = @"正在连接设备";
        [self.indicator startAnimating];
        if (!self.timerAnimation.isValid) {
            self.timerAnimation =[NSTimer timerWithTimeInterval:50 target:self selector:@selector(stopIndicatorAnimation) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:self.timerAnimation forMode:NSRunLoopCommonModes];
        }
        
    }
    if (isConnected && isConnecting) {
        [self.indicator stopAnimating];
        [self.timerAnimation invalidate];
    }
    if (isFinded && !isConnected && !isConnecting) {
        NSLog(@"发现未连接  %d",isConnecting);
        
        return 50;
        // return kBluetoothFindHeight;
    }
    return 50;
}

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
    // BOOL isConnecting = bp.isConnecting;
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
    static NSString *CellIdentifierNoFind = @"CellNoFind";
    
    
    BTBluetoothFindCell *cellFind = [tableView dequeueReusableCellWithIdentifier:CellIdentifierFind];
    BTBluetoothConnectedCell *cellConnet = [tableView dequeueReusableCellWithIdentifier:CellIdentifierConnect];
    BTBluetoothLinkCell *cellNofind = [tableView dequeueReusableCellWithIdentifier:CellIdentifierNoFind];
    NSLog(@"是否找到 %d  是否连接%d",isFinded,isConnected);
    NSLog(@"外围设备名称是 %@",name);
    
    //发现设备 但是木有连接 新设备
    if (isFinded && !isConnected) {
        
        NSLog(@"收到新设备。。。。。。。。。。。。");
        if (cellFind == nil) {
            cellFind = [[BTBluetoothFindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierFind];
        }
        cellFind.titleLabel.text = [NSString stringWithFormat:@"%@",name];
        //移除搜索到历史设备 但未连接页面
        //        if (![self isPastBL]) {
        //            if (_pastVC.view) {
        [_pastVC.view removeFromSuperview];
        //            }
        //
        //        }
        //        //是历史设备 加载历史设备页面
        //        if ([self isPastBL]) {
        //            [self addFindPastView];
        //        }
        return cellFind;
    }
    //连接成功
    else if (isConnected)
    {
        
        
        if (cellConnet == nil) {
            
            cellConnet = [[BTBluetoothConnectedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierConnect tatget:self];
        }
        //        cellConnet.bluetoothName.text = [NSString stringWithFormat:@"%@  %@%@",name,batteryLevel,@"％"];
        //        cellConnet.lastSyncTime.text = _lastSyncTime;//更新数据 从哪里读取数据
        //
        _deleteButton.hidden = NO ;//导航栏上的按钮可按
        
        //再此 移除搜索到历史设备 但未连接页面
        if (_pastVC.view) {
            [_syncTwoVC.view removeFromSuperview];
        }
        /*cell其实还存在  数据也在刷新 不过在此上面盖了一层view而已*/
        //加载连接成功后的视图
        [self addLinkSuccessfulView];
        self.syncTwoVC.batteryLabel.text = [NSString stringWithFormat:@"电量:%@%@",batteryLevel,@"%"];
        
        return cellConnet;
        
    }
    //意外情况断开连接
    else
    {
        
        
        NSLog(@"空加载个屁啊。。。。。。。。");
        
        
        if (cellNofind == nil) {
            
            cellNofind = [[BTBluetoothLinkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierConnect];
        }
        //在此 移除连接成功页面  加载发现历史设备 但未连接状态页面
        if (_syncTwoVC.view) {
            [_syncTwoVC.view removeFromSuperview];
        }
        if (bp) {
            //导航栏右边按钮隐藏
            self.deleteButton.hidden = NO;
            //加载发现历史设备 但未连接页面
            [self addFindPastView];
            
        }
        //新出现的问题 当没有bp的时候也会莫名的走cellForRow方法？？？？
        if (bp == nil) {
            
             [_syncTwoVC.view removeFromSuperview];
            [_pastVC.view removeFromSuperview];
            [self.indicator startAnimating];
            if (!self.timerAnimation.isValid) {
                self.timerAnimation =[NSTimer timerWithTimeInterval:50 target:self selector:@selector(stopIndicatorAnimation) userInfo:nil repeats:NO];
                [[NSRunLoop currentRunLoop] addTimer:self.timerAnimation forMode:NSRunLoopCommonModes];
            }
            
        }
        
        cellNofind.bluetoothName.backgroundColor = [UIColor grayColor];
        cellNofind.bluetoothName.text = [NSString stringWithFormat:@"%@  %@",bp.name,batteryLevel];
        
        return cellNofind;
    }
    
    
}

#pragma mark - tabelview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BTBluetoothFindCell *findCell = (BTBluetoothFindCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    findCell.backgroundColor = [UIColor grayColor];
    findCell.contentView.backgroundColor =  [UIColor blueColor];
    //往coredata里面存放选择的设备  名字
    self.context =[BTGetData getAppContex];
    NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserData" sortKey:nil];
    if (data.count > 0) {
        BTUserData *userData = [data objectAtIndex:0];
        userData.selectedName = findCell.titleLabel.text;
        [_context save:nil];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.bc connectPeripheralByName:findCell.titleLabel.text];//根据设备名字连接设备
    });
    
    //菊花显示
    self.indicator.contentLabel.text = @"正在连接设备";
    [self.indicator startAnimating];
    //动画是否超时
    if (!self.timerAnimation.isValid) {
        self.timerAnimation =[NSTimer timerWithTimeInterval:50 target:self selector:@selector(stopIndicatorAnimation) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timerAnimation forMode:NSRunLoopCommonModes];
    }
    
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
    
    
    //往coredata里面存放选择的设备行数
    self.context =[BTGetData getAppContex];
    //    NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserData" sortKey:nil];
    //    if (data.count > 0) {
    //        BTUserData *userData = [data objectAtIndex:0];
    //        userData.selectedRow = [NSNumber numberWithInt:indexPath.row];
    //        [_context save:nil];
    //    }
    
    
    
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
    NSLog(@"视图将要出现；；；；；；；；；；；；；；；");
    
}

#pragma mark - 加载发现历史设备但是未连接页面 和 连接成功页面
//连接成功页面
- (void)addLinkSuccessfulView
{
    NSLog(@"加载连接成功页面...");
    self.syncTwoVC = [BTSyncTwoViewController shareSyncTwoview];
    _syncTwoVC.view.frame = CGRectMake(0, 0, _syncTwoVC.view.frame.size.width, _syncTwoVC.view.frame.size.height);
    [self.view addSubview:_syncTwoVC.view];
    _deleteButton.hidden = NO;
   
}
//发现历史设备 但是未连接成功
- (void)addFindPastView
{
    
    NSLog(@"加载历史记录页面...");
    self.pastVC = [BTPastLinkViewController sharePastLinkview];
    _pastVC.view.frame = CGRectMake(0, 0, _pastVC.view.frame.size.width, _pastVC.view.frame.size.height);
    [self.view addSubview:_pastVC.view];
    _deleteButton.hidden = NO;
   
}

@end
