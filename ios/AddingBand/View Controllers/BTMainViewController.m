//
//  BTMainViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-20.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTMainViewController.h"
#import "LayoutDef.h"
#import "UMSocialSnsService.h"//友盟分享
#import "UMSocial.h"
#import "NSDate+DateHelper.h"
#import "BTUtils.h"
#import "BTAlertView.h"

#import "BTKnowledgeViewController.h"
#import "MKNetworkEngine.h"
#import "MKNetworkOperation.h"
#import "BTKnowledgeModel.h"
#import "BTKnowledgeCell.h"
#import "BTWarnCell.h"
#import "BTGetData.h"
#import "BTUserSetting.h"

#import "BTRowOfSectionModel.h"
#import "BTPersonalDataView.h"
#import "BTBlogDetailViewController.h"
#import "BTDateCell.h"
#define NAVIGATIONBAR_Y 0
#define NAVIGATIONBAR_HEIGHT 65

static int currentWeek = 0;
@interface BTMainViewController ()
@property(nonatomic,strong)UILabel *dateLabel;//3周4天
@property(nonatomic,strong)UILabel *countLabel;//预产期倒计时
@property(nonatomic,strong)NSString *menstruation;
@property(nonatomic,strong)NSString *today;

@end

@implementation BTMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modelArray = [NSMutableArray arrayWithCapacity:1];
        self.sectionArray = [NSMutableArray arrayWithCapacity:1];
        
    }
    return self;
}
#pragma mark - 视图出现  消失
- (void)viewWillAppear:(BOOL)animated
{
    
    //增加标识，用于判断是否是第一次启动应用,进入此页面
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everAppear"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstAppear"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everAppear"];
        
    }
    
    
    //如果是第一次进入此页面 pop一个view
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstAppear"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstAppear"];
        NSLog(@"第一次进来");
        [self presentPersonnalDataView];
        //[self popAlertView];
        
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self updatePregnancyTime];
    
    //
   
}
- (void)presentPersonnalDataView
{
    BTPersonalDataView *personnalDataView =[[BTPersonalDataView alloc] init];
    [self presentViewController:personnalDataView animated:YES completion:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getMenstruationAndTodayDate];
    //[self popAlertView];
    [self getCurrentWeekOfPregnancy];//得到今天是怀孕第几周
    [self addSubviews];
    [self addChageScrollViewToTopButton];
    
    //[self getNetworkDataWithWeekOfPregnancy:3];
    [self showRefreshHeader:YES];//代码触发刷新
	// Do any additional setup after loading the view.
}
#pragma mark - 得到末次月经 和 今天日期
- (void)getMenstruationAndTodayDate
{
    NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    if (data.count > 0) {
        BTUserSetting *userData = [data objectAtIndex:0];
        NSString *str1 = userData.menstruation;
        self.menstruation = [str1 stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    }
    NSDate *localdate = [NSDate localdate];
    NSNumber *year = [BTUtils getYear:localdate];
    NSNumber *month = [BTUtils getMonth:localdate];
    NSNumber *dayLocal = [BTUtils getDay:localdate];
    self.today = [NSString stringWithFormat:@"%@-%@-%@",year,month,dayLocal];

}
#pragma mark - 代码触发下拉刷新
-(void)showRefreshHeader:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.tableView.contentInset = UIEdgeInsetsMake(65.0f, 0.0f, 0.0f, 0.0f);
        [self.tableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
    }
    else
    {
        self.tableView.contentInset = UIEdgeInsetsMake(65.0f, 0.0f, 0.0f, 0.0f);
        [self.tableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
    }
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
    
}

#pragma mark - 根据预产期 的出今天处于第几周
- (int)getCurrentWeekOfPregnancy
{
    NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    if (data.count > 0) {
        BTUserSetting *userData = [data objectAtIndex:0];
        int day = [self intervalSinceNow:userData.dueDate];
        self.dueDate = [userData.dueDate stringByReplacingOccurrencesOfString:@"." withString:@"-"];//把预产期取出来 存下来 避免反复操作coredata
        //根据怀孕天数 算出是第几周 第几天
        int week = (280 - day)/7 + 1;
        currentWeek = week;
        return week;
    }
    return 0;
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

#pragma mark - 请求网络数据
- (void)getNetworkDataWithWeekOfPregnancy:(int)week
{
    
    //用MKNetworkKit进行异步网络请求
    /*GET请求 示例*/
  
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_HOSTNAME customHeaderFields:nil];
    [self.engine useCache];//使用缓存
    MKNetworkOperation *op = [self.engine operationWithPath:[NSString stringWithFormat:@"/api/schedule_new?p=%@&t=%@&w=%d+%d",self.menstruation,self.today,week,week + 1] params:nil httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        if (_isLoadNextData) {
            [self handleNextDataByGetNetworkSuccessfullyWithJsonData:[operation responseData]];
        }
        else{
            [self handlePastDataByGetNetworkSuccessfullyWithJsonData:[operation responseData]];
        }
      
        
        //请求数据错误
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        [self handleDataByGetNetworkFailly];
        
    }];
    [self.engine enqueueOperation:op];
    
    
}
- (void)handlePastDataByGetNetworkSuccessfullyWithJsonData:(NSData *)data
{
    
    NSMutableArray *section = [NSMutableArray arrayWithCapacity:1];

    currentWeek = 3;
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSDictionary *weekPreviousDic = [resultDic objectForKey:[NSString stringWithFormat:@"w%d",3]];
    NSArray *resultPreviousArray = [weekPreviousDic objectForKey:@"results"];
    //判断是否有数据，有的话再做处理
    BTRowOfSectionModel *model1 = nil;
    if ([resultPreviousArray count] > 0) {
        model1 = [[BTRowOfSectionModel alloc] initWithSectionTitle:[NSString stringWithFormat:@"%d周",currentWeek] row:[resultPreviousArray count]];
        [section addObject:model1];
      }
    NSLog(@"resultPreviousArray==%@",resultPreviousArray);
    NSLog(@"_____%@",model1);
    NSDictionary *weekCurrentDic = [resultDic objectForKey:[NSString stringWithFormat:@"w%d",3 + 1]];
    NSArray *resultCurrentArray = [weekCurrentDic objectForKey:@"results"];
    NSLog(@"resultCurrentArray====%@",resultCurrentArray);
    BTRowOfSectionModel *model2 = nil;
    if ([resultCurrentArray count] > 0) {
       model2 = [[BTRowOfSectionModel alloc] initWithSectionTitle:[NSString stringWithFormat:@"%d周",currentWeek + 1] row:[resultCurrentArray count]];
        [section addObject:model2];
    }
    
    //骚年 这里是分区数据
    
    for (int i = section.count - 1; i >= 0;i--) {
        
        [self.sectionArray insertObject:[section objectAtIndex:i] atIndex:0];//这是分区数据
        
    }
    
    
    //下面是每行数据
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    
    if ([resultPreviousArray count] > 0) {
        for (int i = 0; i < [resultPreviousArray count]; i ++) {
            NSDictionary * dictionary = [resultPreviousArray objectAtIndex:i];
        //    NSLog(@"zidianshi %@",dictionary);
            BTKnowledgeModel * knowledge = [[BTKnowledgeModel alloc] initWithDictionary:dictionary];
            [array1 addObject:knowledge];
        }
        [resultArray addObject:array1];

    }
    
    if ([resultCurrentArray count] > 0) {
        for (int i = 0; i < [resultCurrentArray count]; i ++) {
            NSDictionary * dictionary = [resultCurrentArray objectAtIndex:i];
            BTKnowledgeModel * knowledge = [[BTKnowledgeModel alloc] initWithDictionary:dictionary];
            [array2 addObject:knowledge];
        }
        
        [resultArray addObject:array2];

    }
    
    
        for (int i = resultArray.count - 1;i >= 0;i--)
        {
            NSArray * array = [resultArray objectAtIndex:i];
            //把一个个的knowledge存入可变数组 modelArray(类初始化的时候应开辟空间)
            [self.modelArray insertObject:array atIndex:0];//这是行数据
        }
       NSLog(@"请求结果是.......%@",self.modelArray);
    
    
//    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:resultPreviousArray];
//    [resultArray addObjectsFromArray:resultCurrentArray];
//    
//    NSLog(@"resultArray=====%@",resultArray);
//    for (int i = resultArray.count - 1;i >= 0;i--)
//    {
//        NSLog(@"yigeyige 放进去%@",[resultArray objectAtIndex:i]);
//        NSDictionary * dictionary = [resultArray objectAtIndex:i];
//        BTKnowledgeModel * knowledge = [[BTKnowledgeModel alloc] initWithDictionary:dictionary];
//        //把一个个的knowledge存入可变数组 modelArray(类初始化的时候应经开辟空间)
//        [self.modelArray insertObject:knowledge atIndex:0];//这是行数据
//        
//    }
    
    [self.tableView reloadData];
    [self finishReloadingData];//刷新完成
}

