//
//  BTUserData.h
//  AddingBand
//
//  Created by wangpeng on 14-1-2.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BTUserData : NSManagedObject

@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSString * fundalHeight;
@property (nonatomic, retain) NSString * girth;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSString * weight;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSDate * production;
@property (nonatomic, retain) NSNumber * minute;

@end
