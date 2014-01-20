//
//  BTSyncViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTPhysicSportViewController.h"
#import "LayoutDef.h"
#import "BTUtils.h"
#import "BTDailySportViewController.h"//今日运动量
#import "BTWeeklySportViewController.h"//本周运动量
#import "BTMonthSportViewController.h"//本月运动量
#import "MHTabBarController.h"
#import "BTRawData.h"
#import "BTGetData.h"
#import "NSDate+DateHelper.h"
//tabbarView
#define ktabbarViewX 0
#define ktabbarViewY 80/2
#define ktabbarViewWidth 320
#define ktabbarViewHeight (368 + 82)/2

//运动量完成进度背景view
#define kprogressBgX 0
#define kprogressBgY (ktabbarViewY + ktabbarViewHeight)
#define kprogressBgWidth 320
#define kprogressBgHeight 80
@interface BTPhysicSportViewController ()
@property(nonatomic,strong)UIButton *previousButton;
@property(nonatomic,strong)UIButton *nextButton;
@property(nonatomic,strong)UILabel *titleDateLabel;
@property(nonatomic,assign)int selectedViewControllerIndex;
@property(nonatomic,strong)UIViewController *selectedViewController;
@property(nonatomic,strong)NSDate *currentDate;//调节中 日期
@property(nonatomic,strong)NSDate *currentWeekDate;//调节中 周的日期
@end

static BTPhysicSportViewController *sharedPhysicSportInstance = nil;//单例

@implementation BTPhysicSportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"运动量";
    [self addPreviousAndNextButton];
    [self addDayWeekMonthView];
    [self addTodayProgressView];
    
    
    
   	// Do any additional setup after loading the view.
}
- (void)addPreviousAndNextButton
{
    UIView *redBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ktabbarViewY)];
    redBgView.backgroundColor = kRedColor;
    [self.scrollView addSubview:redBgView];
    
    self.previousButton = [[UIButton alloc] initWithFrame:CGRectMake(20, (redBgView.frame.size.height - 32/2)/2, 50/2, 32/2)];
    _previousButton.backgroundColor = [UIColor yellowColor];
    [_previousButton addTarget:self action:@selector(previousStage:) forControlEvents:UIControlEventTouchUpInside];
    [redBgView addSubview:_previousButton];
    
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(320 - 50/2 - 20, (redBgView.frame.size.height - 32/2)/2, 50/2, 32/2)];
    _nextButton.backgroundColor = [UIColor yellowColor];
    [_nextButton addTarget:self action:@selector(nextStage:) forControlEvents:UIControlEventTouchUpInside];
    [redBgView addSubview:_nextButton];
    
    self.titleDateLabel = [[UILabel alloc] initWithFrame:CGRectMake((320 - 200)/2 , (redBgView.frame.size.height - 30)/2, 200, 30)];
    _titleDateLabel.backgroundColor = [UIColor blueColor];
    _titleDateLabel.textAlignment = NSTextAlignmentCenter;
    _titleDateLabel.text = @"2013年12月24日";
    [redBgView addSubview:_titleDateLabel];
    
    
}
#pragma mark - event