- (void)handleNextDataByGetNetworkSuccessfullyWithJsonData:(NSData *)data
{
    NSMutableArray *section = [NSMutableArray arrayWithCapacity:1];

    currentWeek = 3;
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSDictionary *weekPreviousDic = [resultDic objectForKey:[NSString stringWithFormat:@"w%d",3]];
    NSArray *resultPreviousArray = [weekPreviousDic objectForKey:@"results"];
    //判断是否有数据，有的话再做处理
    BTRowOfSectionModel *model1 = nil;
    if ([resultPreviousArray count] > 0) {
        model1 = [[BTRowOfSectionModel alloc] initWithSectionTitle:[NSString stringWithFormat:@"%d周",currentWeek] row:[resultPreviousArray count]];
        [section addObject:model1];
    }
    NSLog(@"resultPreviousArray==%@",resultPreviousArray);
    NSLog(@"_____%@",model1);
    NSDictionary *weekCurrentDic = [resultDic objectForKey:[NSString stringWithFormat:@"w%d",3 + 1]];
    NSArray *resultCurrentArray = [weekCurrentDic objectForKey:@"results"];
    NSLog(@"resultCurrentArray====%@",resultCurrentArray);
    BTRowOfSectionModel *model2 = nil;
    if ([resultCurrentArray count] > 0) {
        model2 = [[BTRowOfSectionModel alloc] initWithSectionTitle:[NSString stringWithFormat:@"%d周",currentWeek + 1] row:[resultCurrentArray count]];
        [section addObject:model2];
    }
    
    //骚年 这里是分区数据
    
    for (int i = section.count - 1; i >= 0;i--) {
        
        [self.sectionArray insertObject:[section objectAtIndex:i] atIndex:0];//这是分区数据
        
    }
    
    
    //下面是每行数据
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    
    if ([resultPreviousArray count] > 0) {
        for (int i = 0; i < [resultPreviousArray count]; i ++) {
            NSDictionary * dictionary = [resultPreviousArray objectAtIndex:i];
            NSLog(@"zidianshi %@",dictionary);
            BTKnowledgeModel * knowledge = [[BTKnowledgeModel alloc] initWithDictionary:dictionary];
            [array1 addObject:knowledge];
        }
        [resultArray addObject:array1];
        
    }
    
    if ([resultCurrentArray count] > 0) {
        for (int i = 0; i < [resultCurrentArray count]; i ++) {
            NSDictionary * dictionary = [resultCurrentArray objectAtIndex:i];
            BTKnowledgeModel * knowledge = [[BTKnowledgeModel alloc] initWithDictionary:dictionary];
            [array2 addObject:knowledge];
        }
        
        [resultArray addObject:array2];
        
    }
    
    
    for (int i = resultArray.count - 1;i >= 0;i--)
    {
        NSArray * array = [resultArray objectAtIndex:i];
        //把一个个的knowledge存入可变数组 modelArray(类初始化的时候应经开辟空间)
        [self.modelArray insertObject:array atIndex:0];//这是行数据
    }
    NSLog(@"请求结果是.......%@",self.modelArray);
    
    [self.tableView reloadData];
    [self finishReloadingData];//刷新完成
}


