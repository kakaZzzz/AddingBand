//
//  BTMainSuperCell.m
//  AddingBand
//
//  Created by kaka' on 13-11-4.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTMainSuperCell.h"
#import "LayoutDef.h"

@implementation BTMainSuperCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initSubControls];
    }
    return self;
}
- (void)initSubControls
{
    
    CGFloat x = kLeftMargin;
    CGFloat y = kTopMargin;
    CGFloat h = kHeightMargin;
    CGFloat w = kWidthMargin;
    CGRect rect = CGRectMake(x, y, w, h);
    //头像图标
    self.iconImageView = [[UIImageView alloc]initWithFrame:rect];
    _iconImageView.backgroundColor  = [UIColor yellowColor];
    _iconImageView.image = [UIImage imageNamed:@"demo1@2x.png"];
    [self addSubview:_iconImageView];
    
    //时间线图片
    self.timeLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kTimeLineX, kTimeLineY, kTimeLineWidth, kTimeLineHeirht)];
    _timeLineImageView.backgroundColor  = [UIColor yellowColor];
    _timeLineImageView.image = [UIImage imageNamed:@"分割线@2x.png"];
    [self addSubview:_timeLineImageView];

 }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
