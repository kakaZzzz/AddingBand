//
//  BTPhysicalViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTPhysicalViewController.h"
#import "BTPhysicSportViewController.h"
#import "BTPhysicQuickeningViewController.h"
#import "LayoutDef.h"
#import "CircularProgressView.h"
#import "BTGetData.h"
#import "BarChartView.h"
#import "PICircularProgressView.h"
#import "BTColor.h"


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
#define kImageBgX 0
#define kImageBgY 0
#define kImageBgWidth 320
#define kImageBgHeight 200
@interface BTPhysicalViewController ()
@property(nonatomic,strong)UIScrollView *aScrollView;
@property(nonatomic,strong)NSArray *textLabelArray;
@property(nonatomic,strong)NSArray *detailTextArray;

@end

@implementation BTPhysicalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.barYValue = [self getResentOneWeekSteps];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    
   
    [super viewDidLoad];

    //加载滚动视图
    [self addSubviews];
    [self addBackgroundImage];
    [self addMamaPhisicalView];

    [self addBabyTableView];
    // Do any additional setup after loading the view.
}
#pragma mark - 开始配置背景色
- (void)addSubviews
{
    
    //添加滚动视图
    self.aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _aScrollView.delegate = self;
    _aScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 150);
    _aScrollView.showsVerticalScrollIndicator = NO;
    _aScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_aScrollView];
    
    //配置图片 传得参数为图片数量
    //[self addImageViewByNumber:5];

    //背景粉红图
    if (iPhone5) {
        self.aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageBgX, kImageBgY, kImageBgWidth, kImageBgHeight)];
    }
    else
    {
        self.aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageBgX, kImageBgY, kImageBgWidth, kImageBgHeight)];
    }
    _aImageView.image = [UIImage imageNamed:@"red_bg.png"];
    [_aScrollView addSubview:_aImageView];
    
    //设备使用时间背景
    
    self.useTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,_aImageView.frame.size.height - 50, 320, 50)];
    _useTimeImage.image = [UIImage imageNamed:@"uestime_bg.png"];
    
   // [_aImageView addSubview:_useTimeImage];
    
    
    //使用时间标签
    self.useTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, _useTimeImage.frame.size.height)];
    _useTimeLabel.backgroundColor = [UIColor clearColor];
    _useTimeLabel.text = @"使用时间:---";
    _useTimeLabel.textColor = [UIColor whiteColor];
   // [_useTimeImage addSubview:_useTimeLabel];

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
    
    [_aScrollView addSubview:_progressView];
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



#pragma mark - add circle progress
- (void)addCircleProgress
{
    //妈妈运动量标签
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 120, 50)];
    label1.text = @"妈妈运动量:";
    label1.textColor =[UIColor blueColor];
 //   [self.aScrollView addSubview:label1];

    
    
    
    //set backcolor & progresscolor
  //  UIColor *progressColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *progressColor = [UIColor yellowColor];
    UIColor *backColor = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    
   //整体分数进度条
    //alloc CircularProgressView instance
    self.circularGrade = [[CircularProgressView alloc] initWithFrame:CGRectMake(60, 40, 200, 200) backColor:backColor progressColor:progressColor lineWidth:13];
   // [self.circularGrade updateProgressCircle: 50 withTotal:100];

    //add CircularProgressView
    [self.aScrollView addSubview:_circularGrade];
    //分数标签
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_circularGrade.frame.origin.x, _circularGrade.frame.origin.y +40, 140, 70)];
    _gradeLabel.center = _circularGrade.center;//利用center快速定位
    //自动换行
    [_gradeLabel setNumberOfLines:0];
    _gradeLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    _gradeLabel.textAlignment = NSTextAlignmentCenter;
    _gradeLabel.textColor = [UIColor whiteColor];
    _gradeLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    [_aScrollView addSubview:_gradeLabel];
    
    //点击进入运动详情
    _gradeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterDetai)];
    [_gradeLabel addGestureRecognizer:tap];
    
    //创建运动量圆形进度条
    self.circularSport = [[CircularProgressView alloc] initWithFrame:CGRectMake(200, 180, 90, 120) backColor:backColor progressColor:progressColor lineWidth:13];
    //[self.circularSport updateProgressCircle: 50 withTotal:100];
    
    //add CircularProgressView
 //   [self.aScrollView addSubview:_circularSport];
    
    //运动量标签
    self.sportLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    _sportLabel.center = _circularSport.center;//利用center快速定位
    _sportLabel.textAlignment = NSTextAlignmentCenter;
    _sportLabel.text = @"100";
    _sportLabel.backgroundColor = [UIColor redColor];
 //   [_aScrollView addSubview:_sportLabel];

    
      
    
