//
//  BTPhysicalCell.m
//  BTTestCollectionView
//
//  Created by wangpeng on 13-12-26.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import "BTPhysicalCell.h"
#import "LayoutDef.h"
#import "NSDate+DateHelper.h"
#import "BTGetData.h"
#import "BTPhysicalStandard.h"
#import "BTGirthStandard.h"
//#import "LayoutDef.h"
#define titleLabelX 12
#define titleLabelY 22
#define titleLabelWidth 40
#define titleLabelHeight 20

#define contentLabelX (titleLabelX)
#define contentLabelY (titleLabelY + titleLabelHeight + 10)
#define contentLabelWidth 60
#define contentLabelHeight 30

#define warnImageX （320 - 50)
#define warnImageY （titleLabelY）
#define warnImageWidth 14
#define warnImageHeight 14

@implementation BTPhysicalCell

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
    
    //诸如体重 宫高 腹围之类的
    self.kTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelWidth, titleLabelHeight)];
    self.kTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.kTitleLabel.text = @"体重";
    self.kTitleLabel.textColor = kBigTextColor;
    self.kTitleLabel.font = [UIFont systemFontOfSize:17.0f];
  //  self.kTitleLabel.backgroundColor = [UIColor redColor];
     self.kTitleLabel.opaque = NO;
    [self addSubview:self.kTitleLabel];
    
    //提醒图片
    self.warnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prhysical_exclamationMark"]];
  //  _warnImage.backgroundColor = [UIColor grayColor];
    _warnImage.frame = CGRectMake(titleLabelX  + titleLabelWidth, titleLabelY + 2, warnImageWidth, warnImageHeight);
    [self addSubview:_warnImage];

    
    
    //内容 诸如72 kg的72
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight)];
    self.contentLabel.text = @"72.0";
    _contentLabel.font = [UIFont systemFontOfSize:30.0f];
   // _contentLabel.backgroundColor = [UIColor blueColor];

    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.opaque = NO;
    [self addSubview:_contentLabel];
    
    
    
    
    self.conditiontLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX + contentLabelWidth, contentLabelY + contentLabelHeight - 20, 25, 20)];
   // _conditiontLabel.backgroundColor = [UIColor greenColor];
    _conditiontLabel.text = @"kg";
    _conditiontLabel.font = [UIFont systemFontOfSize:17.0f];
    _conditiontLabel.textAlignment = NSTextAlignmentLeft;
   
    _conditiontLabel.textColor = kBigTextColor;
    _conditiontLabel.opaque = NO;
    [self addSubview:_conditiontLabel];
    
    
    //没有数据图片
    self.noDataImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"physical_nodata_icon"]];
    // _noDataImage.backgroundColor = [UIColor grayColor];
    _noDataImage.frame = CGRectMake(_contentLabel.frame.origin.x , _contentLabel.frame.origin.y, contentLabelHeight, contentLabelHeight);
    _noDataImage.hidden = YES;
    [self addSubview:_noDataImage];

    
    
    
}
- (void)setPhysicalModel:(BTPhysicalModel *)physicalModel
{
    if ([_physicalModel.title isEqualToString:physicalModel.title] && [_physicalModel.content isEqualToString:physicalModel.content]) {
        return;
    }
    else{
       _physicalModel = physicalModel;
        
        //下面根据数据重新调整视图布局
        
        
        if ([_physicalModel.title isEqualToString:@"体重"]) {
            
            if ([_physicalModel.content floatValue] == 0.0) {
                
                self.contentLabel.hidden = YES;
                self.conditiontLabel.hidden = YES;
                self.noDataImage.hidden = NO;
                self.warnImage.hidden = NO;
                self.warnImage.image = [UIImage imageNamed:@"physical_askMark"];
            }
            else{
                if (![[NSUserDefaults standardUserDefaults] boolForKey:MAMA_WEIGHT_CONDITION]) {//不正常
                    
                    self.contentLabel.hidden = NO;
                    self.conditiontLabel.hidden = NO;
                    self.noDataImage.hidden = YES;
                     self.warnImage.hidden = NO;
                    self.contentLabel.textColor = kGlobalColor;
                    self.conditiontLabel.textColor = kGlobalColor;
                    self.warnImage.image = [UIImage imageNamed:@"prhysical_exclamationMark"];
                }
                else{
                    self.contentLabel.hidden = NO;
                    self.conditiontLabel.hidden = NO;
                    self.noDataImage.hidden = YES;
                    self.warnImage.hidden = YES;
                    self.contentLabel.textColor = kBigTextColor;
                     self.conditiontLabel.textColor = kBigTextColor;
                }

            }
              self.conditiontLabel.text = @"kg";
        }
        
        else if ([_physicalModel.title isEqualToString:@"宫高"])
        {
            
            if ([_physicalModel.content floatValue] == 0.0) {//无数据
                
                self.contentLabel.hidden = YES;
                self.conditiontLabel.hidden = YES;
                self.noDataImage.hidden = NO;
                 self.warnImage.hidden = NO;
                self.warnImage.image = [UIImage imageNamed:@"physical_askMark"];
            }
            else{//不正常
                if (![[NSUserDefaults standardUserDefaults] boolForKey:FUNDAL_HEIGHT_CONDITION]) {
                    
                    self.contentLabel.hidden = NO;
                    self.conditiontLabel.hidden = NO;
                    self.noDataImage.hidden = YES;
                     self.warnImage.hidden = NO;
                    self.contentLabel.textColor = kGlobalColor;
                    self.conditiontLabel.textColor = kGlobalColor;
                    self.warnImage.image = [UIImage imageNamed:@"prhysical_exclamationMark"];
                }
                else{//正常
                    self.contentLabel.hidden = NO;
                    self.conditiontLabel.hidden = NO;
                    self.noDataImage.hidden = YES;
                     self.warnImage.hidden = YES;
                    self.contentLabel.textColor = kBigTextColor;
                    self.conditiontLabel.textColor = kBigTextColor;

                }
                
            }

             self.conditiontLabel.text = @"cm";
        }
        
        else if ([_physicalModel.title isEqualToString:@"腹围"])
        {
            if ([_physicalModel.content floatValue] == 0.0) {
                
                self.contentLabel.hidden = YES;
                self.conditiontLabel.hidden = YES;
                self.noDataImage.hidden = NO;
                self.warnImage.hidden = NO;
                self.warnImage.image = [UIImage imageNamed:@"physical_askMark"];
            }
            else{//不正常
                if (![[NSUserDefaults standardUserDefaults] boolForKey:MAMA_GIRTH_CONDITION]) {
                    
                    self.contentLabel.hidden = NO;
                    self.conditiontLabel.hidden = NO;
                    self.noDataImage.hidden = YES;
                    self.warnImage.hidden = NO;
                    self.contentLabel.textColor = kGlobalColor;
                    self.conditiontLabel.textColor = kGlobalColor;
                    self.warnImage.image = [UIImage imageNamed:@"prhysical_exclamationMark"];
                }
                else{
                    self.contentLabel.hidden = NO;
                    self.conditiontLabel.hidden = NO;
                    self.noDataImage.hidden = YES;
                    self.warnImage.hidden = YES;
                    self.contentLabel.textColor = kBigTextColor;
                    self.conditiontLabel.textColor = kBigTextColor;
                }
                
            }

            
            self.conditiontLabel.text = @"cm";
        }
        
        else if ([_physicalModel.title isEqualToString:@"B超"])
        {
            
            if ([_physicalModel.content isEqualToString:@"正常"]) {
                
                [self.contentLabel setHidden:NO];
                [self.conditiontLabel setHidden:YES];
                self.noDataImage.hidden = YES;
                self.warnImage.hidden = YES;
                self.contentLabel.textColor = kBigTextColor;
            }
            
            else if ([_physicalModel.content isEqualToString:@"异常"])
            {
                [self.contentLabel setHidden:NO];
                [self.conditiontLabel setHidden:YES];
                self.noDataImage.hidden = YES;
                self.warnImage.hidden = NO;
                self.contentLabel.textColor = self.contentLabel.textColor = kGlobalColor;
                self.warnImage.image = [UIImage imageNamed:@"prhysical_exclamationMark"];
            }
            else{
                self.warnImage.image = [UIImage imageNamed:@"physical_askMark"];
                [self.contentLabel setHidden:YES];
                [self.conditiontLabel setHidden:YES];
                self.noDataImage.hidden = NO;
                self.warnImage.hidden = NO;

            }
            
        }
        
        else if ([_physicalModel.title isEqualToString:@"血压"])
        {
            if ([_physicalModel.title isEqualToString:@""]) {
                self.contentLabel.hidden = YES;
                [self.conditiontLabel setHidden:YES];
                self.noDataImage.hidden = NO;
                self.warnImage.hidden = NO;
                self.warnImage.image = [UIImage imageNamed:@"physical_askMark"];
            }
            else{
                
                self.contentLabel.hidden = NO;
                [self.conditiontLabel setHidden:YES];
                self.noDataImage.hidden = YES;
                self.warnImage.hidden =YES;
                self.contentLabel.font = [UIFont systemFontOfSize:20];
                CGRect rect = self.contentLabel.frame;
                self.contentLabel.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + 50, rect.size.height);
                self.contentLabel.textColor = kBigTextColor;
                

            }

        }

        self.kTitleLabel.text = self.physicalModel.title;
        self.contentLabel.text = self.physicalModel.content;
       
    }
    
}

