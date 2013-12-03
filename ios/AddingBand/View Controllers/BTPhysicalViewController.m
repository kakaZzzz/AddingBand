//
//  BTPhysicalViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTPhysicalViewController.h"
#import "BTPhysicSportViewController.h"
#import "BTPhysicQuickeningViewController.h"
#import "LayoutDef.h"
#import "CircularProgressView.h"
#import "PCLineChartView.h"
#import "BTGetData.h"
#import "BarChartView.h"
#import "PICircularProgressView.h"
#import "BTColor.h"

#define kImageBgX 0
#define kImageBgY 0
#define kImageBgWidth 320
#define kImageBgHeight 200
@interface BTPhysicalViewController ()
@property(nonatomic,strong)UIScrollView *aScrollView;

@end

@implementation BTPhysicalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.barYValue = [self getResentOneWeekSteps];
        
    }
    return self;
}

- (void)viewDidLoad
{
    
   
    [super viewDidLoad];
    //加载滚动视图
    [self addSubviews];
    [self addBackgroundImage];
    //加载折线图
   // [self drawLineChartView];
    // Do any additional setup after loading the view.
}
#pragma mark - 开始配置背景色
- (void)addSubviews
{
    
    //添加滚动视图
    self.aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _aScrollView.delegate = self;
    _aScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 50);
    _aScrollView.showsVerticalScrollIndicator = NO;
    _aScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_aScrollView];
    
    //配置图片 传得参数为图片数量
    //[self addImageViewByNumber:5];

    //背景粉红图
    if (iPhone5) {
        self.aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageBgX, kImageBgY, kImageBgWidth, kImageBgHeight)];
    }
    else
    {
        self.aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageBgX, kImageBgY, kImageBgWidth, kImageBgHeight)];
    }
    _aImageView.image = [UIImage imageNamed:@"red_bg.png"];
    [_aScrollView addSubview:_aImageView];
    
    //设备使用时间背景
    
    self.useTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,_aImageView.frame.size.height - 50, 320, 50)];
    _useTimeImage.image = [UIImage imageNamed:@"uestime_bg.png"];
    
   // [_aImageView addSubview:_useTimeImage];
    
    
    //使用时间标签
    self.useTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, _useTimeImage.frame.size.height)];
    _useTimeLabel.backgroundColor = [UIColor clearColor];
    _useTimeLabel.text = @"使用时间:---";
    _useTimeLabel.textColor = [UIColor whiteColor];
   // [_useTimeImage addSubview:_useTimeLabel];

}

#pragma mark - 添加弧形的进度条
- (void)addGradeCircular
{
    self.progressView = [[PICircularProgressView alloc] initWithFrame:CGRectMake((320 - 160)/2, 20, 160, 160)];
    
    //  self.progressView.progress = 0.8;
    self.progressView.thicknessRatio =0.2;//圆圈宽度
    self.progressView.showText = YES;//圆圈中间是否显示进度数字标签
    // self.progressView.innerBackgroundColor = [UIColor blueColor];
    self.progressView.textColor = [UIColor whiteColor];//字体颜色
    self.progressView.outerBackgroundColor = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];;//状态条背部颜色
    
    self.progressView.progressFillColor = [UIColor whiteColor];//状态条 里面填充色
    
    self.progressView.showShadow = NO;//背部圆圈是否有阴影
    
    //带阴影效果
//    [self.progressView setProgressTopGradientColor:[UIColor colorWithRed:15.0/255.0 green:97.0/255.0 blue:189.0/255.0 alpha:1.0]];
//    [self.progressView setProgressBottomGradientColor:[UIColor colorWithRed:114.0/255.0 green:174.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    [_aScrollView addSubview:_progressView];
	// Do any additional setup after loading the view.
    
    //加入计时器 动态绘制出进度
    _timer =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    
}
- (void)progressChange
{

    if (_progressView.progress >= _progress) {
        NSLog(@"--------");
        [_timer invalidate];
        
    }
    else
    {
        _progressView.progress += 0.01;
    }
    
}



