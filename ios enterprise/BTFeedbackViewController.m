//
//  BTFeedbackViewController.m
//  TEXTFEEDBACK
//
//  Created by wangpeng on 14-1-18.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import "BTFeedbackViewController.h"
#import "BTFeedbackTopicsViewController.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "LayoutDef.h"
#import "BTFeedbackCell.h"
@interface BTFeedbackViewController ()

- (NSString *)platform;
- (NSString *)platformString;
- (NSString*)feedbackSubject;
- (NSString*)feedbackBody;
- (NSString*)appName;
- (NSString*)appVersion;
- (NSString*)selectedTopic;
- (NSString*)selectedTopicToSend;
- (void)updatePlaceholder;
@property(nonatomic,strong)UIButton *backButton;

@end

@implementation BTFeedbackViewController


+ (BOOL)isAvailable
{
    if([MFMailComposeViewController class]){
        return YES;
    }
    return NO;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        self.topicsToSend = [[NSArray alloc]initWithObjects:
                              @"疑问",
                              @"您的要求",
                              @"Bug 反馈",
                              @"商务合作",
                              @"其他",nil];

    }
    return self;
}

- (id)initWithTopics:(NSArray*)theIssues
{
    self = [self init];
    if(self){
        self.topicsToSend = theIssues;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"邮件反馈";
    [self configureNavigationbarBackButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"邮件" style:UIBarButtonItemStyleDone target:self action:@selector(nextDidPress:)];

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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updatePlaceholder];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(_isFeedbackSent){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section==0){
        return 2;
    }
    return 4;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==1){
        return MAX(88, _descriptionTextView.contentSize.height);
    }
    
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    aView.backgroundColor = kTableViewSectionColor;
   
    //加一个一像素的分割线
    UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seperator_line"]];
    lineImage.frame = CGRectMake(0, 44 - kSeparatorLineHeight ,320, kSeparatorLineHeight);
    [aView addSubview:lineImage];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, (44 - 5*2))];
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = NSTextAlignmentLeft;
   // lable.textColor =kGlobalColor;
    [aView addSubview: lable];
    switch (section) {
        case 0:
            lable.text = @"请输入内容";
            break;
        case 1:
            lable.text = @"您的手机";
            break;
        default:
            break;
    }
    
    static int tag = 1001;
    aView.tag = tag++;
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BTFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if(indexPath.section==1){
            //General Infos
            cell = [[BTFeedbackCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.indicateImage.hidden = YES;
           
        }else{
            if(indexPath.row==0){
                //Topics
                cell = [[BTFeedbackCell alloc] initWithStyle:UITableViewCellStyleValue1      reuseIdentifier:CellIdentifier];
                cell.indicateImage.hidden = NO;
            }else{
                //Topics Description
                cell = [[BTFeedbackCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:CellIdentifier];
                cell.indicateImage.hidden = YES;
                cell.lineImage.hidden = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                _descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, 300, 88)];
                _descriptionTextView.backgroundColor = [UIColor clearColor];
                _descriptionTextView.font = [UIFont systemFontOfSize:16];
                _descriptionTextView.delegate = self;
                _descriptionTextView.scrollEnabled = NO;
                _descriptionTextView.text = self.descriptionText;
                [cell.contentView addSubview:_descriptionTextView];
                
                _descriptionPlaceHolder = [[UITextField alloc]initWithFrame:CGRectMake(16, 8, 300, 20)];
                _descriptionPlaceHolder.font = [UIFont systemFontOfSize:16];
                _descriptionPlaceHolder.placeholder = @"请输入内容：";
                _descriptionPlaceHolder.userInteractionEnabled = NO;
                [cell.contentView addSubview:_descriptionPlaceHolder];
                
                [self updatePlaceholder];
            }
        }
    }
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    
                    cell.textLabel.text = @"主题";
                    cell.detailTextLabel.text = [self selectedTopicToSend];
                    break;
                case 1:
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"iPhone";
                    cell.detailTextLabel.text = [self platformString];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case 1:
                    cell.textLabel.text = @"iOS";
                    cell.detailTextLabel.text = [UIDevice currentDevice].systemVersion;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case 2:
                    cell.textLabel.text = @"应用";
                    cell.detailTextLabel.text = [self appName];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case 3:
                    cell.textLabel.text = @"应用版本";
                    cell.detailTextLabel.text = [self appVersion];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==0){
        [_descriptionTextView resignFirstResponder];
        
        BTFeedbackTopicsViewController *feedbackTopicVc = [[BTFeedbackTopicsViewController alloc]initWithStyle:UITableViewStylePlain];
        [feedbackTopicVc.navigationItem setHidesBackButton:YES];
        feedbackTopicVc.delegate = self;
        feedbackTopicVc.selectedIndex = _selectedTopicsIndex;
        [self.navigationController pushViewController:feedbackTopicVc animated:YES];
    }
}


