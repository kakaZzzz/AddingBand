//
//  BTBandCentral.m
//  SmartBat
//
//  Created by kaka' on 13-6-15.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBandCentral.h"

@implementation BTBandCentral

#pragma mark - 初始化
-(id)init{
    self = [super init];
    
    if (self) {
        
        //初始化
        self.cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.globals = [BTGlobals sharedGlobals];
        
        self.allPeripherals = [[NSMutableDictionary alloc] init];
        
        self.connectedList = [[NSMutableDictionary alloc] init];
        
        //没连接上设备之前加锁
        self.syncLocker = YES;
        
        //获取上下文
        UIApplication *app = [UIApplication sharedApplication];
        BTAppDelegate *delegate = (BTAppDelegate *)[app delegate];
        _context = delegate.managedObjectContext;
        
        self.waitForNextSync = YES;
        
        self.globals.displayBleList = NO;
        
         [NSTimer scheduledTimerWithTimeInterval:SCAN_INTERVAL target:self selector:@selector(doScan:) userInfo:nil repeats:YES];
    }
    
    return self;
}

#pragma mark - central改变状态后的回调
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    NSLog(@"调用了搜索蓝牙设备........");
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            
        {
            //设置nil查找任何设备
            [self scan];
            
            //读取coredata里的数据
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTBleList" inManagedObjectContext:_context];
            
            NSFetchRequest* request = [[NSFetchRequest alloc] init];
            [request setEntity:entity];
            
            NSError* error;
            _localBleLIst = [_context executeFetchRequest:request error:&error];
            NSLog(@"8888888888 %d",[_localBleLIst count]);
            for (BTBleList* old in _localBleLIst) {
                
                //如果coredata里有数据，建一个缓存
                
                BTBandPeripheral* new = [[BTBandPeripheral alloc] init];
                
                new.name = old.name;
                new.lastSync = [old.lastSync intValue];
                new.setupDate = [old.setupDate intValue];
                
                new.batteryLevel = 0;
                
                new.isConnected = NO;
                new.isConnecting = NO;
                new.isFinded =NO;
                
                
                [_allPeripherals setObject:new forKey:new.name];
            }
            
            self.globals.bleListCount = _allPeripherals.count;
            
            if (_allPeripherals.count == 0) {
                self.globals.displayBleList = YES;
            }
            
            NSLog(@"array: %@", _allPeripherals);
            
        }
            
            break;
            
        case CBCentralManagerStatePoweredOff:
            
            //关掉蓝牙开关时清零
            self.globals.bleListCount = 0;
            
            [_allPeripherals removeAllObjects];
            
            break;
            
        default:
            NSLog(@"Central Manager did change state");
            break;
    }
}

