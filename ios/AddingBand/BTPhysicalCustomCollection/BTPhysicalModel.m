//
//  BTPhysicalModel.m
//  BTTestCollectionView
//
//  Created by wangpeng on 13-12-26.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import "BTPhysicalModel.h"

@implementation BTPhysicalModel
- (id)initWithTitle:(NSString *)atitle content:(NSString *)acontent
{
    if (self == [super init]) {
        
        self.title = atitle;
        self.content = acontent;
        
    }
    
    return self;
    
}

@end
