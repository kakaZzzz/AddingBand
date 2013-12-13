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

#define CELL_SECTION (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 8)
#define CELL_INDICATOR (indexPath.row == 3 || indexPath.row == 9 || indexPath.row == 10 ||indexPath.row == 11)
#define CELL_TEXTFIELD (indexPath.row == 7)
#define CELL_ACCOUNT (indexPath.row ==  12)

#define ANIMATION_TIME 0.5f

static int selected = 0;//选择行数
static NSString *birthday = nil;//生日
static NSString *duedate = nil;//预产期
static NSString *pregnancy = nil;//怀孕症状
@interface BTMineViewController ()

@end

@implementation BTMineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.showsVerticalScrollIndicator = NO;
        
        birthday = @"2013.12.25";
        duedate = @"2013.12.25";
        pregnancy = @"高血压";
        //从coredata中读取数据
        
        NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserData" sortKey:nil];
        if (data.count > 0) {
            BTUserData *userData = [data objectAtIndex:0];
            birthday = userData.birthday;
            duedate = userData.dueDate;
            pregnancy =  userData.pregnancy;
            self.contentArray = [NSArray arrayWithObjects:@"",@"13466668888",@"yitu@126.com",@"修改密码",@"",userData.birthday,userData.dueDate,userData.pregnancy,@"",@"",@"",@"", nil];
            
        }
        else
        {
            self.contentArray = [NSArray arrayWithObjects:@"",@"13466668888",@"yitu@126.com",@"修改密码",@"",birthday,duedate,pregnancy,@"",@"",@"",@"", nil];
        }
        //cell标题内容
        self.titleArray = [NSArray arrayWithObjects:@"账户名称",@"我的手机号",@"我的邮箱",@"修改密码",@"孕期概况",@"生日",@"预产期",@"怀孕症状",@"系统设置",@"检查更新",@"点个赞！",@"关于", nil];
        
        
        //注册为观察者 监听时间选择器的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewContentOffSize) name:DATEPICKERDISMISSNOTICE object:nil];
        
        //
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 13;
}


