//
//  BTPhisicalModel.m
//  AddingBand
//
//  Created by wangpeng on 13-12-17.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTPhisicalModel.h"

@implementation BTPhisicalModel
- (id)initWithTitle:(NSString *)atitle content:(NSString *)acontent
{
    if (self == [super init]) {
        
        self.title = atitle;
        self.content = acontent;

    }
    
    return self;
    
}
@end
