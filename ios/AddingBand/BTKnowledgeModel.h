//
//  BTKnowledgeModel.h
//  AddingBand
//
//  Created by wangpeng on 14-1-6.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTKnowledgeModel : NSObject

@property(nonatomic,strong)NSString *remind;
@property(nonatomic,strong)NSString *hash;
@property (nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *description;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *expire;
@property(nonatomic,strong)NSString *icon;
@property(nonatomic,strong)NSString *contentImage;
-(id)initWithDictionary:(NSDictionary *)dic;
@end
