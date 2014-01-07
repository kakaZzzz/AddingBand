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
#import "BTView.h"
#import "BTUserData.h"
#import "BTUserSetting.h"//设置数据
#import "NSDate+DateHelper.h"

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
#import "BTUCViewController.h"//宫缩页面
#import "BTPhysicalCell.h"

#import "BTPhysicalCollectionView.h"//
#import "BTPhysicalModel.h"//体征数据model
//布局宏

#define NAVIGATIONBAR_Y 0
#define NAVIGATIONBAR_HEIGHT 65


#define kImageBgX 0
#define kImageBgY 0
#define kImageBgWidth 320
#define kImageBgHeight 220

#define kGradeImageWidth 200
#define kGradeImageHeight 160

static int selectedTag = 0;
@interface BTPhysicalViewController ()

@property(nonatomic,strong)NSArray *textLabelArray;
@property(nonatomic,strong)NSArray *detailTextArray;

@property(nonatomic,strong)UILabel *dateLabel;//3周4天
@property(nonatomic,strong)UILabel *countLabel;//预产期倒计时
@property(nonatomic,strong)UILabel *lastSyncTimeLabel;//上次同步时间
@property(nonatomic,strong)UILabel *progressLabel;//运动量进度
@property(nonatomic,strong)UILabel *goalLabel;//运动量目标Label
@property(nonatomic,strong)UILabel *fetalLabel;//运动量目标Label


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
   self.scrollView.contentSize = CGSizeMake(320, 800);
   
    [self addSubviews];//加载子视图
    
    // Do any additional setup after loading the view.
}
#pragma mark - 开始配置背景色
- (void)addSubviews
{
    
    self.navigationBgView = [[UIView alloc]init];
    if (IOS7_OR_LATER) {
        self.navigationBgView.frame = CGRectMake(0, 0, 320, 90/2 + 20);
    }
    
    else
    {
        self.navigationBgView.frame = CGRectMake(0, 0, 320, 90/2);
    }
    _navigationBgView.backgroundColor = kGlobalColor;
    [self.view addSubview:_navigationBgView];
    
    //navigationBgView上的子视图
    
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logo"]];
    iconImage.frame = CGRectMake(24/2, _navigationBgView.frame.size.height - 5 - 39, 39, 39);
    [_navigationBgView addSubview:iconImage];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.frame.origin.x + iconImage.frame.size.width + 10, iconImage.frame.origin.y, 100, 20)];
     _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.font = [UIFont systemFontOfSize:18];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.text = @"3周4天";
    [_navigationBgView addSubview:_dateLabel];
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.frame.origin.x + iconImage.frame.size.width + 10, _dateLabel.frame.origin.y + _dateLabel.frame.size.height, 200, 20)];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.font = [UIFont systemFontOfSize:15];
    _countLabel.textAlignment = NSTextAlignmentLeft;
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.text = @"预产期倒计时: 255天";
    [_navigationBgView addSubview:_countLabel];
    
    
    //分数背景view
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 90/2, 320, (406-90)/2)];
    _headView.backgroundColor = kGlobalColor;
    [self.scrollView addSubview:_headView];
    
    
    //手环同步背景
    BTView *syncBg = [[BTView alloc]initWithFrame:CGRectMake(0, _headView.frame.origin.y + _headView.frame.size.height, 320, 80/2)];
    // syncBg.backgroundColor = [UIColor redColor];
    syncBg.separationLine.frame = CGRectMake(0, syncBg.frame.size.height - kSeparatorLineHeight, 320, kSeparatorLineHeight);
    [self.scrollView addSubview:syncBg];
    
    UIImageView *handImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hand_icon"]];
    handImage.frame = CGRectMake(36/2, (syncBg.frame.size.height - 15)/2, 12, 15);
    [syncBg addSubview:handImage];
    
    self.lastSyncTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(handImage.frame.origin.x + handImage.frame.size.width, handImage.frame.origin.y - 2 , 200, 20)];
    //_lastSyncTimeLabel.backgroundColor = [UIColor redColor];
    _lastSyncTimeLabel.font = [UIFont systemFontOfSize:14];
    _lastSyncTimeLabel.textAlignment = NSTextAlignmentLeft;
    _lastSyncTimeLabel.textColor = kContentTextColor;
    _lastSyncTimeLabel.text = @"手环上次同步时间: 14:23";
    [syncBg addSubview:_lastSyncTimeLabel];
    
    UIButton *syncButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    syncButton.tag = PHYSICAL_CONTROL_TAG + 1;
    syncButton.frame = CGRectMake(320 - 36/2 - 24, (syncBg.frame.size.height - 24)/2, 24, 24);
    [syncButton setBackgroundImage:[UIImage imageNamed:@"sync_litbutton_bg"] forState:UIControlStateNormal];
    [syncBg addSubview:syncButton];
    
    //运动量完成情况
    BTView *sportProgressView = [[BTView alloc] initWithFrame:CGRectMake(0, syncBg.frame.origin.y + syncBg.frame.size.height, 320, 80)];
    sportProgressView.backgroundColor = [UIColor whiteColor];
    [sportProgressView addTarget:self action:@selector(enterSportView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:sportProgressView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(sportProgressView.frame.origin.x + 36/2, 10, 150, 30)];
    titleLabel.textColor = kBigTextColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    titleLabel.text = @"今日目标完成情况";
    [sportProgressView addSubview:titleLabel];
    
    UILabel *labelGoal = [[UILabel alloc] initWithFrame:CGRectMake(sportProgressView.frame.origin.x + 36/2, titleLabel.frame.origin.y + 30, 70, 30)];
    labelGoal.textColor = kContentTextColor;
    labelGoal.backgroundColor = [UIColor clearColor];
    labelGoal.textAlignment = NSTextAlignmentLeft;
    labelGoal.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    labelGoal.text = @"今日目标:";
    [sportProgressView addSubview:labelGoal];
    
    self.goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelGoal.frame.origin.x + labelGoal.frame.size.width, labelGoal.frame.origin.y, 100, 30)];
    _goalLabel.textColor = kContentTextColor;
    _goalLabel.backgroundColor = [UIColor clearColor];
    _goalLabel.textAlignment = NSTextAlignmentLeft;
    _goalLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _goalLabel.text = @"7000步";
    [sportProgressView addSubview:_goalLabel];
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - sportProgressView.frame.size.height - 80,0, 130,80)];
    _progressLabel.textColor = [UIColor colorWithRed:66/255.0 green:156/255.0 blue:239/255.0 alpha:1.0];
     _progressLabel.backgroundColor = [UIColor clearColor];
    _progressLabel.textAlignment = NSTextAlignmentRight;
    _progressLabel.font = [UIFont systemFontOfSize:50];
    _progressLabel.text = @"100";
    [sportProgressView addSubview:_progressLabel];
    
    //单独 百分号 label
    UILabel *bLabel = [[UILabel alloc] initWithFrame:CGRectMake(290, 40, 20,20)];
    bLabel.backgroundColor = [UIColor clearColor];
    bLabel.textColor = [UIColor colorWithRed:66/255.0 green:156/255.0 blue:239/255.0 alpha:1.0];
    bLabel.textAlignment = NSTextAlignmentCenter;
    bLabel.font = [UIFont systemFontOfSize:17];
    bLabel.text = @"%";
    [sportProgressView addSubview:bLabel];
    
    
    //记录胎动
    BTView *fetalView = [[BTView alloc] initWithFrame:CGRectMake(0, sportProgressView.frame.origin.y + sportProgressView.frame.size.height, 320, 80)];
    fetalView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:fetalView];
    
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(fetalView.frame.origin.x + 36/2, 10, 150, 30)];
    titleLabel.textColor = kBigTextColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    titleLabel.text = @"胎动次数";
    [fetalView addSubview:titleLabel];
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(fetalView.frame.origin.x + 36/2, titleLabel.frame.origin.y + 30, 50, 30)];
    label1.textColor = kContentTextColor;
    label1.backgroundColor = [UIColor clearColor];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    label1.text = @"月平均";
    [fetalView addSubview:label1];
    
    
    self.fetalLabel = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x + label1.frame.size.width, label1.frame.origin.y, 30, 30)];
    _fetalLabel.textColor = kContentTextColor;
    _fetalLabel.backgroundColor = [UIColor clearColor];
    _fetalLabel.textAlignment = NSTextAlignmentLeft;
    _fetalLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    _fetalLabel.text = @"30";
    [fetalView addSubview:_fetalLabel];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(_fetalLabel.frame.origin.x + _fetalLabel.frame.size.width, _fetalLabel.frame.origin.y, 50, 30)];
    label2.textColor = kContentTextColor;
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    label2.text = @"次/每天";
    [fetalView addSubview:label2];

    
    UIButton *recordFetal = [UIButton  buttonWithType:UIButtonTypeCustom];
    recordFetal.tag = PHYSICAL_CONTROL_TAG + 1;
    recordFetal.frame = CGRectMake(320 - 90 - 36/2, (fetalView.frame.size.height - 50)/2, 90, 50);
    [recordFetal addTarget:self action:@selector(enterFetalCountView:) forControlEvents:UIControlEventTouchUpInside];
    [recordFetal setBackgroundImage:[UIImage imageNamed:@"physical_fetal_unsel"] forState:UIControlStateNormal];
    [recordFetal setBackgroundImage:[UIImage imageNamed:@"physical_fetal_sel"] forState:UIControlStateSelected];
    [recordFetal setBackgroundImage:[UIImage imageNamed:@"physical_fetal_sel"] forState:UIControlStateHighlighted];
    [fetalView addSubview:recordFetal];
    
    
    
    
    //自定义collectionview  显示体重，宫高，腹围，B超，血压，宫缩数据
    
    [self addPhysicalViewWithDataWithYvalue:fetalView.frame.origin.y + fetalView.frame.size.height + 10];
    
    //加一条水平分割线
    UIImageView *sepLine1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horizontal_sep_line"]];
    sepLine1.frame = CGRectMake(6, _physicalView.frame.origin.y + _physicalView.frame.size.height + 5 , 320 -2 *6, 10);
    [self.scrollView addSubview:sepLine1];

    //孕期血糖 和胎心监测
    UIView *bloodView = [[UIView alloc] initWithFrame:CGRectMake(6, _physicalView.frame.origin.y + _physicalView.frame.size.height + 20, 320 -2 *6, 96/2)];
    bloodView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:bloodView];
    
    //孕期血糖按钮
    UIButton *bloodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bloodButton.backgroundColor = [UIColor whiteColor];
    bloodButton.frame = CGRectMake(0, 0, 304/2, 96/2);
    [bloodButton addTarget:self action:@selector(enterBloodView:) forControlEvents:UIControlEventTouchUpInside];
    [bloodView addSubview:bloodButton];
    
    UIImageView *bloodIconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"physical_blood_icon"]];
    bloodIconImage.frame = CGRectMake(12, 11, 26, 26);
    [bloodButton addSubview:bloodIconImage];
    
    UILabel *bloodLabel = [[UILabel alloc] initWithFrame:CGRectMake(bloodIconImage.frame.origin.x + bloodIconImage.frame.size.width + 18, bloodIconImage.frame.origin.y, 100, 26)];
    bloodLabel.textColor = kBigTextColor;
    bloodLabel.backgroundColor = [UIColor clearColor];
    bloodLabel.textAlignment = NSTextAlignmentLeft;
    bloodLabel.font = [UIFont systemFontOfSize:17];
    bloodLabel.text = @"孕期血糖";
    [bloodButton addSubview:bloodLabel];
    
    //加一条垂直分割线
    UIImageView *sepLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vertical_sep_line"]];
    sepLine.frame = CGRectMake(bloodButton.frame.origin.x + bloodButton.frame.size.width, 0, 4, bloodView.frame.size.height);
    [bloodView addSubview:sepLine];
    
    //胎心监测按钮
    
    UIButton *fetalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fetalButton.backgroundColor = [UIColor whiteColor];
    [fetalButton addTarget:self action:@selector(enterFetalView:) forControlEvents:UIControlEventTouchUpInside];
    fetalButton.frame = CGRectMake(bloodView.frame.size.width - 304/2, 0, 304/2, 96/2);
    [bloodView addSubview:fetalButton];
    
    UIImageView *fetalIconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"physical_fetal_icon"]];
    fetalIconImage.frame = CGRectMake(12, 11, 26, 26);
    [fetalButton addSubview:fetalIconImage];
    
    UILabel *fetalLabel = [[UILabel alloc] initWithFrame:CGRectMake(bloodIconImage.frame.origin.x + bloodIconImage.frame.size.width + 18, bloodIconImage.frame.origin.y, 100, 26)];
    fetalLabel.textColor = kBigTextColor;
    fetalLabel.backgroundColor = [UIColor clearColor];
    fetalLabel.textAlignment = NSTextAlignmentLeft;
    fetalLabel.font = [UIFont systemFontOfSize:17];
    fetalLabel.text = @"胎心检测";
    [fetalButton addSubview:fetalLabel];
    
}
#pragma mark - 从coredata中获取数据 用于显示体重 宫高 腹围
- (NSArray *)configureDataModelArray
{
    NSManagedObjectContext *contex = [BTGetData getAppContex];
    NSMutableArray *weightArray = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *heighttArray = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *girthArray = [NSMutableArray arrayWithCapacity:1];
   
    NSArray *dataArray = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserData" sortKey:nil];
    BTUserData *one = [[BTUserData alloc] initWithEntity:[NSEntityDescription entityForName:@"BTUserData" inManagedObjectContext:contex] insertIntoManagedObjectContext:contex];
    if (dataArray.count > 0) {
        for (BTUserData *userData in dataArray) {
            if (userData.weight) {
                [weightArray addObject:userData];
            }
            
            if (userData.fundalHeight) {
                [heighttArray addObject:userData];
            }
            
            if (userData.girth) {
                [girthArray addObject:userData];
            }
        }
        

    if ([weightArray count] == 0) {
        [weightArray addObject:one];
        
    }
    if ([heighttArray count] == 0) {
        [heighttArray addObject:one];
        
    }
    if ([girthArray count] == 0) {
        [girthArray addObject:one];
        
    }
        NSArray *resultArray = [NSArray arrayWithObjects:[weightArray lastObject], [heighttArray lastObject],[girthArray lastObject],nil];
        
        return resultArray;

}
    
    return nil;
}
- (void)addPhysicalViewWithDataWithYvalue:(int)yValue
{
    

//    NSArray *array1 = [NSArray arrayWithObjects:@"体重",@"宫高",@"腹围",@"B超",@"血压",@"宫缩", nil];
//    NSArray *array3 = [NSArray arrayWithObjects:@"80.5",@"15.5",@"",@"异常",@"120/80",@"41.5", nil];
      NSArray *array1 = [NSArray arrayWithObjects:@"体重",@"宫高",@"腹围",nil];
      NSArray *array3 = [self configureDataModelArray];
    NSLog(@"^^^^^^^^^^^^^^^^^^%@",array3);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 3; i ++) {
        
        BTUserData *one = [array3 objectAtIndex:i];
        NSString *content = nil;
       
        switch (i) {
            case 0:
            {
                if (one.weight == nil) {
                    content = @"";
                }
                else{
                    content = [NSString stringWithString:one.weight];
                }

               
            }
                break;
            case 1:
            {
                if (one.fundalHeight == nil) {
                    content = @"";
                }
                else{
                    content = [NSString stringWithString:one.fundalHeight];
                }

                
            }
                break;
            case 2:
            {
                if (one.girth == nil) {
                    content = @"";
                }
                else{
                    content = [NSString stringWithString:one.girth];
                }

                
            }
                break;
    
            default:
                break;
        }
        
        BTPhysicalModel *model = [[BTPhysicalModel alloc] initWithTitle:[array1 objectAtIndex:i] content:content year:[NSString stringWithFormat:@"%@",one.year] month:[NSString stringWithFormat:@"%@",one.month] day:[NSString stringWithFormat:@"%@",one.day]];
        [array addObject:model];
    }
    
    
    self.physicalView = [[BTPhysicalCollectionView alloc] initWithFrame:CGRectMake(6 , yValue, 320 - 12,100) modelArray:array];
    
    __weak BTPhysicalViewController *physicalVC = self;
    _physicalView.choosePhysicalBlock = ^(int tag)
    {
        NSLog(@"点击的button的tag wei%d",tag);
 
        switch (tag) {
            case PHYSICAL_BUTTON_TAG + 0://体重
            {
                selectedTag = tag;
                BTWeightViewController *weightVC = [[BTWeightViewController alloc] init];
                weightVC.hidesBottomBarWhenPushed = YES;
                [physicalVC.navigationController pushViewController:weightVC animated:YES];
            }
                break;
            case PHYSICAL_BUTTON_TAG + 1://宫高
            {
                selectedTag = tag;
                BTHeightViewController *heightVC = [[BTHeightViewController alloc] init];
                heightVC.hidesBottomBarWhenPushed = YES;
                [physicalVC.navigationController pushViewController:heightVC animated:YES];
            }
                break;
            case PHYSICAL_BUTTON_TAG + 2://腹围
            {
                selectedTag = tag;
                BTGirthViewController *girthVC = [[BTGirthViewController alloc] init];
                girthVC.hidesBottomBarWhenPushed = YES;
                [physicalVC.navigationController pushViewController:girthVC animated:YES];
            }
                break;

            case PHYSICAL_BUTTON_TAG + 3://B超
            {
                BTWeightViewController *weightVC = [[BTWeightViewController alloc] init];
                weightVC.hidesBottomBarWhenPushed = YES;
                [physicalVC.navigationController pushViewController:weightVC animated:YES];
            }
                break;

            case PHYSICAL_BUTTON_TAG + 4://血压
            {
                BTBPViewController *bpviewVC = [[BTBPViewController alloc] init];
                bpviewVC.hidesBottomBarWhenPushed = YES;
                [physicalVC.navigationController pushViewController:bpviewVC animated:YES];
            }
                break;

            case PHYSICAL_BUTTON_TAG + 5://宫缩
            {
                BTUCViewController *ucVC = [[BTUCViewController alloc] init];
                ucVC.hidesBottomBarWhenPushed = YES;
                [physicalVC.navigationController pushViewController:ucVC animated:YES];
            }
                break;

            default:
                break;
        }
    };
    
    
    [self.scrollView addSubview:_physicalView];
    
    
    
}
#pragma mark - 各种button的event事件
//进入运动详情
- (void)enterSportView:(UIButton *)button
{
    BTPhysicSportViewController *sportVC = [[BTPhysicSportViewController alloc] init];
    sportVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sportVC animated:YES];
}
//进入胎动记录
- (void)enterFetalCountView:(UIButton *)button
{
    BTFetalDailyViewController *fetalDailyVC = [[BTFetalDailyViewController alloc] init];
    fetalDailyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fetalDailyVC animated:YES];
}
//进入孕期血糖
- (void)enterBloodView:(UIButton *)button
{
    BTGluViewController *gluVC = [[BTGluViewController alloc] init];
    gluVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:gluVC animated:YES];

}
//进入胎心监测
- (void)enterFetalView:(UIButton *)button
{
    BTBabyFetalViewController *babyFetalVC = [[BTBabyFetalViewController alloc] init];
    babyFetalVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:babyFetalVC animated:YES];
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

