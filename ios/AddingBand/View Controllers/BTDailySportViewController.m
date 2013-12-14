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
    _barChart.customBarWidth = 40.0f;//柱子宽度 ，外部可以修改  根据柱子的个数灵活改变柱子的宽度
     [self.view addSubview:_barChart];
    
    NSArray *array = [_barChart createChartDataWithTitles:self.xLableArray
                                                   values:self.yValueArray

                                                   colors:[NSArray arrayWithObjects:@"87E317", nil]

                                              labelColors:[NSArray arrayWithObjects:@"87E317", nil]
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
    self.xLableArray = [NSMutableArray arrayWithCapacity:1];
    self.yValueArray = [NSMutableArray arrayWithObject:@"0.1"];
    
    //以下配置数据
    //获取当前时间
    NSDate *localDate = [NSDate localdate];
    
    //分割出年月日小时
    NSNumber* year = [BTUtils getYear:localDate];
    NSNumber* month = [BTUtils getMonth:localDate];
    NSNumber* day = [BTUtils getDay:localDate];
    
    [self.xLableArray addObject:[NSString stringWithFormat:@"%@月%@日",month,day]];
    
    //
     NSPredicate *predicateDevice = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND type == %@",year,month,day,[NSNumber numberWithDouble:DEVICE_SPORT_TYPE]];
    //取出记录时间数组
    NSArray *rawArrayDevice = [BTGetData getFromCoreDataWithPredicate:predicateDevice entityName:@"BTRawData" sortKey:nil];
    int count = 0;
    for (BTRawData *raw in rawArrayDevice) {
        count +=[raw.count intValue];
    }
    if (count > 0) {
        [self.yValueArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",count]];

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
