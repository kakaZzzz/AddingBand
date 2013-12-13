//
//  BTSettingIndicateCell.h
//  AddingBand
//
//  Created by kaka' on 13-11-17.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//


/**
 *  带有指示箭头 部分自定义cell
 *
 *
 *
 */

#import <UIKit/UIKit.h>

@interface BTSettingIndicateCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;//cell标题
@property(nonatomic,strong)UIImageView *indicateImage;//指示箭头
@property(nonatomic,strong)UIImageView *lineImage;//分割线
@end
