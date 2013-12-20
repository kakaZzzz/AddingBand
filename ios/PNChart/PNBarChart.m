//
//  PNBarChart.m
//  PNChartDemo
//
//  Created by wangpeng on 11/7/13.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import "PNBarChart.h"
#import "PNChartLabel.h"
#import "PNBar.h"
#import "BTRawData.h"
#import "BTUtils.h"
#import "BTGetData.h"
#import "LayoutDef.h"
#define xLabelMargin    20.0f//x轴最左边数值距离折线图最左端的距离
#define xLabelHeight 30.0f//x轴坐标label的高度
#define xLabelWidth 13.0f//x轴坐标label的宽度

@implementation PNBarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
    }
    
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    for (NSString * valueString in yLabels) {
        NSInteger value = [valueString integerValue];
        if (value > max) {
            max = value;
        }
        
    }
    
    //Min value for Y label
    if (max < 5) {
        max = 5;
    }
    
    _yValueMax = (int)max;
    
    NSLog(@"Y Max is %d", _yValueMax );
    
	
}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    //    _xLabelWidth = (self.frame.size.width - charBartMargin*2)/5.0;
//    _xLabelWidth = 100;
//    
//    for (NSString * labelText in xLabels) {
//        NSInteger index = [xLabels indexOfObject:labelText];
//        PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + charBartMargin), self.frame.size.height - 30.0, _xLabelWidth, 20.0)];
//        [label setTextAlignment:NSTextAlignmentCenter];
//        label.text = labelText;
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor clearColor];
//        [self addSubview:label];
//    }
    
}

-(void)setStrokeColor:(UIColor *)strokeColor
{
	_strokeColor = strokeColor;
}

-(void)strokeChartWithXLabels:(NSArray *)xLabelArray
{
      
    //开始新需求的bar的绘制
    int _index = 0;
    
    for (BTRawData *raw in xLabelArray) {
        
        int hour = [raw.hour intValue];
        float minute = [raw.minute intValue];
        float  result = hour + minute/60;
        
        NSLog(@"]]]]]]]%f",result);
        float value = result;
        //    PNBar * bar = [[PNBar alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + charBartMargin + _xLabelWidth * 0.25), self.frame.size.height - chartCavanHeight - 30.0, _xLabelWidth * 0.5, chartCavanHeight)];
        PNBar * bar = nil;
        if (IPHONE_5_OR_LATER) {
           bar  = [[PNBar alloc] initWithFrame:CGRectMake(xLabelMargin + ((value - 0)/24) *(self.frame.size.width - xLabelMargin),20,(320 *2 - xLabelMargin)/24, 150)];
        }
        else{
           bar = [[PNBar alloc] initWithFrame:CGRectMake(xLabelMargin + ((value - 0)/24) *(self.frame.size.width - xLabelMargin),20,(320 *2 - xLabelMargin)/24, 150)];
        }
  
        bar.barColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.5];
        bar.grade = 1;//在这个方法里面进行了绘制
        bar.tag = FETAL_BAR_TAG + _index;
        [self addSubview:bar];
        
        //
        
        CGRect rect = CGRectMake((bar.center.x - 70/2), 0, 70, 50);//标签坐标 大小
        bar.markView = [[BTBarMarkView alloc] initWithFrame:rect];
        bar.markView.aImageView.image = [UIImage imageNamed:@"markview_ba_middle@2x"];
        bar.markView.markLabel.text = [NSString stringWithFormat:@"%@ \n%d次",[self getLastRecordTimeFromRaw:raw],[self getFetalCountFromRecordTime:raw.seconds1970]];
        bar.markView.markLabel.font = [UIFont boldSystemFontOfSize:11.0f];
        [self addSubview:bar.markView];
        
        
        //显示最后一个bar的标签 隐藏其他的
        bar.markView.hidden = YES;
        if (_index == [xLabelArray count] - 1) {
            bar.markView.hidden = NO;
        }
        _index ++;
     }
    
}
- (NSString *)getLastRecordTimeFromRaw:(BTRawData *)raw
{
    
        if (raw) {
        NSNumber *seconds = raw.seconds1970;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[seconds doubleValue]];
        //分割出小时 分钟
        NSNumber* minute = [BTUtils getMinutes:date];
        NSNumber* hour = [BTUtils getHour:date];
        
        int aHour = [hour intValue] + 1;
        if (aHour >= 24) {
            aHour = aHour - 24;
        }
        NSLog(@"取出最近记录时间  %@",hour);
        
        NSString *hour1 = [NSString stringWithFormat:@"%@",hour];
        NSString *hour2 = [NSString stringWithFormat:@"%d",aHour];
        NSString *minute1 = [NSString stringWithFormat:@"%@",minute];
        
        //当小时 和分钟 是个位数的时候做如下处理
        if ([hour intValue] < 10) {
            hour1 = [NSString stringWithFormat:@"%d%@",0,hour];
        }
        if (aHour < 10) {
            hour2 = [NSString stringWithFormat:@"%d%d",0,aHour];
            
        }
        
        if ([minute intValue] < 10) {
            minute1 = [NSString stringWithFormat:@"%d%@",0,minute];
        }
        NSString *str = [NSString stringWithFormat:@"%@:%@-%@:%@",hour1,minute1,hour2,minute1];
        return str;
        
    }
    
    else{
        return [NSString stringWithFormat:@"上次记录时间:未记录"];
    }
    
}

- (int)getFetalCountFromRecordTime:(NSNumber *)seconds
{
   
 NSNumber *secondsTO = [NSNumber numberWithDouble:([seconds doubleValue] + 60 * 60)];
//对手机存储的胎动 和 设备存储的胎动记录时间分别遍历
NSPredicate *predicatePhone = [NSPredicate predicateWithFormat:@"seconds1970 >= %@ AND seconds1970 <= %@ AND type == %@",seconds,secondsTO,[NSNumber numberWithDouble:PHONE_FETAL_TYPE]];
NSPredicate *predicateDevice = [NSPredicate predicateWithFormat:@"seconds1970 >= %@ AND seconds1970 <= %@ AND type == %@",seconds,secondsTO,[NSNumber numberWithDouble:DEVICE_FETAL_TYPE]];
//取出记录时间数组
NSArray *rawArrayPhone = [BTGetData getFromCoreDataWithPredicate:predicatePhone entityName:@"BTRawData" sortKey:nil];//取出记录时间数组
NSArray *rawArrayDevice = [BTGetData getFromCoreDataWithPredicate:predicateDevice entityName:@"BTRawData" sortKey:nil];
    
    int oneCount = 0;
    for (BTRawData *raw in rawArrayPhone) {
        oneCount +=[raw.count intValue];
    }
    
    for (BTRawData *raw in rawArrayDevice) {
        oneCount +=[raw.count intValue];
    }
    return oneCount;
    
}
@end
