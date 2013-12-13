//
//  BTModifyPasswordViewController.h
//  AddingBand
//
//  Created by kaka' on 13-11-18.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//


/**
 *  此页面是修改密码页面
 */
#import <UIKit/UIKit.h>

@interface BTModifyPasswordViewController : UIViewController<UITextFieldDelegate>
{
    NSInteger selectedTextFieldTag;
}
@property(nonatomic,strong)UITextField *oldPassordTextField;
@property(nonatomic,strong)UITextField *passordTextField;
@property(nonatomic,strong)UITextField *confirmPassordTextField;
@end
