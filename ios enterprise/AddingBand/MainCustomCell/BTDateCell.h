//
//  BTDateCell.h
//  AddingBand
//
//  Created by wangpeng on 14-1-17.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTKnowledgeModel.h"
@interface BTDateCell : UITableViewCell

@property(nonatomic,strong)UILabel *dayLabel;
@property(nonatomic,strong)UILabel *countdownLabel;
@property(nonatomic,strong)BTKnowledgeModel *knowledgeModel;

@end
