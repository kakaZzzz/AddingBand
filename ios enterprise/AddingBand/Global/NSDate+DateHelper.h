//
//  NSDate+DateHelper.h
//  AddingBand
//
//  Created by wangpeng on 13-12-12.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateHelper)
//获取当前日期
+ (NSDate *)localdate;
//根据0时区的日期转化成当前日期
+ (NSDate *)localdateByDate:(NSDate *)date;
//获取今天是星期几
-(NSInteger)dayOfWeek;
//获取每月有多少天
- (NSInteger)monthOfDay;
//根据年份和月份 得出本月份的天数
+ (NSInteger)dayOfMonthWithYear:(int)y Month:(int)m;
//本周开始时间
-(NSDate*)beginningOfWeek;
//本周结束时间
-(NSDate*)endOfWeek;
//日期添加几天
-(NSDate*)addDay:(NSInteger)day;

//日期格式化
-(NSString*)stringWithFormat:(NSString*)format;
//字符串转换成时间
+(NSDate*)dateFromString:(NSString *)string withFormat:(NSString*)format;
//时间转换成字符串
+(NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)string;
//日期转化成民国时间
-(NSString*)dateToTW:(NSString*)string;
+ (BOOL)isAscendingWithOnedate:(NSDate *)onedate anotherdate:(NSDate *)anotherdate;
@end
