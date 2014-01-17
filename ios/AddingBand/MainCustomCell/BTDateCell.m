//
//  BTDateCell.m
//  AddingBand
//
//  Created by wangpeng on 14-1-17.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import "BTDateCell.h"
#import "LayoutDef.h"
#define kDayLabelX 24/2
#define kDayLabelY 15
#define kDayLabelWidth 100
#define kDayLabelHeight 20

@implementation BTDateCell

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
    [self.contentView addSubview:_dayLabel];
    
    
    
    
    
}


- (void)setKnowledgeModel:(BTKnowledgeModel *)knowledgeModel
{
    NSLog(@"走了此方法了....");
    _knowledgeModel = knowledgeModel;
    self.dayLabel.text = _knowledgeModel.date;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
