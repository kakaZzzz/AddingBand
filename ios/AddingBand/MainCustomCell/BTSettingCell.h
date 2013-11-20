//
//  BTSettingCell.h
//  AddingBand
//
//  Created by kaka' on 13-11-17.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTSettingCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *lineImage;
@property(nonatomic,strong)UITextField *contenTextField;

@end
