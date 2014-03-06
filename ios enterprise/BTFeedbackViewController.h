//
//  BTFeedbackViewController.h
//  TEXTFEEDBACK
//
//  Created by wangpeng on 14-1-18.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "BTFeedbackTopicsViewController.h"

@interface BTFeedbackViewController : UITableViewController
<UITextViewDelegate,
MFMailComposeViewControllerDelegate,
BTFeedbackTopicsViewControllerDelegate>
{
    
}
@property (strong, nonatomic) UITextView *descriptionTextView;
@property (strong, nonatomic) UITextField *descriptionPlaceHolder;
@property (assign, nonatomic) NSInteger selectedTopicsIndex;
@property (assign, nonatomic) BOOL isFeedbackSent;

@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSArray *topics;
@property (strong, nonatomic) NSArray *topicsToSend;
@property (strong, nonatomic) NSArray *toRecipients;
@property (strong, nonatomic) NSArray *ccRecipients;
@property (strong, nonatomic) NSArray *bccRecipients;

+ (BOOL)isAvailable;
- (id)initWithTopics:(NSArray*)theTopics;

@end