#pragma mark - 发现peripheral后的回调
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"Discover Peripheral: %@", peripheral);
    NSLog(@"AD count:%lu", (unsigned long)advertisementData.count);
    
    //排除name=(null)的异常状态
    if (advertisementData.count && peripheral.name != NULL) {
        
        NSLog(@"AD:%@", advertisementData);
        
        //查找之前是否连接过
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTBleList" inManagedObjectContext:_context];
        
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSError* error;
        _localBleLIst = [_context executeFetchRequest:request error:&error];
        
        //取出现在发现设备的型号
        NSString* findModel = [BTUtils getModel:peripheral.name];
        
        Boolean rightOne = YES;
        BOOL isLast = NO;//上一次连接判断标识符
        for (BTBleList* old in _localBleLIst) {
            
            //如果型号一致
            if ([findModel isEqualToString:[BTUtils getModel:old.name]]) {
                
                if ([old.name isEqualToString:peripheral.name]){
                    
                    //sn也一致的话，直接连接
                    // rightOne = NO;//不让列表再刷新  直接在历史页面进行设备连接
                    
                    isLast = YES;
                    
                    if (_waitForNextSync) {
                        [self connectPeripheral:peripheral];
                    }

                    NSLog(@"直接连接!!!2222222");
                    
                }else{
                    
                    //型号一致，但不是之前连接的那个
                    
                    rightOne = NO;
                    
                    NSLog(@"is wrong one!");
                    
                }
            }
        }
        
        //是之前连接过的那个，或者还未连接过此类设备，对所有设备开放
        
        if (rightOne) {
            
            BTBandPeripheral* find = [_allPeripherals objectForKey:peripheral.name];
            
            //如果不在缓存中，新建一个
            if (!find) {
                find = [[BTBandPeripheral alloc] init];
                
                find.name = peripheral.name;
                find.isConnected = NO;
                find.isConnecting = NO;//改过
                find.batteryLevel = 0;
            }
            
            //缓存周边对象，变更查找状态
            [find addPeripheral:peripheral];
            find.isFinded = YES;
            if (_waitForNextSync) {
                find.isConnecting = YES;//改过
           }

            //保存在缓存里
            [_allPeripherals setObject:find forKey:find.name];
            
            //连接上一个以后增加
            self.globals.bleListCount = _allPeripherals.count;//
        }
        
        
        NSLog(@"core data: %@", _localBleLIst);
        
        NSLog(@"%@", _allPeripherals);
    }
}

#pragma mark - 连接peripheral后的回调
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    NSLog(@"Connect Peripheral11: %@", peripheral);
    
    //清除连接超时的timer
    if (_timeoutTimer) {
        [_timeoutTimer invalidate];
    }
    
    //清除其他同型号设备的缓存
    NSMutableArray* others = [[NSMutableArray alloc] init];
    
    NSEnumerator* ev = [_allPeripherals objectEnumerator];
    
    for (BTBandPeripheral* bp in ev) {
        
        if ([BTUtils isSameModel:peripheral.name and:bp.name] && ![peripheral.name isEqual:bp.name]) {
            
            //            [_allPeripherals removeObjectForKey:bp.name];
            [others addObject:bp.name];
        }
        
        else{
            // [_allPeripherals setObject:peripheral forKey:peripheral.name];//
        }
    }
    
    NSLog(@"others::%@", others);
    
    for (NSString* deleteName in others) {
        [_allPeripherals removeObjectForKey:deleteName];
    }
    
    
    
    NSLog(@"all: %@", _allPeripherals);
   
    BTBandPeripheral* find = [_allPeripherals objectForKey:peripheral.name];
    NSLog(@"连接设备%@",find.name);
    //缓存中变更连接状态
    find.isConnecting = YES;//改了
    
//    self.globals.bleListCount = [_allPeripherals count];//王鹏 12月13日修改 不要反复调用刷新列表
    
    //查找之前是否连接过
    Boolean never = YES;
    
    for (BTBleList* old in _localBleLIst) {
        if ([old.name isEqualToString:find.name]) {
            never = NO;
        }
    }
    
    //从来没有连接过
    if (never) {
        //新建一条记录
        BTBleList* first = [NSEntityDescription insertNewObjectForEntityForName:@"BTBleList" inManagedObjectContext:_context];
        
        first.name = find.name;
        first.lastSync = 0;
        
        //记录设备绑定时间
        first.setupDate = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
        
        find.setupDate = [first.setupDate intValue];//时间
        
        //及时保存
        NSError* error;
        if(![_context save:&error]){
            NSLog(@"%@", [error localizedDescription]);
        }
        
        self.globals.displayBleList = NO;
    }
    
    self.globals.bleListCount = [_allPeripherals count];
    
    //代理peripheral
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    NSLog(@"连接到设备hello：%@", _allPeripherals);
}

#pragma mark - 发现service后的回调
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        NSLog(@"DiscoverServices error: %@", error.localizedDescription);
    }
    
    for (CBService *s in peripheral.services) {
        
        if ([s.UUID isEqual:[CBUUID UUIDWithString:UUID_HEALTH_SERVICE]] || [s.UUID isEqual:[CBUUID UUIDWithString:UUID_BATTERY_SERVICE]]) {
            NSLog(@"s:%@", s.UUID);
            [peripheral discoverCharacteristics:nil forService:s];
        }
        
    }
    
}

