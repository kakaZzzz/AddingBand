//
//  BTMainviewModel.m
//  AddingBand
//
//  Created by wangpeng on 13-12-23.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTMainviewModel.h"

@implementation BTMainviewModel
- (id)initWithTitle:(NSString *)atitle content:(NSString *)acontent
{
    if (self == [super init]) {
        
        self.title = atitle;
        self.content = acontent;
        
    }
    
    return self;
    
}

@end
