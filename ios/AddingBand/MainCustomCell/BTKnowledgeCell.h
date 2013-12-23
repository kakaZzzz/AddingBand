//
//  BTKnowledgeCell.h
//  AddingBand
//
//  Created by wangpeng on 13-12-23.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTKnowledgeCell : UITableViewCell
@property(nonatomic,strong)UILabel *dayLabel;
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *accessoryImage;
@property(nonatomic,strong)UILabel *contentLabel;

+ (CGFloat)cellHeightWithisHasTimeFlag:(BOOL)timeFlag;
@end