#pragma mark - 发现characteristic后的回调
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    if (error) {
        NSLog(@"DiscoverCharacteristics error: %@", error.localizedDescription);
    }
    
    NSLog(@"Discover Characteristics sum: %d", service.characteristics.count);
    
    //正常连接操作
    
    BTBandPeripheral* bp = [_allPeripherals objectForKey:peripheral.name];
    
    for (CBCharacteristic* c in service.characteristics) {
        
        NSLog(@"c:%@", c.UUID);
        
        [bp.allCharacteristics setObject:c forKey:c.UUID];
        
        // 设置电量通知
        if ([c.UUID isEqual:[CBUUID UUIDWithString:UUID_BATTERY_LEVEL]]) {
            [peripheral setNotifyValue:YES forCharacteristic:c];
        }
        
        // 设置sync通知
        if ([c.UUID isEqual:[CBUUID UUIDWithString:UUID_HEALTH_SYNC]]) {
            [peripheral setNotifyValue:YES forCharacteristic:c];
        }
        
        // 设置data header通知
        if ([c.UUID isEqual:[CBUUID UUIDWithString:UUID_HEALTH_DATA_HEADER]]) {
            [peripheral setNotifyValue:YES forCharacteristic:c];
        }
        
        // 设置data body通知
        if ([c.UUID isEqual:[CBUUID UUIDWithString:UUID_HEALTH_DATA_BODY]]) {
            [peripheral setNotifyValue:YES forCharacteristic:c];
        }
        
        //连接完成！！
        
        if(bp.allCharacteristics.count == CHARACTERISTICS_COUNT){
            
            NSLog(@"ge zaile ");
            
            //更新手环状态
//            self.globals.bleListCount += 0;
            
            //同步锁打开
            _syncLocker = NO;
            
            //取现在距离2000-1-1的秒数
            uint32_t seconds = [BTUtils currentSeconds];
            
            NSLog(@"now:%d", seconds);
            
            //初始化手环的时间
            [self writeAll:[NSData dataWithBytes:&seconds length:sizeof(seconds)] withUUID:[CBUUID UUIDWithString:UUID_HEALTH_CLOCK]];
            
            //新增一个连接设备
            [self.connectedList setObject:[NSNumber numberWithBool:YES] forKey:[BTUtils getModel:peripheral.name]];
            
        }
    }
}

#pragma mark - 注册update value后的回调
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"UpdateNotificationStateForCharacteristic erroe:%@", error.localizedDescription);
    }
    
    if (characteristic.isNotifying) {
        
        NSLog(@"Notification began on %@", characteristic);
        
        // 发现可以注册notify以后，读取一下数据长度
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUID_HEALTH_DATA_HEADER]]) {
//            [peripheral readValueForCharacteristic:characteristic];
//        }
        
        // 发现可以注册notify以后，读取一下电量
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUID_BATTERY_LEVEL]]) {
            [peripheral readValueForCharacteristic:characteristic];
        }
        
    } else{
        NSLog(@"Notification stop %@", characteristic);
    }
}

