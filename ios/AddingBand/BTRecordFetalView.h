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
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *aLabel;
@property(nonatomic,strong)UILabel *bLabel;
@property(nonatomic,strong)UILabel *cLabel;
@property(nonatomic,strong)UILabel *dLabel;
@property(nonatomic,strong)UIButton *aButton;
@property(nonatomic,strong)BTTimerLabel *timeLabel;

@property(nonatomic,strong)NSManagedObjectContext *context;
@end
