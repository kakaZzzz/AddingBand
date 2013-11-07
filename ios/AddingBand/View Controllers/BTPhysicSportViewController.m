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

@implementation BTPhysicSportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //注册同步的观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCircularProgress:) name:UPDATACIRCULARPROGRESSNOTICE object:nil];
        //添加圆形进度条 和 Label
        [self addCircleProgress];
        //添加柱状图
        [self loadBarChartUsingArray];
        //添加同步按钮
        [self addSycnButton];

    }
    return self;
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
    [self.circularProgressView updateProgressCircle:1000 withTotal:12000];
    NSLog(@"要更新数据了");

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
