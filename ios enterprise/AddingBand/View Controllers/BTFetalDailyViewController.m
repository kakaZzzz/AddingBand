//
//  BTFetalDailyViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-12.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTFetalDailyViewController.h"
#import "BTRecordFetalView.h"//开始记录页面
#import "PNChart.h"//折线图
#import "BTUtils.h"
#import "LayoutDef.h"
#import "BTRawData.h"
#import "BTGetData.h"
#import "NSDate+DateHelper.h"
#import "BTUserSetting.h"

#define klineScrollViewX 0
#define klineScrollViewY 80/2
#define klineScrollViewWidth 320
#define klineScrollViewHeight 200

#define klineScrollViewContentSizeX (320 *2 + 30)
static int offsetX = 0;
@interface BTFetalDailyViewController ()
@property(nonatomic,strong)UIButton *previousButton;
@property(nonatomic,strong)UIButton *nextButton;
@property(nonatomic,strong)UILabel *titleDateLabel;
@property(nonatomic,strong)NSDate *currentDate;//调节中 日期

@end

@implementation BTFetalDailyViewController

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
    [self addPreviousAndNextButton];
	// Do any additional setup after loading the view.
}
- (void)createSubviews
{
    
    //绘制当天的折线图
    NSDate *date = [NSDate localdate];
    [self getBarXValueWithDate:date];
    [self getEveryHourDataWithDate:date];
    [self configureLineAndBarWithData];//配置折线图 和 柱状的遮盖层
    
    
    
    self.fetalConditionTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, _lineScrollView.frame.origin.y + _lineScrollView.frame.size.height + 20, 250, 20)];
    _fetalConditionTitle.textColor = kBigTextColor;
    _fetalConditionTitle.font = [UIFont systemFontOfSize:17];
    _fetalConditionTitle.text = @"上次记录胎动情况:";
    [self.view addSubview:_fetalConditionTitle];
    
    //上次记录时间
    self.lastTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _fetalConditionTitle.frame.origin.y + _fetalConditionTitle.frame.size.height , 150, 30)];
    _lastTimeLabel.font = [UIFont fontWithName:kCharacterAndNumberFont size:20.0];
    _lastTimeLabel.textAlignment = NSTextAlignmentLeft;
    _lastTimeLabel.backgroundColor = [UIColor clearColor];
    _lastTimeLabel.textColor = kBigTextColor;
    _lastTimeLabel.text = [self getLastRecordTimeFromRaw];//从coredata里面取数据
    [self.view addSubview:_lastTimeLabel];
    
    //次数
    self.lastCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_lastTimeLabel.frame.origin.x + _lastTimeLabel.frame.size.width +15, _lastTimeLabel.frame.origin.y - 20, 100, 50)];
    _lastCountLabel.textAlignment = NSTextAlignmentRight;
    _lastCountLabel.font = [UIFont systemFontOfSize:62];
    _lastCountLabel.textColor = kGlobalColor;
    // _bLabel.backgroundColor = [UIColor yellowColor];
    _lastCountLabel.text = [self getLastRecordFetalFromRaw];
    [self.view addSubview:_lastCountLabel];
    
    UILabel *fetalCount = [[UILabel alloc] initWithFrame:CGRectMake(_lastCountLabel.frame.origin.x + _lastCountLabel.frame.size.width, _lastCountLabel.frame.origin.y + 25, 50, 25)];
    fetalCount.font = [UIFont systemFontOfSize:17];
    fetalCount.textColor =kBigTextColor;
    fetalCount.text = @"次";
    [self.view addSubview:fetalCount];
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IPHONE_5_OR_LATER) {
        _startButton.frame = CGRectMake((320 - 152)/2, self.view.frame.size.height - 238, 152, 152);
        
    }
    else{
        _startButton.frame = CGRectMake((320 - 110)/2, self.view.frame.size.height - 160, 110, 110);
        
    }
    [_startButton setBackgroundImage:[UIImage imageNamed:@"fetal_record_unsel@2x"] forState:UIControlStateNormal];
    [_startButton setBackgroundImage:[UIImage imageNamed:@"fetal_record_sel@2x"] forState:UIControlStateSelected];
    [_startButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    [_startButton setTitle:@"开始记录" forState:UIControlStateNormal];
    [self.view addSubview:_startButton];
    
    
}


