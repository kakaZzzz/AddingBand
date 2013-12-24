//
//  BTKnowledgeViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-24.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTKnowledgeViewController.h"
#import "HYActivityView.h"
#import "UMSocialSnsService.h"//友盟分享
#import "UMSocial.h"
@interface BTKnowledgeViewController ()
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) HYActivityView *activityView;
@end

@implementation BTKnowledgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button setTitle:@"press button" forState:UIControlStateNormal];
    [self.button sizeToFit];
    [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];

    
	// Do any additional setup after loading the view.
}
- (void)buttonClicked:(UIButton *)button
{
    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"分享到" referView:self.view];
        
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 6;
        
        ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"share_platform_sina"] handler:^(ButtonView *buttonView){
            NSLog(@"点击新浪微博");
            
            //以下方法可以实现自定义页面
            if (![UMSocialAccountManager isOauthWithPlatform:UMShareToSina]) {
                //进入授权页面
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        //获取微博用户名、uid、token等
                        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                        NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                        //进入你的分享内容编辑页面
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定分享吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                        [alert show];
                    }
                });
                
            };
            
            if ([UMSocialAccountManager isOauthWithPlatform:UMShareToSina]) {
                NSLog(@"已授权；；；；；");
                //直接进入分享页面
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定分享吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alert show];

            }
            
            
            
            
            
            
            
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"Email" image:[UIImage imageNamed:@"share_platform_email"] handler:^(ButtonView *buttonView){
            NSLog(@"点击腾讯微博");
            
            //以下方法可以实现自定义页面
            if (![UMSocialAccountManager isOauthWithPlatform:UMShareToTencent]) {
                //进入授权页面
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent].loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        //获取微博用户名、uid、token等
                        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToTencent];
                        NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                        //进入你的分享内容编辑页面
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定分享吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                        [alert show];
                    }
                });
                
            };
            
            if ([UMSocialAccountManager isOauthWithPlatform:UMShareToTencent]) {
                NSLog(@"已授权；；；；；");
                //直接进入分享页面
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定分享吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alert show];
                
            }

            
            
            
            
            
            
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"印象笔记" image:[UIImage imageNamed:@"share_platform_evernote"] handler:^(ButtonView *buttonView){
            NSLog(@"点击QQ空间");
            
            //以下方法可以实现自定义页面
            if (![UMSocialAccountManager isOauthWithPlatform:UMShareToQzone]) {
                //进入授权页面
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        //获取微博用户名、uid、token等
                        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQzone];
                        NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                        //进入你的分享内容编辑页面
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定分享吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                        [alert show];
                    }
                });
                
            };
            
            if ([UMSocialAccountManager isOauthWithPlatform:UMShareToQzone]) {
                NSLog(@"已授权；；；；；");
                //直接进入分享页面
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定分享吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alert show];
                
            }

            
            
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"QQ" image:[UIImage imageNamed:@"share_platform_qqfriends"] handler:^(ButtonView *buttonView){
            NSLog(@"点击QQ");
        }];
        
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"微信" image:[UIImage imageNamed:@"share_platform_wechat"] handler:^(ButtonView *buttonView){
            NSLog(@"点击微信");
         
//            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//            req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
//            req.bText = YES;
//            req.scene = WXSceneSession;//微信
//            
//            [WXApi sendReq:req];


            
            
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
           //[UMSocialData defaultData].extConfig.appUrl = @"https://www.umeng.com";//设置你应用的下载地址
            [UMSocialData defaultData].shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。";
            [UMSocialData defaultData].shareImage =  [UIImage imageNamed:@"baby_weight_sel@2x"];          //分享内嵌图片
          
            //分享到朋友圈
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline];
            snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);

            
            
            
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"微信朋友圈" image:[UIImage imageNamed:@"share_platform_wechattimeline"] handler:^(ButtonView *buttonView){
            NSLog(@"点击微信朋友圈");
            
            
            //微信开放平台官方文档
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
            req.bText = YES;
            req.scene = WXSceneTimeline;//微信朋友圈
            [WXApi sendReq:req];
            
        }];
        [self.activityView addButtonView:bv];
        
    }
    
    [self.activityView show];
    
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    
    
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        NSLog(@"分享成功");
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSLog(@"确定分享");
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"分享内嵌文字啦啦啦" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //在这里可以弹出分享成功的提醒框
                NSLog(@"分享成功！");
            }
        }];

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
