//
//  BTBleList.h
//  AddingBand
//
//  Created by kaka' on 13-11-20.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BTBleList : NSManagedObject

@property (nonatomic, retain) NSNumber * lastSync;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * setupDate;

@end
