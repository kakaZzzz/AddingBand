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

#define klineScrollViewContentSizeX (320 *2 + 100)
static int offsetX = 0;
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
    //可左右滑动视图
        
    self.lineScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320,368/2)];
    _lineScrollView.contentSize = CGSizeMake(klineScrollViewContentSizeX, _lineScrollView.frame.size.height);
    _lineScrollView.backgroundColor = kGlobalColor;
    [self.view addSubview:_lineScrollView];
    //动画效果 改变偏移量
    [self changeScrollViewContentOffsetWithOffset:offsetX animated:YES];
  
    _barChart = [[BarChartView alloc] initWithFrame:CGRectMake(-20, 0, 640 + 100, 368/2)];//柱形图背景大小
    _barChart.target = self;
    _barChart.backgroundColor = [UIColor clearColor];
    _barChart.customBarWidth = 21.0f;//柱子宽度 ，外部可以修改  根据柱子的个数灵活改变柱子的宽度
    [self.lineScrollView addSubview:_barChart];
  
    NSArray *array = [_barChart createChartDataWithTitles:self.xLableArray
                                                   values:self.yValueArray
                      
                                                   colors:self.barColorsArray
                      
                                              labelColors:self.labelColorsArray
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
- (void)configureBarViewAllDatas
{
    
    
    NSArray *arrayXlabel = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14", @"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",nil];
    NSArray *arrayYvalue = [NSArray arrayWithObjects:@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1",@"0.1", nil];
    NSArray *arraybarColor = [NSArray arrayWithObjects:@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe",@"ffaebe", nil];
    NSArray *arraylabelColor = [NSArray arrayWithObjects:@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff", nil];
    
    
    //首先得到这个月有多少天  按天存放数据
    NSDate *localeDate = [NSDate localdate];
    //分割出年月日小时
    NSNumber* year = [BTUtils getYear:localeDate];
    NSNumber* month = [BTUtils getMonth:localeDate];
    //NSNumber* day = [BTUtils getDay:localeDate];
    int daysCount = [NSDate dayOfMonthWithYear:[year intValue] Month:[month intValue]];
    NSRange range;
    range.location = 0;
    range.length = daysCount;
    self.xLableArray =[arrayXlabel subarrayWithRange:range];
    self.yValueArray =[NSMutableArray arrayWithArray:[arrayYvalue subarrayWithRange:range]];
    self.barColorsArray = [arraybarColor subarrayWithRange:range];
    self.labelColorsArray = [arraylabelColor subarrayWithRange:range];
    
 
    int count = 0;
    for (int i =0; i < 31; i ++) {
        NSPredicate *predicateDevice = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND type == %@",year,month,[NSNumber numberWithInt:i+1],[NSNumber numberWithDouble:DEVICE_SPORT_TYPE]];
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
#pragma mark - 动态的改变scrollview的偏移量
- (void)changeScrollViewContentOffsetWithOffset:(int)offSetX animated:(BOOL)animated
{
    
    int k = ((klineScrollViewContentSizeX)/31) * offSetX;
    if (k < 320/2) {
        k = 0;
    }
    else{
        k = k - 320/2;
    }
    
    if (animated) {
        //动画效果 改变偏移量
        [UIView animateWithDuration:1.0 animations:^{
            
            [self.lineScrollView setContentOffset:CGPointMake(k, 0) animated:YES];
            
        }];
    }
    
    else{
        [self.lineScrollView setContentOffset:CGPointMake(k, 0) animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