- (void)previousStage:(UIButton *)button
{
    if (self.selectedViewControllerIndex == 0) {
        if (!_currentDate) {
            _currentDate = [NSDate localdate];
            
        }
        _currentDate = [_currentDate addDay:-1];
        
        NSNumber *year = [BTUtils getYear:_currentDate];
        NSNumber *month = [BTUtils getMonth:_currentDate];
        NSNumber *day = [BTUtils getDay:_currentDate];
        //然后确定是哪个viewController 然后调用暴露出来的更行接口
        self.titleDateLabel.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        [(BTDailySportViewController *)self.selectedViewController updateViewWithDate:_currentDate];
    }
    
    
    else
    {
        
        if (!_currentWeekDate) {
            NSDate *date1 = [[NSDate alloc] init];
            _currentWeekDate = [date1 beginningOfWeek];
            
        }
        _currentWeekDate = [_currentWeekDate addDay:-7];
        
        NSNumber *year = [BTUtils getYear:_currentWeekDate];
        NSNumber *month = [BTUtils getMonth:_currentWeekDate];
        NSNumber *day = [BTUtils getDay:_currentWeekDate];
        
        //然后确定是哪个viewController 然后调用暴露出来的更行接口
        self.titleDateLabel.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        [(BTWeeklySportViewController *)self.selectedViewController updateViewWithWeekBeginDate:_currentWeekDate];
        
    }
}
- (void)nextStage:(UIButton *)button
{
    if (self.selectedViewControllerIndex == 0) {
        
        if (!_currentDate) {
            _currentDate = [NSDate localdate];
            
        }
        
        if ([[_currentDate addDay:1] timeIntervalSinceDate:[NSDate localdate]] < 0) {
            _currentDate = [_currentDate addDay:1];
            
            NSNumber *year = [BTUtils getYear:_currentDate];
            NSNumber *month = [BTUtils getMonth:_currentDate];
            NSNumber *day = [BTUtils getDay:_currentDate];
            //然后确定是哪个viewController 然后调用暴露出来的更行接口
            
            self.titleDateLabel.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
            
            [(BTDailySportViewController *)self.selectedViewController updateViewWithDate:_currentDate];
        }
        
        
        
    }
    
    
    else
    {
        if (!_currentWeekDate) {
            NSDate *date1 = [[NSDate alloc] init];
            _currentWeekDate = [date1 beginningOfWeek];

            
        }
        
        if ([[_currentWeekDate addDay:1] timeIntervalSinceDate:[[[NSDate alloc] init] beginningOfWeek]] < 0) {
            _currentWeekDate = [_currentWeekDate addDay:7];
            
            NSNumber *year = [BTUtils getYear:_currentWeekDate];
            NSNumber *month = [BTUtils getMonth:_currentWeekDate];
            NSNumber *day = [BTUtils getDay:_currentWeekDate];
            //然后确定是哪个viewController 然后调用暴露出来的更行接口
            
            self.titleDateLabel.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
            
           [(BTWeeklySportViewController *)self.selectedViewController updateViewWithWeekBeginDate:_currentWeekDate];
        }

    }
    
    
    
    
}
#pragma mark - 加载button控制的日 周 月运动详情
- (void)addDayWeekMonthView
{
    
	BTDailySportViewController *dailyVC = [[BTDailySportViewController alloc] init];
    BTWeeklySportViewController *weeklyVC = [[BTWeeklySportViewController alloc]init];
    //   BTMonthSportViewController *monthVC = [[BTMonthSportViewController alloc] init];
    
    
    
    dailyVC.title = @"今天";
    weeklyVC.title = @"周";
    //	monthVC.title = @"月";
    
    
	NSArray *viewControllers = [NSArray arrayWithObjects:dailyVC, weeklyVC,nil];
    
	self.tabBarController = [[MHTabBarController alloc] init];
    _tabBarController.view.frame = CGRectMake(ktabbarViewX, ktabbarViewY, ktabbarViewWidth, ktabbarViewHeight);
    // _tabBarController.view.backgroundColor = [UIColor yellowColor];
    _tabBarController.delegate = self;
	_tabBarController.viewControllers = viewControllers;
    [self.scrollView addSubview:_tabBarController.view];
	
    
    
}
#pragma mark - 自定义tabbar的代理方法
- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    return YES;
}
- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    //这个代理方法tmd太有用了
    self.selectedViewControllerIndex = index;
    self.selectedViewController = viewController;
    NSLog(@"选中的视图小标是%d",index);
}
- (void)addTodayProgressView
{
    UIView *aview = [[UIView alloc] initWithFrame:CGRectMake(kprogressBgX, kprogressBgY, kprogressBgWidth, kprogressBgHeight)];
    aview.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:aview];
    
    
    
    UILabel *label1 =  [[UILabel alloc] initWithFrame:CGRectMake(aview.frame.origin.x + 10, aview.frame.origin.y + 10, 170, 30)];
    label1.textColor = kBigTextColor;
    label1.backgroundColor = [UIColor clearColor];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    label1.text = @"今日运动量完成情况:";
    [self.scrollView addSubview:label1];
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x + label1.frame.size.width, label1.frame.origin.y, 120, 30)];
    _titleLabel.textColor = kBigTextColor;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    _titleLabel.text = @"未完成";
    [self.scrollView addSubview:_titleLabel];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(aview.frame.origin.x + 10, _titleLabel.frame.origin.y + 30, 80, 20)];
    label2.textColor = kContentTextColor;
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    label2.text = @"目标运动量:";
    [self.scrollView addSubview:label2];
    
    self.goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.origin.x + label2.frame.size.width, label2.frame.origin.y, 100, 20)];
    _goalLabel.textColor = kContentTextColor;
    _goalLabel.backgroundColor = [UIColor clearColor];
    _goalLabel.textAlignment = NSTextAlignmentLeft;
    _goalLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _goalLabel.text = @"7000步";
    [self.scrollView addSubview:_goalLabel];
    
    
    //单独 百分号 label
    UILabel *bLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, aview.frame.origin.y + 40, 20,20)];
    bLabel.backgroundColor = [UIColor clearColor];
    bLabel.textColor = [UIColor whiteColor];
    bLabel.textAlignment = NSTextAlignmentCenter;
    bLabel.font = [UIFont systemFontOfSize:17];
    bLabel.text = @"%";
    [self.scrollView addSubview:bLabel];
    
    //蓝线
    UIView *blueLine = [[UIView alloc] initWithFrame:CGRectMake(24/2, _goalLabel.frame.origin.y + _goalLabel.frame.size.height + 88/4 + 20 + 5, (320 - 24), 2)];
    blueLine.backgroundColor = kBlueColor;
    [self.scrollView addSubview:blueLine];
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(24/2, _goalLabel.frame.origin.y + _goalLabel.frame.size.height + 88/4 + 20, 0, 12)];
    _progressView.backgroundColor = kBlueColor;
    [self.scrollView addSubview:_progressView];
    
    
    self.progressImage =   [[UIImageView alloc] initWithFrame:CGRectMake(_progressView.frame.origin.x - (92/2+5)/2, _progressView.frame.origin.y - 35, 52, 66/2)];
    _progressImage.backgroundColor = [UIColor clearColor];
    _progressImage.image = [UIImage imageNamed:@"sport_progress"];
    [self.scrollView addSubview:_progressImage];
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 ,(_progressImage.frame.size.height - 20)/2 -2, 40,20)];
    _progressLabel.textColor = kBlueColor;
    _progressLabel.backgroundColor = [UIColor clearColor];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.font = [UIFont systemFontOfSize:40/2];
    //  _progressLabel.text = @"100";
    [_progressImage addSubview:_progressLabel];
    
    
    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_progressLabel.frame.origin.x + _progressLabel.frame.size.width, 10, 15, 15)];
    percentLabel.textColor = kBlueColor;
    percentLabel.backgroundColor = [UIColor clearColor];
    percentLabel.font = [UIFont systemFontOfSize:12.0];
    percentLabel.text = @"%";
    [_progressImage addSubview:percentLabel];
    //动态绘制进度view
    //  // [self addGradeCircular];
    int i = [self getDailyStep];
    NSLog(@"走了多少步%d",i);
    float progress = (i/7000.0);//此处1000是目标值 记得改 另外改了之后也要改柱状图内部
    //    NSLog(@"++++++++++++%f",progress);
    //    NSString *str = [NSString stringWithFormat:@"%.0f",progress];
    //    self.progressLabel.text = [str substringToIndex:4];
    //
    //    NSLog(@"^^^^^^^^^^^%@",self.progressLabel.text);
    //    [UIView animateWithDuration:1.0 animations:^{
    //
    //        float k = (float)(i/10000.0);
    //        NSLog(@"------------%f",k);
    //        self.progressView.frame = CGRectMake(0, 250,320 * k, 80);
    //
    //
    //	}];
    
    
    
    [self updateProgressAnimatedWithProgress:progress];
    [self updateTaskAchievementWithProgress:progress];
    
}
#pragma mark - 更新进度条
- (void)updateProgressAnimatedWithProgress:(float)progress
{
    [UIView animateWithDuration:2.0 animations:^{
        
        if (progress > 1.0) {
            self.progressView.frame = CGRectMake(_progressView.frame.origin.x, _progressView.frame.origin.y,(320 - 24)*1.0, _progressView.frame.size.height);
            
        }
        else
        {
            self.progressView.frame = CGRectMake(_progressView.frame.origin.x, _progressView.frame.origin.y,(320 - 24)*progress, _progressView.frame.size.height);
            
            
        }
        
        if (progress <  0.1) {
            self.progressImage.frame = CGRectMake((320 - 24)*0.1 - 33/2 + 2, _progressImage.frame.origin.y,_progressImage.frame.size.width, _progressImage.frame.size.height);
            
        }
        else if (progress > 0.9)
        {
            self.progressImage.frame = CGRectMake((320 - 24)*0.9 - 33/2 + 2, _progressImage.frame.origin.y,_progressImage.frame.size.width, _progressImage.frame.size.height);
            
            
        }
        else
        {
            self.progressImage.frame = CGRectMake((320 - 24)*progress - 33/2 + 2, _progressImage.frame.origin.y,_progressImage.frame.size.width, _progressImage.frame.size.height);
            
        }
        
        float percent = progress*100;
        if (percent > 100)
        {
            _progressLabel.text = [NSString stringWithFormat:@"%d",(int)percent];
        }
        else
        {
            _progressLabel.text = [NSString stringWithFormat:@"%0.1f",percent];
            
        }
        
        
    }];
    
}
#pragma mark - 更新完成情况
- (void)updateTaskAchievementWithProgress:(float)progress
{
    if (progress < 1.0) {
        self.titleLabel.text = @"未完成";
        self.titleLabel.textColor = kGlobalColor;
    }
    else{
        self.titleLabel.text = @"已完成";
        self.titleLabel.textColor = kBlueColor;
    }
}
#pragma mark - 读取当天总步数
- (int)getDailyStep
{
    //设置数据类型
    
    NSDate* date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    
    
    NSNumber* year = [BTUtils getYear:localeDate];
    NSNumber* month = [BTUtils getMonth:localeDate];
    NSNumber* day = [BTUtils getDay:localeDate];
    // NSNumber* hour = [BTUtils getHour:localeDate];
    
    
    //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND type == %@",year, month, day,[NSNumber numberWithDouble:DEVICE_SPORT_TYPE]];
    
    int stepCount = 0;
    
    NSArray *array = [BTGetData getFromCoreDataWithPredicate:predicate entityName:@"BTRawData" sortKey:nil];
    NSLog(@"运动量。。。。。。。%@",array);
    for (BTRawData* one in array) {
        stepCount += [one.count intValue];
        
    }
    NSLog(@"当天总步数%d",stepCount);
    
    //
    return stepCount;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
