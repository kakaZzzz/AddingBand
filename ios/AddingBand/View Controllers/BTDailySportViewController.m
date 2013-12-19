//
//  BTDailySportViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-12.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTDailySportViewController.h"
#import "BarChartView.h"
#import "BTUtils.h"
#import "BTGetData.h"
#import "LayoutDef.h"
#import "BTRawData.h"
#import "NSDate+DateHelper.h"//NSDate的类目


static int offsetX = 0;
@interface BTDailySportViewController ()

@end

@implementation BTDailySportViewController

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
    NSLog(@"viewWillAppear--");//备注此方法在第一次出现时 居然不走~~奇葩
    [_barChart animateBars];//每次出现的时候动态绘制柱状图

}
- (void)viewWillDisappear:(BOOL)animated
{
     NSLog(@"viewWillDisappear--");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getEveryHourData];
    [self loadBarChartUsingArray];
    
	// Do any additional setup after loading the view.
}
#pragma mark - loadBarChart  加载柱形图
- (void)loadBarChartUsingArray {
    //Generate properly formatted data to give to the bar chart
    //横坐标元素
    /*   在此传入横坐标名称  柱子表示的数值  柱子颜色  以及label中字体颜色 */
    self.lineScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320,200)];
    _lineScrollView.contentSize = CGSizeMake(320 *2 + 100, _lineScrollView.frame.size.height);
    _lineScrollView.backgroundColor = kGlobalColor;
    [self.view addSubview:_lineScrollView];
    
    //动画效果 改变偏移量
    [UIView animateWithDuration:1.0 animations:^{
        
        int k = ((320 *2 + 100)/24) * offsetX;
        if (k < 160) {
            k = 0;
        }
        else{
            k = k - 160;
        }
        [self.lineScrollView setContentOffset:CGPointMake(k, 0) animated:YES];
    }];
    
    _barChart = [[BarChartView alloc] initWithFrame:CGRectMake(-20, 0, 640 + 100, 200)];//柱形图背景view大小
    _barChart.backgroundColor = [UIColor clearColor];
    _barChart.customBarWidth = 21.0f;//柱子宽度 ，外部可以修改  根据柱子的个数灵活改变柱子的宽度
     [self.lineScrollView addSubview:_barChart];
    
    NSArray *array = [_barChart createChartDataWithTitles:self.xLableArray
                                                   values:self.yValueArray

                                                   colors:[NSArray arrayWithObjects:@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe", nil]

                                              labelColors:[NSArray arrayWithObjects:@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff", nil]
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


//- (void)configureBarViewAllDatas
//{
//    self.xLableArray = [NSMutableArray arrayWithCapacity:1];
//    self.yValueArray = [NSMutableArray arrayWithObject:@"0.1"];
//    
//    //以下配置数据
//    //获取当前时间
//    NSDate *localDate = [NSDate localdate];
//    
//    //分割出年月日小时
//    NSNumber* year = [BTUtils getYear:localDate];
//    NSNumber* month = [BTUtils getMonth:localDate];
//    NSNumber* day = [BTUtils getDay:localDate];
//    
//    [self.xLableArray addObject:[NSString stringWithFormat:@"%@月%@日",month,day]];
//    
//    //
//     NSPredicate *predicateDevice = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND type == %@",year,month,day,[NSNumber numberWithDouble:DEVICE_SPORT_TYPE]];
//    //取出记录时间数组
//    NSArray *rawArrayDevice = [BTGetData getFromCoreDataWithPredicate:predicateDevice entityName:@"BTRawData" sortKey:nil];
//    int count = 0;
//    for (BTRawData *raw in rawArrayDevice) {
//        count +=[raw.count intValue];
//    }
//    if (count > 0) {
//        [self.yValueArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",count]];
//
//    }
//    
//}
#pragma mark - 得到每小时的数据
- (void)getEveryHourData
{
    
    self.xLableArray = [NSMutableArray arrayWithCapacity:1];
    self.xLableArray = [NSMutableArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
    self.yValueArray = [NSMutableArray arrayWithObjects:@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1", nil];

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
    
    int count = 0;
    for (int i =0; i < 24; i ++) {
        NSPredicate *predicateDevice = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND hour == %@ AND type == %@",year,month,day,[NSNumber numberWithInt:i],[NSNumber numberWithDouble:DEVICE_SPORT_TYPE]];
            //取出记录时间数组
        NSArray *rawArrayDevice = [BTGetData getFromCoreDataWithPredicate:predicateDevice entityName:@"BTRawData" sortKey:nil];
        
        for (BTRawData *raw in rawArrayDevice) {
            count +=[raw.count intValue];
        }
        
        if (count >0) {
            [self.yValueArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",count]];
            offsetX = i;
        }
               count = 0;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
