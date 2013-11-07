//
//  BTSyncViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-4.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTSyncViewController.h"
#import "BTBluetoothLinkCell.h"
@interface BTSyncViewController ()

@end

@implementation BTSyncViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
        //设置背景颜色
        UIView *_backgroundview = [[UIView alloc] initWithFrame:self.view.bounds];
        [_backgroundview setBackgroundColor:[UIColor whiteColor]];
        [self.tableView setBackgroundView:_backgroundview];
        
        self.tableView.allowsSelection = NO;
        
        //数据
        self.keyArray = [NSArray arrayWithObjects:@"A1-- XXXX  95%",@"A2-- XXXX  98%", @"A3-- XXXX  100%",nil];
        NSArray *valueArray1 = [NSArray arrayWithObjects:@"上次同步 Wednesday",@"立即同步", nil];
        NSArray *valueArray2 = [NSArray arrayWithObjects:@"立即连接",nil];
        NSArray *valueArray3 = [NSArray arrayWithObjects:@"立即连接", nil];
        NSArray *valueArray = [NSArray arrayWithObjects:valueArray1,valueArray2,valueArray3, nil];
        self.dataDictionary = [NSMutableDictionary dictionaryWithObjects:valueArray forKeys:_keyArray];
      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    NSLog(@"3333333333333333333%@",NSStringFromCGRect(self.tableView.frame));
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [self.dataDictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.dataDictionary  objectForKey:[self.keyArray objectAtIndex:section]] count];
}
//分区头 所要显示的文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
//    switch (section) {
//        case 0:
//        {
//         return @"A1-- XXXX  95%";
//            break;
//        }
//        case 1:
//        {
//        return @"A2-- XXXX  98%";
//            break;
//        }
//        case 2:
//        {
//        return @"A3-- XXXX  100%";
//            break;
//    
//        }
//        default:
//            break;
//    }
//    return nil;
    
    //注意字典是无序的
    return [self.keyArray objectAtIndex:section];
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BTBluetoothLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BTBluetoothLinkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier tatget:self];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
   // cell.textLabel.text = @"首次连接";
  cell.textLabel.text =  [[self.dataDictionary  objectForKey:[self.keyArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    return cell;
}

//Cell上面按钮的触发事件 蛋疼
- (void)testButtonOut:(UIButton *)button event:(id)event
{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    NSLog(@"点击的是第 %d分区 第 %d 行",indexPath.section,indexPath.row);
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