//
#pragma mark - 视图将要出现的时候  刷新页面数据
- (void)viewWillAppear:(BOOL)animated

{
   
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    [self updateSportsProgress];
    //self.fetalLabel
    
    //更新体重 或宫高 或腹围
    
    if (selectedTag != 0) {
        
        
        int index = selectedTag - PHYSICAL_BUTTON_TAG;
        
        NSArray *array1 = [NSArray arrayWithObjects:@"体重",@"宫高",@"腹围",nil];
        NSArray *array3 = [self configureDataModelArray];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        for (int i = 0; i < 3; i ++) {
            
            BTUserData *one = [array3 objectAtIndex:i];
            NSString *content = nil;
            
            switch (i) {
                case 0:
                {
                    if (one.weight == nil) {
                        content = @"";
                    }
                    else{
                        content = [NSString stringWithString:one.weight];
                    }
                    
                }
                    break;
                case 1:
                {
                    if (one.fundalHeight == nil) {
                        content = @"";
                    }
                    else{
                        content = [NSString stringWithString:one.fundalHeight];
                    }
                    
                }
                    break;
                case 2:
                {
                    if (one.girth == nil) {
                        content = @"";
                    }
                    else{
                        content = [NSString stringWithString:one.girth];
                    }

                    
                }
                    break;
                    
                default:
                    break;
            }
            BTPhysicalModel *model = [[BTPhysicalModel alloc] initWithTitle:[array1 objectAtIndex:i] content:content year:[NSString stringWithFormat:@"%@",one.year] month:[NSString stringWithFormat:@"%@",one.month] day:[NSString stringWithFormat:@"%@",one.day]];
            [array addObject:model];
        }
        
        [self.physicalView updateDataWithSubViewTag:selectedTag Model:[array objectAtIndex:index]];

    }
    
    //更新自定义的navigationBar的怀孕时间
    [self updatePregnancyTime];
}
#pragma mark - 更新导航栏上显示的怀孕时间
- (void)updatePregnancyTime
{
    NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    if (data.count > 0) {
        BTUserSetting *userData = [data objectAtIndex:0];
        int day = [self intervalSinceNow:userData.dueDate];
        self.countLabel.text = [NSString stringWithFormat:@"预产期倒计时: %d天",day];
        
        //根据怀孕天数 算出是第几周 第几天
        int week = (280 - day)/7 + 1;
        int day1 = (280 - day)%7;
        self.dateLabel.text = [NSString stringWithFormat:@"%d周%d天",week,day1];
      }

}
- (int)intervalSinceNow:(NSString *)theDate
{
    
    NSDate *localdate = [NSDate localdate];
    NSNumber *year = [BTUtils getYear:localdate];
    NSNumber *month = [BTUtils getMonth:localdate];
    NSNumber *day = [BTUtils getDay:localdate];
    
    NSDate *gmtDate = [NSDate dateFromString:[NSString stringWithFormat:@"%@.%@.%@",year,month,day] withFormat:@"yyyy.MM.dd"];
    NSDate *dueDate = [NSDate dateFromString:theDate withFormat:@"yyyy.MM.dd"];
    
    NSLog(@"现在时间 %@  预产期时间 %@",gmtDate,dueDate);
    
    NSTimeInterval now = [gmtDate timeIntervalSince1970];
    NSTimeInterval due = [dueDate timeIntervalSince1970];
    NSTimeInterval cha = due - now;
    
    int day1 = cha/(24 * 60 * 60);
    
    return day1;
}
- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.progressView removeFromSuperview];
    
}
//更新运动量进度
- (void)updateSportsProgress
{
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
    self.progressLabel.text = [NSString stringWithFormat:@"%0.1f",_progress];

}
//更新胎动数据
- (void)updateFetalData
{
    
}
//
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
