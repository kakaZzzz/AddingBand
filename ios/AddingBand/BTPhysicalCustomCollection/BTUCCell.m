//
//  BTUCCell.m
//  BTTestCollectionView
//
//  Created by wangpeng on 13-12-27.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import "BTUCCell.h"

#define titleLabelX 12
#define titleLabelY 22
#define titleLabelWidth 40
#define titleLabelHeight 20

#define contentLabelX (titleLabelX)
#define contentLabelY (titleLabelY + titleLabelHeight + 8)
#define contentLabelWidth 80
#define contentLabelHeight 15

#define warnImageX （320 - 50)
#define warnImageY （titleLabelY）
#define warnImageWidth 14
#define warnImageHeight 14

@implementation BTUCCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createCustomCell];
    }
    return self;
}
//配置cell内容
- (void)createCustomCell
{
    
    //宫缩
    self.kTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelWidth, titleLabelHeight)];
    self.kTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.kTitleLabel.text = @"宫缩";
    self.kTitleLabel.textColor = [UIColor colorWithRed:94/255.0 green:101/255.0 blue:113/255.0 alpha:1.0];
    self.kTitleLabel.font = [UIFont systemFontOfSize:17.0f];
   // self.kTitleLabel.backgroundColor = [UIColor redColor];
    self.kTitleLabel.opaque = NO;
    [self addSubview:self.kTitleLabel];
    
//    //提醒图片
//    self.warnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]];
//    _warnImage.backgroundColor = [UIColor grayColor];
//    _warnImage.frame = CGRectMake(titleLabelX  + titleLabelWidth, titleLabelY + 2, warnImageWidth, warnImageHeight);
//    [self addSubview:_warnImage];
    
    
    
    //持续时间
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight)];
    self.contentLabel.text = @"持续 00:53";
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
 //   _contentLabel.backgroundColor = [UIColor blueColor];
    _contentLabel.textColor = [UIColor colorWithRed:94/255.0 green:101.0/255.0 blue:113/255.0 alpha:1.0];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.opaque = NO;
    [self addSubview:_contentLabel];
    
    
    
    //间隔时间
    self.conditiontLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY + contentLabelHeight + 4, contentLabelWidth, contentLabelHeight)];
   // _conditiontLabel.backgroundColor = [UIColor greenColor];
    _conditiontLabel.text = @"间隔 05:23";
    _conditiontLabel.font = [UIFont systemFontOfSize:14.0f];
    _conditiontLabel.textAlignment = NSTextAlignmentLeft;
    
    _conditiontLabel.textColor = [UIColor colorWithRed:94/255.0 green:101.0/255.0 blue:113/255.0 alpha:1.0];
    _conditiontLabel.opaque = NO;
    [self addSubview:_conditiontLabel];
    
    
    //没有数据图片
    self.noDataImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]];
    _noDataImage.backgroundColor = [UIColor grayColor];
    _noDataImage.frame = CGRectMake(_contentLabel.frame.origin.x , _contentLabel.frame.origin.y, contentLabelHeight, contentLabelHeight);
   //  [self addSubview:_noDataImage];
    
    
    
    
}
- (void)setPhysicalModel:(BTPhysicalModel *)physicalModel
{
    if ([_physicalModel.title isEqualToString:physicalModel.title] && [_physicalModel.content isEqualToString:physicalModel.content]) {
        return;
    }
    else{
        _physicalModel = physicalModel;
        
        NSLog(@"拉拉拉拉拉拉阿拉拉拉");
    }
    
}


@end
