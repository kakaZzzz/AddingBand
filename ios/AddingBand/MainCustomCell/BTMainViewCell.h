//
//  BTMainViewCell.h
//  AddingBand
//
//  Created by wangpeng on 13-12-21.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTMainViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *dayLabel;
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *accessoryImage;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)UILabel *conditonLabel;
@property(nonatomic,strong)UILabel *measureContentLabel;

+ (CGFloat)cellHeightWithisHasTimeFlag:(BOOL)timeFlag;
@end
