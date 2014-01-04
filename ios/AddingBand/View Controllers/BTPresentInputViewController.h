//
//  BTPresentInputViewController.h
//  AddingBand
//
//  Created by wangpeng on 14-1-2.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import "BTScrollViewController.h"
typedef void(^CompleteBlock)(NSString *str1,NSString *str2,NSString *str3);
typedef enum BTPresentInputType
{
    BTPresentInputWeight = 0,
    BTPresentInputFuntalHeight,
    BTPresentInputGirth
}BTPresentInputTypeStyle;

@interface BTPresentInputViewController : BTScrollViewController<UITextFieldDelegate>
{
     NSInteger selectedTextFieldTag;
}

@property (nonatomic,strong)UITextField *inputField;
@property(nonatomic,assign)BTPresentInputTypeStyle presentStyle;
@property(nonatomic,strong)CompleteBlock completeBlock;
- (id)initWithPresentInputTypeStyle:(BTPresentInputTypeStyle)style Complete:(CompleteBlock)block;
@end
