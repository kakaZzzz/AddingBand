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
//tabbarView
#define ktabbarViewX 0
#define ktabbarViewY 0
#define ktabbarViewWidth 320
#define ktabbarViewHeight 250

//运动量完成进度背景view
#define kprogressBgX 0
#define kprogressBgY 250
#define kprogressBgWidth 320
#define kprogressBgHeight 80
@interface BTPhysicSportViewController ()


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
 
    
    self.navigationItem.title = @"MAMA运动";
    
    [self addDayWeekMonthView];
    [self addTodayProgressView];


    
   	// Do any additional setup after loading the view.
}
#pragma mark - 加载button控制的日 周 月运动详情
- (void)addDayWeekMonthView
{
    
	BTDailySportViewController *dailyVC = [[BTDailySportViewController alloc] init];
    BTWeeklySportViewController *weeklyVC = [[BTWeeklySportViewController alloc]init];
    BTMonthSportViewController *monthVC = [[BTMonthSportViewController alloc] init];
   
    
    
    dailyVC.title = @"今天";
    weeklyVC.title = @"周";
	monthVC.title = @"月";
    
    
	NSArray *viewControllers = [NSArray arrayWithObjects:dailyVC, weeklyVC, monthVC,nil];
    
	self.tabBarController = [[MHTabBarController alloc] init];
    _tabBarController.view.frame = CGRectMake(ktabbarViewX, ktabbarViewY, ktabbarViewWidth, ktabbarViewHeight);
   // _tabBarController.view.backgroundColor = [UIColor yellowColor];
    _tabBarController.delegate = self;
	_tabBarController.viewControllers = viewControllers;
    [self.scrollView addSubview:_tabBarController.view];
	
    
    
}
- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    return YES;
}
- (void)addTodayProgressView
{
    UIView *aview = [[UIView alloc] initWithFrame:CGRectMake(kprogressBgX, kprogressBgY, kprogressBgWidth, kprogressBgHeight)];
    aview.backgroundColor = [UIColor colorWithRed:117/255.0 green:188/255.0 blue:232/255.0 alpha:1.0];
    [self.scrollView addSubview:aview];
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(kprogressBgX, kprogressBgY, 0, kprogressBgHeight)];
    _progressView.backgroundColor = [UIColor colorWithRed:66/255.0 green:156/255.0 blue:239/255.0 alpha:1.0];;
    [self.scrollView addSubview:_progressView];
  
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(aview.frame.origin.x + 10, aview.frame.origin.y + 10, 150, 30)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];

    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.text = @"今日目标完成情况:";
    [self.scrollView addSubview:_titleLabel];
    
    
    self.goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(aview.frame.origin.x + 10, _titleLabel.frame.origin.y + 30, 170, 30)];
    _goalLabel.textColor = [UIColor whiteColor];
    _goalLabel.backgroundColor = [UIColor clearColor];
    _goalLabel.textAlignment = NSTextAlignmentLeft;
    _goalLabel.font = [UIFont systemFontOfSize:17];
    _goalLabel.text = @"目标运动量:10000步";
    [self.scrollView addSubview:_goalLabel];

    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - aview.frame.size.height - 80, aview.frame.origin.y - 10, 130,100)];
    _progressLabel.textColor = [UIColor whiteColor];
    _progressLabel.backgroundColor = [UIColor clearColor];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.font = [UIFont systemFontOfSize:62];
    _progressLabel.text = @"100";
    [self.scrollView addSubview:_progressLabel];
    
    //单独 百分号 label
    UILabel *bLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, aview.frame.origin.y + 40, 20,20)];
    bLabel.backgroundColor = [UIColor clearColor];
    bLabel.textColor = [UIColor whiteColor];
    bLabel.textAlignment = NSTextAlignmentCenter;
    bLabel.font = [UIFont systemFontOfSize:17];
    bLabel.text = @"%";
    [self.scrollView addSubview:bLabel];

    UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(aview.frame.origin.x, aview.frame.origin.y + aview.frame.size.height + 5, 320, 220)];
    aImageView.image = [UIImage imageNamed:@"physical_sport_bg@2x"];
    [self.scrollView addSubview:aImageView];
    
    //动态绘制进度view
    //  // [self addGradeCircular];
    int i = [self getDailyStep];
    NSLog(@"走了多少步%d",i);
    float progress = (i/10000.0) *100;//此处1000是目标值 记得改 另外改了之后也要改柱状图内部
    NSLog(@"++++++++++++%f",progress);
    NSString *str = [NSString stringWithFormat:@"%f",progress];
    self.progressLabel.text = [str substringToIndex:4];
    
    NSLog(@"^^^^^^^^^^^%@",self.progressLabel.text);
    [UIView animateWithDuration:1.0 animations:^{
		
        float k = (float)(i/10000.0);
        NSLog(@"------------%f",k);
        self.progressView.frame = CGRectMake(0, 250,320 * k, 80);
        
		
	}];


    
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
