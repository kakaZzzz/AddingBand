//
//  BTSyncViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTPhysicSportViewController.h"
#import "CircularProgressView.h"
#import "BarChartView.h"
#import "LayoutDef.h"
#import "BTUtils.h"
#import "BTRawData.h"
#import "BTGlobals.h"
#import "BTBandCentral.h"
#import "BTGetData.h"
//button
#define syncButtonX 200
#define syncButtonY 390
#define syncButtonWidth 100
#define syncButtonHeight 50

//label
#define stepLabelX 110
#define stepLabelY 100
#define stepLabelWidth 100
#define stepLabelHeight 50
#define stepLabelFont 20
@interface BTPhysicSportViewController ()
@property (strong, nonatomic) CircularProgressView *circularProgressView;
@property (strong, nonatomic) UIButton *sycnButton;
@end

static BTPhysicSportViewController *sharedPhysicSportInstance = nil;//单例
static int totalStep = 0;
static int dailyStep = 0;
@implementation BTPhysicSportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //注册同步的观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCircularProgress:) name:UPDATACIRCULARPROGRESSNOTICE object:nil];
        //
        [self.g addObserver:self forKeyPath:@"bleListCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
        //添加圆形进度条 和 Label
        [self addCircleProgress];
        //添加柱状图
        [self loadBarChartUsingArray];
        //添加同步按钮
        [self addSycnButton];

        
        //读取当天总步数 和  累计总步数
        totalStep = [self getTotalStep];
        dailyStep = [self getDailyStep];
//        self.totalStep.text = [NSString stringWithFormat:@"%d",totalStep];
//        [self.circularProgressView updateProgressCircle:dailyStep withTotal:totalStep];

    }
    return self;
}

//监控参数，更新显示
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"更新数据");
    
    if([keyPath isEqualToString:@"dlPercent"])
    {
        NSLog(@"what");
        
        BTBandPeripheral* bp = [self.bc getBpByModel:MAM_BAND_MODEL];
        
        if (bp.dlPercent == 1) {
            
            //同步完成逻辑
            //   [self buildMain];
            
        }
    }
    
    if([keyPath isEqualToString:@"bleListCount"])
    {
        //连接上该型号设备
        if ([self.bc isConnectedByModel:MAM_BAND_MODEL]){
            
            //注册同步进度的监听
            [[self.bc getBpByModel:MAM_BAND_MODEL] addObserver:self forKeyPath:@"dlPercent" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
            
            
        }else{
            
            //没有连接上时的处理
        }
        
        //读取一下对更新时间的描述
        NSString* syncWord = [self.bc getLastSyncDesc:MAM_BAND_MODEL];
        
    }
}