#pragma mark - 判断数据是否正常
- (BOOL)judgeFundalCondition:(BTPhysicalModel *)model
{
    float onLimit = 0.0;
    float offLimit = 0.0;
    float now = [model.content floatValue];

    
    NSDate *localDate = [NSDate dateFromString:[NSString stringWithFormat:@"%@.%@.%@",model.year,model.month,model.day] withFormat:@"yyyy.MM.dd"];
    
        int day1 = [BTGetData getPregnancyDaysWithDate:localDate];//怀孕天数
        
        if ((day1/7 + 1 >= 20) && (day1/7 + 1 <= 40)) {
            NSArray *array = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTPhysicalStandard" sortKey:nil];
            for (int i = 0; i < [array count]; i ++) {
                BTPhysicalStandard *one = [array objectAtIndex:i];
                if (([one.day intValue]/7 + 1) == (day1/7 + 1)) {
                    if (i < [array count] - 1) {
                        BTPhysicalStandard *nextModel =  [array objectAtIndex:i+1];
                        onLimit = (([nextModel.onLimit floatValue] - [one.onLimit floatValue])/6) * (day1 - [one.day intValue]) +[one.onLimit floatValue];
                        offLimit = (([nextModel.offLimit floatValue] - [one.offLimit floatValue])/6) * (day1 - [one.day intValue]) +[one.offLimit floatValue];
                        if (now > onLimit || now > offLimit) {
                            return  YES;
                        }
                        else{
                            return NO;
                        }
                    }
            }
                break;

       }
    }
    
         return NO;
    
}


