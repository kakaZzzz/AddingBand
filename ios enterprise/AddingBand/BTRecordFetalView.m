//
//  BTRecordFetalView.m
//  AddingBand
//
//  Created by wangpeng on 13-12-2.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTRecordFetalView.h"
#import "BTTimerLabel.h"
#import "BTUtils.h"
#import "BTRawData.h"
#import "BTGetData.h"
#import "LayoutDef.h"
#define kAlabelX 20
#define kAlabelY 20
#define kAlabelWidth 150
#define kAlabelHeight 20
static int fetalCount = 0;//胎动次数
//static int recordCount = 0;//记录次数
static int comHour = 0;
static int comMinute = 0;
@interface BTRecordFetalView ()
@property(nonatomic,strong)NSNumber *aYear;
@property(nonatomic,strong)NSNumber *aMonth;
@property(nonatomic,strong)NSNumber *aDay;
@property(nonatomic,strong)NSNumber *aHour;
@property(nonatomic,strong)NSNumber *aMinute;
@property(nonatomic,strong)NSNumber *aSeconds;
@end

@implementation BTRecordFetalView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)getLocalTime
{
    
    //获取当前时间
    NSDate* date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"localeDate211==%@", localeDate);
    
    //分割出年月日小时
    NSNumber* year = [BTUtils getYear:localeDate];
    NSNumber* month = [BTUtils getMonth:localeDate];
    NSNumber* day = [BTUtils getDay:localeDate];
    NSNumber* hour = [BTUtils getHour:localeDate];
    NSNumber* minute = [BTUtils getMinutes:localeDate];
    NSTimeInterval seconds = [localeDate timeIntervalSince1970];//当前时间距离1970年的秒数
  
    self.aYear = year;
    self.aMonth = month;
    self.aDay = day;
    self.aHour = hour;
    self.aMinute = minute;
    self.aSeconds = [NSNumber numberWithDouble:seconds];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubviews];
	// Do any additional setup after loading the view.
}
- (void)createSubviews
{
    [self getLocalTime];//取出现在的时间
    //现在就往coredata里写一条数据  开始记录时间
    [self writeToCoredataWithFetalType:[NSNumber numberWithInt:PHONE_START_TIME_TYPE]];
    
    //倒计时
    self.countTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAlabelX, kAlabelY, kAlabelWidth, kAlabelHeight)];
    //_cLabel.backgroundColor = [UIColor yellowColor];
    _countTitleLabel.textColor = kBigTextColor;
    _countTitleLabel.font = [UIFont systemFontOfSize:17];

    _countTitleLabel.text = @"倒计时:";
    [self.view addSubview:_countTitleLabel];

    //开始时间
    self.startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAlabelX, _countTitleLabel.frame.origin.y + _countTitleLabel.frame.size.height, kAlabelWidth, kAlabelHeight)];
    //_aLabel.backgroundColor = [UIColor yellowColor];
    _startTimeLabel.textColor = kBigTextColor;
    //显示的时候做下处理
    NSString *hour1 = [NSString stringWithFormat:@"%@",self.aHour];
    NSString *minute1 = [NSString stringWithFormat:@"%@",self.aMinute];
    
    
    int aHour = [hour1 intValue] + 1;
    if (aHour >= 24) {
        aHour = aHour - 24;
    }
   NSString *hour2 = [NSString stringWithFormat:@"%d",aHour];
    //当小时 和分钟 是个位数的时候做如下处理
    if ([self.aHour intValue] < 10) {
        hour1 = [NSString stringWithFormat:@"%d%@",0,self.aHour];
    }
    if (aHour < 10) {
        hour2 = [NSString stringWithFormat:@"%d%d",0,aHour];
        
    }

    if ([self.aMinute intValue] < 10) {
        minute1 = [NSString stringWithFormat:@"%d%@",0,self.aMinute];
        
    }
    
    _startTimeLabel.text = [NSString stringWithFormat:@"%@:%@-%@:%@",hour1,minute1,hour2,minute1];
    [self.view addSubview:_startTimeLabel];
    
    
    
    
    
    
    //此处为倒计时label
    self.timeLabel = [[BTTimerLabel alloc] initWithTimerType:BTTimerLabelTypeTimer];
    _timeLabel.frame = CGRectMake(_countTitleLabel.frame.origin.x + _countTitleLabel.frame.size.width, _countTitleLabel.frame.origin.y - 20, _countTitleLabel.frame.size.width, kAlabelHeight + 50);
   // _timeLabel.backgroundColor = [UIColor redColor];
    _timeLabel.font = [UIFont systemFontOfSize:62];
    _timeLabel.textColor = kGlobalColor;

    [self.timeLabel setCountDownTime:20];
    _timeLabel.delegate = self;
    [self.view addSubview:_timeLabel];
    
    
    
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (IPHONE_5_OR_LATER) {
        _recordButton.frame = CGRectMake((320 - 152)/2, 90, 152, 152);
       
    }
    else{
        _recordButton.frame = CGRectMake((320 - 110)/2, 60, 110, 110);
        
    }

    [_recordButton addTarget:self action:@selector(oneceTap) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"fetal_record_unsel@2x"] forState:UIControlStateNormal];
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"fetal_record_sel@2x"] forState:UIControlStateSelected];
    [self.view addSubview:_recordButton];
    
    //胎动次数
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(_countTitleLabel.frame.origin.x -30, _countTitleLabel.frame.origin.y,80, kAlabelHeight + 50)];
    _countLabel.center = _recordButton.center;
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.font = [UIFont systemFontOfSize:62];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.text = @"0";
    [self.view addSubview:_countLabel];

    UILabel *fetalCount = [[UILabel alloc] initWithFrame:CGRectMake(_countLabel.frame.origin.x + _countLabel.frame.size.width - 11, _countLabel.frame.origin.y + 35, 50, 25)];
    fetalCount.font = [UIFont systemFontOfSize:17];
    fetalCount.backgroundColor = [UIColor clearColor];
    fetalCount.textColor =[UIColor whiteColor];
    fetalCount.text = @"次";
    [self.view addSubview:fetalCount];

}
#pragma mark - 点击记录胎动
- (void)oneceTap
{
    [self getLocalTime];//得出当前时间
    
   double nowDate = [[NSDate date] timeIntervalSince1970];
    
   if ([self isBeyondFiveMinutes:nowDate]) {
        _countLabel.text = [NSString stringWithFormat:@"%d",++fetalCount];
        //往coredata里存一条数据
        [self writeToCoredataWithFetalType:[NSNumber numberWithInt:PHONE_FETAL_TYPE]];
    }
    
    comHour = [self.aHour intValue];
    comMinute = [self.aMinute intValue];
}
#pragma mark - 5分钟去重 

