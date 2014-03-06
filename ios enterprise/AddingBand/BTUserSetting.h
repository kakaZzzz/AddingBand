//
//  BTUserSetting.h
//  AddingBand
//
//  Created by wangpeng on 14-1-2.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BTUserSetting : NSManagedObject

@property (nonatomic, retain) NSString * birthday;//生日
@property (nonatomic, retain) NSString * dueDate;//预产期
@property (nonatomic, retain) NSString * menstruation;//末次月经时间
@property (nonatomic, retain) NSString * mamHeight;//妈妈身高
@property (nonatomic, retain) NSString * previousWeight;//孕前体重

@end
