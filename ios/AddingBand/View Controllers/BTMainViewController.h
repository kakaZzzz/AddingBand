//
//  BTMainViewController.h
//  AddingBand
//
//  Created by wangpeng on 13-12-20.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "BTSheetPickerview.h"
@class MKNetworkEngine;
@interface BTMainViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate,
EGORefreshTableDelegate,
BTSheetPickerviewDelegate>
{
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    BOOL _isFirst;
    
}
@property(nonatomic,strong)UIView *navigationBgView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIView *tableViewBackgroundView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *toTopButton;
@property(nonatomic,strong)NSMutableArray *modelArray;//行数据
@property(nonatomic,strong)NSMutableArray *sectionArray;//分区头数据
@property(nonatomic,strong)NSMutableArray *rowOfSectionArray;//每个分区有多少行
@property(nonatomic,strong)NSString *dueDate;
//输入预产期 选择器
@property(nonatomic,strong)BTSheetPickerview *actionSheetView;

@property(nonatomic,retain)UIWebView *webView;
//网络请求
@property(nonatomic,strong)MKNetworkEngine *engine;
@property(nonatomic,assign)BOOL isLoadNextData;//加载未来数据标识符
@end
