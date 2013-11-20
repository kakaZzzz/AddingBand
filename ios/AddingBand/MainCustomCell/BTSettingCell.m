//
//  BTSettingCell.m
//  AddingBand
//
//  Created by kaka' on 13-11-17.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTSettingCell.h"
#import "LayoutDef.h"
#import "BTColor.h"

#define titleLabelX 20
#define titleLabelY 7
#define titleLabelWidth 100
#define titleLabelHeight 30

#define contentLabelX 5
#define contentLabelY 7
#define contentLabelWidth 310
#define contentLabelHeight 30

#define lineImageX 20
#define lineImageY 43
#define lineImageWidth 300
#define lineImageHeight 1

#define titleLabelColor @"333333"
#define contentLabelColor @"999999"

@implementation BTSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createCustomCell];
    }
    return self;
}
//配置cell内容
- (void)createCustomCell
{
   // self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"settingcell_bg.png"]];
       
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX,titleLabelY, titleLabelWidth, titleLabelHeight)];
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    _titleLabel.textColor = [BTColor getColor:titleLabelColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.opaque = NO;
    [self.contentView addSubview:_titleLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight)];
    _contentLabel.font = [UIFont systemFontOfSize:16.0f];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.textColor = [BTColor getColor:contentLabelColor];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.opaque = NO;
    [self.contentView addSubview:_contentLabel];
    
    
//    self.contenTextField = [[UITextField alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight)];
//    _contenTextField.font = [UIFont systemFontOfSize:16.0f];
//    _contenTextField.textAlignment = NSTextAlignmentRight;
//    _contenTextField.textColor = [BTColor getColor:contentLabelColor];
//    _contenTextField.backgroundColor = [UIColor clearColor];
//    _contenTextField.opaque = NO;
//    _contenTextField.delegate = self;
//    [self.contentView addSubview:_contenTextField];

    self.lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sep_line.png"]];
    _lineImage.frame = CGRectMake(lineImageX, lineImageY, lineImageWidth, lineImageHeight);
     [self.contentView addSubview:_lineImage];
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
