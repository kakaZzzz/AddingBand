//
//  BTMainViewCell.m
//  AddingBand
//
//  Created by wangpeng on 13-12-21.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTMainViewCell.h"
#import "LayoutDef.h"
@implementation BTMainViewCell

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
    
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5, 50, 20)];
    _dayLabel.font = [UIFont systemFontOfSize:17.0f];
    _dayLabel.backgroundColor = [UIColor clearColor];
    _dayLabel.textColor = kBigTextColor;
    _dayLabel.text = @"12.13";
    _dayLabel.backgroundColor = [UIColor blueColor];
    _dayLabel.opaque = NO;
    [self.contentView addSubview:_dayLabel];

    
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,_dayLabel.frame.origin.y + _dayLabel.frame.size.height, 50, 50)];
    _iconImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_iconImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImage.frame.origin.x + _iconImage.frame.size.width + 10, _iconImage.frame.origin.y, 100, 50)];
    _titleLabel.font = [UIFont systemFontOfSize:17.0f];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.backgroundColor = [UIColor redColor];
     [self.contentView addSubview:_titleLabel];
    
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x , _titleLabel.frame.origin.y + _titleLabel.frame.size.height, 100, 50)];
    _contentLabel.font = [UIFont systemFontOfSize:17.0f];
    _contentLabel.backgroundColor = [UIColor yellowColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_contentLabel];

    self.accessoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]];
    _accessoryImage.frame = CGRectMake(320 - 50,_iconImage.frame.origin.y, 50, 50);
    [self.contentView addSubview:_accessoryImage];
    
//    self.conditiontLabel = [[UILabel alloc] initWithFrame:CGRectMake(_warnImage.frame.origin.x + _warnImage.frame.size.width, contentLabelY, contentLabelWidth, contentLabelHeight)];
//    _conditiontLabel.backgroundColor = [UIColor clearColor];
//    
//    _conditiontLabel.font = [UIFont systemFontOfSize:17.0f];
//    _conditiontLabel.textAlignment = NSTextAlignmentLeft;
//    _conditiontLabel.textColor = kBigTextColor;
//    //  _conditiontLabel.backgroundColor = [UIColor redColor];
//    _conditiontLabel.opaque = NO;
//    [self.contentView addSubview:_conditiontLabel];
//    
//    self.accessoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_blue@2x"]];
//    _accessoryImage.frame = CGRectMake(320 - 20, 11.5, 20, 20);
//    [self.contentView addSubview:_accessoryImage];
    
    
}

+ (CGFloat)cellHeight:(NSString *)content
{
//    CGSize size = CGSizeMake(kContentLabelWidth,3000);
//    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:kContentFontSize]
//                             constrainedToSize:size
//                                 lineBreakMode:NSLineBreakByCharWrapping];
//    
//    timeLineHeignt = contentSize.height +20;
   return  20;
}

- (void)layoutSubviews
{
    
 
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
