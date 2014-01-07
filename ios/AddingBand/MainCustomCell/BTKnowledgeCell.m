//
//  BTKnowledgeCell.m
//  AddingBand
//
//  Created by wangpeng on 13-12-23.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTKnowledgeCell.h"
#import "LayoutDef.h"
#define kDayLabelX 24/2
#define kDayLabelY 5
#define kDayLabelWidth 100
#define kDayLabelHeight 20

#define kIconImageX 24/2
#define kIconImageY (kDayLabelY + kDayLabelHeight + 30/2)
#define kIconImageWidth 44/2
#define kIconImageHeight 44/2

#define kTitleLabelX (kIconImageX + kIconImageWidth + 10)
#define kTitleLabelY kIconImageY
#define kTitleLabelWidth 200
#define kTitleLabelHeight 20

#define kContentLabelHeight 50
@implementation BTKnowledgeCell

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
    
    //时间标签
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDayLabelX,kDayLabelY, kDayLabelWidth, kDayLabelHeight)];
    _dayLabel.font = [UIFont systemFontOfSize:10.0f];
    _dayLabel.backgroundColor = [UIColor clearColor];
    _dayLabel.textColor = kBigTextColor;
    _dayLabel.text = @"12.13";
    _dayLabel.backgroundColor = [UIColor blueColor];
    _dayLabel.opaque = NO;
    [self.contentView addSubview:_dayLabel];
    
    
    //icon图标
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kIconImageX,kIconImageY, kIconImageWidth, kIconImageHeight)];
    _iconImage.backgroundColor = [UIColor clearColor];
    _iconImage.image = [UIImage imageNamed:@"knowledge_icon"];
    [self.contentView addSubview:_iconImage];
    
    //内容标题标签
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleLabelX, kTitleLabelY, kTitleLabelWidth, kTitleLabelHeight)];
    _titleLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_titleLabel];
    
    //内容标签
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x , _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 10, 320 - _titleLabel.frame.origin.x - 24/2, kContentLabelHeight)];
    _contentLabel.font = [UIFont systemFontOfSize:17.0f];
    _contentLabel.backgroundColor = [UIColor yellowColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_contentLabel];
    
    //    //指示图标
    self.accessoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_gray@2x"]];
    _accessoryImage.frame = CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width,_titleLabel.frame.origin.y, 30, 30);
    [self.contentView addSubview:_accessoryImage];
    
    
    
}
+ (CGFloat)cellHeightWithMode:(BTKnowledgeModel *)model
{
    
    NSLog(@"返回高度.........");
    
    CGSize size = CGSizeMake(kTitleLabelWidth,2000);
    UIFont *font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [model.title sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    return (kTitleLabelY + labelSize.height+ kContentLabelHeight + 10 + 10);
}

- (void)setKnowledgeModel:(BTKnowledgeModel *)knowledgeModel
{
    NSLog(@"走设置方法.........");
    _knowledgeModel = knowledgeModel;
    
    //标题label
    CGSize size = CGSizeMake(_titleLabel.frame.size.width,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [_knowledgeModel.title sizeWithFont:_titleLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, labelSize.width, labelSize.height);
    
    
    self.accessoryImage.frame = CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width + 5, _titleLabel.frame.origin.y, 30, 30);
    
    
    //内容label
    //    CGSize sizeContent = CGSizeMake(_contentLabel.frame.size.width,2000);
    //    CGSize contentlabelSize = [_knowledgeModel.description sizeWithFont:_contentLabel.font constrainedToSize:sizeContent lineBreakMode:NSLineBreakByWordWrapping];
    //    self.contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, contentlabelSize.height);
    
    self.titleLabel.text = _knowledgeModel.title;
    self.contentLabel.text = _knowledgeModel.description;
    self.dayLabel.text = _knowledgeModel.date;
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
