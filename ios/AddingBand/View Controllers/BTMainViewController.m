//
//  BTMainViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-20.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTMainViewController.h"
#import "LayoutDef.h"
#import "BTMainViewCell.h"
#import "UMSocialSnsService.h"//友盟分享
#import "UMSocial.h"
#define NAVIGATIONBAR_Y 0
#define NAVIGATIONBAR_HEIGHT 65
@interface BTMainViewController ()

@end

@implementation BTMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - 视图出现  消失
- (void)viewWillAppear:(BOOL)animated
{
     [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
   
    [self addSubviews];
    [self addChageScrollViewToTopButton];
	// Do any additional setup after loading the view.
}
#pragma mark - 加载返回第一行按钮
- (void)addChageScrollViewToTopButton
{
    self.toTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toTopButton.frame = CGRectMake(10, self.view.frame.size.height - 100, 50, 50);
    _toTopButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [_toTopButton addTarget:self action:@selector(toTop:) forControlEvents:UIControlEventTouchUpInside];
    [_toTopButton setTitle:@"toTop" forState:UIControlStateNormal];
    [self.view addSubview:_toTopButton];
}
//返回到首页
- (void)toTop:(UIButton *)button
{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
     self.tableView.contentOffset = CGPointMake(0, 0);
    } completion:nil];
    
    //友盟分享
//    UMSocialSnsPlatform *sinaPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//    sinaPlatform.bigImageName = @"icon";
//    sinaPlatform.displayName = @"微博";
//    sinaPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
//        NSLog(@"点击新浪微博的响应");
//        
//
//  
//    };

//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:nil
//                                      shareText:@"你要分享的文字"
//                                     shareImage:[UIImage imageNamed:@"icon.png"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToQzone,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,nil]
//                                       delegate:nil];

 
    
//    //以下方法可以实现自定义页面
//    if (![UMSocialAccountManager isOauthWithPlatform:UMShareToSina]) {
//        //进入授权页面
//        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                //获取微博用户名、uid、token等
//                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
//                NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
//                //进入你的分享内容编辑页面
//                
//            }
//        });
//
//        };
//    
//    if ([UMSocialAccountManager isOauthWithPlatform:UMShareToSina]) {
//        NSLog(@"已授权；；；；；");
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"分享内嵌文字啦啦啦" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//            }
//        }];
//    }
    
    
    
    //单独测试微信朋友圈
    
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"分享内嵌文字啦啦啦" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
           }];
 }
#pragma mark - 加载子视图
- (void)addSubviews
{
    self.navigationBgView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_Y, 320, NAVIGATIONBAR_HEIGHT)];
    _navigationBgView.backgroundColor = kGlobalColor;
    [self.view addSubview:_navigationBgView];
    
//    self.tableViewBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, _navigationBgView.frame.origin.y + _navigationBgView.frame.size.height, 320, self.view.frame.size.height - NAVIGATIONBAR_HEIGHT)];
//    _tableViewBackgroundView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_tableViewBackgroundView];
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, 320, 40)];
    _headView.backgroundColor = kGlobalColor;
    [self.view addSubview:_headView];

    //加载tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headView.frame.origin.y + _headView.frame.size.height, 320,self.view.frame.size.height)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= 40) {
       // static CGRect rect = _headView.frame;
        NSLog(@"..........%f",_tableView.contentOffset.y);
        
     [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
         _headView.frame = CGRectMake(0,NAVIGATIONBAR_HEIGHT - scrollView.contentOffset.y, 320, 40);
         self.tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT - scrollView.contentOffset.y + 40, 320, self.view.frame.size.height);

     } completion:nil];
         [self.view bringSubviewToFront:_navigationBgView];
    }
    
    
    else if (scrollView.contentOffset.y > 40) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _headView.frame = CGRectMake(0,NAVIGATIONBAR_HEIGHT - 40, 320, 40);
            self.tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT - 40 + 40, 320, self.view.frame.size.height - 59);
            
        } completion:nil];

    }
    
    else{
        //[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _headView.frame = CGRectMake(0,NAVIGATIONBAR_HEIGHT, 320, 40);
            
        //} completion:nil];

    }
    NSLog(@"..........%f",_tableView.contentOffset.y);
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 60 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    aView.backgroundColor = [UIColor greenColor];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, (44 - 5*2))];
    lable.backgroundColor = [UIColor blueColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor =[UIColor whiteColor];
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(320 - 100, 10,100, (44 - 10*2));
    button.tag = MAIN_BUTTON_TAG + section;
    [button setTitle:@"卵子受孕中" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushNextView:) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:button];
    
    if (section == 0) {
       lable.text = @"3周";
    }
    if (section == 1)
    {
        lable.text = @"看.属于你的文字";
        
    }
    if (section == 2)
    {
        lable.text = @"做.属于你的个性";
        
    }
    
    [aView addSubview: lable];
  
    static int tag = 1001;
    aView.tag = tag++;
    return aView;
}
- (void)pushNextView:(UIButton *)button
{
    NSLog(@"点击分区头，进入下一页");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BTMainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BTMainViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.separatorColor = [UIColor clearColor];
//    BTPhisicalModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    cell.physicalModel = model;
    cell.textLabel.text = @"哈哈";
    return cell;
    
}

#pragma mark - tabelview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