#pragma mark - 收到周边设备的数据更新
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"UpdateValueForCharacteristic error: %@", error.localizedDescription);
    }
    
    NSLog(@"update:%@", characteristic.UUID);
    
    //根据uuid取到对象
    BTBandPeripheral* bp = [_allPeripherals objectForKey:peripheral.name];
    
    //把数据放到缓存里
    [bp.allValues setObject:characteristic.value forKey:characteristic.UUID];
    
    //    NSLog(@"c:%@, v:%@", characteristic.UUID, characteristic.value);
    
    //用来做调试的
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUID_HEALTH_SYNC]]) {
        
        NSLog(@"debug: %@", characteristic.value);
        
        // 调试每条记录用
//        uint32_t hourSencodes;
//        [characteristic.value getBytes:&hourSencodes range:NSMakeRange(0, 4)];
//        NSLog(@"hour:%@", [BTUtils dateWithSeconds:(NSTimeInterval)hourSencodes]);
        
        // 调试加速计xyz输出
//        int16_t x,y,z;
//        
//        [characteristic.value getBytes:&x range:NSMakeRange(0, 2)];
//        [characteristic.value getBytes:&y range:NSMakeRange(2, 2)];
//        [characteristic.value getBytes:&z range:NSMakeRange(4, 2)];
//        
//        NSLog(@"x:%d y:%d z:%d", x,y,z);
        
        
        uint8_t same;
        uint16_t addr;
        
        [characteristic.value getBytes:&addr range:NSMakeRange(0, 2)];
        [characteristic.value getBytes:&same range:NSMakeRange(2, 1)];
        
        NSLog(@"a:%d s:%d", addr, same);


    }
    
    //接到电量的通知
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUID_BATTERY_LEVEL]]) {
        
        NSLog(@"Battery: %@", characteristic.value);
        
        BTBandPeripheral* bp = [_allPeripherals objectForKey:peripheral.name];
        
        bp.isConnected = YES;
        
        [self sync:[BTUtils getModel:peripheral.name]];
        
        //更新手环状态  在电量读取出来之后
        self.globals.bleListCount = [_allPeripherals count];

    }
    
    //接到数据总长度的通知
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUID_HEALTH_DATA_HEADER]]) {
        
        NSLog(@"%@", characteristic.value);
        
        uint16_t d;
        [characteristic.value getBytes:&d];
        
        bp.dataLength = d;
        
        NSLog(@"length:%d", bp.dataLength);
    }
    
    //接到数据通知
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUID_HEALTH_DATA_BODY]]) {
        NSLog(@"value:%@",  characteristic.value);
        
        uint32_t seconds;
        uint16_t count;//同步数据的时候的运动步数
        uint8_t type;
        
        [characteristic.value getBytes:&seconds range:NSMakeRange(0, 4)];
        [characteristic.value getBytes:&count range:NSMakeRange(4, 2)];
        [characteristic.value getBytes:&type range:NSMakeRange(6, 1)];
        
        
        //获取当前时间
        NSDate* date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        
        NSLog(@"localeDate211==%@", localeDate);
//

        if (count > 0 && seconds) {
            
            NSLog(@"%@, c:%d t:%d", [BTUtils dateWithSeconds:(NSTimeInterval)seconds], count, type);
            
            //分割出年月日小时
            NSDate* date = [BTUtils dateWithSeconds:(NSTimeInterval)seconds];
            
            NSNumber* year = [BTUtils getYear:date];
            NSNumber* month = [BTUtils getMonth:date];
            NSNumber* day = [BTUtils getDay:date];
            NSNumber* hour = [BTUtils getHour:date];
            NSNumber* minute = [BTUtils getMinutes:date];
            
            NSNumber *second1970 = [NSNumber numberWithDouble:[date timeIntervalSince1970]];//距离1970年的秒数
            NSLog(@"%@ %@ %@ %@ %@",year,month,day,hour,minute);
            //设置coredataye
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTRawData" inManagedObjectContext:_context];
            
            NSFetchRequest* request = [[NSFetchRequest alloc] init];
            [request setEntity:entity];
            
            //设置查询条件
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day = %@ AND hour == %@ AND minute == %@ AND type == %@",year, month, day, hour, minute, [NSNumber numberWithInt:type]];
            
            [request setPredicate:predicate];
            
            NSError* error;
            NSArray* raw = [_context executeFetchRequest:request error:&error];
            
            if (raw.count == 1) {
                
                //已经有条目了
                //进行coredata的更改数据操作
                BTRawData* one = [raw objectAtIndex:0];
                
                NSLog(@"ther is %@", one.count);
                
                one.count = [NSNumber numberWithInt:[one.count intValue] + count];
                NSLog(@"ther is %@", one.count);
                //如果先前已经存有数据的话 判断写的数据是否跟原有数据是同一天的 如果是仅仅改变这个实体的count属性就可以了
//                BTRawData *one = [raw lastObject];
//                if ([year isEqual:one.year] && [month isEqual:month] && [day isEqual:day]) {
//                     count = [one.count intValue] + count;
//                    one.count = [NSNumber numberWithInt:count];
//                    
//                }
                
            }else if(raw.count == 0){
                
                //木有啊,就新建一条  进行coredata的插入数据操作
                
                NSLog(@"there no");
                
                BTRawData* new = [NSEntityDescription insertNewObjectForEntityForName:@"BTRawData" inManagedObjectContext:_context];
                
                new.year = year;
                new.month = month;
                new.day = day;
                new.hour = hour;
                new.minute = minute;
                new.type = [NSNumber numberWithInt:type];
                new.count = [NSNumber numberWithInt:count];
                new.from = peripheral.name;
                new.seconds1970 = second1970;//存个秒数
            }
            
            [_context save:&error];
            // 及时保存
            if(![_context save:&error]){
                NSLog(@"%@", [error localizedDescription]);
            }
            
        }
        
        
        bp.currentBlock++;
        
        bp.dlPercent = (float)bp.currentBlock / (float)bp.dataLength;
        
        //同步完成
        if (bp.dlPercent == 1) {
            _syncLocker = NO;
            
            //更新上次同步时间
            bp.lastSync = [[NSDate date] timeIntervalSince1970];
            
            //设置coredata
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTBleList" inManagedObjectContext:_context];
            
            NSFetchRequest* request = [[NSFetchRequest alloc] init];
            [request setEntity:entity];
            
            //设置查询条件
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", bp.name];
            
            [request setPredicate:predicate];
            
            NSError* error;
            NSArray* raw = [_context executeFetchRequest:request error:&error];
            
            if (raw.count) {
                BTBleList* one = [raw objectAtIndex:0];
                
                //更新coredata里的最后更新时间
                one.lastSync = [NSNumber numberWithInt:bp.lastSync];
            }
            
            // 及时保存
            if(![_context save:&error]){
                NSLog(@"%@", [error localizedDescription]);
            }
            
            _waitForNextSync = NO;
            [_cm cancelPeripheralConnection:peripheral];
            
        }
        
    }
    
    //取出缓存中的block并执行
    void (^block)(NSData* value, CBCharacteristic* characteristic, CBPeripheral* peripheral)  = [bp.allCallback objectForKey:characteristic.UUID];
    
    if (block) {
        block(characteristic.value, characteristic, peripheral);
    }
    
    [bp.allCallback removeObjectForKey:characteristic.UUID];
}