//动态改变每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 12)
    {
        return 130;
    }
    else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierSection = @"CellSection";
    static NSString *CellIdentifierIndicate = @"CellIndicate";
    BTSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BTSettingSectionCell *cellSection = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSection];
    BTSettingIndicateCell *cellIndicate = [tableView dequeueReusableCellWithIdentifier:CellIdentifierIndicate];
    
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
    else if (CELL_INDICATOR){
        if (cellIndicate == nil ) {
            cellIndicate = [[ BTSettingIndicateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierIndicate];
        }
        cellIndicate.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
        cellIndicate.selectionStyle = UITableViewCellSelectionStyleGray;//选中灰色效果
        return cellIndicate;
        
    }
    //带输入框的
    else if(CELL_TEXTFIELD){
        
        BTTextfieldCell *textCell = [[BTTextfieldCell alloc] init];
        textCell.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
        textCell.contenTextField.text = [_contentArray objectAtIndex:indexPath.row];
        textCell.contenTextField.returnKeyType = UIReturnKeyDone;//返回按键类型
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中无效果
        textCell.contenTextField.delegate = self;
        return textCell;
    }
    
    else if(CELL_ACCOUNT)
    {
        BTAccountCell *cellAccount = [[BTAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        // cellAccount.textLabel.text = @"你好您好";
        cellAccount.selectionStyle = UITableViewCellSelectionStyleNone;//选中无效果
        cellAccount.chooseAccountBlock = ^(NSString *account){
            
            //获得账号  然后将账号发给服务器 验证 登录
            
            NSLog(@"选择的账号是%@",account);
            
        };
        return cellAccount;
    }
    
    //带Label的Cell
    else{
        if (cell == nil) {
            cell = [[BTSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        // cellFind.bluetoothName.text = [NSString stringWithFormat:@"%@",name];
        cell.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
        cell.contentLabel.text = [_contentArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中无效果
        return cell;
    }
    return nil;
}

#pragma mark - tabelview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    BTSettingCell *cell =(BTSettingCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    //  [cell.contenTextField resignFirstResponder];
    //时间选择器
    if (indexPath.row == 5 || indexPath.row == 6) {
        selected = indexPath.row;
        [self showPicker:cell.titleLabel.text];
        self.pickerLabel = cell.contentLabel;
    }
    //修改密码
    if (indexPath.row == 3) {
        BTModifyPasswordViewController *modifyVC = [[BTModifyPasswordViewController alloc] init];
        [modifyVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:modifyVC animated:YES];
    }
    
    if (indexPath.row == 9) {
        
        //检查更新
        [BTCheckVersion checkVersion];
        
    }
    
    if (indexPath.row == 10) {
        //打开AppStore去评分
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/bai-du-yin-le/id468623917?mt=8"]];
    }
    //关于页面
    if (indexPath.row == 11) {
        BTAboutViewController *aboutVC = [[BTAboutViewController alloc] init];
        // [aboutVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    
}
//弹出选择器
- (void)showPicker:(NSString *)title
{
    
    //
    BTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *mainWindow = appDelegate.window;
    self.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:mainWindow];
    self.flatDatePicker.delegate = self;
    self.flatDatePicker.title = title;
    self.flatDatePicker.datePickerMode = FlatDatePickerModeDate;
    
    [UIView beginAnimations:@"FlatDatePickerShow1" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:ANIMATION_TIME];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    self.tableView.contentOffset = CGPointMake(0, 100);
    self.tableView.userInteractionEnabled = NO;
    [UIView commitAnimations];
    
    [self.flatDatePicker show];
}
//收回选择器 视图调整偏移量到初始位置
- (void)changeViewContentOffSize
{
    [UIView beginAnimations:@"FlatDatePickerDismiss" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:ANIMATION_TIME];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    self.tableView.contentOffset = CGPointMake(0, 0);
    self.tableView.userInteractionEnabled = YES;
    [UIView commitAnimations];
}
#pragma mark - FlatDatePickerDelegate
- (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(id)date {
    //   if (self.flatDatePicker.datePickerMode == FlatDatePickerModeWeight) {
    NSLog(@"%@",date);
    
    NSLog(@"dateDidChange");
    //   }
    
    NSNumber* year = [BTUtils getYear:date];
    NSNumber* month = [BTUtils getMonth:date];
    NSNumber* day = [BTUtils getDay:date];
    NSNumber* hour = [BTUtils getHour:date];
    NSNumber* minute = [BTUtils getMinutes:date];
    NSLog(@"%@ %@ %@ %@ %@",year,month,day,hour,minute);
    self.pickerLabel.text = [NSString stringWithFormat:@"%@.%@.%@",year,month,day];
    NSLog(@"%@",self.pickerLabel.text);
    
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didCancel:(UIButton*)sender {
    
    NSLog(@"didCancel");
    
    
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didValid:(UIButton*)sender date:(id)date {
    
    //获取当前时间
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate *localeDate = [date1  dateByAddingTimeInterval: interval];
    
    NSNumber* year = [BTUtils getYear:date];
    NSNumber* month = [BTUtils getMonth:date];
    NSNumber* day = [BTUtils getDay:date];
    NSNumber *day1 =[NSNumber numberWithInt:([day intValue]+1)];//因为选择器会莫名的比选择的早一天
    NSNumber* hour = [BTUtils getHour:date];
    NSNumber* minute = [BTUtils getMinutes:date];
    
    self.pickerLabel.text = [NSString stringWithFormat:@"%@.%@.%@",year,month,day1];
    //生日选择
    if (selected == 5) {
        birthday = self.pickerLabel.text;
        //数据持久化 存放在coredata里面
        NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserData" sortKey:nil];
        if (data.count > 0) {
            self.context =[BTGetData getAppContex];
            BTUserData *userData = [data objectAtIndex:0];
            userData.birthday = _pickerLabel.text;
            [_context save:nil];
            
            self.contentArray = [NSArray arrayWithObjects:@"",@"13466668888",@"yitu@126.com",@"修改密码",@"",birthday,duedate,pregnancy,@"",@"",@"",@"", nil];
            
        }
        else
        {
            self.context =[BTGetData getAppContex];
            
            //往context中插入一个对象
            BTUserData *userData = [NSEntityDescription insertNewObjectForEntityForName:@"BTUserData" inManagedObjectContext:_context];
            userData.birthday = _pickerLabel.text;
            [_context save:nil];
            self.contentArray = [NSArray arrayWithObjects:@"",@"13466668888",@"yitu@126.com",@"修改密码",@"",birthday,duedate,pregnancy,@"",@"",@"",@"", nil];
        }
    }
    //预产期
    if (selected == 6) {
        duedate = self.pickerLabel.text;
        //数据持久化 存放在coredata里面
        NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserData" sortKey:nil];
        if (data.count > 0) {
            NSManagedObjectContext *context =[BTGetData getAppContex];
            BTUserData *userData = [data objectAtIndex:0];
            userData.dueDate = _pickerLabel.text;
            [context save:nil];
            self.contentArray = [NSArray arrayWithObjects:@"",@"13466668888",@"yitu@126.com",@"修改密码",@"",birthday,duedate,pregnancy,@"",@"",@"",@"", nil];
            
        }
        else
        {
            self.context =[BTGetData getAppContex];
            
            //往context中插入一个对象
            BTUserData *userData = [NSEntityDescription insertNewObjectForEntityForName:@"BTUserData" inManagedObjectContext:_context];
            userData.dueDate = _pickerLabel.text;
            [_context save:nil];
            self.contentArray = [NSArray arrayWithObjects:@"",@"13466668888",@"yitu@126.com",@"修改密码",@"",birthday,duedate,pregnancy,@"",@"",@"",@"", nil];
        }
    }
    NSLog(@"%@",self.contentArray);
    [self.tableView reloadData];
    NSLog(@"%@ %@ %@ %@ %@",year,month,day,hour,minute);
    NSLog(@"现在时间是多少:%@",localeDate);
    NSLog(@"选择了时间%@",date);
}

#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserData" sortKey:nil];
    pregnancy = textField.text;
    if (data.count > 0) {
        self.context =[BTGetData getAppContex];
        BTUserData *userData = [data objectAtIndex:0];
        userData.pregnancy = textField.text;
        [_context save:nil];
        self.contentArray = [NSArray arrayWithObjects:@"",@"13466668888",@"yitu@126.com",@"修改密码",@"",birthday,duedate,pregnancy,@"",@"",@"",@"", nil];
        
        
    }
    else
    {
        self.context =[BTGetData getAppContex];
        //往context中插入一个对象
        BTUserData *userData = [NSEntityDescription insertNewObjectForEntityForName:@"BTUserData" inManagedObjectContext:_context];
        userData.pregnancy = textField.text;
        [_context save:nil];
        self.contentArray = [NSArray arrayWithObjects:@"",@"13466668888",@"yitu@126.com",@"修改密码",@"",birthday,duedate,pregnancy,@"",@"",@"",@"", nil];
    }
    
}
//收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
