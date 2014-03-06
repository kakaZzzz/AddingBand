//
//  BTWarnCell.h
//  AddingBand
//
//  Created by wangpeng on 13-12-23.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTKnowledgeModel.h"
@interface BTWarnCell : UITableViewCell
@property(nonatomic,strong)UILabel *dayLabel;
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *accessoryImage;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIButton *todoButton;
@property(nonatomic,strong)UIImageView *lineImage;
@property(nonatomic,strong)BTKnowledgeModel *knowledgeModel;

@property(nonatomic,strong)NSManagedObjectContext *context;
+ (CGFloat)cellHeightWithMode:(BTKnowledgeModel *)model;

@end