// 建立主要区域
-(void)buildMain{
    
    NSLog(@"build graph!!");
    
    //设置数据类型
    int type = 2;
    
    //分割出年月日小时
    NSDate* date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSLog(@"localeDate==%@", localeDate);
    
    NSNumber* year = [BTUtils getYear:localeDate];
    NSNumber* month = [BTUtils getMonth:localeDate];
    NSNumber* day = [BTUtils getDay:localeDate];
    NSNumber* hour = [BTUtils getHour:localeDate];
    
    //设置coredata
    //取得context
    //获取上下文··
//    self.context =[(BTAppDelegate *) [UIApplication sharedApplication].delegate managedObjectContext];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTRawData" inManagedObjectContext:self.context];
//    
//    NSFetchRequest* request = [[NSFetchRequest alloc] init];
//    [request setEntity:entity];
//    
//    //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day = %@ AND hour == %@ AND type == %@",year, month, day, hour, [NSNumber numberWithInt:type]];
    
//    [request setPredicate:predicate];
//    
//    //排序
//    NSMutableArray *sortDescriptors = [NSMutableArray array];
//    [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"minute" ascending:YES] ];
//    
//    [request setSortDescriptors:sortDescriptors];
//    
//    
////    //
////    //创建一个请求
////    self.context =[(BTAppDelegate *) [UIApplication sharedApplication].delegate managedObjectContext];
////    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BTRawData"];
////    
////    NSArray* raw = [self.context executeFetchRequest:request error:nil];
//
//    NSError* error;
   //从coredata中读取的数据 记录时间和步数
    NSArray* raw = [BTGetData getFromCoreDataWithPredicate:predicate
                                                entityName:@"BTRawData" sortKey:@"minute"];
    NSLog(@"从coredata里取出的数据%@",raw);
//    //初始化数据
//    _dailyData = [NSMutableArray arrayWithCapacity:1];
//    [_dailyData removeAllObjects];
//    for (int i = 0; i < 60; i++) {
//        // 显示好看，空的设1
//        [_dailyData addObject:[NSNumber numberWithInt:1]];
//    }
//    
//    _stepCount = 0;
    
    //如果有数据
    
//    for (BTRawData* one in raw) {
//           NSLog(@"走的步数一共是 %d",_stepCount);
//        NSNumber* m = one.minute;
//     //   [_dailyData insertObject:one.count atIndex:59 - [m integerValue]];
//        
//        _stepCount += [one.count intValue];
//      
//    }
    //更新总步数Label和圆形进度条
    //总步数 和整体一天的步数数据
   // [self getDailyStep];
    dailyStep = [self getDailyStep];
    totalStep = [self getTotalStep];
    [self updateUIWithStepDaily:dailyStep totalStep:totalStep];
    //总步数   用来显示用户总的数据
    
  //  _stepCount;
  //  NSLog(@"每日数据是 %@",_dailyData);
   
    //具体步数时间分布
    //index-小时，value-步数
    _dailyData;
    
}

//单例
+(BTPhysicSportViewController *)sharedPhysicSportViewController
{
   @synchronized(self)
    {
    if (sharedPhysicSportInstance == nil ) {
        sharedPhysicSportInstance = [[BTPhysicSportViewController alloc] init];
    }
    }
    return sharedPhysicSportInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.title = @"MAMA运动";
 
    
   	// Do any additional setup after loading the view.
}

