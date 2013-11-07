//
//  BTConfigs.h
//  SmartBat
//
//  Created by kaka' on 13-6-4.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTAppDelegate.h"
#import "BTEntity.h"
#import "BTConstants.h"

@interface BTGlobals : NSObject{
    NSManagedObjectContext* _context;
    BTEntity* _globalsInEntity;
}

//这里是全局变量

@property(assign, nonatomic) int lastCheckVersionDate;
@property(assign, nonatomic) int installDate;
@property(assign, nonatomic) int hasAskGrade;

//手环总数
@property(assign, nonatomic) NSInteger bleListCount;

+(BTGlobals*)sharedGlobals;
-(void)applicationWillResignActive:(NSNotification*) notification;

@end
