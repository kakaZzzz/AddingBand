//
//  BTSettingSectionCell.m
//  AddingBand
//
//  Created by kaka' on 13-11-17.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTSettingSectionCell.h"
#import "LayoutDef.h"
#import "BTColor.h"

#define titleLabelX 20
#define titleLabelY 7
#define titleLabelWidth 100
#define titleLabelHeight 30



#define lineImageX 0
#define lineImageY 43
#define lineImageWidth 320
#define lineImageHeight 1

@implementation BTSettingSectionCell

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
    // self.contentView.backgroundColor = [UIColor grayColor];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX,titleLabelY, titleLabelWidth, titleLabelHeight)];
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    _titleLabel.textColor = [BTColor getColor:titleLabelColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.opaque = NO;
    [self.contentView addSubview:_titleLabel];
    
     
    
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
