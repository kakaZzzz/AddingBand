//
//  BTPhysicalViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTPhysicalViewController.h"
#import "BTPhysicSportViewController.h"
#import "LayoutDef.h"
#import "CircularProgressView.h"
#import "BTGetData.h"
#import "PICircularProgressView.h"
#import "BTColor.h"
#import "BTUtils.h"
#import "BTRawData.h"

#import "MHTabBarController.h"
#import "BTWeightViewController.h"
#import "BTHeightViewController.h"
#import "BTGirthViewController.h"
#import "BTGluViewController.h"
#import "BTBPViewController.h"
#import "BTMamaDetailViewController.h"//妈妈体征详情页面
#import "BTFetalViewController.h"//胎动详情
#import "BTBabyFetalViewController.h"//胎心详情
#import "BTBabyWeightViewController.h"//胎儿体重详情
#import "BTFetalDailyViewController.h"//每日胎动页面
#import "BTPhysicalCell.h"
#import "BTPhisicalModel.h"

//布局宏
#define kImageBgX 0
#define kImageBgY 0
#define kImageBgWidth 320
#define kImageBgHeight 220

#define kGradeImageWidth 200
#define kGradeImageHeight 160
@interface BTPhysicalViewController ()

@property(nonatomic,strong)NSArray *textLabelArray;
@property(nonatomic,strong)NSArray *detailTextArray;

@end

@implementation BTPhysicalViewController

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
    
    [self addSubviews];//加载子视图

    // Do any additional setup after loading the view.
}
#pragma mark - 开始配置背景色
- (void)addSubviews
{
    
    
    //背景粉红图
    if (IOS7_OR_LATER) {
        self.aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageBgX, -20, kImageBgWidth, kImageBgHeight)];
    }
    else
    {
        self.aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageBgX, kImageBgY, kImageBgWidth, kImageBgHeight)];
    }
    _aImageView.image = [UIImage imageNamed:@"physical_top_bg@2x"];
    [self.scrollView addSubview:_aImageView];
    
    //分数
    self.gradeImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kGradeImageWidth,_aImageView.frame.size.height - kGradeImageHeight, kGradeImageWidth, kGradeImageHeight)];
    _gradeImage.image = [UIImage imageNamed:@"physical_grade@2x"];
    
    [_aImageView addSubview:_gradeImage];
    

    [self addPhysicalTableView];
    [self addBabyPhysicalView];
}

#pragma mark - 添加弧形的进度条
- (void)addGradeCircular
{
    self.progressView = [[PICircularProgressView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 160)/2, 20, 160, 160)];
    
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
    
    [self.scrollView addSubview:_progressView];
	// Do any additional setup after loading the view.
    
    //加入计时器 动态绘制出进度
    _timer =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    
}
- (void)progressChange
{

    if (_progressView.progress >= _progress) {
        
    [_timer invalidate];
        
    }
    else
    {
        _progressView.progress += 0.01;
    }
    
}



#pragma mark - 配置体征tableView
- (void)addPhysicalTableView
{
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.textLabelArray = [NSArray arrayWithObjects:@"运动量",@"体   重",@"宫   高",@"腹   围",@"血   糖",@"血   压", nil];
    self.detailTextArray = [NSArray arrayWithObjects:@"70%",@"72kg",@"16cm",@"88cm",@"",@"120/80", nil];

    for (int i = 0; i <6; i ++) {
        BTPhisicalModel *model = [[BTPhisicalModel alloc] initWithTitle:[self.textLabelArray objectAtIndex:i] content:[self.detailTextArray objectAtIndex:i]];
        [self.dataArray addObject:model];
    }
    
    self.tableView.rowHeight = 60;
     //加载tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _aImageView.frame.origin.y + _aImageView.frame.size.height, 320,360)];
   // _tableView.backgroundColor = [UIColor redColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.scrollView addSubview:_tableView];

}
#pragma mark - 配置胎儿体征三个页面
- (void)addBabyPhysicalView
{
    UIButton *buttonWeight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonWeight.frame = CGRectMake(15, self.tableView.frame.origin.y + self.tableView.frame.size.height -80, 90, 90);
    [buttonWeight setBackgroundImage:[UIImage imageNamed:@"baby_weight_unsel@2x"] forState:UIControlStateNormal];
    [buttonWeight setBackgroundImage:[UIImage imageNamed:@"baby_weight_sel@2x"] forState:UIControlStateHighlighted];
    [buttonWeight addTarget:self action:@selector(enterBabyWeigh) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:buttonWeight];
    
    UIButton *buttonfetalCount = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonfetalCount.frame = CGRectMake(buttonWeight.frame.origin.x + buttonWeight.frame.size.width + 10, buttonWeight.frame.origin.y, 90, 90);
    [buttonfetalCount setBackgroundImage:[UIImage imageNamed:@"Fetal_count_unsel@2x"] forState:UIControlStateNormal];
    [buttonfetalCount setBackgroundImage:[UIImage imageNamed:@"Fetal_count_sel@2x"] forState:UIControlStateHighlighted];

    [buttonfetalCount addTarget:self action:@selector(enterBabyFetalCount) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:buttonfetalCount];

    UIButton *buttonfetal = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonfetal.frame = CGRectMake(buttonfetalCount.frame.origin.x + buttonfetalCount.frame.size.width + 10, buttonWeight.frame.origin.y, 90, 90);
    [buttonfetal setBackgroundImage:[UIImage imageNamed:@"fetal_unsel@2x"] forState:UIControlStateNormal];
    [buttonfetal setBackgroundImage:[UIImage imageNamed:@"fetal_sel@2x"] forState:UIControlStateHighlighted];

    [buttonfetal addTarget:self action:@selector(enterenterBabyFetal) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:buttonfetal];

    //设置一下滚动视图的contentsize
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, buttonfetal.frame.origin.y + buttonfetal.frame.size.height + 60);
}