#pragma mark - add circle progress
- (void)addCircleProgress
{
    //妈妈运动量标签
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 120, 50)];
    label1.text = @"妈妈运动量:";
    label1.textColor =[UIColor blueColor];
 //   [self.aScrollView addSubview:label1];

    
    
    
    //set backcolor & progresscolor
  //  UIColor *progressColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *progressColor = [UIColor yellowColor];
    UIColor *backColor = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    
   //整体分数进度条
    //alloc CircularProgressView instance
    self.circularGrade = [[CircularProgressView alloc] initWithFrame:CGRectMake(60, 40, 200, 200) backColor:backColor progressColor:progressColor lineWidth:13];
   // [self.circularGrade updateProgressCircle: 50 withTotal:100];

    //add CircularProgressView
    [self.aScrollView addSubview:_circularGrade];
    //分数标签
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_circularGrade.frame.origin.x, _circularGrade.frame.origin.y +40, 140, 70)];
    _gradeLabel.center = _circularGrade.center;//利用center快速定位
    //自动换行
    [_gradeLabel setNumberOfLines:0];
    _gradeLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    _gradeLabel.textAlignment = NSTextAlignmentCenter;
    _gradeLabel.textColor = [UIColor whiteColor];
    _gradeLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    [_aScrollView addSubview:_gradeLabel];
    
    //点击进入运动详情
    _gradeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterDetai)];
    [_gradeLabel addGestureRecognizer:tap];
    
    //创建运动量圆形进度条
    self.circularSport = [[CircularProgressView alloc] initWithFrame:CGRectMake(200, 180, 90, 120) backColor:backColor progressColor:progressColor lineWidth:13];
    //[self.circularSport updateProgressCircle: 50 withTotal:100];
    
    //add CircularProgressView
 //   [self.aScrollView addSubview:_circularSport];
    
    //运动量标签
    self.sportLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    _sportLabel.center = _circularSport.center;//利用center快速定位
    _sportLabel.textAlignment = NSTextAlignmentCenter;
    _sportLabel.text = @"100";
    _sportLabel.backgroundColor = [UIColor redColor];
 //   [_aScrollView addSubview:_sportLabel];

    
      
    
