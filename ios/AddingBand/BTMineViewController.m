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
@interface BTMineViewController ()

@end

@implementation BTMineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //设置tableview类型 为UITableViewStyleGrouped
      //  self.tableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.showsVerticalScrollIndicator = NO;
        //cell标题内容
        self.titleArray = [NSArray arrayWithObjects:@"账户名称",@"我的手机号",@"我的邮箱",@"修改密码",@"孕期概况",@"生日",@"预产期",@"怀孕症状",@"系统设置",@"检查更新",@"点个赞！",@"关于", nil];
          self.contentArray = [NSArray arrayWithObjects:@"",@"13466668888",@"yitu@126.com",@"修改密码",@"",@"2013.12.25",@"2013.12.25",@"高血压",@"",@"",@"",@"", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  //  self.view.backgroundColor = [UIColor blueColor];
    NSLog(@"==================%@",NSStringFromCGRect(self.view.frame));
	// Do any additional setup after loading the view.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //刚开始没有连接上设备的时候 每个设备下面只有一行  显示“立即连接” ;当连接上的时候 设备下面变成两行 显示“上次同步时间” “立即同步”
    //当同步完的时候 怎么做？？？
    return 12;
}

////分区头 所要显示的文字
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//
//{
//    switch (section) {
//        case 0:
//            return @"账户名称";
//            break;
//        case 1:
//            return @"孕期概况";
//            break;
//        case 2:
//            return @"系统设置";
//            break;
//        default:
//            break;
//    }
//    return nil;
//}
//

////动态改变每一行的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierSection = @"CellSection";
    static NSString *CellIdentifierIndicate = @"CellIndicate";
    BTSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BTSettingSectionCell *cellSection = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSection];
    BTSettingIndicateCell *cellIndicate = [tableView dequeueReusableCellWithIdentifier:CellIdentifierIndicate];

    if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 8) {
        if (cellSection == nil ) {
            cellSection = [[BTSettingSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSection];
        }
        cellSection.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
        cellSection.selectionStyle = UITableViewCellSelectionStyleNone;//选中无效果
        return cellSection;
    }
    else if (indexPath.row == 3){
        if (cellIndicate == nil ) {
            cellIndicate = [[ BTSettingIndicateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierIndicate];
        }
        cellIndicate.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
        cellIndicate.selectionStyle = UITableViewCellSelectionStyleNone;//选中无效果
        return cellIndicate;

    }
    
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
