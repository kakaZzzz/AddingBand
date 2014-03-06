//
//  BTBluetoothFindCell.m
//  AddingBand
//
//  Created by kaka' on 13-11-7.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBluetoothFindCell.h"
#import "LayoutDef.h"
#import "BTColor.h"

#define titleLabelX 24/2
#define titleLabelY 0
#define titleLabelWidth 200




#define lineImageX 24/2
#define lineImageWidth (320 - 24)
#define lineImageHeight 1

#define indicateX  300
#define indicateY  19
#define indicateWidth  15
#define indicateHeight 15


@implementation BTBluetoothFindCell

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
    
    //title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX,titleLabelY, titleLabelWidth, self.frame.size.height)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont fontWithName:kCharacterAndNumberFont size:FIRST_TITLE_SIZE];
    _titleLabel.textColor = kBigTextColor;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.opaque = NO;
    [self.contentView addSubview:_titleLabel];
    
    
    //分割线
    self.lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seperator_line"]];
    _lineImage.frame = CGRectMake(lineImageX, self.frame.size.height - kSeparatorLineHeight, lineImageWidth, kSeparatorLineHeight);
    [self.contentView addSubview:_lineImage];
    //指示图标
    self.indicateImage = [[UIImageView alloc] initWithFrame:CGRectMake(indicateX, (self.frame.size.height - indicateHeight)/2, indicateWidth, indicateHeight)];
    _indicateImage.image = [UIImage imageNamed:@"accessory_gray"];
    [self.contentView addSubview:_indicateImage];
    
}
- (void)layoutSubviews
{
     _titleLabel.frame = CGRectMake(titleLabelX,titleLabelY, titleLabelWidth, self.frame.size.height);
     _lineImage.frame = CGRectMake(lineImageX, self.frame.size.height - kSeparatorLineHeight, lineImageWidth, kSeparatorLineHeight);
     _indicateImage.frame = CGRectMake(indicateX, (self.frame.size.height - indicateHeight)/2, indicateWidth, indicateHeight);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
