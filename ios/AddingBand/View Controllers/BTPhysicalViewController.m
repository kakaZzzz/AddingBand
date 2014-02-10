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
    self.scrollView.contentSize = CGSizeMake(320, 550);
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
    
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:kNavigationbarIcon];
    iconImage.frame = CGRectMake(24/2, _navigationBgView.frame.size.height - 5 - 39, 39, 39);
    [_navigationBgView addSubview:iconImage];
    
    
    
    //加一个文字logo
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_text"]];
    logoImage.frame = CGRectMake(iconImage.frame.origin.x + iconImage.frame.size.width + 5, _navigationBgView.frame.size.height - 11 - 42/2, 232/2, 42/2);
    [_navigationBgView addSubview:logoImage];

    //分数背景view
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 90/2, 320, (406-90)/2)];
    _headView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:_headView];
    
    //grade
    UIImageView *gradeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headView.frame.size.width, _headView.frame.size.height)];
    gradeImage.image = [UIImage imageNamed:@"physical_head_image"];
    [_headView addSubview:gradeImage];
    
    BTView *sportProgressView = [[BTView alloc] initWithFrame:CGRectMake(0, _headView.frame.origin.y + _headView.frame.size.height, 320, 80)];
    sportProgressView.backgroundColor = [UIColor whiteColor];
    [sportProgressView addTarget:self action:@selector(enterSportView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:sportProgressView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(sportProgressView.frame.origin.x + 36/2, 10, 150, 30)];
    titleLabel.textColor = kBigTextColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    titleLabel.text = @"今日完成情况";
    [sportProgressView addSubview:titleLabel];
    
    UILabel *labelGoal = [[UILabel alloc] initWithFrame:CGRectMake(sportProgressView.frame.origin.x + 36/2, titleLabel.frame.origin.y + 30, 40, 30)];
    labelGoal.textColor = kContentTextColor;
    labelGoal.backgroundColor = [UIColor clearColor];
    labelGoal.textAlignment = NSTextAlignmentLeft;
    labelGoal.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    labelGoal.text = @"目标:";
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
    [fetalView addTarget:self action:@selector(enterFetalView:) forControlEvents:UIControlEventTouchUpInside];
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
    
    
}

#pragma mark - 从coredata中获取数据 用于显示体重 宫高 腹围
- (NSArray *)configureDataModelArray
{
    NSManagedObjectContext *contex = [BTGetData getAppContex];
    NSMutableArray *weightArray = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *heighttArray = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *girthArray = [NSMutableArray arrayWithCapacity:1];
   
    NSDictionary *sortDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"year",@"sortkey1",@"month",@"sortkey2",@"day",@"sortkey3", nil];
    NSArray *dataArray = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserData" sortKey:sortDic];
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

//- (NSArray *)configureDataModelArray
//{
//    
//}




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
- (void)enterFetalView:(UIButton *)button
{
    BTFetalDailyViewController *fetalDailyVC = [[BTFetalDailyViewController alloc] init];
    fetalDailyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fetalDailyVC animated:YES];

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
////进入胎心监测
//- (void)enterFetalView:(UIButton *)button
//{
//    BTBabyFetalViewController *babyFetalVC = [[BTBabyFetalViewController alloc] init];
//    babyFetalVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:babyFetalVC animated:YES];
//}
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
   // [self updatePregnancyTime];
}
#pragma mark - 更新导航栏上显示的怀孕时间
- (void)updatePregnancyTime
{

    NSDate *localdate = [NSDate localdate];
    NSNumber *year = [BTUtils getYear:localdate];
    NSNumber *month = [BTUtils getMonth:localdate];
    NSNumber *dayLocal = [BTUtils getDay:localdate];
    NSDate *gmtDate = [NSDate dateFromString:[NSString stringWithFormat:@"%@.%@.%@",year,month,dayLocal] withFormat:@"yyyy.MM.dd"];
    int day = [BTGetData getPregnancyDaysWithDate:gmtDate];
    //根据怀孕天数 算出是第几周 第几天
    int week = day/7 + 1;
    int day1 = day%7;
    if (day%7 == 0) {
        week = week - 1;
        day1 = 7;
    }
        self.countLabel.text = [NSString stringWithFormat:@"预产期倒计时: %d天",(280 - day)];
        self.dateLabel.text = [NSString stringWithFormat:@"%d周%d天",week,day1];


}
//- (int)intervalSinceNow:(NSString *)theDate
//{
//    
//    NSDate *localdate = [NSDate localdate];
//    NSNumber *year = [BTUtils getYear:localdate];
//    NSNumber *month = [BTUtils getMonth:localdate];
//    NSNumber *day = [BTUtils getDay:localdate];
//    
//    NSDate *gmtDate = [NSDate dateFromString:[NSString stringWithFormat:@"%@.%@.%@",year,month,day] withFormat:@"yyyy.MM.dd"];
//    NSDate *dueDate = [NSDate dateFromString:theDate withFormat:@"yyyy.MM.dd"];
//    
//    NSLog(@"现在时间 %@  预产期时间 %@",gmtDate,dueDate);
//    
//    NSTimeInterval now = [gmtDate timeIntervalSince1970];
//    NSTimeInterval due = [dueDate timeIntervalSince1970];
//    NSTimeInterval cha = due - now;
//    
//    int day1 = cha/(24 * 60 * 60);
//    
//    return day1;
//}
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
    _progress = i/7000.0;//此处1000是目标值 记得改 另外改了之后也要改柱状图内部
    NSLog(@"进度是%f",_progress);
    self.progressLabel.text = [NSString stringWithFormat:@"%0.1f",_progress *100];

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
