//
//  BTMainViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-20.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTMainViewController.h"
#import "LayoutDef.h"

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
    [self addSubviews];
	// Do any additional setup after loading the view.
}
#pragma mark - 加载子视图
- (void)addSubviews
{
    self.navigationBgView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_Y, 320, NAVIGATIONBAR_HEIGHT)];
    _navigationBgView.backgroundColor = kGlobalColor;
    [self.view addSubview:_navigationBgView];
    
//    self.tableViewBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, _navigationBgView.frame.origin.y + _navigationBgView.frame.size.height, 320, self.view.frame.size.height - NAVIGATIONBAR_HEIGHT)];
//    _tableViewBackgroundView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_tableViewBackgroundView];
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, 320, 40)];
    _headView.backgroundColor = kGlobalColor;
    [self.view addSubview:_headView];

    //加载tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headView.frame.origin.y + _headView.frame.size.height, 320,self.view.frame.size.height)];
    _tableView.backgroundColor = [UIColor blueColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}
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
}
#pragma mark - Table view data source

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
- (void)pushNextView:(UIButton *)button
{
    NSLog(@"点击分区头，进入下一页");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.separatorColor = [UIColor clearColor];
//    BTPhisicalModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    cell.physicalModel = model;
    cell.textLabel.text = @"哈哈";
    return cell;
    
}

#pragma mark - tabelview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
