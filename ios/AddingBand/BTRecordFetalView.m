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
#define kAlabelX 10
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
    self.view.backgroundColor = [UIColor blueColor];
    [self createSubviews];
	// Do any additional setup after loading the view.
}
- (void)createSubviews
{
    [self getLocalTime];//取出现在的时间
    //现在就往coredata里写一条数据  开始记录时间
    [self writeToCoredataWithFetalType:[NSNumber numberWithInt:PHONE_START_TIME_TYPE]];
    //开始时间
    self.aLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAlabelX, kAlabelY, kAlabelWidth, kAlabelHeight)];
    _aLabel.backgroundColor = [UIColor yellowColor];
    //显示的时候做下处理
    NSString *hour1 = [NSString stringWithFormat:@"%@",self.aHour];
    NSString *minute1 = [NSString stringWithFormat:@"%@",self.aMinute];
    
    //当小时 和分钟 是个位数的时候做如下处理
    if ([self.aHour intValue] < 10) {
        hour1 = [NSString stringWithFormat:@"%d%@",0,self.aHour];
    }
    if ([self.aMinute intValue] < 10) {
        minute1 = [NSString stringWithFormat:@"%d%@",0,self.aMinute];
        
    }
    
    _aLabel.text = [NSString stringWithFormat:@"开始时间:%@:%@",hour1,minute1];
    [self.view addSubview:_aLabel];
    
    //记录间隔
    self.bLabel = [[UILabel alloc] initWithFrame:CGRectMake(_aLabel.frame.origin.x, _aLabel.frame.origin.y + _aLabel.frame.size.height +10, _aLabel.frame.size.width, _aLabel.frame.size.height)];
    _bLabel.backgroundColor = [UIColor yellowColor];
    _bLabel.text = @"记录间隔:60分钟";
    [self.view addSubview:_bLabel];
    //倒计时
    self.cLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAlabelX + kAlabelWidth + 10, kAlabelY, 75, kAlabelHeight)];
    _cLabel.backgroundColor = [UIColor yellowColor];
    _cLabel.text = @"剩余时间:";
    [self.view addSubview:_cLabel];
    
    //此处为倒计时label
    self.timeLabel = [[BTTimerLabel alloc] initWithTimerType:BTTimerLabelTypeTimer];
    _timeLabel.frame = CGRectMake(_cLabel.frame.origin.x + _cLabel.frame.size.width, _cLabel.frame.origin.y, _cLabel.frame.size.width, kAlabelHeight);
    _timeLabel.backgroundColor = [UIColor redColor];
    [self.timeLabel setCountDownTime:20];
    _timeLabel.delegate = self;
    [self.view addSubview:_timeLabel];
    
    
    //胎动次数
    self.dLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cLabel.frame.origin.x, _bLabel.frame.origin.y,_cLabel.frame.size.width + 50, kAlabelHeight)];
    _dLabel.backgroundColor = [UIColor yellowColor];
    _dLabel.text = @"胎动次数:0次";
    [self.view addSubview:_dLabel];
    
    
    
    
    
    self.aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _aButton.frame = CGRectMake(30, 80, 260, 50);
    [_aButton addTarget:self action:@selector(oneceTap) forControlEvents:UIControlEventTouchUpInside];
    [_aButton setTitle:@"感觉到胎动时,点击这里" forState:UIControlStateNormal];
    [self.view addSubview:_aButton];
    
}
#pragma mark - 点击记录胎动
- (void)oneceTap
{
    [self getLocalTime];//得出当前时间
    
    double nowDate = [[NSDate date] timeIntervalSince1970];
    
    if ([self isBeyondFiveMinutes:nowDate]) {
        _dLabel.text = [NSString stringWithFormat:@"胎动次数:%d次",++fetalCount];
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