- (void)handleDataByGetNetworkFailly
{
//    NSDictionary * dictionary;
//    for (int i = 0; i < 2; i ++) {
//        if (i == 0) {
//            dictionary  = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"event_id",@"103",@"event_type",@"该吃药了哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈",@"title", @"",@"hash",@"丫今儿该吃苹果了",@"description",@"2014-1-2",@"date",@"2014-1-4",@"expire",@"",@"icon",nil];
//        }
//        if (i == 1) {
//            dictionary  = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"event_id",@"103",@"event_type",@"什么是叶酸什么是叶酸什么是叶酸什么是叶酸什么是叶酸什么是叶酸什么是叶酸什么是叶酸什么是叶酸什么是叶酸什么是叶酸什么是叶酸？",@"title", @"",@"hash",@"叶酸是维生素B9的水溶形式。叶酸的名字来源于拉丁文folium。由米切尔及其同事 首次从菠菜叶中提取纯化出来，命名为叶酸。叶酸作为重要的一碳载体，在核苷酸合成，同型半胱氨酸的再甲基化等诸多重要生理代谢功能方面有重要作用。因此叶酸在快速的细胞分裂和生长过程中有尤其重要的作用。",@"description",@"2014-1-2",@"date",@"2014-1-4",@"expire",@"",@"icon",nil];
//            
//        }
//        BTKnowledgeModel * knowledge = [[BTKnowledgeModel alloc] initWithDictionary:dictionary];
//        //把一个个的shop存入可变数组 dataArray(父类中定义 并初始化)
//        [self.modelArray addObject:knowledge];
//        
//        
//    }
    
    [self finishReloadingData];//刷新完成
    [self.tableView reloadData];
    
}

