//
//  BTMainViewController.h
//  AddingBand
//
//  Created by wangpeng on 13-12-20.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface BTMainViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate,
EGORefreshTableDelegate>
{
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    BOOL _isFirst;

}
@property(nonatomic,strong)UIView *navigationBgView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIView *tableViewBackgroundView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *toTopButton;
@end
