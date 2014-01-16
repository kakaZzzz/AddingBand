//
//  BTKnowledgeModel.m
//  AddingBand
//
//  Created by wangpeng on 14-1-6.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import "BTKnowledgeModel.h"

@implementation BTKnowledgeModel
-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.remind = [dic objectForKey:@"remind"];
        self.title = [dic objectForKey:@"title"];
        self.hash = [dic objectForKey:@"hash"];
        self.title = [dic objectForKey:@"title"];
        self.description = [dic objectForKey:@"description"];
        //对date进行一下分割转换
        // NSMutableString
        NSArray *subString = [[dic objectForKey:@"date"] componentsSeparatedByString:@"-"];
        self.date = [NSString stringWithFormat:@"%@.%@",[subString objectAtIndex:1],[subString objectAtIndex:2]];
        self.expire = [dic objectForKey:@"expire"];
        self.icon = [dic objectForKey:@"icon"];
        self.contentImage = [dic objectForKey:@"image"];
   
    }
    return self;
}

@end