#pragma mark - 加载返回第一行按钮
- (void)addChageScrollViewToTopButton
{
    self.toTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toTopButton.frame = CGRectMake(10, self.view.frame.size.height - 100, 30, 30);
    [_toTopButton setBackgroundImage:[UIImage imageNamed:@"anchor_unselected"] forState:UIControlStateNormal];
    [_toTopButton setBackgroundImage:[UIImage imageNamed:@"anchor_selected"] forState:UIControlStateSelected];
    [_toTopButton setBackgroundImage:[UIImage imageNamed:@"anchor_selected"] forState:UIControlStateHighlighted];
    [_toTopButton addTarget:self action:@selector(toTop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toTopButton];
}
//返回到首页
- (void)toTop:(UIButton *)button
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.contentOffset = CGPointMake(0, 0);
    } completion:nil];
    
}
#pragma mark - 加载子视图
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
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.frame.origin.x + iconImage.frame.size.width + 10, iconImage.frame.origin.y, 100, 20)];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.font = [UIFont systemFontOfSize:15];
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
    
    UIButton *clockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clockButton setBackgroundImage:[UIImage imageNamed:@"appointment_bt_unselected"] forState:UIControlStateNormal];
    [clockButton setBackgroundImage:[UIImage imageNamed:@"appointment_bt_selected"] forState:UIControlStateSelected];
    [clockButton setBackgroundImage:[UIImage imageNamed:@"appointment_bt_selected"] forState:UIControlStateHighlighted];
    [clockButton addTarget:self action:@selector(inputYourPreproduction:) forControlEvents:UIControlEventTouchUpInside];
    clockButton.frame = CGRectMake(320 - 50, _navigationBgView.frame.size.height - 39, 60/2, 60/2);
    [_navigationBgView addSubview:clockButton];
    
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, 320, 40)];
    _headView.backgroundColor = kGlobalColor;
    //  [self.view addSubview:_headView];
    
    //加载tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _navigationBgView.frame.origin.y + _navigationBgView.frame.size.height, 320,self.view.frame.size.height - (_navigationBgView.frame.origin.y + _navigationBgView.frame.size.height) - 55)];
    
    if (IOS7_OR_EARLIER) {
        
        self.tableView.frame = CGRectMake(0, _navigationBgView.frame.origin.y + _navigationBgView.frame.size.height, 320,self.view.frame.size.height - (_navigationBgView.frame.origin.y + _navigationBgView.frame.size.height) - 58);
    }
    NSLog(@"页面高度 亲 %f",self.view.frame.size.height);
    _tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self createHeaderView];
    [self setFooterView];
}