//    //创建Label
//    self.totalStep = [[UILabel alloc] initWithFrame:CGRectMake(stepLabelX, stepLabelY, stepLabelWidth, stepLabelHeight)];
//    _totalStep.font = [UIFont systemFontOfSize:stepLabelFont];
//    _totalStep.text = @"9506";
//    _totalStep.textAlignment =  NSTextAlignmentCenter;
//    _totalStep.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_totalStep];
//    
//    self.realStep = [[UILabel alloc] initWithFrame:CGRectMake(stepLabelX, stepLabelY + 170, stepLabelWidth, stepLabelHeight)];
//    _realStep.text = @"100";
//    _realStep.font = [UIFont systemFontOfSize:stepLabelFont];
//    _realStep.textAlignment =  NSTextAlignmentCenter;
//    [self.view addSubview:_realStep];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 100, 50)];
    label.text = @"宝宝胎动：";
    label.textColor =[UIColor blueColor];
    [self.aScrollView addSubview:label];
}
#pragma mark -添加演示用背景花边
- (void)addBackgroundImage
{
    UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _aImageView.frame.origin.y + _aImageView.frame.size.height, self.view.frame.size.width, 131)];
    aImageView.image = [UIImage imageNamed:@"lace_bg.png"];
    [_aScrollView addSubview:aImageView];
    
    //胎动
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    
    aLabel.textAlignment = NSTextAlignmentLeft;
    aLabel.text = @"胎动";
    aLabel.backgroundColor = [UIColor clearColor];
    [aImageView addSubview:aLabel];
    
    UIImageView *bImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, aImageView.frame.origin.y + aImageView.frame.size.height, self.view.frame.size.width, 121)];
    bImageView.backgroundColor = [UIColor redColor];
    bImageView.image = [UIImage imageNamed:@"test_bg.png"];
    [_aScrollView addSubview:bImageView];
}
#pragma mark - loadBarChart  加载柱形图
- (void)loadBarChartUsingArray {
    //Generate properly formatted data to give to the bar chart
    //横坐标元素
    /*   在此传入横坐标名称  柱子表示的数值  柱子颜色  以及label中字体颜色 */
    
    _barChart = [[BarChartView alloc] initWithFrame:CGRectMake(30, 220, 250, 100)];//柱形图背景大小
    _barChart.backgroundColor = [UIColor clearColor];
    [self.aScrollView addSubview:_barChart];
    
    NSArray *array = [_barChart createChartDataWithTitles:_barXValue
                                                   values:_barYValue
                                                   colors:_barColors
                                              labelColors:_barLabelColors];
    
    
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
                      withColor:[BTColor getColor:kBarColor]//指示坐标颜色 Y轴颜色
        shouldPlotVerticalLines:YES];
}
#pragma mark - 读取最近一周每天的运动量 并配置绘制柱形图所需参数
- (NSArray *)getResentOneWeekSteps
{
    
    self.barColors = [NSMutableArray arrayWithObjects:@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317", nil];
    self.barLabelColors = [NSMutableArray arrayWithObjects:@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317", nil];
    
    //设置数据类型
    int type = 1;
    //读取当前时间
    NSDate* date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSLog(@"localeDate==%@", localeDate);
    //分割出年 月 日 小时
    NSNumber* year = [BTUtils getYear:localeDate];
//    NSNumber* month = [BTUtils getMonth:localeDate];
//    NSNumber* day = [BTUtils getDay:localeDate];
//    NSNumber* minute = [BTUtils getMinutes:date];
    NSNumber* hour = [BTUtils getHour:localeDate];
    //设置查询条件
    //按月查询
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND hour == %@ AND type == %@",year,hour ,[NSNumber numberWithInt:type]];
    NSArray *array = [BTGetData getFromCoreDataWithPredicate:predicate entityName:@"BTRawData" sortKey:nil];
    
    NSMutableArray *arrayStep = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *arrayDate = [NSMutableArray arrayWithCapacity:1];
    for (BTRawData* one in array) {
        [arrayStep addObject:[NSString stringWithFormat:@"%@",one.count]];
        [arrayDate addObject:[NSString stringWithFormat:@"%@分",one.minute]];//测试用小时 实际上线时 用天
        
    }
    
    
    //最近七天的一个范围
    NSArray *resultArray;
    //如果数据大于七天
    if (arrayStep.count >= 7) {
        NSRange theRange;
        theRange.location = arrayStep.count - 7;//range的起点
        theRange.length = 7;//range的长度
        resultArray = [arrayStep subarrayWithRange:theRange];
        self.barXValue = [arrayDate subarrayWithRange:theRange];
        
    }
    //如果数据少于七天
    else{
        resultArray = arrayStep;
        //横坐标值
        self.barXValue = arrayDate;
        
        NSRange theRange;
        theRange.location = arrayStep.count ;//range的起点
        theRange.length = 7 - arrayStep.count;//range的长度
        
        //柱子颜色
        [self.barColors removeObjectsInRange:theRange];
        [self.barLabelColors removeObjectsInRange:theRange];
        
    }
    NSLog(@"最近一周的运动量是 %@",resultArray);
    return resultArray;
    
    
}

#pragma mark - 点击label进入详情
- (void)enterDetai
{
   // BTPhysicSportViewController *sportVC = [[BTPhysicSportViewController alloc] init];
   // [self.navigationController pushViewController:sportVC animated:YES];
}
#pragma mark - 更新圆形进度条

#pragma mark - 视图将要出现的时候更新进度条
- (void)viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:animated];
    NSLog(@"视图出现出现出现.....");
//    //在视图出现的时候加载进度条 然后再视图消失的时候移除进度条  这样可以保证进度条进度动态的出现
//    [self addCircleProgress];
//    int i = [self getDailyStep];
//    [self updateUIWithStepDaily:i totalStep:2000];//100为每日目标
//    if (i == 0) {
//    self.gradeLabel.text = [NSString stringWithFormat:@"今日还未开始运动,妈妈要努力啊"];
//    }
//
//    if (i < 2000 && i > 0) {
//         self.gradeLabel.text = [NSString stringWithFormat:@"今日已完成%d步,继续努力啊",i];
//    }
//    
//    if (i >= 2000) {
//        self.gradeLabel.text = [NSString stringWithFormat:@"今日圆满完成目标，妈妈真棒"];
//    }
    
    
    [self addGradeCircular];
    int i = [self getDailyStep];
    NSLog(@"走了多少步%d",i);
    if (i == 0) {
        self.progressView.roundedHead = NO;
    }
    else{
        self.progressView.roundedHead = YES;
    }
    _progress =(float) i/500;//此处1000是目标值 记得改 另外改了之后也要改柱状图内部
    NSLog(@"进度是%f",_progress);
 //   [self updateUIWithStepDaily:i totalStep:2000];//100为每日目标
   
    self.barYValue = [self getResentOneWeekSteps];
    [self loadBarChartUsingArray];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.circularGrade removeFromSuperview];
