//
//  BTMainViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTMainViewController.h"
#import "RBParallaxTableVC.h"
#import "BTUndoCell.h"
#import "BTChartViewController.h"


static NSString *textStr = nil;
@interface BTMainViewController ()

@end

@implementation BTMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    //在这里  添加图片
    self = [super initWithImage:[UIImage imageNamed:@"demo1@2x.png"]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    textStr = [NSString stringWithFormat:@"Hello AddingHome   "];
    NSLog(@"11111111111111%@",NSStringFromCGRect(self.view.frame));
   
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"配置tableView");
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
     return 1;
    else
     return 10;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//
//{
//    NSLog(@"titleForHeaderInSection");
//    if (section == 0) {
//        return nil;
//    }
//    else
//    return @"哈哈哈哈哈哈哈哈哈哈哈";
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
     return 130.0;
    else
    {
    NSLog(@"%f........",[BTUndoCell cellHeight:textStr]);
        
    return [BTUndoCell cellHeight:textStr];
        
    }
;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cellForRowAtIndexPath");
    static NSString *cellReuseIdentifier   = @"RBParallaxTableViewCell";
    static NSString *windowReuseIdentifier = @"RBParallaxTableViewWindow";
    
  
    if (indexPath.section == 0) {
       
     UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:windowReuseIdentifier];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:windowReuseIdentifier];
            cell.backgroundColor             = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle              = UITableViewCellSelectionStyleNone;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            //cell不可点击
            cell.userInteractionEnabled = NO;
        }
        return cell;
    } else {
        NSLog(@"显示内容cell");
      BTUndoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
        if (!cell) {
            cell = [[BTUndoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
            cell.backgroundColor             = [UIColor whiteColor];
            cell.contentLabel.text = @"Hello,AddingHome ";
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle              = UITableViewCellSelectionStyleNone;
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
        }
        return cell;
    }
 
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTChartViewController *chartVC = [[BTChartViewController alloc] init];
    //点击进入下一界面 进入历史记录页面
    chartVC.hidesBottomBarWhenPushed = YES;//隐藏tabbar
    [self.navigationController pushViewController:chartVC animated:YES];
    
}


@end