- (BOOL)judgeGirthCondition:(BTPhysicalModel *)model
{
    float onLimit = 0.0;
    float offLimit = 0.0;
    float now = [model.content floatValue];
    
    
    NSDate *localDate = [NSDate dateFromString:[NSString stringWithFormat:@"%@.%@.%@",model.year,model.month,model.day] withFormat:@"yyyy.MM.dd"];
    
    int day1 = [BTGetData getPregnancyDaysWithDate:localDate];//怀孕天数
    
    if ((day1/7 + 1 >= 20) && (day1/7 + 1 <= 40)) {
        NSArray *array = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTGirthStandard" sortKey:nil];
        for (int i = 0; i < [array count]; i ++) {
            BTGirthStandard *one = [array objectAtIndex:i];
            if (([one.day intValue]/7 + 1) == (day1/7 + 1)) {
                if (i < [array count] - 1) {
                    BTGirthStandard *nextModel =  [array objectAtIndex:i+1];
                    onLimit = (([nextModel.onLimit floatValue] - [one.onLimit floatValue])/6) * (day1 - [one.day intValue]) +[one.onLimit floatValue];
                    offLimit = (([nextModel.offLimit floatValue] - [one.offLimit floatValue])/6) * (day1 - [one.day intValue]) +[one.offLimit floatValue];
                    if (now > onLimit || now > offLimit) {
                        return  YES;
                    }
                    else{
                        return NO;
                    }
                }
            }
            break;
            
        }
    }
    
    return NO;
    
}


@end