#pragma mark - popview 请输入预产期
- (void)popAlertView
{
    
    
    BTAlertView *alert = [[BTAlertView alloc] initWithTitle:@"产检提醒" iconImage:[UIImage imageNamed:@"antenatel_icon"] contentText:@"请输入产检日期" leftButtonTitle:nil rightButtonTitle:@"知道了"];
    [alert show];
    alert.rightBlock = ^() {
        NSLog(@"right button clicked");
        //弹出输入预产期选择器
        if (self.actionSheetView == nil) {
            self.actionSheetView = [[BTSheetPickerview alloc] initWithPikerType:BTActionSheetPickerStyleDateAndTimePicker referView:self.view delegate:self];
        }
        
        [_actionSheetView show];
        
    };
    alert.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };
    
}

#pragma mark - 各种button event

#pragma MARK - 打开webview
//点击分区头上的按钮 进入下一页
- (void)pushNextView:(UIButton *)button
{
    NSLog(@"点击分区头，进入下一页");
    
    NSURL *strUrl = [NSURL URLWithString:@"http://www.addinghome.com/blog/app/45"];
    NSURLRequest *request = [NSURLRequest requestWithURL:strUrl];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 360, 320, 44)];
    toolBar.backgroundColor = [UIColor blueColor];
    [self.webView addSubview:toolBar];
    
    UIBarButtonItem *barBack = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goBack)];
    UIBarButtonItem *barForward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(goForward)];
    UIBarButtonItem *barSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //barSpace.width = 240;
    
    NSArray *arr = [NSArray arrayWithObjects:barBack,barSpace,barForward,nil];
    toolBar.items = arr;
    
}

- (void)goBack

{
    [_webView goBack];
}
- (void)goForward
{
    [_webView stopLoading];
    [_webView removeFromSuperview];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
    NSLog(@"shouldStartLoadWithRequest");
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"ViewDidStartLoad---");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //  [_activityIndicatorView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad---");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // [_activityIndicatorView stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError---");
}