//开始记录
- (void)startRecord
{
    
    self.recordVC = [[BTRecordFetalView alloc] init];
    _recordVC.view.frame = CGRectMake(0,_lineScrollView.frame.origin.y + _lineScrollView.frame.size.height, 320, self.view.frame.size.height - _lineScrollView.frame.origin.y - _lineScrollView.frame.size.height);
    
    if(![_recordVC.timeLabel counting]){
        [_recordVC.timeLabel start];
    }
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view addSubview:_recordVC.view];
        
    } completion:nil];
    
    
}
#pragma mark - 收到通知 刷新UI
- (void)updateView:(NSNotification *)notice
{
    NSLog(@"要刷新UI了啊");
    
    self.lastTimeLabel.text = [self getLastRecordTimeFromRaw];
    self.lastCountLabel.text = [self getLastRecordFetalFromRaw];
    //从coredata中取出数据 上次记录时间
    
    
    //现在的处理方法很屌丝 要优化
    [_lineScrollView removeFromSuperview];
    
  
    [self updateChartViewWithDate:[NSDate localdate]];
    //柱状图重绘
    
    // [self getBarXValue];
    
}
#pragma mark - 添加左右查看历史按钮
- (void)addPreviousAndNextButton
{
    
    
    UIView *redBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, klineScrollViewY)];
    redBgView.backgroundColor = kRedColor;
    [self.scrollView addSubview:redBgView];
    
    self.previousButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (redBgView.frame.size.height - 70/2)/2, 70/2, 70/2)];
    //  _previousButton.backgroundColor = [UIColor yellowColor];
    [_previousButton setBackgroundImage:[UIImage imageNamed:@"left_indicate_button"] forState:UIControlStateNormal];
    [_previousButton addTarget:self action:@selector(previousStage:) forControlEvents:UIControlEventTouchUpInside];
    [redBgView addSubview:_previousButton];
    
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(320 - 70/2, (redBgView.frame.size.height - 70/2)/2, 70/2, 70/2)];
    //  _nextButton.backgroundColor = [UIColor yellowColor];
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"right_nonindicate_button"] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextStage:) forControlEvents:UIControlEventTouchUpInside];
    [redBgView addSubview:_nextButton];
    
    self.titleDateLabel = [[UILabel alloc] initWithFrame:CGRectMake((320 - 200)/2 , (redBgView.frame.size.height - 30)/2, 200, 30)];
    _titleDateLabel.backgroundColor = [UIColor clearColor];
    _titleDateLabel.textColor = [UIColor whiteColor];
    _titleDateLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    _titleDateLabel.textAlignment = NSTextAlignmentCenter;
    _titleDateLabel.text = @"2013-12-24";
    [redBgView addSubview:_titleDateLabel];
    
    
}

- (void)previousStage:(UIButton *)button
{
    //末次月经是分界线
    NSDate *menstruationDate = nil;
    NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    if (data.count > 0) {
        BTUserSetting *userData = [data objectAtIndex:0];
        menstruationDate = [NSDate dateFromString:userData.menstruation withFormat:@"yyyy.MM.dd"];//duedate为00：00：00
    }
    
    if (!_currentDate) {
        _currentDate = [NSDate localdate];
        
    }

    
    if (![NSDate isAscendingWithOnedate:[_currentDate addDay:-1] anotherdate:menstruationDate]) {
        _currentDate = [_currentDate addDay:-1];
        
        NSNumber *year = [BTUtils getYear:_currentDate];
        NSNumber *month = [BTUtils getMonth:_currentDate];
        NSNumber *day = [BTUtils getDay:_currentDate];
        self.titleDateLabel.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        
        [self updateChartViewWithDate:_currentDate];
        [self changePreviousAndNextButtonBackgroundImage];
        
    }
    else{
        //改变按钮的背景图
        [_previousButton setBackgroundImage:[UIImage imageNamed:@"left_nonindicate_button"] forState:UIControlStateNormal];
        
    }
}


