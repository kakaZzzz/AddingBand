//
//  BTSettingIndicateCell.m
//  AddingBand
//
//  Created by kaka' on 13-11-17.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTSettingIndicateCell.h"
#import "BTColor.h"

#define titleLabelX 20
#define titleLabelY 7
#define titleLabelWidth 100
#define titleLabelHeight 30



#define lineImageX 20
#define lineImageY 43
#define lineImageWidth 300
#define lineImageHeight 1

#define indicateX  300
#define indicateY  16
#define indicateWidth  10
#define indicateHeight 10

#define titleLabelColor @"333333"
@implementation BTSettingIndicateCell

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
    
    
    
    self.lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sep_line.png"]];
    _lineImage.frame = CGRectMake(lineImageX, lineImageY, lineImageWidth, lineImageHeight);
    [self.contentView addSubview:_lineImage];
    
    self.indicateImage = [[UIImageView alloc] initWithFrame:CGRectMake(indicateX, indicateY, indicateWidth, indicateHeight)];
    _indicateImage.image = [UIImage imageNamed:@"indicate.png"];
    [self.contentView addSubview:_indicateImage];
    
    
      
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
