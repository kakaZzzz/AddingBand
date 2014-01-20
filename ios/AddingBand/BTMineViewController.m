//
//  BTMineViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTMineViewController.h"
#import "BTSettingCell.h"
#import "BTSettingSectionCell.h"
#import "BTSettingIndicateCell.h"
#import "BTUtils.h"
#import "BTAppDelegate.h"
#import "LayoutDef.h"
#import "BTAboutViewController.h"
#import "BTModifyPasswordViewController.h"
#import "BTCheckVersion.h"
#import "BTTextfieldCell.h"
#import "BTGetData.h"
#import "BTUserData.h"
#import "BTAccountCell.h"
#import "BTUserSetting.h"

#import "BTCustomSettingCell.h"
#import "BTModifyDateViewController.h"
#import "BTFeedbackViewController.h"//
#import "BTNavicationController.h"
#define CELL_SECTION (indexPath.row == 0 || indexPath.row == 4)
#define CELL_INDICATOR (indexPath.row == 3 || indexPath.row == 9 || indexPath.row == 10 ||indexPath.row == 11)
#define CELL_TEXTFIELD (indexPath.row == 7)
#define CELL_ACCOUNT (indexPath.row ==  12)

#define ANIMATION_TIME 0.5f


static NSString *birthday = nil;//生日
static NSString *duedate = nil;//预产期
static NSString *menstruation = nil;//末次月经时间
static NSString *version = nil;//版本号
@interface BTMineViewController ()

@end

@implementation BTMineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
           //cell标题内容
        self.titleArray = [NSArray arrayWithObjects:@"关于用户",@"生日",@"末次月经时间",@"预产期",@"系统设置",@"检查更新",@"评分",@"关于",@"意见反馈",nil];
        self.iconArray = [NSArray arrayWithObjects:@"",@"setting_birthday_icon",@"setting_menstrual_icon",@"setting_duedate_icon",@"",@"setting_version_icon",@"setting_grade_icon",@"setting_about_icon",@"setting_feedback_icon" ,nil];
        
         
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    
 
    birthday = @"2013.12.25";
    duedate = @"2013.12.25";
    menstruation = @"2013.12.25";
    NSString *versionString =  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];//获取版本号
    version = [NSString stringWithFormat:@"V%@",versionString];
    //从coredata中读取数据
    
    NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    if (data.count > 0) {
        BTUserSetting *userData = [data objectAtIndex:0];
        if (userData.birthday) {
            birthday = userData.birthday;
        }
        if (userData.dueDate) {
            duedate = userData.dueDate;
        }
        if (userData.menstruation) {
             menstruation =  userData.menstruation;
        }
        self.contentArray = [NSArray arrayWithObjects:@"",birthday,menstruation,duedate,@"",version,@"",@"",@"",nil];
        
    }
    else
    {
        
        self.contentArray = [NSArray arrayWithObjects:@"",birthday,menstruation,duedate,@"",version,@"",@"",@"",nil];
    }

    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    NSLog(@"页面高度是   %0.1f",self.view.frame.size.height);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 50 - 10) style:UITableViewStylePlain];
    if (IOS7_OR_LATER) {
        self.tableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 50 - 20 -10);
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 9;
}


//动态改变每一行的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return 90/2;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    

    static NSString *CellIdentifierSection = @"CellSection";
    static NSString *CellIdentifierIndicate = @"CellIndicate";
    BTSettingSectionCell *cellSection = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSection];
    BTCustomSettingCell *cellIndicate = [tableView dequeueReusableCellWithIdentifier:CellIdentifierIndicate];
    
    //类分区
    if (CELL_SECTION) {
        if (cellSection == nil ) {
            cellSection = [[BTSettingSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSection];
        }
        cellSection.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
        cellSection.selectionStyle = UITableViewCellSelectionStyleNone;//选中无效果
        return cellSection;
    }
    //带箭头
    else {
        if (cellIndicate == nil ) {
            cellIndicate = [[ BTCustomSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierIndicate];
        }
        
        cellIndicate.iconImage.image = [UIImage imageNamed:[self.iconArray objectAtIndex:indexPath.row]];
        cellIndicate.indexRow = indexPath.row;
        //cellIndicate.indicateImage = UITableViewCellAccessoryDisclosureIndicator;
        cellIndicate.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
        cellIndicate.contentLabel.text = [_contentArray objectAtIndex:indexPath.row];
        cellIndicate.selectionStyle = UITableViewCellSelectionStyleGray;//选中灰色效果
        return cellIndicate;
        
    }
    return nil;
 }

#pragma mark - tabelview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    switch (indexPath.row) {
        case 1://修改生日
        {
            BTModifyDateViewController *modifyVC = [[BTModifyDateViewController alloc] init];
            modifyVC.modifyType = MODIFY_BIRTHDAY_TYPE;
            modifyVC.hidesBottomBarWhenPushed = YES;
           [modifyVC.navigationItem setHidesBackButton:YES];//隐藏系统的返回按钮
            
            [self.navigationController pushViewController:modifyVC animated:YES];
        }
            break;
        case 2://修改末次月经日期
        {
            BTModifyDateViewController *modifyVC = [[BTModifyDateViewController alloc] init];
            modifyVC.modifyType = MODIFY_MENSTRUATION_TYPE;
            [modifyVC.navigationItem setHidesBackButton:YES];
            modifyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:modifyVC animated:YES];
        }
            break;
        case 3://修改预产期
        {
            BTModifyDateViewController *modifyVC = [[BTModifyDateViewController alloc] init];
            modifyVC.modifyType = MODIFY_DUEDATE_TYPE;
            [modifyVC.navigationItem setHidesBackButton:YES];
            modifyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:modifyVC animated:YES];
        }
            break;
        case 5://检查更新
        {
           // 检查更新
            [BTCheckVersion checkVersion];

        }
            break;
        case 6:
        {
            //打开AppStore去评分
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/bai-du-yin-le/id468623917?mt=8"]];
        }
            break;
        case 7://关于
        {
            BTAboutViewController *aboutVC = [[BTAboutViewController alloc] init];
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        case 8://意见反馈
        {
            BTFeedbackViewController *feedbackVc = [[BTFeedbackViewController alloc]init];
            [feedbackVc.navigationItem setHidesBackButton:YES];//隐藏系统的返回按钮
            feedbackVc.hidesBottomBarWhenPushed = YES;
            feedbackVc.toRecipients = [NSArray arrayWithObject:@"yituwangpeng@gmail.com"];
            feedbackVc.ccRecipients = nil;
            feedbackVc.bccRecipients = nil;
            [self.navigationController pushViewController:feedbackVc animated:YES];

        }
            break;
   
        default:
            break;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