//    //创建Label
//    self.totalStep = [[UILabel alloc] initWithFrame:CGRectMake(stepLabelX, stepLabelY, stepLabelWidth, stepLabelHeight)];
//    _totalStep.font = [UIFont systemFontOfSize:stepLabelFont];
//    _totalStep.text = @"9506";
//    _totalStep.textAlignment =  NSTextAlignmentCenter;
//    _totalStep.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_totalStep];
//    
//    self.realStep = [[UILabel alloc] initWithFrame:CGRectMake(stepLabelX, stepLabelY + 170, stepLabelWidth, stepLabelHeight)];
//    _realStep.text = @"100";
//    _realStep.font = [UIFont systemFontOfSize:stepLabelFont];
//    _realStep.textAlignment =  NSTextAlignmentCenter;
//    [self.view addSubview:_realStep];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 100, 50)];
    label.text = @"宝宝胎动：";
    label.textColor =[UIColor blueColor];
    [self.aScrollView addSubview:label];
}
#pragma mark -添加演示用背景花边
- (void)addBackgroundImage
{
    UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _aImageView.frame.origin.y + _aImageView.frame.size.height, self.view.frame.size.width, 131)];
    aImageView.image = [UIImage imageNamed:@"lace_bg.png"];
    [_aScrollView addSubview:aImageView];
    
    //胎动
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    
    aLabel.textAlignment = NSTextAlignmentLeft;
    aLabel.text = @"胎动";
    aLabel.backgroundColor = [UIColor clearColor];
  //  [aImageView addSubview:aLabel];
    
    UIImageView *bImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, aImageView.frame.origin.y + aImageView.frame.size.height, self.view.frame.size.width, 121)];
    bImageView.backgroundColor = [UIColor redColor];
    bImageView.image = [UIImage imageNamed:@"lace_bg.png"];
    //在柱形图上加入手势 点击进如下一页面 目前进入胎动详情
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterNextView:)];
    bImageView.userInteractionEnabled = YES;
    [bImageView addGestureRecognizer:tap];

    [_aScrollView addSubview:bImageView];
}
#pragma mark - 点击花边背景暂时进入胎动详情页面
- (void)enterNextView:(UITapGestureRecognizer *)tap
{
    BTFetalViewController *fetalVC = [[BTFetalViewController alloc] init];
    fetalVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fetalVC animated:YES];
}

