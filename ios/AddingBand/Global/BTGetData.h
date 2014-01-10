//
//  BTGetData.h
//  AddingBand
//
//  Created by kaka' on 13-11-8.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTGetData : NSObject
//从coredata中取出实体
+ (NSArray *)getFromCoreDataWithPredicate:(NSPredicate *)predicate entityName:(NSString *)entityName sortKey:(NSDictionary *)sortKey;
//获取程序上下文
+ (NSManagedObjectContext *)getAppContex;

//根据设备绑定时间 返回设备使用时间
+ (NSString *)getBLEuseTime:(long)usetime;

//根据任意日期 得出是怀孕第几天
+ (int)getPregnancyDaysWithDate:(NSDate *)date;
@end
