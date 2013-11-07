//
//  BTUndoCell.m
//  AddingBand
//
//  Created by kaka' on 13-11-2.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTUndoCell.h"

#define kContentFontSize 10
#define kContentLabelWidth 120
#define kContentLabelHeight 60
static float timeLineHeignt = 0;
@implementation BTUndoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createSubControls];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)createSubControls
{
    
   
    //内容气泡图片
    self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 30, self.iconImageView.frame.origin.y, kContentLabelWidth, kContentLabelHeight)];
    _contentImageView.backgroundColor = [UIColor blueColor];
    [self addSubview:_contentImageView];
  
    //内容Label
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageView.frame.origin.x , self.iconImageView.frame.origin.y, 100, 40)];
   // _contentLabel.backgroundColor = [UIColor blueColor];
    _contentLabel.font = [UIFont systemFontOfSize:kContentFontSize];
    _contentLabel.textColor = [UIColor redColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _contentLabel.numberOfLines= 0;
    [self.contentImageView addSubview:_contentLabel];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //Cell 自适应高度
    //设置一个行高上限
    CGSize size = CGSizeMake(kContentLabelWidth,3000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [_contentLabel.text sizeWithFont:_contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    //内容Label的高度
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.bounds.size.width, labelsize.height+10);
   //内容气泡图片的高度
    _contentImageView.frame = CGRectMake(_contentImageView.frame.origin.x, _contentImageView.frame.origin.y, _contentImageView.bounds.size.width, labelsize.height+10);
    //时间线图片
    self.timeLineImageView.frame = CGRectMake(self.timeLineImageView.frame.origin.x, self.timeLineImageView.frame.origin.y, self.timeLineImageView.bounds.size.width, timeLineHeignt);
}
+ (CGFloat)cellHeight:(NSString *)content
{
    CGSize size = CGSizeMake(kContentLabelWidth,3000);
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:kContentFontSize]
                                         constrainedToSize:size
                                            lineBreakMode:NSLineBreakByCharWrapping];
    
    timeLineHeignt = contentSize.height + 60;
    return contentSize.height + 60;
}

@end
