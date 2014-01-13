//
//  BTFetalViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-2.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTFetalViewController.h"
#import "BTRecordFetalView.h"//开始记录页面
#import "PNChart.h"//折线图
#import "BTUtils.h"
#import "LayoutDef.h"
#import "BTRawData.h"
#import "BTGetData.h"
#define kContentLabelX 0
#define kContentLabelY 200
#define kContentLabelWidth 320
#define kContentLabelHeight 90

@interface BTFetalViewController ()

@end

@implementation BTFetalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //注册更新数据的监听者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:FETALVIEWUPDATENOTICE object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.scrollEnabled = NO;
    self.navigationItem.title = @"胎动记录";
    self.view.backgroundColor = [UIColor whiteColor];//有时候，白色的底色也是需要设置的哦
    [self createSubviews];
	// Do any additional setup after loading the view.
}
- (void)createSubviews
{

    if (IPHONE_5_OR_LATER) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentLabelX, kContentLabelY, kContentLabelWidth, kContentLabelHeight)];

    }
    else{
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentLabelX, kContentLabelY - 30, kContentLabelWidth, kContentLabelHeight)];

    }
    _contentLabel.backgroundColor = [UIColor redColor];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.text = @"系统自动将5分钟内的连续胎动去重，记录为1次，每小时胎动3-5次属于正常范围，每天胎动次数在20~30次以上，但胎动的强弱和次数，个体差异很大。";
    [self.view addSubview:_contentLabel];
    
    self.aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 20, 250, 20)];
    _aLabel.backgroundColor = [UIColor yellowColor];
    
    _aLabel.text = [self getLastRecordTimeFromRaw];//从coredata里面取数据
    [self.view addSubview:_aLabel];
    
    self.bLabel = [[UILabel alloc] initWithFrame:CGRectMake(_aLabel.frame.origin.x, _aLabel.frame.origin.y + _aLabel.frame.size.height +10, _aLabel.frame.size.width, _aLabel.frame.size.height)];
    _bLabel.backgroundColor = [UIColor yellowColor];
    _bLabel.text = [self getLastRecordFetalFromRaw];
    [self.view addSubview:_bLabel];
    
    self.aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (IPHONE_5_OR_LATER) {
        _aButton.frame = CGRectMake(60, self.view.frame.size.height - 200, 200, 50);

    }
    else{
        _aButton.frame = CGRectMake(60, self.view.frame.size.height - 110, 200, 50);

    }
    [_aButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    [_aButton setTitle:@"开始记录" forState:UIControlStateNormal];
    [self.view addSubview:_aButton];
    
    
    //折线图
    [self configureBarLine];
}
//开始记录
- (void)startRecord
{
  
        self.recordVC = [[BTRecordFetalView alloc] init];
        _recordVC.view.frame = CGRectMake(0,_contentLabel.frame.origin.y + _contentLabel.frame.size.height, 320, self.view.frame.size.height - _contentLabel.frame.origin.y - _contentLabel.frame.size.height);
        
        if(![_recordVC.timeLabel counting]){
            [_recordVC.timeLabel start];
        }
        
        [self.view addSubview:_recordVC.view];

 
}

#pragma mark - 配置折线图
- (void)configureBarLine
{
    self.arrayLineX = [NSMutableArray arrayWithCapacity:1];
    self.arrayYValue = [NSMutableArray arrayWithCapacity:1];
    
    [self configuerLineXandYValue];//调用此方法 即可更新self.lineXValue和 self.lineYValue
    
   // [self testGetRecentThirtyHoursData];
    self.lineChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _contentLabel.frame.origin.y)];
	//lineChart.backgroundColor = [UIColor clearColor];
