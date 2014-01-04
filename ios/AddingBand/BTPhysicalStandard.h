//
//  BTPhysicalStandard.h
//  AddingBand
//
//  Created by wangpeng on 14-1-4.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BTPhysicalStandard : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * onLimit;
@property (nonatomic, retain) NSString * offLimit;
@property (nonatomic, retain) NSNumber * day;

@end