#pragma mark - 读取当天总步数
- (int)getTotalStep
{
     int stepCount = 0;
    NSArray *array = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTRawData" sortKey:nil];
    for (BTRawData* one in array) {
        stepCount += [one.count intValue];
        
    }
    NSLog(@"一共步数%d",stepCount);
    return stepCount;
}
#pragma mark - 读取累计总步数
- (int)getDailyStep
{
    //设置数据类型
    int type = 2;
    NSDate* date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSLog(@"localeDate==%@", localeDate);
    
    NSNumber* year = [BTUtils getYear:localeDate];
    NSNumber* month = [BTUtils getMonth:localeDate];
    NSNumber* day = [BTUtils getDay:localeDate];
       //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day = %@ AND type == %@",year, month, day, [NSNumber numberWithInt:type]];

     int stepCount = 0;
    
    NSArray *array = [BTGetData getFromCoreDataWithPredicate:predicate entityName:@"BTRawData" sortKey:nil];
    for (BTRawData* one in array) {
        stepCount += [one.count intValue];
        
    }
    NSLog(@"当天总步数%d",stepCount);
    return stepCount;

}
- (void)updateUIWithStepDaily:(int)stepDaily totalStep:(int)totalStep
{
    [self.circularProgressView updateProgressCircle:stepDaily withTotal:totalStep];
}
#pragma mark - add circle progress
- (void)addCircleProgress
{
    //set backcolor & progresscolor
    UIColor *backColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *progressColor = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    
    //alloc CircularProgressView instance
    self.circularProgressView = [[CircularProgressView alloc] initWithFrame:CGRectMake(25, 77, 270, 270) backColor:backColor progressColor:progressColor lineWidth:10];
    
    //add CircularProgressView
    [self.view addSubview:self.circularProgressView];
    
    //创建Label
    self.totalStep = [[UILabel alloc] initWithFrame:CGRectMake(stepLabelX, stepLabelY, stepLabelWidth, stepLabelHeight)];
    _totalStep.font = [UIFont systemFontOfSize:stepLabelFont];
    _totalStep.text = @"9506";
    _totalStep.textAlignment =  NSTextAlignmentCenter;
    _totalStep.backgroundColor = [UIColor redColor];
    [self.view addSubview:_totalStep];
    
    self.realStep = [[UILabel alloc] initWithFrame:CGRectMake(stepLabelX, stepLabelY + 170, stepLabelWidth, stepLabelHeight)];
    _realStep.text = @"100";
    _realStep.font = [UIFont systemFontOfSize:stepLabelFont];
    _realStep.textAlignment =  NSTextAlignmentCenter;
    [self.view addSubview:_realStep];


}
#pragma mark - add sync button
- (void)addSycnButton
{
    //同步按钮
    UIButton *buttonSync = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonSync.frame = CGRectMake(syncButtonX, syncButtonY, syncButtonWidth, syncButtonHeight);
    [buttonSync setTitle:@"SYNC" forState:UIControlStateNormal];
    [buttonSync addTarget:self action:@selector(syncData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSync];
    
}

- (void)syncData
{
    NSLog(@"同步数据......");
}
#pragma mark - loadBarChart
- (void)loadBarChartUsingArray {
    //Generate properly formatted data to give to the bar chart
    //横坐标元素
 /*   在此传入横坐标名称  柱子表示的数值  柱子颜色  以及label中字体颜色 */
    
    _barChart = [[BarChartView alloc] initWithFrame:CGRectMake(60, 160, 200, 100)];//柱形图背景大小
    [self.view addSubview:_barChart];

    NSArray *array = [_barChart createChartDataWithTitles:[NSArray arrayWithObjects:@"1", @"2", @"3", @"4",@"5" ,@"6",@"7",nil]
                                                  values:[NSArray arrayWithObjects:@"4.7", @"8.3", @"50", @"5.4",@"10.0" ,@"10.0" ,@"10.0" ,nil]
                                                  colors:[NSArray arrayWithObjects:@"87E317", @"17A9E3", @"E32F17", @"FFE53D",@"FFE53D", @"FFE53D",@"FFE53D",nil]
                                             labelColors:[NSArray arrayWithObjects:@"17A9E3", @"17A9E3", @"17A9E3", @"17A9E3", @"17A9E3",@"17A9E3",@"17A9E3",nil]];
    
  
    //Set the Shape of the Bars (Rounded or Squared) - Rounded is default
    //柱形形状  分圆角型和直角型
    [_barChart setupBarViewShape:BarShapeSquared];
    
    //Set the Style of the Bars (Glossy, Matte, or Flat) - Glossy is default
    //柱形样式  分有光泽的  无光泽的  扁平的
    [_barChart setupBarViewStyle:BarStyleFlat];
    
    //Set the Drop Shadow of the Bars (Light, Heavy, or None) - Light is default
    //柱形阴影   分 轻 重 无 三种
    [_barChart setupBarViewShadow:BarShadowNone];
    
    //Generate the bar chart using the formatted data
    [_barChart setDataWithArray:array
                      showAxis:DisplayBothAxes
                     withColor:[UIColor clearColor]//指示坐标颜色
       shouldPlotVerticalLines:YES];
    }


//更新圆形进度条
- (void)updateCircularProgress:(NSNotification *)notification
{
    //亲，在这个方法里传入进度参数即可
    float progress = [[notification.userInfo objectForKey:@"progress"] floatValue];
    [self.circularProgressView updateProgressCircle:progress withTotal:10];
    NSLog(@"要更新数据了");
 
    [self buildMain];
  //  [[BTBandCentral sharedBandCentral] sync:MAM_BAND_MODEL];
    
    

}
//页面将要显示的时候 处理数据
- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:1 animations:^{
        [self updateUIWithStepDaily:dailyStep totalStep:totalStep];
        self.totalStep.text = [NSString stringWithFormat:@"%d",totalStep];

    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