#pragma mark - 写数据完成后的回调
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@"WriteValueForCharacteristic error: %@", error.localizedDescription);
    }
    NSLog(@"write value: %@", characteristic.value);
    
}

#pragma mark - peripheral断开连接
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    NSLog(@"dis:%@ err:%@", peripheral, error);
    NSLog(@"突然断开连接........");
    //从缓存中移除
    [_allPeripherals removeObjectForKey:peripheral.name];
    
    
    //读取coredata里的数据
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTBleList" inManagedObjectContext:_context];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError* err;
    _localBleLIst = [_context executeFetchRequest:request error:&err];
    
    for (BTBleList* old in _localBleLIst) {
        
        if ([old.name isEqual:peripheral.name]) {
            
            //如果在coredata中，则在缓存中重建
            
            BTBandPeripheral* new = [[BTBandPeripheral alloc] init];
            
            new.name = peripheral.name;
            new.lastSync = [old.lastSync intValue];
            new.setupDate = [old.setupDate intValue];
            
            new.isConnected = NO;
            new.batteryLevel = 0;
            new.isFinded = NO;
            new.isConnecting = NO;
            
            [_allPeripherals setObject:new forKey:new.name];
            
            //把coredata里的数据删除
            //            [_context delete:old];
            
        }
    }
    
    //设备总数减少 刷新列表
    self.globals.bleListCount = _allPeripherals.count;
    
    //断开一个设备
    [_connectedList setObject:[NSNumber numberWithBool:NO] forKey:[BTUtils getModel:peripheral.name]];
    
    //断开连接后自动重新搜索
    
    NSLog(@"停止搜索 并调用搜索。。。。。。");
    
    [self restartScan];
}