- (void)cancelDidPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextDidPress:(id)sender
{
    [_descriptionTextView resignFirstResponder];
    
    
//    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
//    
//    if (mailClass != nil)
//    {
//        if ([mailClass canSendMail])
//        {
//            [self displayComposerSheet];
//        }
//        else
//        {
//            [self launchMailAppOnDevice];
//        }
//    }
//    else
//    {
//        [self launchMailAppOnDevice];
//    }
    
  

    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = self;
    [picker setToRecipients:self.toRecipients];
    [picker setCcRecipients:self.ccRecipients];
    [picker setBccRecipients:self.bccRecipients];
    
    [picker setSubject:[self feedbackSubject]];
    [picker setMessageBody:[self feedbackBody] isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)textViewDidChange:(UITextView *)textView
{
    CGRect f = _descriptionTextView.frame;
    f.size.height = _descriptionTextView.contentSize.height;
    _descriptionTextView.frame = f;
    [self updatePlaceholder];
    self.descriptionText = _descriptionTextView.text;
    
    //Magic for updating Cell height
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if(result==MFMailComposeResultCancelled){
    }else if(result==MFMailComposeResultSent){
        _isFeedbackSent = YES;
    }else if(result==MFMailComposeResultFailed){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"发送邮件失败"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
            }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (void)feedbackTopicsViewController:(BTFeedbackTopicsViewController *)feedbackTopicsViewController didSelectTopicAtIndex:(NSInteger)selectedIndex {
    _selectedTopicsIndex = selectedIndex;
}

#pragma mark - Internal Info

- (void)updatePlaceholder
{
    if([_descriptionTextView.text length]>0){
        _descriptionPlaceHolder.hidden = YES;
    }else{
        _descriptionPlaceHolder.hidden = NO;
    }
}

- (NSString*)feedbackSubject
{
    return [NSString stringWithFormat:@"%@: %@", [self appName],[self selectedTopicToSend], nil];
}

- (NSString*)feedbackBody
{
    NSString *body = [NSString stringWithFormat:@"%@\n\n\nDevice:\n%@\n\niOS:\n%@\n\nApp:\n%@ %@",
                      _descriptionTextView.text,
                      [self platformString],
                      [UIDevice currentDevice].systemVersion,
                      [self appName],
                      [self appVersion], nil];
    
    return body;
}

- (NSString*)selectedTopic
{
    return [_topics objectAtIndex:_selectedTopicsIndex];
}

- (NSString*)selectedTopicToSend
{
    return [_topicsToSend objectAtIndex:_selectedTopicsIndex];
}

- (NSString*)appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:
            @"CFBundleDisplayName"];
}

- (NSString*)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

// Codes are from
// http://stackoverflow.com/questions/448162/determine-device-iphone-ipod-touch-with-iphone-sdk
// Thanks for sss and UIBuilder
- (NSString *) platform
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

- (NSString *) platformString
{
    NSString *platform = [self platform];
    NSLog(@"%@",platform);
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad 4 (CDMA)";
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
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