//	[lineChart setXLabels:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30"]];
    
    	//[lineChart setXLabels:@[@"4",@"4"]];
     // self.lineYValue = [NSArray arrayWithObjects:[NSString stringWithFormat:@"0"] count:30];
    [_lineChart setXLabels:self.lineXValue];
    [_lineChart setYValues:self.lineYValue];

  //  [lineChart setYValues:@[@"20",@"140",@"130",@"6",@"3",@"8",@"10",@"14",@"19",@"3"]];
    //[lineChart setYValues:@[@"20",@"50"]];
	[_lineChart strokeChart];

	[self.view addSubview:_lineChart];

}
#pragma mark - 收到通知 刷新UI
- (void)updateView:(NSNotification *)notice
{
    NSLog(@"要刷新UI了啊");
    NSString *str = [self getLastRecordTimeFromRaw];
    self.aLabel.text = str;
    self.bLabel.text = [self getLastRecordFetalFromRaw];
    //从coredata中取出数据 上次记录时间
    
    //刷新折线图 重绘
    
    [_lineChart setXLabels:self.lineXValue];
    [_lineChart setYValues:self.lineYValue];
    [_lineChart strokeChart];

}
#pragma mark - 数据处理处理 处理横坐标和纵坐标数据
-(void)configuerLineXandYValue
{
    self.lineXValue = [self getRecentThirtyDaysDateIsCludeMonth:NO];//绘制折线图所需横坐标 Like 3这样的

    NSArray *arrayX = [self getRecentThirtyDaysDateIsCludeMonth:YES];//包含月份的 比如 Like 12-3这样的
    [self getRecentThirtyDaysData];
    
    self.lineYValue = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    for (int j = 0; j <[self.arrayLineX count] ; j++) {
        for (int i = 0; i <30 ; i++) {
            if ([[self.arrayLineX objectAtIndex:j] isEqualToString:[arrayX objectAtIndex:i]]) {
                [self.lineYValue replaceObjectAtIndex:i withObject:[self.arrayYValue objectAtIndex:j]];
                break;
            }
        }
    }
    
    
    
}
#pragma mark - 从coredata中取出数据 上次记录时间
- (NSString *)getLastRecordTimeFromRaw
{
    
 
    BTRawData *raw = [self compareDeviceAndPhoneLastRecordTime];
    if (raw) {
        NSNumber *seconds = raw.seconds1970;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[seconds doubleValue]];
        //分割出小时 分钟
        NSNumber* minute = [BTUtils getMinutes:date];
        NSNumber* hour = [BTUtils getHour:date];
        
        int aHour = [hour intValue] + 1;
        if (aHour >= 24) {
            aHour = aHour - 24;
        }
        NSLog(@"取出最近记录时间  %@",hour);
        
        NSString *hour1 = [NSString stringWithFormat:@"%@",hour];
        NSString *hour2 = [NSString stringWithFormat:@"%d",aHour];
        NSString *minute1 = [NSString stringWithFormat:@"%@",minute];
        
        //当小时 和分钟 是个位数的时候做如下处理
        if ([hour intValue] < 10) {
            hour1 = [NSString stringWithFormat:@"%d%@",0,hour];
        }
        if (aHour < 10) {
            hour2 = [NSString stringWithFormat:@"%d%d",0,aHour];

        }
        
        if ([minute intValue] < 10) {
            minute1 = [NSString stringWithFormat:@"%d%@",0,minute];
        }
        NSString *str = [NSString stringWithFormat:@"上次记录时间:%@:%@-%@:%@",hour1,minute1,hour2,minute1];
        return str;

    }
    
    else{
        return [NSString stringWithFormat:@"上次记录时间:未记录"];
    }

}

#pragma mark - 从coredata中取出数据 根据最后记录时间 取出最后记录的胎动次数
- (NSString *)getLastRecordFetalFromRaw
{
    BTRawData *raw = [self compareDeviceAndPhoneLastRecordTime];
    int aCount = 0;
    NSString *str = nil;
    if (raw) {
        NSNumber *seconds = raw.seconds1970;
        NSNumber *type = nil;
        if ([raw.type isEqual:[NSNumber numberWithInt:DEVICE_START_TIME_TYPE]]) {
            type = [NSNumber numberWithInt:DEVICE_FETAL_TYPE];
        }
        else{
            type = [NSNumber numberWithInt:PHONE_FETAL_TYPE];
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"seconds1970 >= %@ AND type == %@",seconds,type];
        NSArray *rawArray = [BTGetData getFromCoreDataWithPredicate:predicate entityName:@"BTRawData" sortKey:nil];
        if (rawArray.count) {
            for (BTRawData *rawOne in rawArray) {
                aCount = aCount + [rawOne.count intValue];
            }
            str = [NSString stringWithFormat:@"胎动次数:%d次",aCount];
            return str;
        }
        else{
            str = [NSString stringWithFormat:@"胎动次数:0次"];
            return str;
        }
    }
    else{
        str = [NSString stringWithFormat:@"胎动次数:0次"];
        return str;

    }
}

