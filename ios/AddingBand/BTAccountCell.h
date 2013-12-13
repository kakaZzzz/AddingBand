//
//  BTAccountCell.h
//  AddingBand
//
//  Created by kaka' on 13-11-25.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

/**
 *  绑定账户 部分自定义cell
 *  使用block用于点击绑定账户之后的回调
 *  
 *
 *
 */
#import <UIKit/UIKit.h>
typedef void(^chooseAccount)(NSString *);
@interface BTAccountCell : UITableViewCell
@property(nonatomic,strong)UIButton *aButton;
@property(nonatomic,strong)UIButton *bButton;
@property(nonatomic,strong)UIButton *cButton;
@property(nonatomic,strong)chooseAccount chooseAccountBlock;
@end
