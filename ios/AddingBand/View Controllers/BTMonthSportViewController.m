//
//  BTMonthSportViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-12.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTMonthSportViewController.h"
#import "NSDate+DateHelper.h"
#import "BarChartView.h"
#import "BTUtils.h"
#import "BTGetData.h"
#import "LayoutDef.h"
#import "BTRawData.h"
@interface BTMonthSportViewController ()

@end

@implementation BTMonthSportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    
    NSLog(@"viewWillAppear");
    [_barChart animateBars];//每次出现的时候动态绘制柱状图
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureBarViewAllDatas];
    [self loadBarChartUsingArray];
    
	// Do any additional setup after loading the view.
}
#pragma mark - loadBarChart  加载柱形图
- (void)loadBarChartUsingArray {
    //Generate properly formatted data to give to the bar chart
    //横坐标元素
    /*   在此传入横坐标名称  柱子表示的数值  柱子颜色  以及label中字体颜色 */
    
    _barChart = [[BarChartView alloc] initWithFrame:CGRectMake(0, 40, 320, 300)];//柱形图背景大小
    _barChart.backgroundColor = [UIColor clearColor];
    _barChart.customBarWidth = 7.0f;//柱子宽度 ，外部可以修改  根据柱子的个数灵活改变柱子的宽度
    [self.view addSubview:_barChart];
    
    NSArray *array = [_barChart createChartDataWithTitles:self.xLableArray
                                                   values:self.yValueArray
                      
                                                   colors:[NSArray arrayWithObjects:@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317", nil]
                      
                                              labelColors:[NSArray arrayWithObjects:@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317", nil]
                      ];
    
    
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
                      withColor:[UIColor blueColor]//指示坐标颜色 Y轴颜色
        shouldPlotVerticalLines:YES];
}
- (void)configureBarViewAllDatas
{
    self.xLableArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14", @"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",nil];
    self.yValueArray = [NSMutableArray arrayWithCapacity:1];
    self.yValueArray = [NSMutableArray arrayWithObjects:@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50",@"50", nil];
    
    //首先得到这个月有多少天
    int daysCount = [[NSDate date] monthOfDay];
    NSLog(@"这一个月有多少天  %d",daysCount);
}


//首先得到这个月有多少天

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