- (void)nextStage:(UIButton *)button
{
    
    if (!_currentDate) {
        _currentDate = [NSDate localdate];
        
    }

    if ([NSDate isAscendingWithOnedate:_currentDate anotherdate:[NSDate localdate]]) {
        _currentDate = [_currentDate addDay:1];
        
        NSNumber *year = [BTUtils getYear:_currentDate];
        NSNumber *month = [BTUtils getMonth:_currentDate];
        NSNumber *day = [BTUtils getDay:_currentDate];
        //然后确定是哪个viewController 然后调用暴露出来的更行接口
        
        self.titleDateLabel.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        
        [self updateChartViewWithDate:_currentDate];
        [self changePreviousAndNextButtonBackgroundImage];
    }
    else{
        //改变按钮的背景图
        [_nextButton setBackgroundImage:[UIImage imageNamed:@"right_nonindicate_button"] forState:UIControlStateNormal];
    }
    
}

- (void)updateChartViewWithDate:(NSDate *)date
{
    if (_lineScrollView) {
        offsetX = 0;
        [_lineScrollView removeFromSuperview];
        [self getBarXValueWithDate:date];
        [self getEveryHourDataWithDate:date];
        [self configureLineAndBarWithData];
    }

}
#pragma mark - 随时调整左右箭头的背景
- (void)changePreviousAndNextButtonBackgroundImage
{
    NSDate *menstruationDate = nil;
    NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    if (data.count > 0) {
        BTUserSetting *userData = [data objectAtIndex:0];
        menstruationDate = [NSDate dateFromString:userData.menstruation withFormat:@"yyyy.MM.dd"];//duedate为00：00：00
    }
    
    if (![NSDate isAscendingWithOnedate:_currentDate anotherdate:menstruationDate] && [NSDate isAscendingWithOnedate:_currentDate anotherdate:[NSDate localdate]]) {
        [_previousButton setBackgroundImage:[UIImage imageNamed:@"left_indicate_button"] forState:UIControlStateNormal];
        [_nextButton setBackgroundImage:[UIImage imageNamed:@"right_indicate_button"] forState:UIControlStateNormal];
    }
    
    
}

#pragma mark - 配置折线图 和 柱状的遮盖层~~~~~~
- (void)configureLineAndBarWithData
{
    //可左右滑动视图
    self.lineScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, klineScrollViewY, SCREEN_WIDTH,klineScrollViewHeight)];
    _lineScrollView.contentSize = CGSizeMake(klineScrollViewContentSizeX, _lineScrollView.frame.size.height);
    _lineScrollView.backgroundColor = kGlobalColor;
    _lineScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_lineScrollView];

    self.lineChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH *2 + 30, klineScrollViewHeight)];
    self.lineXValues = @[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00"];
    [_lineChart setXLabels:self.lineXValues];
    _lineChart.strokeColor = [UIColor whiteColor];//线条颜色
    [_lineChart setYValues:self.lineYValues];
    [_lineChart strokeChart];
    [_lineScrollView  addSubview:_lineChart];
    
    
   
    PNChart * barChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 2 + 30 , 200.0)];
	barChart.backgroundColor = [UIColor clearColor];
	barChart.type = PNBarType;
	[barChart setXLabels:self.arrayBarXValue];
	[barChart setYValues:@[@"140",@"140",@"140",@"140",@"140"]];
	[barChart strokeChart];
    [_lineScrollView addSubview:barChart];
    
    //动画效果 改变偏移量
    [self changeScrollViewContentOffsetWithOffset:offsetX animated:YES];
}
- (void)getEveryHourDataWithDate:(NSDate *)date
{
    
    self.lineYValues = [NSMutableArray arrayWithCapacity:1];
    //分割出年月日小时
    NSNumber* year = [BTUtils getYear:date];
    NSNumber* month = [BTUtils getMonth:date];
    NSNumber* day = [BTUtils getDay:date];
    
    int count = 0;
    for (int i =0; i < 24; i ++) {
        NSPredicate *predicatePhone = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND hour == %@ AND type == %@",year,month,day,[NSNumber numberWithInt:i],[NSNumber numberWithDouble:PHONE_FETAL_TYPE]];
        NSPredicate *predicateDevice = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND hour == %@ AND type == %@",year,month,day,[NSNumber numberWithInt:i],[NSNumber numberWithDouble:DEVICE_FETAL_TYPE]];
        //取出记录时间数组
        NSArray *rawArrayPhone = [BTGetData getFromCoreDataWithPredicate:predicatePhone entityName:@"BTRawData" sortKey:nil];//取出记录时间数组
        NSArray *rawArrayDevice = [BTGetData getFromCoreDataWithPredicate:predicateDevice entityName:@"BTRawData" sortKey:nil];
        for (BTRawData *raw in rawArrayPhone) {
            count +=[raw.count intValue];
        }
        
        for (BTRawData *raw in rawArrayDevice) {
            count +=[raw.count intValue];
        }
        
        if (count > 0) {
            offsetX = i;
        }
        
        [self.lineYValues addObject:[NSString stringWithFormat:@"%d",count]];
        count = 0;
    }
    
    
    
    
}

