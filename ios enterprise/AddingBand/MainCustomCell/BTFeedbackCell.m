//
//  BTFeedbackCell.m
//  AddingBand
//
//  Created by wangpeng on 14-1-20.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import "BTFeedbackCell.h"
#import "LayoutDef.h"
@implementation BTFeedbackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createSubviews];
    }
    return self;
}
- (void)createSubviews
{
    //
    self.textLabel.textColor = kBigTextColor;
    self.textLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    self.detailTextLabel.textColor = kContentTextColor;
    self.detailTextLabel.font = [UIFont fontWithName:kCharacterAndNumberFont size:24/2];
    
    self.indicateImage = [[UIImageView alloc] initWithFrame:CGRectMake(320 - 10, (self.frame.size.height - 10)/2, 15, 15)];
    _indicateImage.image = [UIImage imageNamed:@"accessory_gray.png"];
    _indicateImage.hidden = YES;
    [self.contentView addSubview:_indicateImage];

    self.lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seperator_line"]];
    _lineImage.frame = CGRectMake(0, self.frame.size.height - 0.5 , 320-0, kSeparatorLineHeight);
    [self.contentView addSubview:_lineImage];

}
//- (void)layoutSubviews
//{
//    _lineImage.frame = CGRectMake(0, self.frame.size.height - 0.5 , 320-0, kSeparatorLineHeight);
//
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
