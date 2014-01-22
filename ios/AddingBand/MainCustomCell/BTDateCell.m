//
//  BTDateCell.m
//  AddingBand
//
//  Created by wangpeng on 14-1-17.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import "BTDateCell.h"
#import "LayoutDef.h"
#import "BTUtils.h"
#import "NSDate+DateHelper.h"
#import "BTGetData.h"

#define kDayLabelX 24/2
#define kDayLabelY 15
#define kDayLabelWidth 100
#define kDayLabelHeight 20
@interface BTDateCell ()
@property(nonatomic,strong)UIView *lineView;//日期下 小横线
@end

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
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDayLabelX,self.frame.size.height - kDayLabelHeight, kDayLabelWidth, kDayLabelHeight)];
    _dayLabel.font = [UIFont fontWithName:kCharacterAndNumberFont size:10.0f];
    _dayLabel.backgroundColor = [UIColor clearColor];
    _dayLabel.textColor = kBigTextColor;
    _dayLabel.text = @"12.13";
    [self.contentView addSubview:_dayLabel];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(5, _dayLabel.frame.origin.y + _dayLabel.frame.size.height - 1.0, 40, 1.0)];
    _lineView.backgroundColor = kGlobalColor;
    _lineView.hidden = YES;
    [self.contentView addSubview:_lineView];
    
    self.countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 200 + 10,_dayLabel.frame.origin.y, 200, kDayLabelHeight)];
    _countdownLabel.font = [UIFont fontWithName:kCharacterAndNumberFont size:10.0f];
    _countdownLabel.backgroundColor = [UIColor clearColor];
    _countdownLabel.textAlignment = NSTextAlignmentRight;
    _countdownLabel.textColor = kGlobalColor;
    _countdownLabel.text = [self calculateDuedate];
    _countdownLabel.hidden = YES;
    [self.contentView addSubview:_countdownLabel];
    
    
    
}


- (void)setKnowledgeModel:(BTKnowledgeModel *)knowledgeModel
{
    
    _knowledgeModel = knowledgeModel;
    self.dayLabel.frame = CGRectMake(kDayLabelX,self.frame.size.height - kDayLabelHeight, kDayLabelWidth, kDayLabelHeight);
    self.lineView.frame = CGRectMake(5, _dayLabel.frame.origin.y + _dayLabel.frame.size.height - 1.0, 40, 1.0);
    self.countdownLabel.frame = CGRectMake(320 - 200,_dayLabel.frame.origin.y, 200, kDayLabelHeight);
    
    NSArray *subString = [_knowledgeModel.date componentsSeparatedByString:@"-"];
    NSString *date = [NSString stringWithFormat:@"%@.%@",[subString objectAtIndex:1],[subString objectAtIndex:2]];
    self.dayLabel.text = date;
    
    if ([self isCurrentDay:_knowledgeModel.date]) {
        self.lineView.hidden = NO;
        self.countdownLabel.hidden = NO;
        self.countdownLabel.text = [self calculateDuedate];
        self.dayLabel.textColor = kGlobalColor;
    }
    else{
        self.lineView.hidden = YES;
        self.countdownLabel.hidden = YES;
        self.dayLabel.textColor = kBigTextColor;
    }

}

- (BOOL)isCurrentDay:(NSString *)date
{
    NSDate *localDate = [NSDate localdate];
    NSNumber *localYear = [BTUtils getYear:localDate];
    NSNumber *localMonth = [BTUtils getMonth:localDate];
    NSNumber *localDay = [BTUtils getDay:localDate];
    
    NSArray *subString = [date componentsSeparatedByString:@"-"];
    NSString *year = [subString objectAtIndex:0];
    NSString *month = [subString objectAtIndex:1];
    NSString *day = [subString objectAtIndex:2];
    
    if (([localYear intValue] == [year intValue]) && ([localMonth intValue] == [month intValue]) && ([localDay intValue] == [day intValue])) {
        return YES;
    }
    else{
        return NO;
    }
    
}
//计算预产期
- (NSString *)calculateDuedate
{
    NSDate *localdate = [NSDate localdate];
    NSNumber *year = [BTUtils getYear:localdate];
    NSNumber *month = [BTUtils getMonth:localdate];
    NSNumber *dayLocal = [BTUtils getDay:localdate];
    NSDate *gmtDate = [NSDate dateFromString:[NSString stringWithFormat:@"%@.%@.%@",year,month,dayLocal] withFormat:@"yyyy.MM.dd"];
    int day = [BTGetData getPregnancyDaysWithDate:gmtDate];
    //根据怀孕天数 算出是第几周 第几天
    int week = day/7 + 1;
    int day1 = day%7;
    
    if (day%7 == 0) {
        week = week - 1;
        day1 = 7;
    }
//    self.countLabel.text = [NSString stringWithFormat:@"预产期倒计时: %d天",(280 - day)];
//    self.dateLabel.text = [NSString stringWithFormat:@"%d周%d天",week,day1];
    
    NSString *resultString = [NSString stringWithFormat:@"怀孕%d周%d天 宝宝出生还有%d天",week,day1,(280 - day)];
    return resultString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
