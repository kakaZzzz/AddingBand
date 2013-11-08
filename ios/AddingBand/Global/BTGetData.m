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

@end
