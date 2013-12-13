//
//  BTSyncViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-4.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTSyncViewController.h"
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
@interface BTSyncViewController ()

@end

@implementation BTSyncViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        //初始化
        self.g = [BTGlobals sharedGlobals];
        self.bc = [BTBandCentral sharedBandCentral];
        
        //监听设备变化
        [self.g addObserver:self forKeyPath:@"bleListCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
         //不可滚动
        self.tableView.scrollEnabled = NO;
        UIView *_backgroundview = [[UIView alloc] initWithFrame:self.view.bounds];
        [_backgroundview setBackgroundColor:[UIColor whiteColor]];
        [self.tableView setBackgroundView:_backgroundview];
        //设置tabelview的高度
        self.tableView.frame = CGRectMake(0, 50, 320, self.view.frame.size.height-50);
        //
         self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
       //self.tableView.allowsSelection = NO;
        self.tableView.rowHeight = kBluetoothConnectedHeight;
        //
//        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        _indicator.frame = CGRectMake(100, 100, 100, 100);
//        [self.view addSubview:_indicator];
        self.indicator = [[DDIndicator alloc] initWithFrame:CGRectMake(120, 150, 60, 60)];
        [self.view addSubview:_indicator];
        _indicator.hidden = YES;
       // [_indicator startAnimating];

        
        
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
    NSLog(@"上次同步时间是：%@",_lastSyncTime);
    self.syncTwoVC.lastSyncTime.text = _lastSyncTime;
    self.pastVC.lastSyncTime.text = _lastSyncTime;
    //计算使用时间
    int k = [[self.bc getBpByModel:MAM_BAND_MODEL] setupDate];
    NSString *str = [BTGetData getBLEuseTime:k];
    self.syncTwoVC.useTimeLabel.text = [NSString stringWithFormat:@"%@",str];
    self.pastVC.useTimeLabel.text = [NSString stringWithFormat:@"%@",str];
    [self.tableView reloadData];
    
}
//监控参数，更新显示  当连接  断开的时候也会调用此方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"监听设备数量变化");
    
    if([keyPath isEqualToString:@"bleListCount"])
    {
        NSLog(@"ble count: %d", self.g.bleListCount);
        
        //行数变化时，重新加载列表
        //todo 等于0的时候处理成“查找中”
        if (self.g.bleListCount == 0) {
            //加载动画显示
            NSLog(@"准备加个搜索动画呢啊");
         //   [self.indicator startAnimating];
         //   [self.tableView reloadData];
        }
        if (self.g.bleListCount > 0) {
            
         //   [self.indicator stopAnimating];
            //reloaddata的条件还得加以判断
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
        //  NSDictionary *dicProgress = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:bp.dlPercent] forKey:@"progress"];
        
        if (bp.dlPercent == 1) {
            
            
            
            //同步完成逻辑
            //在这里发送通知  刷新需要显示运动量之类页面的数据 包括进度条  label  柱形图
            //同步完成之后要通知数据页面进行数据刷新
            //    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATACIRCULARPROGRESSNOTICE object:nil userInfo:dicProgress];//接受通知页面必须存在
        }
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor blueColor];
    self.tableView.frame = CGRectMake(0, 50, 320, self.tableView.frame.size.height);
    self.tableView.backgroundColor = [UIColor blueColor];
    NSLog(@"3333333333333333333%@",NSStringFromCGRect(self.tableView.frame));
    
    //
    [self configureNavigationbar];
}
#pragma mark - 设置导航栏上面的按钮
- (void)configureNavigationbar
{
    self.syncButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _syncButton.frame = CGRectMake(250, 5, 65, 30);
    
    [_syncButton setTitle:@"删除" forState:UIControlStateNormal];//title的值根据定位和和选择而改变
    _syncButton.tag = 198;
    _syncButton.hidden = YES; 
    [_syncButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_syncButton addTarget:self action:@selector(breakConnect) forControlEvents:UIControlEventTouchUpInside];
    [_syncButton setBackgroundImage:[UIImage imageNamed:@"透明.png"] forState:UIControlStateNormal];
    _syncButton.tintColor = [UIColor colorWithRed:70/255.0 green:163/255.0 blue:210/255.0 alpha:1];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)_syncButton];
}
#pragma mark - 断开连接
//导航栏上的断开按钮触发断开事件  断开时将syncTwoVC.view从父视图上移除  导航栏上按钮隐藏,当再次连接的时候再显示出来
- (void)breakConnect
{
    NSLog(@"立即断开");
    
    //弹出提醒框
    UIAlertView *aLart = [[UIAlertView alloc] initWithTitle:@"删除此设备" message:@"您确定要删除此设备吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    aLart.tag = 100;
    [aLart show];

    
    
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//    
//  //  [self.indicator startAnimating];
//    
//    if (alertView.tag == 100) {
//        if (buttonIndex == 0) {
//            
//            //断开连接
//            
//            int i = 0;
//            self.context =[BTGetData getAppContex];
//            NSArray *data1 = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserData" sortKey:nil];
//            if (data1.count > 0) {
//                BTUserData *userData = [data1 objectAtIndex:0];
//                i = [userData.selectedRow intValue];
//            }
//            self.bc = [BTBandCentral sharedBandCentral];
//            NSEnumerator * enumeratorValue = [self.bc.allPeripherals objectEnumerator];
//            BTBandPeripheral* bp = [[enumeratorValue allObjects] objectAtIndex:0];
//
//            //如果是正在连接的设备就断开连接
//            if (bp.isConnected) {
//                [self.bc togglePeripheralByIndex:0];
//               // [self.indicator startAnimating];//加载动画
//                _syncButton.hidden = YES;
//                //[self.navigationItem.rightBarButtonItem setEnabled:NO];
//                [self.syncTwoVC.view removeFromSuperview];
//                [self.pastVC.view removeFromSuperview];
//                
//                //设备总数减少
////                self.g.bleListCount = [self.bc.allPeripherals count];
////                
////                [self.bc.allPeripherals removeObjectForKey:bp.name];
//            }
//            
//            
//            
//            
//            else{
//            
//                //以下为删除设备
//                //往coredata里面存放选择的设备行数
//                
//                //根据index找到对应的peripheral
//                self.bc = [BTBandCentral sharedBandCentral];
//                
//                //删除coredata里的这条数据
//                _context = [BTGetData getAppContex];
//                NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTBleList" inManagedObjectContext:_context];
//                
//                NSFetchRequest* request = [[NSFetchRequest alloc] init];
//                [request setEntity:entity];
//                
//                NSError* error;
//                
//                NSArray *resultArray = [_context executeFetchRequest:request error:&error];
//                
//                for (BTBleList* old in resultArray) {
//                    NSLog(@"设备名称%@",bp.name);
//                    if ([[BTUtils getModel:old.name] isEqualToString:@"A1"]){
//                        [self.bc.allPeripherals removeObjectForKey:bp.name];
//                        [_context deleteObject:old];
//                        NSLog(@"!!!2222222");
//                    }
//                    
//                    
//                    //及时保存
//                    NSError* err;
//                    if(![_context save:&err]){
//                        NSLog(@"%@", [err localizedDescription]);
//                    }
//                    
//                    //设备总数减少
//                    self.g.bleListCount = [self.bc.allPeripherals count];
//                [self.bc.allPeripherals removeObjectForKey:bp.name];
//            }
//            
//            //移除页面
//            [self.pastVC.view removeFromSuperview];
//                _syncButton.hidden = YES;
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadData" object:nil];
//           // [self.bc scan];
//            
//            
//        }
//    }
//    }
//    
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 视图上进度条动画
- (void)startIndicatorAnimation
{
//    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    _indicator.frame = CGRectMake(100, 100, 100, 100);
//    
//    BTAppDelegate *appDelegate = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    [appDelegate.window addSubview:_indicator];
//    [_indicator startAnimating];

}

- (void)stopIndicatorAnimation
{
    [self.indicator stopAnimating];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

       return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    //刚开始没有连接上设备的时候 每个设备下面只有一行  显示“立即连接” ;当连接上的时候 设备下面变成两行 显示“上次同步时间” “立即同步”
    //当同步完的时候 怎么做？？？
    return self.g.bleListCount ;
}

////分区头 所要显示的文字
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//
//{
//    //
//    return @"可连接设备";
//    
//}


//动态改变每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"heightForRowAtIndexPath");
    //根据index找到对应的peripheral
    BTBandPeripheral*bp  = [self.bc getBpByIndex:indexPath.row];
    
    //是否发现
    Boolean isFinded = bp.isFinded;
    //是否连接
    Boolean isConnected = bp.isConnected;
    
    //是否正在连接中
    BOOL isConnecting = bp.isConnecting;
    
    NSLog(@"设备是否正在连接  %d",isConnecting);
    //
    if (isConnecting && !isConnected) {
        NSLog(@"开始搜索动画");
        [self.indicator startAnimating];
    }
    if (isConnected && isConnecting) {
        [self.indicator stopAnimating];
    }
    if (isFinded && !isConnected) {
        NSLog(@"发现未连接  %d",isConnecting);
        
        return 50;
       // return kBluetoothFindHeight;
    }
    else if (isConnected)
    {
        NSLog(@"已连接");
        return kBluetoothConnectedHeight;
    }
    else
        return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    
    //根据index找到对应的peripheral
    BTBandPeripheral*bp  = [self.bc getBpByIndex:indexPath.row];
    
    //是否发现
    Boolean isFinded = bp.isFinded;
    
    //是否连接
    Boolean isConnected = bp.isConnected;
    
    //是否正在连接中
  //  BOOL isConnecting = bp.isConnecting;
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
      NSLog(@" %d  %d",isFinded,isConnected);
    NSLog(@"外围设备名称是 %@",name);
//    if (indexPath.row == 0) {
//        if (cellSection == nil) {
//            cellSection = [[BTSettingSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellSection];
//        }
//        cellSection.titleLabel.text = @"可连接设备";
//          return cellSection;
//    }
//
//    }


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
        self.syncTwoVC.batteryLabel.text = [NSString stringWithFormat:@"电量:%@%@",batteryLevel,@"%"];
        _syncButton.hidden = NO ;//导航栏上的按钮可按
        //再此 移除搜索到历史设备 但未连接页面
        if (_pastVC.view) {
            [_syncTwoVC.view removeFromSuperview];
        }
        
        //加载连接成功后的视图
        [self addLinkSuccessfulView];

        return cellConnet;
        
    }
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
        //导航栏右边按钮隐藏
        self.syncButton.hidden = NO;
        //加载发现历史设备 但未连接页面
        [self addFindPastView];
        
        
        cellNofind.bluetoothName.backgroundColor = [UIColor grayColor];
        cellNofind.bluetoothName.text = [NSString stringWithFormat:@"%@  %@",bp.name,batteryLevel];
        
        return cellNofind;
    }

}

#pragma mark - tabelview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark - viewControllers
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"视图将要出现；；；；；；；；；；；；；；；");
    
}

#pragma mark - 加载发现历史设备但是未连接页面 和 连接成功页面
//连接成功页面
- (void)addLinkSuccessfulView
{
    self.syncTwoVC = [BTSyncTwoViewController shareSyncTwoview];
    _syncTwoVC.view.frame = CGRectMake(0, -20, _syncTwoVC.view.frame.size.width, _syncTwoVC.view.frame.size.height);
    [self.view addSubview:_syncTwoVC.view];
    _syncButton.hidden = NO;
}
//发现历史设备 但是未连接成功
- (void)addFindPastView
{
    self.pastVC = [BTPastLinkViewController sharePastLinkview];
    _pastVC.view.frame = CGRectMake(0, -20, _pastVC.view.frame.size.width, _pastVC.view.frame.size.height);
    [self.view addSubview:_pastVC.view];
    _syncButton.hidden = NO;

}

@end
