//
//  BTPhsicalData.h
//  AddingBand
//
//  Created by kaka' on 13-11-16.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BTPhsicalData : NSManagedObject

@property (nonatomic, retain) NSNumber * babyHeart;
@property (nonatomic, retain) NSNumber * babyHeight;
@property (nonatomic, retain) NSNumber * babyWeight;
@property (nonatomic, retain) NSNumber * mamaWeight;
@property (nonatomic, retain) NSNumber * mamaTempetature;

@end