#pragma mark - 下面都是对外暴露的接口

#pragma mark - 向所有peripheral写数据
-(void)writeAll:(NSData*)value withUUID:(CBUUID*)cuuid{
    
    NSEnumerator * enumeratorValue = [_allPeripherals objectEnumerator];
    
    for (BTBandPeripheral* bp in enumeratorValue) {
        CBCharacteristic* tmp = [bp.allCharacteristics objectForKey:cuuid];
        
        if (tmp && bp.handle.isConnected) {
            [bp.handle writeValue:value forCharacteristic:tmp type:CBCharacteristicWriteWithResponse];
        }
    }
}


#pragma mark - 读取所有peripheral里某个characteristic
-(void)readAll:(CBUUID*)cuuid withBlock:(void (^)(NSData* value, CBCharacteristic* characteristic, CBPeripheral* peripheral))block{
    
    //遍历所有的peripheral
    NSEnumerator * enumeratorValue = [_allPeripherals objectEnumerator];
    
    for (BTBandPeripheral* bp in enumeratorValue) {
        
        //根据uuid找到具体的characteristic
        CBCharacteristic* tmp = [bp.allCharacteristics objectForKey:cuuid];
        
        if (tmp && bp.handle.isConnected) {
            //把block句柄放到缓存里
            //注意：没有加锁，可能有问题
            if (block) {
                [bp.allCallback setObject:block forKey:cuuid];
            }
            
            //发送read请求
            [bp.handle readValueForCharacteristic:tmp];
        }
    }
}


#pragma mark - 把丫做成单例
+(BTBandCentral *)sharedBandCentral
{
    static BTBandCentral *sharedBandCentralInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedBandCentralInstance = [[self alloc] init];
    });
    return sharedBandCentralInstance;
}

#pragma mark - 扫描指定的蓝牙服务
-(void)scan{
    
    [_cm scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:UUID_HEALTH_SERVICE]] options:nil];
    
    NSLog(@"scan ForPeripherals");
}

#pragma mark - 根据缓存中的序号，连接或断开蓝牙周边
-(void)togglePeripheralByIndex:(NSUInteger)index{
    
    //根据index找到对应的peripheral
    NSEnumerator * enumeratorValue = [_allPeripherals objectEnumerator];
    BTBandPeripheral* bp = [[enumeratorValue allObjects] objectAtIndex:index];
    
    if (!bp.handle.isConnected) {
        
        [self connectPeripheral:bp.handle];
        NSLog(@"!!!connect");
        
    }else{
        
        //删除coredata里的这条数据
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTBleList" inManagedObjectContext:_context];
        
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSError* error;
        _localBleLIst = [_context executeFetchRequest:request error:&error];
        
        for (BTBleList* old in _localBleLIst) {
            if ([old.name isEqualToString:bp.handle.name]){
                [_context deleteObject:old];
                NSLog(@"!!!2222222");
            }
        }
        
        //及时保存
        NSError* err;
        if(![_context save:&err]){
            NSLog(@"%@", [err localizedDescription]);
        }
        
        self.globals.displayBleList = YES;
        
        //断开连接
        [_cm cancelPeripheralConnection:bp.handle];
        NSLog(@"cancel connected");
    }
    
}

