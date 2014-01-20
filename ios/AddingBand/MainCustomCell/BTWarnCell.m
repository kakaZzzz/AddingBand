//
//  BTWarnCell.m
//  AddingBand
//
//  Created by wangpeng on 13-12-23.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTWarnCell.h"
#import "LayoutDef.h"
#define kDayLabelX 24/2
#define kDayLabelY 15
#define kDayLabelWidth 100
#define kDayLabelHeight 20

#define kIconImageX 24/2
#define kIconImageY 15
#define kIconImageWidth 44/2
#define kIconImageHeight 44/2

#define kTitleLabelX (kIconImageX + kIconImageWidth + 10)
#define kTitleLabelY kIconImageY
#define kTitleLabelWidth 200
#define kTitleLabelHeight 20

#define kContentLabelHeight 40
@implementation BTWarnCell

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
    _dayLabel.font = [UIFont fontWithName:kCharacterAndNumberFont size:10.0f];
    _dayLabel.backgroundColor = [UIColor clearColor];
    _dayLabel.textColor = kBigTextColor;
    _dayLabel.text = @"12.13";
    _dayLabel.opaque = NO;
  //  [self.contentView addSubview:_dayLabel];
    
    
    //icon图标
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kIconImageX,kIconImageY, kIconImageWidth, kIconImageHeight)];
    _iconImage.backgroundColor = [UIColor clearColor];
    _iconImage.image = [UIImage imageNamed:@"warn_icon"];
    [self.contentView addSubview:_iconImage];
    
    //内容标题标签
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleLabelX, kTitleLabelY, kTitleLabelWidth, kTitleLabelHeight)];
    _titleLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    _titleLabel.textColor = kBigTextColor;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_titleLabel];
    
    //内容标签
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x,  _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 10, 320 - _titleLabel.frame.origin.x - 24/2, kContentLabelHeight)];
    _contentLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _contentLabel.textColor = kContentTextColor;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_contentLabel];
    
    
    
    
    //提醒todo按钮
    self.todoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_todoButton setBackgroundImage:[UIImage imageNamed:@"warn_unselected"] forState:UIControlStateNormal];
    [_todoButton addTarget:self action:@selector(todoSelect:) forControlEvents:UIControlEventTouchUpInside];
    _todoButton.frame = CGRectMake(320 - 78/2,_iconImage.frame.origin.y - 4,78/2, 60/2);
    [self.contentView addSubview:_todoButton];
    
    self.lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seperator_line"]];
    _lineImage.frame = CGRectMake(kTitleLabelX, self.frame.size.height-kSeparatorLineHeight , 320-24, kSeparatorLineHeight);
    [self.contentView addSubview:_lineImage];

    
    
}

- (void)todoSelect:(UIButton *)button
{
    
    if ([_todoButton.currentBackgroundImage isEqual:[UIImage imageNamed:@"warn_unselected"]]) {
        
        NSLog(@"点击了button");
        [_todoButton setBackgroundImage:[UIImage imageNamed:@"warn_selected"] forState:UIControlStateNormal];
        
    }
    
}
+ (CGFloat)cellHeightWithMode:(BTKnowledgeModel *)model
{
    
    NSLog(@"返回高度.........");
    //   UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kTitleLabelX, kTitleLabelY, kTitleLabelWidth, kTitleLabelHeight)];
    CGSize size = CGSizeMake(kTitleLabelWidth,2000);
    UIFont *font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [model.title sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
      NSLog(@"提醒类cell的高度....%0.1f",(20 + labelSize.height + 10));
    if ([model.description isEqualToString:@""]) {
        return (2 * kTitleLabelY + labelSize.height);
        
    }
    else{
        
        return (2 * kTitleLabelY + labelSize.height+ kContentLabelHeight + 10);
        
    }
    
}

- (void)setKnowledgeModel:(BTKnowledgeModel *)knowledgeModel
{
    
    _knowledgeModel = knowledgeModel;
    
    CGSize size = CGSizeMake(_titleLabel.frame.size.width,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [_knowledgeModel.title sizeWithFont:_titleLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    // [self.titleLabel setFrame:CGRectMake:(_titleLabel.frame.origin.x,_titleLabel.frame.origin.y,labelSize.width, labelSize.height)];
    self.titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, _titleLabel.frame.size.width, labelSize.height);
    
    self.titleLabel.text = _knowledgeModel.title;
    self.contentLabel.text = _knowledgeModel.description;
   
    
    if ([_knowledgeModel.description isEqualToString:@""]) {
        self.contentLabel.frame = CGRectMake(_titleLabel.frame.origin.x  , _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 10, 320 - _titleLabel.frame.origin.x - 24/2, 0.0);
        _lineImage.frame = CGRectMake(kTitleLabelX, (2 * kTitleLabelY + labelSize.height) -kSeparatorLineHeight , 320-24, kSeparatorLineHeight);
    }
    
    else{
        
        

        _lineImage.frame = CGRectMake(kTitleLabelX, (2 * kTitleLabelY + labelSize.height + kContentLabelHeight + 10)-kSeparatorLineHeight , 320-24, kSeparatorLineHeight);
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
