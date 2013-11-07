//
//  BTEntity.h
//  AddingBand
//
//  Created by kaka' on 13-11-7.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BTEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * hasAskGrade;
@property (nonatomic, retain) NSNumber * installDate;
@property (nonatomic, retain) NSNumber * lastCheckVersionDate;

@end
