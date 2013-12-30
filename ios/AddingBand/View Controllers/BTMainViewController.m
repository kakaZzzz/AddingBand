//
//  BTMainViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-20.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTMainViewController.h"
#import "LayoutDef.h"
#import "BTMainViewCell.h"
#import "UMSocialSnsService.h"//友盟分享
#import "UMSocial.h"
#import "NSDate+DateHelper.h"
#import "BTUtils.h"
#import "BTAlertView.h"

#import "BTKnowledgeViewController.h"
#define NAVIGATIONBAR_Y 0
#define NAVIGATIONBAR_HEIGHT 65
@interface BTMainViewController ()

@end

@implementation BTMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
        [self popAlertView];
        
        
    }

     [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
 
    [self popAlertView];
    
    [self addSubviews];
    [self addChageScrollViewToTopButton];
    [self createHeaderView];
	// Do any additional setup after loading the view.
}
#pragma mark - 加载返回第一行按钮
- (void)addChageScrollViewToTopButton
{
    self.toTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toTopButton.frame = CGRectMake(10, self.view.frame.size.height - 100, 50, 50);
    _toTopButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [_toTopButton addTarget:self action:@selector(toTop:) forControlEvents:UIControlEventTouchUpInside];
    [_toTopButton setTitle:@"toTop" forState:UIControlStateNormal];
    [self.view addSubview:_toTopButton];
}
//返回到首页
- (void)toTop:(UIButton *)button
{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
     self.tableView.contentOffset = CGPointMake(0, 0);
    } completion:nil];
    
 }
#pragma mark - 加载子视图
- (void)addSubviews
{
    self.navigationBgView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_Y, 320, NAVIGATIONBAR_HEIGHT)];
    _navigationBgView.backgroundColor = kGlobalColor;
    [self.view addSubview:_navigationBgView];
    
    UIButton *clockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clockButton setTitle:@"产检期" forState:UIControlStateNormal];
    [clockButton addTarget:self action:@selector(inputYourPreproduction:) forControlEvents:UIControlEventTouchUpInside];
    clockButton.frame = CGRectMake(320 - 100, 30, 100, 50);
    [_navigationBgView addSubview:clockButton];
//    self.tableViewBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, _navigationBgView.frame.origin.y + _navigationBgView.frame.size.height, 320, self.view.frame.size.height - NAVIGATIONBAR_HEIGHT)];
//    _tableViewBackgroundView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_tableViewBackgroundView];
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, 320, 40)];
    _headView.backgroundColor = kGlobalColor;
    [self.view addSubview:_headView];

    //加载tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headView.frame.origin.y + _headView.frame.size.height, 320,self.view.frame.size.height)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - popview 请输入预产期
- (void)popAlertView
{
    

    BTAlertView *alert = [[BTAlertView alloc] initWithTitle:@"美妈美妈" iconImage:nil contentText:@"请输入宝宝预产期" leftButtonTitle:nil rightButtonTitle:@"好的"];
    [alert show];
    alert.rightBlock = ^() {
        NSLog(@"right button clicked");
        //弹出输入预产期选择器
        if (self.actionSheetView == nil) {
            self.actionSheetView = [[BTSheetPickerview alloc] initWithPikerType:BTActionSheetPickerStyleDatePicker referView:self.view delegate:self];
        }
        
        [_actionSheetView show];
        
    };
    alert.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };
    
}

#pragma mark - 各种button event
//点击分区头上的按钮 进入下一页
- (void)pushNextView:(UIButton *)button
{
    NSLog(@"点击分区头，进入下一页");
}

//输入预产期
- (void)inputYourPreproduction:(UIButton *)button
{
    if (self.actionSheetView == nil) {
        self.actionSheetView = [[BTSheetPickerview alloc] initWithPikerType:BTActionSheetPickerStyleDatePicker referView:self.view delegate:self];
    }
    
    [_actionSheetView show];

}
#pragma mark - 输入预产期 日期选择器delegate
- (void)actionSheetPickerView:(BTSheetPickerview *)pickerView didSelectDate:(NSDate*)date
{
    
    NSDate *localDate = [NSDate localdateByDate:date];
    NSString *dateAndTime = [NSDate stringFromDate:date withFormat:@"yy-MM-dd HH:mm:ss"];
    NSNumber *year = [BTUtils getYear:localDate];
    NSNumber *month = [BTUtils getMonth:localDate];
    NSNumber *day = [BTUtils getDay:localDate];
    NSNumber *hour = [BTUtils getHour:localDate];
    NSNumber *minute = [BTUtils getMinutes:localDate];
   
    
    NSLog(@"选择的日期是。。。。。%@",dateAndTime);
    NSLog(@"选泽的年：%@,月：%@，日：%@,小时：%@,分钟：%@",year,month,day,hour,minute);
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 60 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    aView.backgroundColor = [UIColor greenColor];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, (44 - 5*2))];
    lable.backgroundColor = [UIColor blueColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor =[UIColor whiteColor];
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(320 - 100, 10,100, (44 - 10*2));
    button.tag = MAIN_BUTTON_TAG + section;
    [button setTitle:@"卵子受孕中" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushNextView:) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:button];
    
    if (section == 0) {
       lable.text = @"3周";
    }
    if (section == 1)
    {
        lable.text = @"看.属于你的文字";
        
    }
    if (section == 2)
    {
        lable.text = @"做.属于你的个性";
        
    }
    
    [aView addSubview: lable];
  
    static int tag = 1001;
    aView.tag = tag++;
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BTMainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BTMainViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = @"哈哈";
    return cell;
    
}

#pragma mark - tabelview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTKnowledgeViewController *knowledge = [[BTKnowledgeViewController alloc] init];
    knowledge.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:knowledge animated:YES];
    
    
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
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height) arrowImageName:@"blueArrow.png" textColor:[UIColor whiteColor] orientation:YES];
    _refreshHeaderView.delegate = self;
   	[self.tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)testFinishedLoadData{
	
    
    //[self setFooterView];
}
//===============
//刷新delegate
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
}

//刷新调用的方法
-(void)refreshView
{
    
    //[self requestNetwork];
    
    NSLog(@"刷新完成");
    [self finishReloadingData];
    
    
    
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    
    
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= 40) {
        // static CGRect rect = _headView.frame;
        NSLog(@"..........%f",_tableView.contentOffset.y);
        
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _headView.frame = CGRectMake(0,NAVIGATIONBAR_HEIGHT - scrollView.contentOffset.y, 320, 40);
            self.tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT - scrollView.contentOffset.y + 40, 320, self.view.frame.size.height);
            
        } completion:nil];
        [self.view bringSubviewToFront:_navigationBgView];
    }
    
    
    else if (scrollView.contentOffset.y > 40) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _headView.frame = CGRectMake(0,NAVIGATIONBAR_HEIGHT - 40, 320, 40);
            self.tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT - 40 + 40, 320, self.view.frame.size.height - 59);
            
        } completion:nil];
        
    }
    
    else{
        //[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _headView.frame = CGRectMake(0,NAVIGATIONBAR_HEIGHT, 320, 40);
        
        //} completion:nil];
        
    }
    NSLog(@"..........%f",_tableView.contentOffset.y);
    
    //刷新数据
    if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
}

//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
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