-(void)connectPeripheral:(CBPeripheral *)peripheral{
    
    [_cm connectPeripheral:peripheral options:nil];
    
    _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:CONNECT_PERIPHERAL_TIMEOUT target:self selector:@selector(timeout:) userInfo:nil repeats:NO];
}

#pragma mark - 通过设备名连接蓝牙周边
-(void)connectPeripheralByName:(NSString*)name{
    
    BTBandPeripheral* bp = [self getBpByName:name];
    
    if (bp && !bp.isConnected && bp.isFinded) {
        
        [self connectPeripheral:bp.handle];
        
        NSLog(@"try to connect %@", name);
    }
    
}

#pragma mark - 通过设备型号断开蓝牙周边
-(void)removePeripheralByModel:(NSString*)model{
    
    //先删除coredata里的数据
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTBleList" inManagedObjectContext:_context];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError* error;
    _localBleLIst = [_context executeFetchRequest:request error:&error];
    //因为 BTBleList只存放连接上的设备 其元素个数为1
    for (BTBleList* old in _localBleLIst) {
        if ([[BTUtils getModel:old.name] isEqualToString:model]){
            
            [_context deleteObject:old];
            NSLog(@"find model %@ in coredata, then delete it", model);
        }
    }
    
    //及时保存
    NSError* err;
    if(![_context save:&err]){
        NSLog(@"%@", [err localizedDescription]);
    }
    
    NSLog(@"!#@^^& update");
    self.globals.displayBleList = YES;
    _waitForNextSync = YES;
  
    //如果设备正在连接，则断开
    BTBandPeripheral* bp = [self getBpByModel:model];
    //如果是意外断开设备的时候  手动删除设备后要 刷新列表
    if (bp && ! bp.isConnected) {
        self.globals.bleListCount = [_allPeripherals count];
    }
    
    if (bp && bp.isConnected) {
        [_cm cancelPeripheralConnection:bp.handle];
        
        NSLog(@"try to cancel connect model %@", model);
    }else{
        [self restartScan];
    }
    
}
#pragma mark - 通过设备名称断开蓝牙周边
-(void)removePeripheralByName:(NSString*)name{
    
    //先删除coredata里的数据
    NSLog(@"设备数组是数组是%@",_allPeripherals);
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTBleList" inManagedObjectContext:_context];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError* error;
    _localBleLIst = [_context executeFetchRequest:request error:&error];
    
    for (BTBleList* old in _localBleLIst) {
        if ([old.name isEqualToString:name]){
            
            [_context deleteObject:old];
            NSLog(@"find model %@ in coredata, then delete it", name);
        }
    }
    
    //及时保存
    NSError* err;
    if(![_context save:&err]){
        NSLog(@"%@", [err localizedDescription]);
    }
    
    self.globals.displayBleList = YES;
    
    //刷新列表
    self.globals.bleListCount = [_allPeripherals count];
    
    //如果设备正在连接，则断开
    BTBandPeripheral* bp = [self getBpByName:name];
    
    if (bp && bp.isConnected) {
        [_cm cancelPeripheralConnection:bp.handle];
        
        NSLog(@"try to cancel connect model %@", name);
    }
    
}

#pragma mark - 通过设备型号发起同步操作
-(void)sync:(NSString*)model{
    
    if (!_syncLocker) {
        
        _syncLocker = YES;
        
        NSLog(@"wo ca");
        
        BTBandPeripheral* bp = [self getBpByModel:model];
        
        if (bp) {
            
            //开始同步
            
            bp.currentBlock = 0;
            
            CBCharacteristic* c = [bp.allCharacteristics objectForKey:[CBUUID UUIDWithString:UUID_HEALTH_SYNC]];
            
            uint16_t dd = SYNC_CODE;
            
            [bp.handle writeValue:[NSData dataWithBytes:&dd length:sizeof(dd)] forCharacteristic:c type:CBCharacteristicWriteWithResponse];
            
        }
        
    }
    
}

