//
//  BTUserData.h
//  AddingBand
//
//  Created by wangpeng on 13-12-5.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BTUserData : NSManagedObject

@property (nonatomic, retain) NSString * birthday;//生日
@property (nonatomic, retain) NSString * dueDate;//预产期
@property (nonatomic, retain) NSString * email;//邮箱
@property (nonatomic, retain) NSString * passWord;//密码
@property (nonatomic, retain) NSString * phoneNumber;//电话
@property (nonatomic, retain) NSString * pregnancy;//怀孕症状
@property (nonatomic, retain) NSString * selectedName;//连接的外设的名字

@end
