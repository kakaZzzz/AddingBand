//
//  BTFeedbackTopicsViewController.m
//  TEXTFEEDBACK
//
//  Created by wangpeng on 14-1-18.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import "BTFeedbackTopicsViewController.h"

@interface BTFeedbackTopicsViewController ()

- (NSInteger)selectedIndex;
- (void)updateCellselection;
-(NSArray*)topics;
@property(nonatomic,strong)UIButton *backButton;

@end

@implementation BTFeedbackTopicsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateCellselection];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"邮件标题";
    [self configureNavigationbarBackButton];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
#pragma mark - 设置导航栏上面的按钮
- (void)configureNavigationbarBackButton
{
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(250, 5, 100/2, 48/2);
    [_backButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_unselected"] forState:UIControlStateNormal];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_selected"] forState:UIControlStateHighlighted];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_selected"] forState:UIControlStateSelected];
    [_backButton addTarget:self action:@selector(backToUpperView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)_backButton];
    
}
- (void)backToUpperView:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_delegate){
        return [[self topics]count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self topics]objectAtIndex:indexPath.row];
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    [self setSelectedIndex:row];
    [self updateCellselection];
    
    if ([_delegate respondsToSelector:@selector(feedbackTopicsViewController:didSelectTopicAtIndex:)]) {
        [_delegate feedbackTopicsViewController:self didSelectTopicAtIndex:row];
    }
}

#pragma mark - Internal

- (NSInteger)selectedIndex
{
    return _selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)theIndex;
{
    _selectedIndex = theIndex;
}

- (void)updateCellselection
{
    NSArray *cells = [self.tableView visibleCells];
    int n = [cells count];
    for(int i=0; i<n; i++)
    {
        UITableViewCell *cell = [cells objectAtIndex:i];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:[self selectedIndex] inSection:0];
    
    UITableViewCell *cell;
    cell = [self.tableView cellForRowAtIndexPath:path];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.textLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    [cell setSelected:NO animated:YES];
}

- (NSArray*)topics
{
    return (NSArray*)[_delegate performSelector:@selector(topicsToSend)];
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