static double lastDate = 0;
-(BOOL)isBeyondFiveMinutes:(double)now
{
    //测试用的5秒钟
    if ((now - lastDate) > 5.0) {
        lastDate = now;
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark - 往coredata里面写入数据
- (void)writeToCoredataWithFetalType:(NSNumber *)aType
{
    //设置coredatatype
    _context = [BTGetData getAppContex];
    //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND hour == %@ AND minute == %@ AND seconds1970 == %@ AND type == %@",self.aYear, self.aMonth, self.aDay,self.aHour,self.aMinute,self.aSeconds, aType];
    NSError *error;
    NSArray *rawArray = [BTGetData getFromCoreDataWithPredicate:predicate entityName:@"BTRawData" sortKey:nil];
    
    if (rawArray.count == 1) {
        
        //已经有条目了
        //进行coredata的更改数据操作
        BTRawData* one = [rawArray objectAtIndex:0];
        
        NSLog(@"ther is %@", one.count);
        
        one.count = [NSNumber numberWithInt:[one.count intValue] + 1];
        // one.recordCount = [NSNumber numberWithInt:([one.recordCount intValue] + 1)];//在一天里记录的次数
        NSLog(@"ther is %@", one.count);
      //  NSLog(@"记录次数 %@", one.recordCount);
    }else if(rawArray.count == 0){
        
        //木有啊,就新建一条  进行coredata的插入数据操作
        
        NSLog(@"there no");
        
        BTRawData* new = [NSEntityDescription insertNewObjectForEntityForName:@"BTRawData" inManagedObjectContext:_context];
        
        new.year = self.aYear;
        new.month = self.aMonth;
        new.day = self.aDay;
        new.hour = self.aHour;
        new.minute = self.aMinute;
        new.type = aType;
        new.count = [NSNumber numberWithInt:1];
        new.seconds1970 = self.aSeconds;
        // new.from = peripheral.name;
        // new.recordCount = [NSNumber numberWithInt:1];
        NSLog(@"存进去的记录开始时间是  %@",self.aHour);
    }
    
    [_context save:&error];
    // 及时保存
    if(![_context save:&error]){
        NSLog(@"%@", [error localizedDescription]);
    }
    
}
#pragma mark - 时间到了之后
-(void)timerLabel:(BTTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{
    //弹出提醒框
    UIAlertView *aLart = [[UIAlertView alloc] initWithTitle:@"时间到了亲" message:[NSString stringWithFormat:@"您本次记录胎动%d次",fetalCount] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [aLart show];
    
    
}
#pragma mark - 点击提醒框 移除记录胎动页面
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    fetalCount = 0;//胎动次数重新置0
    comHour = 0;
    comMinute = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:FETALVIEWUPDATENOTICE object:nil userInfo:nil];
    [self.view removeFromSuperview];//移除记录胎动页面
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLog(@"2走了dealloc");
}
@end
