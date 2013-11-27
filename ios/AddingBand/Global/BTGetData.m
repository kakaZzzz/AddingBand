//
//  BTGetData.m
//  AddingBand
//
//  Created by kaka' on 13-11-8.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTGetData.h"
#import "BTAppDelegate.h"

@implementation BTGetData

+ (NSArray *)getFromCoreDataWithPredicate:(NSPredicate *)predicate entityName:(NSString *)entityName sortKey:(NSString *)sortKey
{
    //获取上下文··
    NSManagedObjectContext *context =[(BTAppDelegate *) [UIApplication sharedApplication].delegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    //条件
    if (predicate) {
        [request setPredicate:predicate];

    }
    
    //排序
    if (sortKey) {
        NSMutableArray *sortDescriptors = [NSMutableArray array];
        [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES] ];
        
        [request setSortDescriptors:sortDescriptors];
    }

    
    
    NSError* error;
    //从coredata中读取的数据 记录时间和步数
    NSArray* raw = [context executeFetchRequest:request error:&error];
    return raw ;
}

+ (NSManagedObjectContext *)getAppContex
{
    NSManagedObjectContext *context =[(BTAppDelegate *) [UIApplication sharedApplication].delegate managedObjectContext];
    return context;
}

+ (NSString *)getBLEuseTime:(long)usetime
{
    //  NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:usetime];
    
      NSString *str = nil;
      NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
      long time1 = [datenow timeIntervalSince1970];
      long i = time1 - usetime;
   
    if (i == 0) {
         str = [NSString stringWithFormat:@"设备还未使用"];
        return str;
    }
    
    else if( i > 0 && i <60 *60)
    {
        int k = i/(60);
        if (k == 0) {
            str = [NSString stringWithFormat:@"刚使用哦"];
        }
        else
        {
        str = [NSString stringWithFormat:@"已使用%d分钟",k];
        }
        return str;

    }
    else if (i >= 60 *60 && i < 24 * 60 *60) {
        int k = i/(60 *60);
        str = [NSString stringWithFormat:@"已使用%d小时",k];
        return str;
        
    }

   else if(i >= 24 * 60 *60) {
        int k = i/(24 * 60 *60);
        str = [NSString stringWithFormat:@"已使用%d天",k];
        return str;
       
    }
    
   else{
       return nil;
   }
           
}
@end