//    [self.circularSport removeFromSuperview];
    
    [self.progressView removeFromSuperview];
    [self.barChart removeFromSuperview];
}
- (void)updateUIWithStepDaily:(int)stepDaily totalStep:(int)totalStep
{
    
    [self.circularGrade updateProgressCircle:stepDaily withTotal:totalStep];
}
#pragma mark - 绘制折线图
- (void)drawLineChartView
{
    _lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(10,180,200,120)];
    [_lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    _lineChartView.minValue = 40;
    _lineChartView.maxValue = 90;
    [self.aScrollView addSubview:_lineChartView];
    
    NSMutableArray *components = [NSMutableArray array];
    
    //
   // NSArray *arrayTitle = [NSArray arrayWithObjects:@"你好",@"我好", nil];//每条折线的标签
    for (int i=0; i< 3; i++)
    {
        
		//	NSDictionary *point = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
        PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
        
      //  [component setTitle:[arrayTitle objectAtIndex:i]];
        
        
        [component setShouldLabelValues:NO];//是否显示数据标签
        
        if (i==0)
        {
            [component setColour:PCColorYellow];
            [component setPoints:[NSArray arrayWithObjects:@"60",@"62",@"64",@"68",@"70",nil]];
        }
        else if (i==1)
        {
            [component setColour:PCColorGreen];
            [component setPoints:[NSArray arrayWithObjects:@"50",@"52",@"54",@"56",@"60",nil]];
        }
        
        else if (i==2)
        {
            [component setColour:PCColorOrange];
             [component setPoints:[NSArray arrayWithObjects:@"40",@"42",@"44",@"46",@"50",nil]];
        }
        //			else if (i==3)
        //			{
        //				[component setColour:PCColorRed];
        //			}
        //			else if (i==4)
        //			{
        //				[component setColour:PCColorBlue];
        //			}
        
        [components addObject:component];
    }
    [_lineChartView setComponents:components];
    [_lineChartView setXLabels:[NSMutableArray arrayWithObjects:@"1月",@"2月",@"3月",@"4月",@"5月", nil]];
}


#pragma mark - 读取累计总步数
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
#pragma mark - 读取当天总步数
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
    NSNumber* hour = [BTUtils getHour:localeDate];
    
    
    //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND hour == %@ AND type == %@",year, month, day, hour, [NSNumber numberWithInt:type]];
    
    int stepCount = 0;
    
    NSArray *array = [BTGetData getFromCoreDataWithPredicate:predicate entityName:@"BTRawData" sortKey:nil];
    for (BTRawData* one in array) {
        stepCount += [one.count intValue];
        
    }
    NSLog(@"当天总步数%d",stepCount);
    
    //
    return stepCount;
    
}

//根据图片数目添加图片
//- (void)addImageViewByNumber:(NSInteger)imageNumber
//{
//    int lineNumber = imageNumber/2.0 + 0.5;
//    //创建imageView
//    CGFloat x = kPhysicalImageX, y = kPhysicalImageY;
//    for (int i = 0; i < lineNumber; i++) {
//        if ((i == (int)lineNumber - 1) && imageNumber % 2 != 0) {
//            UIImageView *aImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demo1.png"]];
//            aImageView.frame = CGRectMake(x, y, kPhysicalImageWidth, kPhysicalImageHeight);
//            aImageView.backgroundColor = [UIColor whiteColor];
//            aImageView.tag = 100 + 2 *i;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
//            [aImageView addGestureRecognizer:tap];
//            aImageView.userInteractionEnabled = YES;
//            [_aScrollView addSubview:aImageView];
//            x += self.view.frame.size.width - kPhysicalImageX * 2 - kPhysicalImageWidth;
//            
//        }
//        else
//        {
//            for (int j = 0; j < 2; j++) {
//                UIImageView *aImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demo1.png"]];
//                aImageView.frame = CGRectMake(x, y, kPhysicalImageWidth, kPhysicalImageHeight);
//                aImageView.backgroundColor = [UIColor whiteColor];
//                aImageView.tag = 100 + 2 *i + j;
//                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
//                [aImageView addGestureRecognizer:tap];
//                aImageView.userInteractionEnabled = YES;
//                [_aScrollView addSubview:aImageView];
//                x += self.view.frame.size.width - kPhysicalImageX * 2 - kPhysicalImageWidth;
//            }
//        }
//        x = kPhysicalImageX;
//        y += kPhysicalImageHeight + 10;
//    }
//}

#pragma mark - 点击图片触发事件
//- (void)doTap:(UITapGestureRecognizer *)tap
//{
//    NSLog(@"点击的图片的tag值是 %d",tap.view.tag);
//    //tag值100 表示运动  101表示胎动
//    switch (tap.view.tag) {
//        case 100:
//        {
//            BTPhysicSportViewController *sportVC = [[BTPhysicSportViewController alloc] init];
//            sportVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sportVC animated:YES];
//            break;
//        }
//            case 101:
//        {
//            BTPhysicQuickeningViewController *quickeningVC = [[BTPhysicQuickeningViewController alloc] init];
//            quickeningVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:quickeningVC animated:YES];
//
//            break;
//        }
//        default:
//            break;
//    }
// }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
