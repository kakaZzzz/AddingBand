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
        self.eventId = [dic objectForKey:@"event_id"];
        self.eventType = [dic objectForKey:@"event_type"];
        self.title = [dic objectForKey:@"title"];
        self.hash = [dic objectForKey:@"hash"];
        self.title = [dic objectForKey:@"title"];
        self.description = [dic objectForKey:@"description"];
        self.date = [dic objectForKey:@"date"];
        self.expire = [dic objectForKey:@"expire"];
        self.icon = [dic objectForKey:@"icon"];
   
    }
    return self;
}

@end
