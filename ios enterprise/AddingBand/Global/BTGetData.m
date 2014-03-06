//
//  BTGetData.m
//  AddingBand
//
//  Created by kaka' on 13-11-8.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTGetData.h"
#import "BTAppDelegate.h"
#import "BTUserSetting.h"
#import "NSDate+DateHelper.h"
#import "LayoutDef.h"
@implementation BTGetData

+ (NSArray *)getFromCoreDataWithPredicate:(NSPredicate *)predicate entityName:(NSString *)entityName sortKey:(NSDictionary *)sortKey
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
        NSArray *sortValues = [sortKey allValues];
        NSMutableArray *sortDescriptors = [NSMutableArray arrayWithCapacity:1];
        for (NSString *sort in sortValues) {
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:sort ascending:YES] ];
        }
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

+ (int)getPregnancyDaysWithDate:(NSDate *)date
{
     NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    if (data.count > 0) {
        BTUserSetting *userData = [data objectAtIndex:0];
   
        NSDate *dueDate = [NSDate dateFromString:userData.menstruation withFormat:@"yyyy.MM.dd"];//duedate为00：00：00
        
        NSTimeInterval menstruation = [dueDate timeIntervalSince1970];
        NSTimeInterval now = [date timeIntervalSince1970];
        NSTimeInterval cha = now - menstruation;
        
        int day1 = cha/(24 * 60 * 60);
        return day1;
     }
    
    return 0;

}

//将数据存放在plist文件中
+ (void)writeMusicToPlistFile:(NSString *)name data:(NSDictionary *)dic
{
     //寻取文件路径
    //找到Documents文件所在的路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    //把TestPlist文件加入
    NSString *plistPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]];//名字
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:plistPath]) {
        
        [[NSFileManager defaultManager] createFileAtPath:plistPath contents:nil attributes:nil];
        NSLog(@"创建一个新的plist");
        
    }
    
    [dic writeToFile:plistPath atomically:YES];
    
}

//从plist文件中读取东西
+ (NSArray *)getOnlimitFromPlistpath:(NSString *)name
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    //把TestPlist文件加入
    NSString *plistPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]];
    
    NSDictionary *dic = [NSArray arrayWithContentsOfFile:plistPath];//外层字典
    NSDictionary *dic1 = [dic objectForKey:name];//对应的数组
    NSArray *arrayOnlimit = [dic1 objectForKey:ON_LIMIT];
    
    return arrayOnlimit;
}

+ (NSArray *)getOfflimitFromPlistpath:(NSString *)name
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    //把TestPlist文件加入
    NSString *plistPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]];
    
    NSDictionary *dic = [NSArray arrayWithContentsOfFile:plistPath];//外层字典
    NSDictionary *dic1 = [dic objectForKey:name];//对应的数组
    NSArray *arrayOnlimit = [dic1 objectForKey:OFF_LIMIT];
    
    return arrayOnlimit;
}

@end
