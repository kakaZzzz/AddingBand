//
//  BTKnowledgeCell.h
//  AddingBand
//
//  Created by wangpeng on 13-12-23.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTKnowledgeModel;
@class EGOImageView;
@interface BTKnowledgeCell : UITableViewCell
@property(nonatomic,strong)UILabel *dayLabel;
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *accessLabel;
@property(nonatomic,strong)UIImageView *accessImage;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *lineImage;
@property(nonatomic,retain)EGOImageView *contentImage;
@property(nonatomic,strong)BTKnowledgeModel *knowledgeModel;
+ (CGFloat)cellHeightWithMode:(BTKnowledgeModel *)model;
@end