#pragma mark - 获得同步时间的文字描述
-(NSString*)getLastSyncDesc:(NSString*)model{
    
    NSString* syncWords;
    
    BTBandPeripheral* bp = [self getBpByModel:model];
    
    if (bp) {
        
        if (bp.lastSync) {
            
            NSString* last;
            
            int interval = [[NSDate date] timeIntervalSince1970] - bp.lastSync;
            
            if (interval > AUTO_SYNC_INTERVAL) {
                
                [self scanAndSync];
            }
            
            
            if (interval < 10) {
                
                // 10秒以内，刚刚
                last = @"刚刚";
                
            }else if (interval < 60) {
                
                // 1分钟以内，xx秒前
                last = [NSString stringWithFormat:@"%d0秒前", interval/10];
                
            }else if(interval < 3600){

                // 1小时以内，xx分钟前
                last = [NSString stringWithFormat:@"%d分钟前", interval/60];
                
            }else if(interval < 86400){
                
                // 1天以内，xx小时前
                last = [NSString stringWithFormat:@"%d小时前", interval/3600];
                
            }else if(interval < 345600){
                
                // 4天以内，x天前
                last = [NSString stringWithFormat:@"%d天前", interval/86400];
                
            }else{
                
                // 用全日期
                NSDateFormatter* df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd"];
                [df setTimeZone:[NSTimeZone localTimeZone]];
                
                last = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:bp.lastSync]];
            }
            
            syncWords = [NSString stringWithFormat:@"上次同步:%@", last];
            
        }else{
            
            //从没同步过
            syncWords = @"从未同步";
            
        }
        
//        NSLog(@"%@", syncWords);
        
    }
    
    return syncWords;
    
}

#pragma mark - 通过设备型号获得BTBandPeripheral对象
-(BTBandPeripheral*)getBpByModel:(NSString*)model{
    
    //遍历所有的peripheral
    NSEnumerator * enumeratorValue = [_allPeripherals objectEnumerator];
    
    for (BTBandPeripheral* bp in enumeratorValue) {
        
        if ([model isEqual:[BTUtils getModel:bp.name]]) {
            
//            NSLog(@"------%@",bp);
            
            return bp;
        }
        
    }
    
    return Nil;
}

#pragma mark - 通过设备名获得BTBandPeripheral对象
-(BTBandPeripheral*)getBpByName:(NSString*)name{
    
    //遍历所有的peripheral
    NSEnumerator * enumeratorValue = [_allPeripherals objectEnumerator];
    
    for (BTBandPeripheral* bp in enumeratorValue) {
        
        if ([name isEqual:bp.name]) {
            
            return bp;
        }
        
    }
    
    return Nil;
}

#pragma mark - 通过缓存中的序号获得BTBandPeripheral对象
-(BTBandPeripheral*)getBpByIndex:(NSInteger)row{
    NSArray * ev = [[_allPeripherals objectEnumerator] allObjects];
    return [ev objectAtIndex:row];
}

#pragma mark - 检查某个型号的设备是否连接上
-(Boolean)isConnectedByModel:(NSString*)model{
    
    NSNumber* b = [_connectedList objectForKey:model];
    
    if (b && b.boolValue) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 停止当前扫描，并在1秒后重新开始扫描
-(void)restartScan{
    
    [_cm stopScan];
    
    _scanTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doScan:) userInfo:nil repeats:NO];
}

#pragma mark - 定时器调用
-(void)doScan:(NSTimer *)theTimer{
    [self scan];
}

#pragma mark - 连接设备超时触发事件
-(void)timeout:(NSTimer *)theTimer{
    
    if (_timeoutBlock) {
        _timeoutBlock();
    }
}

#pragma mark - 重新扫描并同步
-(void)scanAndSync{
    
    if (_waitForNextSync == NO) {
        _waitForNextSync = YES;
        
        [self scan];
    }
}

@end
