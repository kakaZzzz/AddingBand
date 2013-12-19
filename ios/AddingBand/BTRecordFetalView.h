//
//  BTRecordFetalView.h
//  AddingBand
//
//  Created by wangpeng on 13-12-2.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTimerLabel.h"
@interface BTRecordFetalView : UIViewController<BTTimerLabelDelegate>

@property(nonatomic,strong)UILabel *startTimeLabel;//开始时间
@property(nonatomic,strong)UILabel *countTitleLabel;//倒计时title
@property(nonatomic,strong)UILabel *countLabel;//胎动次数
@property(nonatomic,strong)UIButton *recordButton;
@property(nonatomic,strong)BTTimerLabel *timeLabel;//倒计时时间

@property(nonatomic,strong)NSManagedObjectContext *context;
@end
