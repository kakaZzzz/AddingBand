//
//  BTCustomSettingCell.m
//  AddingBand
//
//  Created by wangpeng on 13-12-31.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTCustomSettingCell.h"
#import "LayoutDef.h"
@implementation BTCustomSettingCell

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
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - 40)/2, 40, 40)];
    _iconImage.image = [UIImage imageNamed:@"indicate.png"];
    [self.contentView addSubview:_iconImage];

    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,(self.frame.size.height - 40)/2, 150, 40)];
    _titleLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    _titleLabel.textColor = kBigTextColor;
    _titleLabel.backgroundColor = [UIColor blueColor];
    _titleLabel.opaque = NO;
    [self.contentView addSubview:_titleLabel];
    
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 100 - 20),(self.frame.size.height - 40)/2, 100, 40)];
    _contentLabel.font = [UIFont systemFontOfSize:24/2];
    _contentLabel.textColor = kContentTextColor;
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.backgroundColor = [UIColor redColor];
    _contentLabel.opaque = NO;
    [self.contentView addSubview:_contentLabel];

    
    self.indicateImage = [[UIImageView alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x + _contentLabel.frame.size.width + 5, (self.frame.size.height - 10)/2, 10, 10)];
    _indicateImage.image = [UIImage imageNamed:@"indicate.png"];
    [self.contentView addSubview:_indicateImage];
    
    
    self.lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sep_line.png"]];
    _lineImage.frame = CGRectMake(50, self.frame.size.height - 1.0, 320-50, 1.0);
    [self.contentView addSubview:_lineImage];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