#pragma mark - loadBarChart  加载柱形图
- (void)loadBarChartUsingArray {
    //Generate properly formatted data to give to the bar chart
    //横坐标元素
    /*   在此传入横坐标名称  柱子表示的数值  柱子颜色  以及label中字体颜色 */
    
    _barChart = [[BarChartView alloc] initWithFrame:CGRectMake(30, 220, 250, 100)];//柱形图背景大小
    _barChart.backgroundColor = [UIColor clearColor];
   // [self.aScrollView addSubview:_barChart];
    
    NSArray *array = [_barChart createChartDataWithTitles:_barXValue
                                                   values:_barYValue
                                                   colors:_barColors
                                              labelColors:_barLabelColors];
    
    
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
                      withColor:[BTColor getColor:kBarColor]//指示坐标颜色 Y轴颜色
        shouldPlotVerticalLines:YES];
}
#pragma mark - 读取最近一周每天的运动量 并配置绘制柱形图所需参数
- (NSArray *)getResentOneWeekSteps
{
    
    self.barColors = [NSMutableArray arrayWithObjects:@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317", nil];
    self.barLabelColors = [NSMutableArray arrayWithObjects:@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317",@"87E317", nil];
    
    //设置数据类型
    int type = 1;
    //读取当前时间
    NSDate* date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSLog(@"localeDate==%@", localeDate);
    //分割出年 月 日 小时
    NSNumber* year = [BTUtils getYear:localeDate];
//    NSNumber* month = [BTUtils getMonth:localeDate];
//    NSNumber* day = [BTUtils getDay:localeDate];
//    NSNumber* minute = [BTUtils getMinutes:date];
    NSNumber* hour = [BTUtils getHour:localeDate];
    //设置查询条件
    //按月查询
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND type == %@",year,[NSNumber numberWithInt:type]];
    NSArray *array = [BTGetData getFromCoreDataWithPredicate:predicate entityName:@"BTRawData" sortKey:nil];
    
    NSMutableArray *arrayStep = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *arrayDate = [NSMutableArray arrayWithCapacity:1];
    for (BTRawData* one in array) {
        [arrayStep addObject:[NSString stringWithFormat:@"%@",one.count]];
        [arrayDate addObject:[NSString stringWithFormat:@"%@分",one.minute]];//测试用小时 实际上线时 用天
        
    }
    
    
    //最近七天的一个范围
    NSArray *resultArray;
    //如果数据大于七天
    if (arrayStep.count >= 7) {
        NSRange theRange;
        theRange.location = arrayStep.count - 7;//range的起点
        theRange.length = 7;//range的长度
        resultArray = [arrayStep subarrayWithRange:theRange];
        self.barXValue = [arrayDate subarrayWithRange:theRange];
        
    }
    //如果数据少于七天
    else{
        resultArray = arrayStep;
        //横坐标值
        self.barXValue = arrayDate;
        
        NSRange theRange;
        theRange.location = arrayStep.count ;//range的起点
        theRange.length = 7 - arrayStep.count;//range的长度
        
        //柱子颜色
        [self.barColors removeObjectsInRange:theRange];
        [self.barLabelColors removeObjectsInRange:theRange];
        
    }
    NSLog(@"最近一周的运动量是 %@",resultArray);
    return resultArray;
    
    
}

#pragma mark - 加载button控制的对页面视图 妈妈体征项
- (void)addMamaPhisicalView
{
    
	BTWeightViewController *weightVC = [[BTWeightViewController alloc] init];
    BTHeightViewController *heightVC = [[BTHeightViewController alloc] init];
    BTGirthViewController *girthVC = [[BTGirthViewController alloc] init];
    BTGluViewController *gluVC = [[BTGluViewController alloc] init];
    BTBPViewController *bpVC = [[BTBPViewController alloc] init];
    
    
    weightVC.title = @"体重";
    heightVC.title = @"宫高";
	girthVC.title = @"腹围";
    gluVC.title = @"血糖";
    bpVC.title = @"血压";
    
    
	NSArray *viewControllers = [NSArray arrayWithObjects:weightVC, heightVC, girthVC,gluVC,bpVC, nil];
    
	self.tabBarController = [[MHTabBarController alloc] init];
    _tabBarController.view.frame = CGRectMake(0, 200, 220, 120);
    _tabBarController.delegate = self;
	_tabBarController.viewControllers = viewControllers;
    [self.aScrollView addSubview:_tabBarController.view];
	
    
    //添加详情按钮
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [detailButton setTitle:@"详情" forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(enterMamaDetail:) forControlEvents:UIControlEventTouchUpInside];
    detailButton.frame = CGRectMake(320 - 40, _tabBarController.view.frame.origin.y + 5, 30, 30);
    [self.aScrollView addSubview:detailButton];
    
    //添加今日运动量标签
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tabBarController.view.frame.origin.x + _tabBarController.view.size.width + 10, detailButton.frame.origin.y + 40, 90, 30)];
    aLabel.text = @"今日运动量";
    [self.aScrollView addSubview:aLabel];
    
    self.sportLabel = [[UILabel alloc] initWithFrame:CGRectMake(aLabel.frame.origin.x, aLabel.frame.origin.y + aLabel.frame.size.height - 10, aLabel.frame.size.width, 50)];
    _sportLabel.backgroundColor = [UIColor redColor];
    _sportLabel.font = [UIFont systemFontOfSize:25];
    _sportLabel.textAlignment = NSTextAlignmentCenter ;
    _sportLabel.text = @"69%";
    //在label上加手势  点击进入下一个页面  运动量详情
    _sportLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToSportView:)];
    [_sportLabel addGestureRecognizer:tap];
    [self.aScrollView addSubview:_sportLabel];

}
- (void)pushToSportView:(UITapGestureRecognizer *)tap
{
    BTPhysicSportViewController *sportVC = [[BTPhysicSportViewController alloc] init];
    sportVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sportVC animated:YES];
}

#pragma mark - 妈妈体征页的代理方法 自写tabbar的代理方法
- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	//NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %u", tabBarController, viewController, index);
    
    //在这里可以决定哪个button不允许点击
    
	return YES;
}

- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	//NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %u", tabBarController, viewController, index);
}
#pragma mark - 进入mama体征详情页面
- (void)enterMamaDetail:(UIButton *)button
{
    
    UIViewController *selectedVC = self.tabBarController.selectedViewController;
    BTMamaDetailViewController *detailVC = [[BTMamaDetailViewController alloc] init];
    detailVC.navigationItem.title = selectedVC.title;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}

#pragma mark - 配置胎儿体征tableView
- (void)addBabyTableView
{
    
    self.textLabelArray = [NSArray arrayWithObjects:@"胎儿体重",@"胎动记录",@"胎心监护", nil];
    self.detailTextArray = [NSArray arrayWithObjects:@"598g",@"平均每天 30次",@"平均每分钟 147次", nil];

    //加载tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _tabBarController.view.frame.origin.y + _tabBarController.view.frame.size.height + 5, 320,200)];
   // _tableView.backgroundColor = [UIColor redColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_aScrollView addSubview:_tableView];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    //    return [self.peripheralArray count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    //刚开始没有连接上设备的时候 每个设备下面只有一行  显示“立即连接” ;当连接上的时候 设备下面变成两行 显示“上次同步时间” “立即同步”
    //当同步完的时候 怎么做？？？
    return 3 ;
}


//动态改变每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"sync_btn_sel"];
    cell.textLabel.text = [self.textLabelArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.detailTextArray objectAtIndex:indexPath.row];
    return cell;

}

#pragma mark - tabelview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0://胎儿体重
        {
            BTBabyWeightViewController *weightVC = [[BTBabyWeightViewController alloc] init];
            weightVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:weightVC animated:YES];
        }
            break;
        case 1://胎动记录
        {
            BTFetalViewController *fetalVC = [[BTFetalViewController alloc] init];
            fetalVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fetalVC animated:YES];

        }
            break;
        case 2://胎心监护
        {
            BTBabyFetalViewController *babyFetalVC = [[BTBabyFetalViewController alloc] init];
            babyFetalVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:babyFetalVC animated:YES];
            
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
//    //在视图出现的时候加载进度条 然后再视图消失的时候移除进度条  这样可以保证进度条进度动态的出现
//    [self addCircleProgress];
//    int i = [self getDailyStep];
//    [self updateUIWithStepDaily:i totalStep:2000];//100为每日目标
//    if (i == 0) {
//    self.gradeLabel.text = [NSString stringWithFormat:@"今日还未开始运动,妈妈要努力啊"];
//    }
//
//    if (i < 2000 && i > 0) {
//         self.gradeLabel.text = [NSString stringWithFormat:@"今日已完成%d步,继续努力啊",i];
//    }
//    
//    if (i >= 2000) {
//        self.gradeLabel.text = [NSString stringWithFormat:@"今日圆满完成目标，妈妈真棒"];
//    }
    
    
    [self addGradeCircular];
    int i = [self getDailyStep];
    NSLog(@"走了多少步%d",i);
    //判断保证内圆为0的时候没有凸来的圆角矩形
    if (i == 0) {
        self.progressView.roundedHead = NO;
    }
    else{
        self.progressView.roundedHead = YES;
    }
    _progress =(float) i/500;//此处1000是目标值 记得改 另外改了之后也要改柱状图内部
    NSLog(@"进度是%f",_progress);
 //   [self updateUIWithStepDaily:i totalStep:2000];//100为每日目标
   
    self.barYValue = [self getResentOneWeekSteps];
    [self loadBarChartUsingArray];
    
    //刷新胎儿一栏数据
    
    [self.tableView reloadData];//既可以刷新数据 又可以取消某一行的选中状态
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.circularGrade removeFromSuperview];
//    [self.circularSport removeFromSuperview];
    
    [self.progressView removeFromSuperview];
    [self.barChart removeFromSuperview];
}
- (void)updateUIWithStepDaily:(int)stepDaily totalStep:(int)totalStep
{
    
    [self.circularGrade updateProgressCircle:stepDaily withTotal:totalStep];
}


#pragma mark - 读取累计总步数
- (int)getTotalStep
{
    int stepCount = 0;
    NSArray *array = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTRawData" sortKey:nil];
    for (BTRawData* one in array) {
        stepCount += [one.count intValue];
        
    }
    NSLog(@"一共步数%d",stepCount);
    return stepCount;
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
    NSNumber* hour = [BTUtils getHour:localeDate];
    
    
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
