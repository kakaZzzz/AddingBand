//
//  BTPhysicalModel.m
//  FYChartViewDemo
//
//  Created by wangpeng on 13-12-28.
//  Copyright (c) 2013年 zbflying. All rights reserved.
//

#import "BTPhysicalModel.h"

@implementation BTPhysicalModel
- (id)initWithTitle:(NSString *)title content:(NSString *)content day:(NSString *)day
{
    if (self == [super init]) {
        
        self.title = title;
        self.content = content;
        self.day = day;
    }
    
    return self;
    
}

- (id)initWithTitle:(NSString *)atitle content:(NSString *)acontent
{
    if (self == [super init]) {
        
        self.title = atitle;
        self.content = acontent;
        
    }
    
    return self;
    
}
- (id)initWithTitle:(NSString *)title content:(NSString *)content year:(NSString *)year month:(NSString *)month day:(NSString *)day
{
    if (self == [super init]) {
        
        self.title = title;
        self.content = content;
        self.day = day;
        self.year = year;
        self.month = month;
    }
    
    return self;

}

@end
