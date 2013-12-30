//
//  BTGirthViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-3.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTGirthViewController.h"
#import "FYChartView.h"
#import "BTPhysicalModel.h"
#import "LayoutDef.h"
#import "BTView.h"
#import "BTSheetPickerview.h"

@interface BTGirthViewController ()<FYChartViewDataSource>
@property(nonatomic,strong)UIScrollView *chartScrollView;
@property (nonatomic, retain) FYChartView *chartView;
@property (nonatomic, retain) NSArray *values;

@end

#define ARC4RANDOM_MAX  0x100000000

@implementation BTGirthViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"腹围";
    
    self.chartScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, RED_BACKGROUND_HEIGHT)];
    _chartScrollView.contentSize = CGSizeMake(1200, 200);
    _chartScrollView.scrollEnabled = NO;
    _chartScrollView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_chartScrollView];
    
    [self drawLineChartView];
    
    
    
    
  
    
    //腹围
    BTView *weightView = [[BTView alloc] initWithFrame:CGRectMake(0, _chartScrollView.frame.origin.y + _chartScrollView.frame.size.height, 320, 112/2)];
    weightView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:weightView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(weightView.frame.origin.x + 36/2, 10, 80, 30)];
    titleLabel.textColor = [UIColor colorWithRed:94/255.0 green:101.0/255.0 blue:113/255.0 alpha:1.0];
    titleLabel.backgroundColor = [UIColor blueColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    titleLabel.text = @"目前腹围:";
    [weightView addSubview:titleLabel];
    
    self.weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width, titleLabel.frame.origin.y, 170, 30)];
    _weightLabel.textColor = [UIColor colorWithRed:145/255.0 green:154/255.0 blue:170/255.0 alpha:1.0];
    _weightLabel.backgroundColor = [UIColor yellowColor];
    _weightLabel.textAlignment = NSTextAlignmentLeft;
    _weightLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _weightLabel.text = @"15cm";
    [weightView addSubview:_weightLabel];
    
    //修改按钮
    UIButton *modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [modifyButton setTitle:@"修改" forState:UIControlStateNormal];
    modifyButton.backgroundColor = [UIColor redColor];
    [modifyButton addTarget:self action:@selector(modifyData:) forControlEvents:UIControlEventTouchUpInside];
    modifyButton.frame = CGRectMake(320 - 10 - 40, (weightView.frame.size.height - 40)/2, 40, 40);
    [weightView addSubview:modifyButton];

    //腹围情况
    
    BTView *weightConditionView = [[BTView alloc] initWithFrame:CGRectMake(0, weightView.frame.origin.y + weightView.frame.size.height, 320, 170/2)];
    weightConditionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:weightConditionView];
    
    
    //是否正常label
    self.weightConditionLabel = [[UILabel alloc] initWithFrame:CGRectMake((320 - weightConditionView.frame.size.height)/2, 0, weightConditionView.frame.size.height, weightConditionView.frame.size.height)];
    _weightConditionLabel.textColor = [UIColor colorWithRed:145/255.0 green:154/255.0 blue:170/255.0 alpha:1.0];
    _weightConditionLabel.backgroundColor = [UIColor redColor];
    _weightConditionLabel.textAlignment = NSTextAlignmentLeft;
    _weightConditionLabel.font = [UIFont systemFontOfSize:40];
    _weightConditionLabel.text = @"正常";
    [weightConditionView addSubview:_weightConditionLabel];
    
    
 	// Do any additional setup after loading the view.
}

#pragma mark - event
- (void)modifyData:(UIButton *)btn
{
    if (self.actionSheetView == nil) {
        self.actionSheetView = [[BTSheetPickerview alloc] initWithPikerType:BTActionSheetPickerStyleTextPicker referView:self.view delegate:self];
        //[_actionSheetView setIsRangePickerView:YES];
        NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:1];
        for (int i =50; i <= 150; i ++) {
            [array1 addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        for (int i = 0; i < 10; i ++) {
            [array2 addObject:[NSString stringWithFormat:@".%d",i]];
        }
        [_actionSheetView setTitlesForComponenets:[NSArray arrayWithObjects:
                                                   array1,
                                                   array2,
                                                   [NSArray arrayWithObjects:@"cm", nil],
                                                   nil]];
        
    }
    
    [_actionSheetView show];
    
    
}

#pragma mark - 输入宫高 选择器delegate
- (void)actionSheetPickerView:(BTSheetPickerview *)pickerView didSelectTitles:(NSArray*)titles
{
    
    //对选择结果进行处理
    NSString *str = [NSString stringWithFormat:@"%@%@%@",[titles objectAtIndex:0],[titles objectAtIndex:1],[titles objectAtIndex:2]];
    self.weightLabel.text = str;

    NSLog(@"选择的宫高是%@",titles);
    
}

#pragma mark - 绘制折线图
- (void)drawLineChartView
{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < 280; i++)
    {
        double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f);
        
        BTPhysicalModel *model = [[BTPhysicalModel alloc] initWithTitle:@"体重" content:[NSString stringWithFormat:@"%0.2f",val] day:[NSString stringWithFormat:@"%d",i+1]];
        [array addObject:model];
    }
    self.values = array;
    
    self.chartView = [[FYChartView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1200.0f, RED_BACKGROUND_HEIGHT)];
    self.chartView.hideDescriptionViewWhenTouchesEnd = YES;
    self.chartView.backgroundColor = kGlobalColor;
    self.chartView.rectangleLineColor = [UIColor grayColor];
    self.chartView.lineColor = [UIColor whiteColor];
    self.chartView.dataSource = self;
    
    self.chartView.modelArray = self.values;
    [self.chartScrollView addSubview:self.chartView];
    
    
    
    
}

#pragma mark - FYChartViewDataSource

//number of value count
- (NSInteger)numberOfValueItemCountInChartView:(FYChartView *)chartView;
{
    //return self.values ? self.values.count : 0;
    return 20;
}


//horizontal title alignment at index
- (HorizontalTitleAlignment)chartView:(FYChartView *)chartView horizontalTitleAlignmentAtIndex:(NSInteger)index
{
    HorizontalTitleAlignment alignment = HorizontalTitleAlignmentCenter;
    if (index == 0)
    {
        alignment = HorizontalTitleAlignmentCenter;
    }
    else if (index == self.values.count - 1)
    {
        alignment = HorizontalTitleAlignmentRight;
    }
    
    return alignment;
}

//description view at index
- (UIView *)chartView:(FYChartView *)chartView descriptionViewAtIndex:(NSInteger)index model:(BTPhysicalModel *)model
{
    
    
    //显示第几周第几周第几天 体重
    int week = [model.day intValue]%7 == 0  ? [model.day intValue]/7 : ([model.day intValue]/7 + 1);
    int day = [model.day intValue]%7 == 0 ? 7 : [model.day intValue]%7;
    
    //如何根据 index找到model
    NSString *description = [NSString stringWithFormat:@"孕%d周%d天\n %0.1fkg", week,day,[model.content floatValue]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"markview_ba_middle"]];
    imageView.frame = CGRectMake(0,0, 91/2, 85/2);
    // imageView.backgroundColor = [UIColor redColor];
    CGRect frame = imageView.frame;
    frame.size = CGSizeMake(80.0f, 40.0f);
    imageView.frame = frame;
    UILabel *label = [[UILabel alloc]
                      initWithFrame:CGRectMake(10.0f, -5.0f, imageView.frame.size.width, imageView.frame.size.height)];
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = kGlobalColor;
    label.text = description;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:10.0f];
    [imageView addSubview:label];
    
    return imageView;
    
    //  return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
