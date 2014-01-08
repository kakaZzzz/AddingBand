//
//  BTUGCCell.h
//  AddingBand
//
//  Created by wangpeng on 14-1-8.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTUGCCell : UITableViewCell
@property(nonatomic,strong)UILabel *dayLabel;
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *accessoryImage;
@property(nonatomic,strong)UILabel *contentLabel;

//@property(nonatomic,strong)BTKnowledgeModel *knowledgeModel;
//+ (CGFloat)cellHeightWithMode:(BTKnowledgeModel *)model;

@end
