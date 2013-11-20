//
//  BTUserData.h
//  AddingBand
//
//  Created by kaka' on 13-11-20.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BTUserData : NSManagedObject

@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * dueDate;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * passWord;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * pregnancy;
@property (nonatomic, retain) NSNumber * selectedRow;

@end