- (void)enterBabyWeigh
{
    //胎儿体重
    BTBabyWeightViewController *weightVC = [[BTBabyWeightViewController alloc] init];
    weightVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:weightVC animated:YES];

}
- (void)enterBabyFetalCount
{
    //胎动详情
    BTFetalDailyViewController *fetalVC = [[BTFetalDailyViewController alloc] init];
    fetalVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fetalVC animated:YES];

}
- (void)enterenterBabyFetal
{   //胎心
    BTBabyFetalViewController *fetalVC = [[BTBabyFetalViewController alloc] init];
    fetalVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fetalVC animated:YES];

    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
     return 6 ;
}


////动态改变每一行的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 60;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BTPhysicalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BTPhysicalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    BTPhisicalModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.physicalModel = model;
    
    return cell;

}

#pragma mark - tabelview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.row) {
        case 0://运动量
        {
            BTPhysicSportViewController *sportVC = [[BTPhysicSportViewController alloc] init];
            sportVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sportVC animated:YES];
        }
            break;
        case 1://妈妈体重
        {
            BTWeightViewController *weightlVC = [[BTWeightViewController alloc] init];
            weightlVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:weightlVC animated:YES];

        }
            break;
        case 2://宫高
        {
             BTHeightViewController *heightVC = [[BTHeightViewController alloc] init];
            heightVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:heightVC animated:YES];
            
        }
            break;
    
        case 3://腹围
        {
            BTGirthViewController *girthVC = [[BTGirthViewController alloc] init];
            girthVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:girthVC animated:YES];
            
        }
            break;

        case 4://血糖
        {
            BTGluViewController *gluVC = [[BTGluViewController alloc] init];

            gluVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gluVC animated:YES];
            
        }
            break;

        case 5://血压
        {
           BTBPViewController *bpVC = [[BTBPViewController alloc] init];
           bpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bpVC animated:YES];
            
        }
            break;

        default:
            break;
    }
    
}


#pragma mark - 视图将要出现的时候更新进度条
- (void)viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:animated];
    NSLog(@"视图出现出现出现.....");
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
   // [self addGradeCircular];
    int i = [self getDailyStep];
    NSLog(@"走了多少步%d",i);
    //判断保证内圆为0的时候没有凸来的圆角矩形
    if (i == 0) {
        self.progressView.roundedHead = NO;
    }
    else{
        self.progressView.roundedHead = YES;
    }
    _progress = i/10000.0;//此处1000是目标值 记得改 另外改了之后也要改柱状图内部
    NSLog(@"进度是%f",_progress);
   
    NSString *strProgress = [NSString stringWithFormat:@"%0.1f%%",_progress*100];
    BTPhisicalModel *model = [[BTPhisicalModel alloc] initWithTitle:@"运动量" content:strProgress];
   // self.detailTextArray = [NSArray arrayWithObjects:strProgress,@"72kg",@"16cm",@"88cm",@"88cm",@"120/80", nil];
    [self.dataArray replaceObjectAtIndex:0 withObject:model];
    [self.tableView reloadData];//既可以刷新数据 又可以取消某一行的选中状态
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.progressView removeFromSuperview];
    
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
  //  NSNumber* hour = [BTUtils getHour:localeDate];
    
    
    //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND type == %@",year, month, day, [NSNumber numberWithInt:type]];
    
    int stepCount = 0;
    
    NSArray *array = [BTGetData getFromCoreDataWithPredicate:predicate entityName:@"BTRawData" sortKey:nil];
    for (BTRawData* one in array) {
        stepCount += [one.count intValue];
        
    }
    NSLog(@"当天总步数%d",stepCount);
    
    //
    return stepCount;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
