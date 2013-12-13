//
//  BTSettingSectionCell.h
//  AddingBand
//
//  Created by kaka' on 13-11-17.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//


/**
 *  设置分区内容 部分自定义cell
 *  3个分区 分别是：账户名称 孕期概况  系统设置
 *
 *
 */

#import <UIKit/UIKit.h>
@interface BTSettingSectionCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;//分区内容
@property(nonatomic,strong)UIImageView *lineImage;//分割线图片

@end
