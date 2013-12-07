//
//  BTWeightViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-3.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTWeightViewController.h"
#import "PCLineChartView.h"
@interface BTWeightViewController ()

@end

@implementation BTWeightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"视图加载加载");

    if (_lineChartView == nil) {
        [self drawLineChartView];
        
    }
    NSLog(@"****************%@",_lineChartView);

	// Do any additional setup after loading the view.
}
#pragma mark - 绘制折线图
- (void)drawLineChartView
{
    NSLog(@"绘制折线图");
    _lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(0,-25,240,100)];
  //  [_lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];//为什么加了这句之后就不调用drawRect:
  //  [_lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    _lineChartView.minValue = 40;
  //  _lineChartView.backgroundColor = [UIColor yellowColor];
    _lineChartView.maxValue = 90;
    [self.view addSubview:_lineChartView];
    
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
- (void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
