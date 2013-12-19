//
//  BTSyncViewController.h
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTScrollViewController.h"
#import "MHTabBarController.h"

@class MHTabBarController;
@interface BTPhysicSportViewController : BTScrollViewController<MHTabBarControllerDelegate>
@property(nonatomic,strong)MHTabBarController *tabBarController;//一定要用属性，不然就dealloc了
@property(nonatomic,strong)UIView *progressView;//进度动画view
@property(nonatomic,strong)UILabel *titleLabel;//
@property(nonatomic,strong)UILabel *goalLabel;//目标量
@property(nonatomic,strong)UILabel *progressLabel;//完成进度label
@end
