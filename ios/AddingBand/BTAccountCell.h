//
//  BTAccountCell.h
//  AddingBand
//
//  Created by kaka' on 13-11-25.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^chooseAccount)(NSString *);
@interface BTAccountCell : UITableViewCell
@property(nonatomic,strong)UIButton *aButton;
@property(nonatomic,strong)UIButton *bButton;
@property(nonatomic,strong)UIButton *cButton;
@property(nonatomic,strong)chooseAccount chooseAccountBlock;
@end