- (void)getBarXValueWithDate:(NSDate *)date
{
    self.arrayBarXValue = [NSMutableArray arrayWithCapacity:1];
     //分割出年月日小时
    NSNumber* year = [BTUtils getYear:date];
    NSNumber* month = [BTUtils getMonth:date];
    NSNumber* day = [BTUtils getDay:date];
    
    //对手机存储的胎动 和 设备存储的胎动记录时间分别遍历
    NSPredicate *predicatePhone = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND type == %@",year,month,day,[NSNumber numberWithDouble:PHONE_START_TIME_TYPE]];
    NSPredicate *predicateDevice = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND type == %@",year,month,day,[NSNumber numberWithDouble:DEVICE_START_TIME_TYPE]];
    
    //取出记录时间数组
    NSArray *rawArrayPhone = [BTGetData getFromCoreDataWithPredicate:predicatePhone entityName:@"BTRawData" sortKey:nil];//取出记录时间数组
    NSArray *rawArrayDevice = [BTGetData getFromCoreDataWithPredicate:predicateDevice entityName:@"BTRawData" sortKey:nil];
    
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:rawArrayPhone];
    for (BTRawData *aRaw in rawArrayDevice) {
        [array addObject:aRaw];
    }
    //[array arrayByAddingObjectsFromArray:rawArrayDevice];
    //排序
    NSSortDescriptor *sorter = [[NSSortDescriptor  alloc ] initWithKey :@"seconds1970" ascending:YES];
    [array  sortUsingDescriptors :[NSArray  arrayWithObject:sorter]];
    
    //在这里判断两个记录时间是否相差1个小时 如果小于一个小时 则只留一个
    BTRawData *rawOne = nil;
    for (BTRawData *raw in array) {
        if ([raw.seconds1970 doubleValue] - [rawOne.seconds1970 doubleValue] >= 3600) {
            [self.arrayBarXValue addObject:raw];
            rawOne = raw;
        }
        else{
            
            continue;
        }
        
    }
    
    rawOne = nil;
    
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
        NSString *str = [NSString stringWithFormat:@"%@:%@-%@:%@",hour1,minute1,hour2,minute1];
        return str;
        
    }
    
    else{
        return [NSString stringWithFormat:@"未记录"];
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
            str = [NSString stringWithFormat:@"%d",aCount];
            return str;
        }
        else{
            str = [NSString stringWithFormat:@"0"];
            return str;
        }
    }
    else{
        str = [NSString stringWithFormat:@"0"];
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

#pragma mark - 动态的改变scrollview的偏移量
- (void)changeScrollViewContentOffsetWithOffset:(int)offSetX animated:(BOOL)animated
{
    
    int k = ((klineScrollViewContentSizeX)/24) * offSetX;
    if (k < 320/2) {
        k = 0;
    }
    else{
        k = k - 320/2;
    }
    
    if (animated) {
        //动画效果 改变偏移量
        [UIView animateWithDuration:1.0 animations:^{
            
            [self.lineScrollView setContentOffset:CGPointMake(k, 0) animated:YES];
            
        }];
    }
    
    else{
        [self.lineScrollView setContentOffset:CGPointMake(k, 0) animated:YES];
        
    }
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
