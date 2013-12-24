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
    
    UIView *aView = [[UIView alloc] initWithFrame:self.frame];
    aView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = aView;

    //时间标签
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5, 50, 20)];
    _dayLabel.font = [UIFont systemFontOfSize:17.0f];
    _dayLabel.backgroundColor = [UIColor clearColor];
    _dayLabel.textColor = kBigTextColor;
    _dayLabel.text = @"12.13";
    _dayLabel.backgroundColor = [UIColor blueColor];
    _dayLabel.opaque = NO;
    [self.contentView addSubview:_dayLabel];

    
    //icon图标
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,_dayLabel.frame.origin.y + _dayLabel.frame.size.height, 30, 30)];
    _iconImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_iconImage];
    
    //内容标题标签
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImage.frame.origin.x + _iconImage.frame.size.width + 10, _iconImage.frame.origin.y, 100, 50)];
    _titleLabel.font = [UIFont systemFontOfSize:17.0f];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.backgroundColor = [UIColor redColor];
     [self.contentView addSubview:_titleLabel];
    
    //内容标签
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x , _titleLabel.frame.origin.y + _titleLabel.frame.size.height, 80, 50)];
    _contentLabel.font = [UIFont systemFontOfSize:17.0f];
    _contentLabel.backgroundColor = [UIColor yellowColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_contentLabel];

    //胎动量 或者运动量次数标签
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x  + _contentLabel.frame.size.width, _contentLabel.frame.origin.y, 50, 50)];
    _countLabel.font = [UIFont systemFontOfSize:25.0f];
    _countLabel.text = @"5次";
    _countLabel.backgroundColor = [UIColor blueColor];
    _countLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_countLabel];

    //是否正常
    self.conditonLabel = [[UILabel alloc] initWithFrame:CGRectMake(_countLabel.frame.origin.x  + _countLabel.frame.size.width, _countLabel.frame.origin.y, 50, 50)];
    _conditonLabel.font = [UIFont systemFontOfSize:17.0f];
    _conditonLabel.text = @"正常";
    _conditonLabel.backgroundColor = [UIColor redColor];
    _conditonLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_conditonLabel];


    
    //指示图标
    self.accessoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_gray@2x"]];
    _accessoryImage.frame = CGRectMake(320 - 30,_iconImage.frame.origin.y + 10, 30, 30);
    [self.contentView addSubview:_accessoryImage];
    
    //体征标签
    self.measureContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - _accessoryImage.frame.size.width - 50,_titleLabel.frame.origin.y, 50, 50)];
    _measureContentLabel.font = [UIFont systemFontOfSize:17.0f];
    _measureContentLabel.text = @"体征";
    _measureContentLabel.backgroundColor = [UIColor greenColor];
    _measureContentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_measureContentLabel];

    
}

+ (CGFloat)cellHeightWithisHasTimeFlag:(BOOL)timeFlag
{
    if (timeFlag) {
        return 150.0;
    }
    else{
        return 100.0;
    }
    
}

- (void)layoutSubviews
{   //self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5, 50, 20)];
    _dayLabel.backgroundColor = [UIColor clearColor];
    self.iconImage.frame = CGRectMake(0,0, 30, 30);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
