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
#define ktabbarViewHeight (368 + 82)/2

//运动量完成进度背景view
#define kprogressBgX 0
#define kprogressBgY (ktabbarViewHeight)
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

    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(24/2, _goalLabel.frame.origin.y + _goalLabel.frame.size.height + 88/4, 0, 12)];
    _progressView.backgroundColor = [UIColor blueColor];;
    [self.scrollView addSubview:_progressView];
    
    
    self.progressImage =   [[UIImageView alloc] initWithFrame:CGRectMake(_progressView.frame.origin.x, _progressView.frame.origin.y - 40, 40, 40)];
    _progressImage.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:_progressImage];
                          
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, 30,30)];
    _progressLabel.textColor = [UIColor whiteColor];
    _progressLabel.backgroundColor = [UIColor yellowColor];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.font = [UIFont systemFontOfSize:40/2];
  //  _progressLabel.text = @"100";
    [_progressImage addSubview:_progressLabel];

//    //动态绘制进度view
//    //  // [self addGradeCircular];
//    int i = [self getDailyStep];
//    NSLog(@"走了多少步%d",i);
//    float progress = (i/10000.0) *100;//此处1000是目标值 记得改 另外改了之后也要改柱状图内部
//    NSLog(@"++++++++++++%f",progress);
//    NSString *str = [NSString stringWithFormat:@"%f",progress];
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
//

    
    [UIView animateWithDuration:1.0 animations:^{
        
    self.progressView.frame = CGRectMake(_progressView.frame.origin.x, _progressView.frame.origin.y,50, _progressView.frame.size.height);
    self.progressImage.frame = CGRectMake(12 + 50, _progressImage.frame.origin.y,_progressImage.frame.size.width, _progressImage.frame.size.height);
        
        for (int i = 0; i <= 50; i ++) {
              _progressLabel.text = [NSString stringWithFormat:@"%0.1f", (float)i/50];
        }
      
        
        
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