#pragma mark - 比较设备和手机最后记录时间，然后确定最后记录时间的RAW
- (BTRawData *)compareDeviceAndPhoneLastRecordTime
{
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"type == %@",[NSNumber numberWithInt:PHONE_START_TIME_TYPE]];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"type == %@",[NSNumber numberWithInt:DEVICE_START_TIME_TYPE]];
    NSArray *arrayPhone = [BTGetData getFromCoreDataWithPredicate:predicate1 entityName:@"BTRawData" sortKey:nil];
    NSArray *arrayDevice = [BTGetData getFromCoreDataWithPredicate:predicate2 entityName:@"BTRawData" sortKey:nil];

    if (arrayPhone.count == 0 && arrayDevice.count == 0) {
        return nil;
    }
    if (arrayPhone.count == 0 && arrayDevice.count > 0) {
        BTRawData *raw = [arrayDevice lastObject];
        return raw;
    }
    if (arrayPhone.count > 0 && arrayDevice.count == 0) {
        BTRawData *raw = [arrayPhone lastObject];
        return raw;
    }
    if (arrayPhone.count > 0 && arrayDevice.count > 0) {
        BTRawData *raw1 = [arrayPhone lastObject];
        BTRawData *raw2 = [arrayDevice lastObject];
        if (raw1.seconds1970 > raw2.seconds1970) {
            return raw1;
        }
        else{
            return raw2;
        }
    }
    else{
        return nil;
    }
}
#pragma mark - 计算最近30天的日期
- (NSArray *)getRecentThirtyDaysDateIsCludeMonth:(BOOL)cludeMonth
{
    //求出当前月份的天数
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //求出当前年份 月份 日期
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger iCurYear = [components year];  //当前的年份
    NSInteger iCurMonth = [components month];  //当前的月份
    NSInteger iCurDay = [components day];  // 当前的号数
    
    //求出上一个月的天数
    int lastYear = iCurYear;
    int lastMonth = iCurMonth - 1;
    if (lastMonth == 0) {
        lastMonth = 12;
        lastYear = iCurYear -1;
    }
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *dateZone =[dateFormat dateFromString:[NSString stringWithFormat:@"%d-%d-%d",lastYear,lastMonth,1]];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:dateZone];
    NSDate *date1 = [dateZone  dateByAddingTimeInterval: interval];
    
    NSRange rangeLast = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date1];
    NSUInteger lastMonthLength = rangeLast.length;//上一个月的天数

    //array1存放最近30天的号数
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
    if (cludeMonth) {
        for (int i = lastMonthLength - (30 - iCurDay) + 1; i <= lastMonthLength; i++) {
            [array1 addObject:[NSString stringWithFormat:@"%d-%d",lastMonth,i]];
        }
        for (int i = 1; i <= iCurDay; i++) {
            [array1 addObject:[NSString stringWithFormat:@"%d-%d",iCurMonth,i]];
        }
        
        if (lastMonthLength == 28 && iCurDay == 1) {//当2，3月份特殊情况的时候
            [array1 replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d-%d",1,31]];
        }
        
        return array1;

    }
    
    else{
        for (int i = lastMonthLength - (30 - iCurDay) + 1; i <= lastMonthLength; i++) {
            [array1 addObject:[NSString stringWithFormat:@"%d",i]];
        }
        for (int i = 1; i <= iCurDay; i++) {
            [array1 addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        if (lastMonthLength == 28 && iCurDay == 1) {//当2，3月份特殊情况的时候
            [array1 replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",31]];
        }
        
        return array1;

    }
}


#pragma mark - 根据当前时间得出前30天得日期,并得出其距离1970的秒数
- (NSTimeInterval)getThirtyAgoDateByCurrentTime
{
    //获取当前时间
    NSDate* date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];

    NSTimeInterval secondsThirtyDays =30 * 24 * 60 * 60;
    NSDate *date2 =  [[NSDate alloc] initWithTimeInterval:-secondsThirtyDays sinceDate:localeDate];
    
    int hour = [[BTUtils getHour:localeDate] intValue];
    int minute = [[BTUtils getMinutes:localeDate] intValue];
    NSTimeInterval seconds = [date2 timeIntervalSince1970] - (hour * 60 *60 + minute * 60);
    return seconds;
}
#pragma mark - 得到最近30天的数据
/*思路：1：先得到30天前那一天的日期（距离1970年的秒数 也可以）
 2：从coredata中遍历手机和设备存储 得到记录胎动开始时间的数组 （是未排序 未去重的）
 3：对2得到的数组进行排序和去重操作
 4：3得到的数组就是记录胎动的开始时间，但是它是精确到分钟的  所以要处理 得到精确到每天的一个数组
 5：然后就是将3的到的数组的每个元素转化成NSdate类型的 分割出年 月 日  然后在将年 月 日 转化成1970秒数 存放到一个数组中
 6：5得到的数组显然又是未排序 未去重的 进行排序和去重操作  存放到数组中
 7：6得到的数组是5的数组排序和去重之后的数组   将6的每个元素分别在5中遍历  记录出现的次数 放到数组中  这样存放的就是每一天完整记录胎动的次数
 8：将6的元素再转化为NSdate的类型
 9：根据天在coredata中找出每天记录的胎动次数
 */
- (void)getRecentThirtyDaysData
{
    NSNumber *seconds = [NSNumber numberWithDouble:[self getThirtyAgoDateByCurrentTime]];//取出距离现在30天得日期距离1970年的秒数
    //对手机存储的胎动 和 设备存储的胎动记录时间分别遍历
    NSPredicate *predicatePhone = [NSPredicate predicateWithFormat:@"seconds1970 > %@ AND type == %@",seconds,[NSNumber numberWithDouble:PHONE_START_TIME_TYPE]];
    NSPredicate *predicateDevice = [NSPredicate predicateWithFormat:@"seconds1970 > %@ AND type == %@",seconds,[NSNumber numberWithDouble:DEVICE_START_TIME_TYPE]];
    //取出记录时间数组
    NSArray *rawArrayPhone = [BTGetData getFromCoreDataWithPredicate:predicatePhone entityName:@"BTRawData" sortKey:nil];//取出记录时间数组
    NSArray *rawArrayDevice = [BTGetData getFromCoreDataWithPredicate:predicateDevice entityName:@"BTRawData" sortKey:nil];
    NSLog(@"..........%@",rawArrayPhone);
    NSMutableArray *arrayOringe = [NSMutableArray arrayWithCapacity:1];//将开始记录胎动的原始时间存放在这个数组
    NSMutableArray *arrayPerDay = [NSMutableArray arrayWithCapacity:1];//存放每天距离1970年的秒数  未排序 未去重
    NSMutableArray *arrayCount = [NSMutableArray arrayWithCapacity:1];//存放每一天有记录了几次胎动
    for (BTRawData *raw in rawArrayPhone) {
        [arrayOringe addObject:raw.seconds1970];
    }
    
    for (BTRawData *raw in rawArrayDevice) {
        [arrayOringe addObject:raw.seconds1970];
    }
    NSLog(@",,,,,,,,,%@",arrayOringe);
    //对数组进行去重操作
    NSSet *set = [NSSet setWithArray:arrayOringe];
    NSArray *array2 = [set allObjects];
    //然后对数组进行升序排序
    NSArray *arrayX = [array2 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 doubleValue] > [obj2 doubleValue]) {
            
            return (NSComparisonResult)NSOrderedDescending;
            
        }
        
        if ([obj1 doubleValue] < [obj2 doubleValue]) {
            
            return (NSComparisonResult)NSOrderedAscending;
            
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    //现在arrayX是排序之后的数组 存放记录开始时间 秒数
    //根据秒数 求出日期
    NSLog(@"=========%@",arrayX);
    for (NSNumber *num in arrayX) {
        NSDate *date =  [NSDate dateWithTimeIntervalSince1970:[num doubleValue]];
        NSNumber *year = [BTUtils getYear:date];
        NSNumber *month = [BTUtils getMonth:date];
        NSNumber *day = [BTUtils getDay:date];
        NSLog(@"++++++++%@ %@ %@",year,month,day);
        //单取年月日 计算距离1970年的秒数
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
        [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *dateZone =[dateFormat dateFromString:[NSString stringWithFormat:@"%@-%@-%@",year,month,day]];
        
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *date1 = [dateZone  dateByAddingTimeInterval: interval];

        NSLog(@"^^^^^^^^^^%@",date1);
        NSTimeInterval seconds = [date1 timeIntervalSince1970];
        [arrayPerDay addObject:[NSNumber numberWithDouble:seconds]];
        //只要年月日
    }
    NSLog(@"￥￥￥￥￥￥￥%@",arrayPerDay);
    //现在arrayPerDay中存放的就是开始记录的天 距离1970年的秒数
    //要找出每天出现的次数
    int count = 0;
    NSArray *arrayQu = [[NSSet setWithArray:arrayPerDay] allObjects];//去重之后的数组
    //然后再排序
    //array3存放的即是每天距离1970年的秒数  并且是去重 排序过后的
    NSArray *array3 = [arrayQu sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 doubleValue] > [obj2 doubleValue]) {
            
            return (NSComparisonResult)NSOrderedDescending;
            
        }
        
        if ([obj1 doubleValue] < [obj2 doubleValue]) {
            
            return (NSComparisonResult)NSOrderedAscending;
            
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];

    for (int i = 0; i < [array3 count]; i++) {
        for (NSNumber *num in arrayPerDay) {
            if ([[array3 objectAtIndex:i] isEqual:num]) {
                count++;
            }
        }
        [arrayCount addObject:[NSNumber numberWithInt:count]];
        count = 0;
    }
    
    NSLog(@"&&&&&&&&&%@",array3);
    //循环玩之后 arrayCount村放得就是每天出现的次数
    //array3 和 arrayCount一一对应
    //再此将 array3里面的转化为 年 月 日的形式
    for (int i = 0; i < [array3 count]; i++) {
        NSNumber *num = [array3 objectAtIndex:i];
        NSDate *date =  [NSDate dateWithTimeIntervalSince1970:[num doubleValue]];
       // NSNumber *year = [BTUtils getYear:date];
        NSNumber *month = [BTUtils getMonth:date];
        NSNumber *day = [BTUtils getDay:date];
        [self.arrayLineX addObject:[NSString stringWithFormat:@"%@-%@",month,day]];
        
        NSLog(@"!!!!!!!!!%@",self.arrayLineX);
        NSNumber *num1 = [self getYlabelByMonth:month AndDay:day];
        NSNumber *num2 = [arrayCount objectAtIndex:i];
        int countTotal = [num1 intValue]/[num2 intValue]*12;
        [self.arrayYValue addObject:[NSString stringWithFormat:@"%d",countTotal]];
        NSLog(@"########%@",self.arrayYValue);
    }
      //要分别在手机记录和手环记录之间取数据
    
}
-(NSNumber *)getYlabelByMonth:(NSNumber *)month AndDay:(NSNumber *)day
{
    NSPredicate *predicatePhone = [NSPredicate predicateWithFormat:@"month == %@ AND day == %@ AND type == %@",month,day,[NSNumber numberWithDouble:PHONE_FETAL_TYPE]];
    NSPredicate *predicateDevice = [NSPredicate predicateWithFormat:@"month == %@ AND day == %@ AND type == %@",month,day,[NSNumber numberWithDouble:DEVICE_FETAL_TYPE]];
    //取出记录时间数组
    NSArray *rawArrayPhone = [BTGetData getFromCoreDataWithPredicate:predicatePhone entityName:@"BTRawData" sortKey:nil];//取出记录时间数组
    NSArray *rawArrayDevice = [BTGetData getFromCoreDataWithPredicate:predicateDevice entityName:@"BTRawData" sortKey:nil];
    int count = 0;
    for (BTRawData *raw in rawArrayPhone) {
        count = count + [raw.count intValue];
    }
    
    for (BTRawData *raw in rawArrayDevice) {
        count = count + [raw.count intValue];

    }

    return [NSNumber numberWithInt:count];
}

#pragma mark - 胎动折线图测试用以下方法 -----------------------

#pragma mark - 根据当前时间得出前30小时得日期,并得出其距离1970的秒数
- (NSTimeInterval)testGetThirtyHoursAgoDateByCurrentTime
{
    //获取当前时间
    NSDate* date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSTimeInterval secondsThirtyDays =30 * 60 * 60;
    NSDate *date2 =  [[NSDate alloc] initWithTimeInterval:-secondsThirtyDays sinceDate:localeDate];
    
//    int hour = [[BTUtils getHour:localeDate] intValue];
//    int minute = [[BTUtils getMinutes:localeDate] intValue];
    NSTimeInterval seconds = [date2 timeIntervalSince1970];
    return seconds;
}
#pragma mark - 得到最近30天的数据
- (void)testGetRecentThirtyHoursData
{
    NSNumber *seconds = [NSNumber numberWithDouble:[self getThirtyAgoDateByCurrentTime]];//取出距离现在30天得日期距离1970年的秒数
    NSPredicate *predicatePhone = [NSPredicate predicateWithFormat:@"seconds1970 > %@ AND type == %@",seconds,[NSNumber numberWithDouble:PHONE_START_TIME_TYPE]];
    NSPredicate *predicateDevice = [NSPredicate predicateWithFormat:@"seconds1970 > %@ AND type == %@",seconds,[NSNumber numberWithDouble:DEVICE_START_TIME_TYPE]];
    //取出记录时间数组
    NSArray *rawArrayPhone = [BTGetData getFromCoreDataWithPredicate:predicatePhone entityName:@"BTRawData" sortKey:nil];//取出记录时间数组
    NSArray *rawArrayDevice = [BTGetData getFromCoreDataWithPredicate:predicateDevice entityName:@"BTRawData" sortKey:nil];
    NSLog(@"..........%@",rawArrayPhone);
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *arrayD = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *arrayCount = [NSMutableArray arrayWithCapacity:1];
    for (BTRawData *raw in rawArrayPhone) {
        [array1 addObject:raw.seconds1970];
    }
    
    for (BTRawData *raw in rawArrayDevice) {
        [array1 addObject:raw.seconds1970];
    }
    NSLog(@",,,,,,,,,%@",array1);
    //对数组进行去重操作
    NSSet *set = [NSSet setWithArray:array1];
    NSArray *array2 = [set allObjects];
    //然后对数组进行升序排序
    NSArray *arrayX = [array2 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 doubleValue] > [obj2 doubleValue]) {
            
            return (NSComparisonResult)NSOrderedDescending;
            
        }
        
        if ([obj1 doubleValue] < [obj2 doubleValue]) {
            
            return (NSComparisonResult)NSOrderedAscending;
            
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    //现在arrayX是排序之后的数组 存放记录开始时间 秒数
    //根据秒数 求出日期
    NSLog(@"=========%@",arrayX);
    for (NSNumber *num in arrayX) {
        NSDate *date =  [NSDate dateWithTimeIntervalSince1970:[num doubleValue]];
        NSNumber *year = [BTUtils getYear:date];
        NSNumber *month = [BTUtils getMonth:date];
        NSNumber *day = [BTUtils getDay:date];
        NSNumber *hour = [BTUtils getHour:date];
        NSLog(@"++++++++%@ %@ %@ %@",year,month,day,hour);
        //单取年月日 计算距离1970年的秒数
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH"];//设定时间格式,这里可以设置成自己需要的格式
        [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *dateZone =[dateFormat dateFromString:[NSString stringWithFormat:@"%@-%@-%@ %@",year,month,day,hour]];
        
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *date1 = [dateZone  dateByAddingTimeInterval: interval];
        
        NSLog(@"^^^^^^^^^^%@",date1);
        NSTimeInterval seconds = [date1 timeIntervalSince1970];
        [arrayD addObject:[NSNumber numberWithDouble:seconds]];
        //只要年月日
    }
    NSLog(@"￥￥￥￥￥￥￥%@",arrayD);
    //现在arrayD中存放的就是开始记录的小时 距离1970年的秒数
    //要找出每天出现的次数
    int count = 0;
    NSArray *arrayQu = [[NSSet setWithArray:arrayD] allObjects];//去重之后的数组
    //然后再排序
    NSArray *array3 = [arrayQu sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 doubleValue] > [obj2 doubleValue]) {
            
            return (NSComparisonResult)NSOrderedDescending;
            
        }
        
        if ([obj1 doubleValue] < [obj2 doubleValue]) {
            
            return (NSComparisonResult)NSOrderedAscending;
            
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];

    for (int i = 0; i < [array3 count]; i++) {
        for (NSNumber *num in arrayD) {
            if ([[array3 objectAtIndex:i] isEqual:num]) {
                count++;
            }
        }
        [arrayCount addObject:[NSNumber numberWithInt:count]];
        count = 0;
    }
    
    NSLog(@"&&&&&&&&&%@",array3);
    NSLog(@"&&&&&&&&&%@",arrayCount);
    //array3是经过去重和排序的数组
    //循环玩之后 arrayCount村放得就是每天出现的次数
    //array3 和 arrayCount一一对应
    //再此将 array3里面的转化为 年 月 日的形式
    for (int i = 0; i < [array3 count]; i++) {
        NSNumber *num = [array3 objectAtIndex:i];
        NSDate *date =  [NSDate dateWithTimeIntervalSince1970:[num doubleValue]];
       // NSNumber *year = [BTUtils getYear:date];
       // NSNumber *month = [BTUtils getYear:date];
        NSNumber *day = [BTUtils getDay:date];
        NSNumber *hour = [BTUtils getHour:date];
        [self.arrayLineX addObject:[NSString stringWithFormat:@"%@",hour]];
        
        NSLog(@"!!!!!!!!!%@",self.arrayLineX);
        NSNumber *num1 = [self getYlabelByDay:day AndHour:hour];
        NSNumber *num2 = [arrayCount objectAtIndex:i];
        int countTotal = [num1 intValue]/[num2 intValue]*12;
        [self.arrayYValue addObject:[NSString stringWithFormat:@"%d",countTotal]];
        NSLog(@"########%@",self.arrayYValue);
    }
    //要分别在手机记录和手环记录之间取数据
    
}
-(NSNumber *)getYlabelByDay:(NSNumber *)day AndHour:(NSNumber *)hour
{
    NSPredicate *predicatePhone = [NSPredicate predicateWithFormat:@"day == %@ AND hour == %@ AND type == %@",day,hour,[NSNumber numberWithDouble:PHONE_FETAL_TYPE]];
    NSPredicate *predicateDevice = [NSPredicate predicateWithFormat:@"day == %@ AND hour == %@ AND type == %@",day,hour,[NSNumber numberWithDouble:DEVICE_FETAL_TYPE]];
    //取出记录时间数组
    NSArray *rawArrayPhone = [BTGetData getFromCoreDataWithPredicate:predicatePhone entityName:@"BTRawData" sortKey:nil];//取出记录时间数组
    NSArray *rawArrayDevice = [BTGetData getFromCoreDataWithPredicate:predicateDevice entityName:@"BTRawData" sortKey:nil];
    int count = 0;
    for (BTRawData *raw in rawArrayPhone) {
        count = count + [raw.count intValue];
    }
    
    for (BTRawData *raw in rawArrayDevice) {
        count = count + [raw.count intValue];
        
    }
    
    return [NSNumber numberWithInt:count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    //如果正在记录胎动的时候 退出页面 停止计时器
    if (self.recordVC.timeLabel.counting) {
        [self.recordVC.timeLabel pause];
    }

    NSLog(@"1走了dealloc");
}
@end
