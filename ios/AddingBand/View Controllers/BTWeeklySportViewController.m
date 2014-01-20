//
//  BTWeeklySportViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-12.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTWeeklySportViewController.h"
#import "NSDate+DateHelper.h"
#import "BarChartView.h"
#import "BTUtils.h"
#import "BTGetData.h"
#import "LayoutDef.h"
#import "BTRawData.h"

@interface BTWeeklySportViewController ()

@end

@implementation BTWeeklySportViewController

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
    
    [_barChart animateBars];//每次出现的时候动态绘制柱状图
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    NSDate *date = [[NSDate alloc] init];
    NSDate *dateBegin = [date beginningOfWeek];
    NSArray *arrayWeek = [self getDateOfWeeklyWithFirstdayOfWeek:dateBegin];

    [self configureBarViewAllDatasWithWeekdays:arrayWeek];
    NSLog(@"周运动量==========%@",self.yValueArray);
    [self loadBarChartUsingArray];
    
}
- (void)updateViewWithWeekBeginDate:(NSDate *)date
{
    if (self.lineScrollView) {
        [_lineScrollView removeFromSuperview];
        NSArray *arrayWeek = [self getDateOfWeeklyWithFirstdayOfWeek:date];
        [self configureBarViewAllDatasWithWeekdays:arrayWeek];
        [self loadBarChartUsingArray];

    }

}
#pragma mark - loadBarChart  加载柱形图
- (void)loadBarChartUsingArray {
    //Generate properly formatted data to give to the bar chart
    //横坐标元素
    /*   在此传入横坐标名称  柱子表示的数值  柱子颜色  以及label中字体颜色 */
    
    self.lineScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320,368/2)];
    _lineScrollView.contentSize = CGSizeMake(320, _lineScrollView.frame.size.height);
    _lineScrollView.backgroundColor = kGlobalColor;
    _lineScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_lineScrollView];
 
    
    _barChart = [[BarChartView alloc] initWithFrame:CGRectMake(-20, 0, 320, 368/2)];//柱形图背景大小
    _barChart.backgroundColor = [UIColor clearColor];
    _barChart.customBarWidth = 40.0f;//柱子宽度 ，外部可以修改  根据柱子的个数灵活改变柱子的宽度
    [self.lineScrollView addSubview:_barChart];
    
    NSArray *array = [_barChart createChartDataWithTitles:self.xLableArray
                                                   values:self.yValueArray
                      
                                                   colors:[NSArray arrayWithObjects:@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",nil]
                      
                                              labelColors:[NSArray arrayWithObjects:@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff", nil]
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
                      withColor:[UIColor clearColor]//指示坐标颜色 Y轴颜色
        shouldPlotVerticalLines:NO];
}

- (NSArray *)getDateOfWeeklyWithFirstdayOfWeek:(NSDate *)date
{
    
   
    //将日期加8小时
    
    NSLog(@"周一对应日期  %@",date);
    NSLog(@"周二对应日期  %@",[date addDay:1]);
    NSLog(@"周三对应日期  %@",[date addDay:2]);
    NSLog(@"周四对应日期  %@",[date addDay:3]);
    NSLog(@"周五对应日期  %@",[date addDay:4]);
    NSLog(@"周六对应日期  %@",[date addDay:5]);
    NSLog(@"周日对应日期  %@",[date addDay:6]);
    
    NSDate *date1 = date;
    NSDate *date2 = [date addDay:1];
    NSDate *date3 = [date addDay:2];
    NSDate *date4 = [date addDay:3];
    NSDate *date5 = [date addDay:4];
    NSDate *date6 = [date addDay:5];
    NSDate *date7 = [date addDay:6];
    
  NSArray *dateArray = [NSArray arrayWithObjects:date1,date2,date3,date4,date5,date6,date7, nil];
    return dateArray;
    
}

- (void)configureBarViewAllDatasWithWeekdays:(NSArray *)weekArray
{
    
    self.xLableArray = [NSArray arrayWithObjects:@"周一",@"二",@"三",@"四",@"五",@"六",@"日", nil];
   self.yValueArray = [NSMutableArray arrayWithCapacity:1];
    self.yValueArray = [NSMutableArray arrayWithObjects:@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1", nil];
    
    
    
    //
    for (int i = 0; i < 7; i ++) {
        
        NSDate *date = [weekArray objectAtIndex:i];
        //分割出年月日小时
        NSNumber* year = [BTUtils getYear:date];
        NSNumber* month = [BTUtils getMonth:date];
        NSNumber* day = [BTUtils getDay:date];

        
        NSPredicate *predicateDevice = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND type == %@",year,month,day,[NSNumber numberWithDouble:DEVICE_SPORT_TYPE]];
        //取出记录时间数组
        NSArray *rawArrayDevice = [BTGetData getFromCoreDataWithPredicate:predicateDevice entityName:@"BTRawData" sortKey:nil];
        int count = 0;
        for (BTRawData *raw in rawArrayDevice) {
            count +=[raw.count intValue];
        }
        if (count > 0) {
        [self.yValueArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",count]];

        }
        
      }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
