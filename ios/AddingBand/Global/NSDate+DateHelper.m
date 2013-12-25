//
//  NSDate+DateHelper.m
//  AddingBand
//
//  Created by wangpeng on 13-12-12.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "NSDate+DateHelper.h"

@implementation NSDate (DateHelper)
//获取当前日期
+ (NSDate *)localdate
{
    NSDate* date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSDate *)localdateByDate:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;

}
//获取今天是星期几
-(NSInteger)dayOfWeek{
    NSCalendar*calendar =[NSCalendar currentCalendar];
    NSDateComponents*offsetComponents =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                                   fromDate:self];
    NSInteger y=[offsetComponents year];
    NSInteger m=[offsetComponents month];
    NSInteger d=[offsetComponents day];
    static int t[]={0,3,2,5,0,3,5,1,4,6,2,4};
    y -=m <3;
    
    NSInteger result=(y +y/4-y/100+y/400+t[m-1]+d)%7;
    if(result==0){
        result=7;
    }
    return result;
}
//获取每月有多少天
- (NSInteger)monthOfDay{
    NSCalendar*calendar =[NSCalendar currentCalendar];
    NSDateComponents*offsetComponents =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                                   fromDate:self];
    NSInteger y=[offsetComponents year];
    NSInteger m=[offsetComponents month];
    if(m==2){
        if(y%4==0&&(y%100!=0||y%400==0)){
            return 29;
        }
        return 28;
    }
    if(m==4||m==6||m==9||m==11){
        return 30;
    }
    return 31;
}
//根据年份和月份得出本月有多少天
+ (NSInteger)dayOfMonthWithYear:(int)y Month:(int)m
{
    if(m==2){
        if(y%4==0&&(y%100!=0||y%400==0)){
            return 29;
        }
        return 28;
    }
    if(m==4||m==6||m==9||m==11){
        return 30;
    }
    return 31;

}
//本周开始时间
-(NSDate*)beginningOfWeek{
    NSInteger weekday=[self dayOfWeek];
    //转化成当前时区的时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: [NSDate date]];
    NSDate *dateLocalZone = [[self addDay:(weekday-1)*-1]  dateByAddingTimeInterval: interval];

    return dateLocalZone;
}
//本周结束时间
-(NSDate*)endOfWeek{
    NSInteger weekday=[self dayOfWeek];
    if(weekday == 7){
        return self;
    }
    //转化成当前时区的时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: [NSDate date]];
    NSDate *dateLocalZone = [[self addDay:7- weekday]  dateByAddingTimeInterval: interval];

    
    return dateLocalZone;
}
//日期添加几天
-(NSDate*)addDay:(NSInteger)day{
    NSTimeInterval interval =24*60*60;
    return[self dateByAddingTimeInterval:day*interval];
}
//日期格式化
-(NSString*)stringWithFormat:(NSString*)format {
    NSDateFormatter*outputFormatter =[[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:format];
    NSString*timestamp_str =[outputFormatter stringFromDate:self];
    
    return timestamp_str;
}
//字符串转换成时间
+(NSDate*)dateFromString:(NSString *)string withFormat:(NSString*)format {
    NSDateFormatter*inputFormatter =[[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat:format];
    NSDate*date =[inputFormatter dateFromString:string];
 
    return date;
}
//时间转换成字符串
+(NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format {
    return[date stringWithFormat:format];
}
//日期转化成民国时间
-(NSString*)dateToTW:(NSString*)string{
    NSString*str=[self stringWithFormat:string];
    int y=[[str substringWithRange:NSMakeRange(0,4)]intValue];
    return[NSString stringWithFormat:@"%d%@",y-1911,[str stringByReplacingCharactersInRange:NSMakeRange(0,4)withString:@""]];
}
@end
