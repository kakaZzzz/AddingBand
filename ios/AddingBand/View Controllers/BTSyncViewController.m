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

@interface BTSyncViewController ()

@end

@implementation BTSyncViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //
        _isBreak = NO;
        //初始化
        self.g = [BTGlobals sharedGlobals];
        self.bc = [BTBandCentral sharedBandCentral];
        
        //监听设备变化
        [self.g addObserver:self forKeyPath:@"bleListCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
        //设置tableview类型 为UITableViewStyleGrouped
        self.tableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
        
        //设置背景颜色
        UIView *_backgroundview = [[UIView alloc] initWithFrame:self.view.bounds];
        [_backgroundview setBackgroundColor:[UIColor whiteColor]];
        [self.tableView setBackgroundView:_backgroundview];
        
        self.tableView.allowsSelection = NO;
        self.tableView.rowHeight = kBluetoothConnectedHeight;
        //数据
        //存放外部蓝牙设备
        //self.peripheralArray = @[MAM_BAND_MODEL];
        self.peripheralArray = [NSMutableArray arrayWithCapacity:1];
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.tableView addSubview:_indicator];
        
        
        //启动计时器 监控上次更新时间   反复调用会不会出现什么意外情况？？？
        [self observeLastSyncTime];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(observeLastSyncTime) userInfo:nil repeats:YES];
    }
    return self;
}
//检测上次更新时间
- (void)observeLastSyncTime
{
    //读取一下对更新时间的描述
    _lastSyncTime = [self.bc getLastSyncDesc:MAM_BAND_MODEL];
    NSLog(@"上次同步时间是：%@",_lastSyncTime);
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
            [self.indicator startAnimating];
            [self.tableView reloadData];
        }
        if (_isBreak == NO || self.g.bleListCount > 0) {
            
            [self.indicator stopAnimating];
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
    NSLog(@"3333333333333333333%@",NSStringFromCGRect(self.tableView.frame));
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.g.bleListCount;
}

////分区头 所要显示的文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    //
    return @"加丁手环";
    
}
//

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
        [self.indicator startAnimating];
    }
    if (isConnected && isConnecting) {
        [self.indicator stopAnimating];
    }
    if (isFinded && !isConnected) {
        NSLog(@"发现未连接  %d",isConnecting);
        return kBluetoothFindHeight;
    }
    else if (isConnected)
    {
        NSLog(@"已连接");
        return kBluetoothConnectedHeight;
    }
    else
        return kBluetoothNotFindHeight;
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
    BOOL isConnecting = bp.isConnecting;
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
    
    if (isFinded && !isConnected) {
        
        if (cellFind == nil) {
            cellFind = [[BTBluetoothFindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierFind tatget:self];
        }
        cellFind.bluetoothName.text = [NSString stringWithFormat:@"%@",name];
        return cellFind;
    }
    else if (isConnected)
    {
        if (cellConnet == nil) {
            
            cellConnet = [[BTBluetoothConnectedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierConnect tatget:self];
        }
        cellConnet.bluetoothName.text = [NSString stringWithFormat:@"%@  %@%@",name,batteryLevel,@"％"];
        cellConnet.lastSyncTime.text = _lastSyncTime;//更新数据 从哪里读取数据
        return cellConnet;
        
    }
    else
    {
        if (cellNofind == nil) {
            
            cellNofind = [[BTBluetoothLinkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierConnect];
        }
        cellNofind.bluetoothName.backgroundColor = [UIColor grayColor];
        cellNofind.bluetoothName.text = [NSString stringWithFormat:@"%@  %@",bp.name,batteryLevel];
        
        return cellNofind;
    }
    
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.bc togglePeripheralByIndex:[indexPath row]];
    });
    
}

//立即断开的时候 屏幕会闪动 在此时究竟发生了什么？？？
//reason:以只有一个外围设备为例 当断开的时候  外围设备数量变为零  所以导致表视图空白  然后中心设备会再次搜索发现外围设备 刷新视图
//measure:设定一个判断是否进行断开操作的标识符  isBreak
- (void)breakConnect:(UIButton *)button event:(id)event
{
    //连接或者断开断开
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    _isBreak = YES;
    //点击完之后让按钮不可点击 否则就会crash
    button.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.bc togglePeripheralByIndex:[indexPath row]];
    });
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