//输入预产期
- (void)inputYourPreproduction:(UIButton *)button
{
    if (self.actionSheetView == nil) {
        self.actionSheetView = [[BTSheetPickerview alloc] initWithPikerType:BTActionSheetPickerStyleDateAndTimePicker referView:self.view delegate:self];
    }
    
    [_actionSheetView show];
    
}
#pragma mark - 输入预产期 日期选择器delegate
- (void)actionSheetPickerView:(BTSheetPickerview *)pickerView didSelectDate:(NSDate*)date
{
    
    NSDate *localDate = [NSDate localdateByDate:date];
    NSNumber *year = [BTUtils getYear:localDate];
    NSNumber *month = [BTUtils getMonth:localDate];
    NSNumber *day = [BTUtils getDay:localDate];
    NSNumber *hour = [BTUtils getHour:localDate];
    NSNumber *minute = [BTUtils getMinutes:localDate];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:localDate forKey:ANTENATEL_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self registerLocalNotificationWithDate:localDate];
    NSLog(@"选择的日期是。。。。。%@",localDate);
    NSLog(@"选泽的年：%@,月：%@，日：%@,小时：%@,分钟：%@",year,month,day,hour,minute);
    
}
- (void)registerLocalNotificationWithDate:(NSDate *)date
{
    
    NSLog(@"注册通知");
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    
    NSTimeInterval inteval = [date timeIntervalSinceDate:[NSDate localdate]];
    NSDate *now=[NSDate new];
    notification.fireDate=[now dateByAddingTimeInterval:inteval];//10秒后通知        notification.fireDate=date; //触发通知的时间
    notification.repeatInterval=0; //循环次数，kCFCalendarUnitWeekday一周一次
    notification.timeZone=[NSTimeZone localTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertBody=@"美妈，该产检了";
    
    notification.alertAction = @"打开";  //提示框按钮
    notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
    
    notification.applicationIconBadgeNumber =0; //设置app图标右上角的数字
    
    //下面设置本地通知发送的消息，这个消息可以接受
    NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
    notification.userInfo = infoDic;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //在这里判断 用哪个cell进行展示 然后调用cell的自动调整高度的方法
    NSArray *arrayModel = [self.modelArray objectAtIndex:indexPath.section];
    BTKnowledgeModel *model = [arrayModel objectAtIndex:indexPath.row];

    if ([model.title isEqualToString:@""]) {
        
        return 30.0;
    }
    
    else
    {
        switch ([model.remind intValue]) {
            case 1://warn
                return [BTWarnCell cellHeightWithMode:model];
                break;
            case 0://Knowledge
                return [BTKnowledgeCell cellHeightWithMode:model];
                break;
                
            default:
                break;
        }

    }
    return 150.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
   
    return [self.sectionArray count];
    
    
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BTRowOfSectionModel *model = [self.sectionArray objectAtIndex:section];
    return model.row;
    // return [self.modelArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    aView.backgroundColor = [UIColor whiteColor];
    aView.alpha = 0.9;
    //加一个一像素的分割线
    UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seperator_line"]];
    lineImage.frame = CGRectMake(0, 44 - kSeparatorLineHeight ,320, kSeparatorLineHeight);
    [aView addSubview:lineImage];

    
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, (44 - 5*2))];
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor =kGlobalColor;
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(320 - 100, 10,100, (44 - 10*2));
    button.tag = MAIN_BUTTON_TAG + section;
    [button setTitle:@"卵子受孕中" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushNextView:) forControlEvents:UIControlEventTouchUpInside];
   // [aView addSubview:button];
    
    BTRowOfSectionModel *model = [self.sectionArray objectAtIndex:section];
    //    if (section == 0) {
    //        lable.text = @"3周";
    
    lable.text = model.sectionTile;
    //    }
    [aView addSubview: lable];
    
    static int tag = 1001;
    aView.tag = tag++;
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierWarn = @"CellWarn";
    static NSString *CellIdentifierDate = @"CellDate";
    BTKnowledgeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BTWarnCell *warnCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierWarn];
    BTDateCell *dateCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDate];

    
    if (cell == nil) {
        cell = [[BTKnowledgeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (warnCell == nil) {
        warnCell = [[BTWarnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierWarn];
    }
    if (dateCell == nil) {
        dateCell = [[BTDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierDate];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    warnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    dateCell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    NSArray *arrayModel = [self.modelArray objectAtIndex:indexPath.section];
    BTKnowledgeModel *model = [arrayModel objectAtIndex:indexPath.row];
    if ([model.title isEqualToString:@""]) {
        NSLog(@"------%@",model.date);
        dateCell.knowledgeModel = model;
        return dateCell;
    }
    else{
        if  ([model.remind intValue] == 0)
        {
            cell.knowledgeModel = model;
            return cell;
            
            
        }
        else {
            warnCell.knowledgeModel = model;
            return warnCell;
            
        }

    }
    
    
    return nil;
}

#pragma mark - tabelview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *arrayModel = [self.modelArray objectAtIndex:indexPath.section];
    BTKnowledgeModel *model = [arrayModel objectAtIndex:indexPath.row];
    NSString *hash = model.hash;
    BTBlogDetailViewController *blogVC = [[BTBlogDetailViewController alloc] init];
    blogVC.blogHash = hash;
    
    if (![hash isEqualToString:@""]) {
    blogVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:blogVC animated:YES];

    }
    
    
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark - methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    //	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
    //                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
    //                                     self.view.frame.size.width, self.view.bounds.size.height) orientation:YES];
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height) arrowImageName:@"pull_down.png" textColor:[UIColor whiteColor] orientation:YES];
    _refreshHeaderView.delegate = self;
   	[self.tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)testFinishedLoadData{
	
    
    //[self setFooterView];
}
//===============
//刷新delegate
-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.tableView.contentSize.height, self.tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
	{
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
	{
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
 	}
    else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
    
}

//刷新调用的方法
-(void)refreshView
{
    //判断到什么时候就没有更多数据了
    
    //    currentWeek =  currentWeek - 2;
    //    if (currentWeek > 0) {
    //        [self getNetworkDataWithWeekOfPregnancy:currentWeek];
    //    }
    //    else
    //    {
    //        [self finishReloadingData];
    //
    //    }
    self.isLoadNextData = NO;
    [self getNetworkDataWithWeekOfPregnancy:3];
    
    
}

- (void)getNextPageView
{
    //判断到什么时候就没有更多数据了
    
    self.isLoadNextData = YES;
    [self getNetworkDataWithWeekOfPregnancy:3];
  
}
#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        [self removeFooterView];//先移除
        [self setFooterView];
    }
    
    
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //刷新数据
    if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    
}

//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
    if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}



#pragma mark - EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{

	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

