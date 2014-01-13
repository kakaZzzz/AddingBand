//
//  BTKnowledgeModel.h
//  AddingBand
//
//  Created by wangpeng on 14-1-6.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTKnowledgeModel : NSObject

@property(nonatomic,retain)NSString *remind;
@property(nonatomic,retain)NSString *hash;
@property (nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *description;
@property(nonatomic,retain)NSString *date;
@property(nonatomic,assign)NSString *expire;
@property(nonatomic,assign)NSString *icon;
@property(nonatomic,assign)NSString *contentImage;
-(id)initWithDictionary:(NSDictionary *)dic;
@end
