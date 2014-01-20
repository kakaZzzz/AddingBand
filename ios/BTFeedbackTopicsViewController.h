//
//  BTFeedbackTopicsViewController.h
//  TEXTFEEDBACK
//
//  Created by wangpeng on 14-1-18.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTFeedbackTopicsViewController;
@protocol BTFeedbackTopicsViewControllerDelegate<NSObject>

- (void)feedbackTopicsViewController:(BTFeedbackTopicsViewController *)feedbackTopicsViewController didSelectTopicAtIndex:(NSInteger)selectedIndex;

@end


@interface BTFeedbackTopicsViewController : UITableViewController
{
    NSInteger _selectedIndex;
}

@property (assign, nonatomic) NSInteger selectedIndex;
@property (assign, nonatomic) id<BTFeedbackTopicsViewControllerDelegate> delegate;


@end

