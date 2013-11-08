//
//  BTGetData.h
//  AddingBand
//
//  Created by kaka' on 13-11-8.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTGetData : NSObject
+ (NSArray *)getFromCoreDataWithPredicate:(NSPredicate *)predicate entityName:(NSString *)entityName sortKey:(NSString *)sortKey;
@end
