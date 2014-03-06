//
//  BTTextfieldCell.h
//  AddingBand
//
//  Created by kaka' on 13-11-18.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

/**
 *  带有textField 部分自定义cell
 *
 *
 *
 */

#import <UIKit/UIKit.h>
@interface BTTextfieldCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;//cell标题内容
@property(nonatomic,strong)UIImageView *lineImage;//分割线
@property(nonatomic,strong)UITextField *contenTextField;//textField
@end
