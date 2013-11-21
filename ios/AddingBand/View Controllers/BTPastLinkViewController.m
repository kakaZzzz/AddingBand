//
//  BTPastLinkViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-19.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTPastLinkViewController.h"
#import "BTGlobals.h"
#import "BTBandCentral.h"
#import "BTGetData.h"
#import "BTUserData.h"
#define kImageBgX 0
#define kImageBgY 0
#define kImageBgWidth 320
#define kImageBgHeight 200

#define kIconImageX 10
#define kIconImageY (kImageBgHeight - 75)/2
#define kIconImageWidth 75
#define kIconImageHeight 75

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

static BTPastLinkViewController *pastLinkVC = nil;
@interface BTPastLinkViewController ()

@end

@implementation BTPastLinkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//单例
+ (BTPastLinkViewController *)sharePastLinkview
{
    @synchronized(self)//单例标准写法 防止多线程访问单例出错
    {
        if (pastLinkVC == nil) {
            pastLinkVC = [[BTPastLinkViewController alloc]init];
            
        }
        return pastLinkVC;
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_refreshButton setTitle:@"重新连接" forState:UIControlStateNormal];
    if (iPhone5) {
        _refreshButton.frame = CGRectMake((320 - 200)/2, self.view.frame.size.height - 200, 200, 50);

    }
    else
    {
    _refreshButton.frame = CGRectMake((320 - 200)/2, self.view.frame.size.height - 150, 200, 50);
    }
    [_refreshButton setBackgroundImage:[UIImage imageNamed:@"refresh_btn.png"] forState:UIControlStateNormal];
    [_refreshButton setBackgroundImage:[UIImage imageNamed:@"refresh_btn_sel.png"] forState:UIControlStateHighlighted];

    [_refreshButton addTarget:self action:@selector(refreshLink) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_refreshButton];
    [self addSubviews];
	// Do any additional setup after loading the view.
}

//视图布局
- (void)addSubviews
{
    //背景粉红图
    if (iPhone5) {
        self.aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageBgX, kImageBgY, kImageBgWidth, kImageBgHeight + 50)];
    }
    else
    {
        self.aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageBgX, kImageBgY, kImageBgWidth, kImageBgHeight)];
    }
    _aImageView.image = [UIImage imageNamed:@"red_bg.png"];
    [self.view addSubview:_aImageView];
    //手环icon
    self.aIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageWidth, kIconImageHeight)];
    _aIconImage.image = [UIImage imageNamed:@"家丁手环icon.png"];
    [_aImageView addSubview:_aIconImage];
    //上次同步时间背景图
    self.asynctimeImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 140, (kImageBgHeight - 50)/2, 140, 50)];
    _asynctimeImage.image = [UIImage imageNamed:@"透明层.png"];
    [_aImageView addSubview:_asynctimeImage];
    
    //上次同步时间
    self.lastSyncTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _asynctimeImage.frame.size.width,_asynctimeImage.frame.size.height)];
    _lastSyncTime.backgroundColor = [UIColor clearColor];
    _lastSyncTime.font = [UIFont systemFontOfSize:16];
    _lastSyncTime.textColor = [UIColor whiteColor];
    _lastSyncTime.textAlignment = NSTextAlignmentCenter;
    _lastSyncTime.lineBreakMode = NSLineBreakByTruncatingTail;
    _lastSyncTime.numberOfLines= 0;
    [self.asynctimeImage addSubview:_lastSyncTime];
    
    //电量
    
    self.batteryLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, _aIconImage.frame.origin.y - 5, 90,30)];
    NSLog(@"电量标签的坐标%@", NSStringFromCGRect(_batteryLabel.frame));
    _batteryLabel.backgroundColor = [UIColor clearColor];
    _batteryLabel.text = @"电量----";
    _batteryLabel.font = [UIFont systemFontOfSize:15];
    _batteryLabel.textColor = [UIColor grayColor];
    _batteryLabel.textAlignment = NSTextAlignmentCenter;
    _batteryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _batteryLabel.numberOfLines= 0;
    [self.view addSubview:_batteryLabel];
    
    //设备名称
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_batteryLabel.frame.origin.x, _batteryLabel.frame.origin.y + _batteryLabel.frame.size.height,_batteryLabel.frame.size.width,_batteryLabel.frame.size.height)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:20];
    _nameLabel.textColor = [UIColor grayColor];
    _nameLabel.text = @"加丁手环";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLabel.numberOfLines= 0;
    [self.view addSubview:_nameLabel];
    
    //连接状态
    self.linkLabel = [[UILabel alloc]initWithFrame:CGRectMake(_batteryLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height,_nameLabel.frame.size.width,_nameLabel.frame.size.height)];
    _linkLabel.backgroundColor = [UIColor clearColor];
    _linkLabel.font = [UIFont systemFontOfSize:15];
    _linkLabel.textColor = [UIColor whiteColor];
    _linkLabel.text = @"连接失败";
    _linkLabel.textAlignment = NSTextAlignmentCenter;
    _linkLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _linkLabel.numberOfLines= 0;
    [self.view addSubview:_linkLabel];
    
    //设备使用时间背景
    self.useTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, _aImageView.frame.size.height - 50, 320, 50)];
    _useTimeImage.image = [UIImage imageNamed:@"uestime_bg.png"];
    [_aImageView addSubview:_useTimeImage];
    
    //使用时间标签
    self.useTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, _useTimeImage.frame.size.height)];
    _useTimeLabel.backgroundColor = [UIColor clearColor];
    _useTimeLabel.text = @"使用时间:---";
    _useTimeLabel.textColor = [UIColor whiteColor];
    [_useTimeImage addSubview:_useTimeLabel];
    
    self.label1 = [[UILabel alloc]initWithFrame:CGRectMake( 5, _aImageView.frame.origin.y + _aImageView.frame.size.height + 10,250,30)];
    _label1.backgroundColor = [UIColor clearColor];
    _label1.font = [UIFont systemFontOfSize:15];
    _label1.textColor = [UIColor grayColor];
    _label1.text = @"1.将手机放在距离设备近一些的地方";
    _label1.textAlignment = NSTextAlignmentLeft;
    _label1.lineBreakMode = NSLineBreakByTruncatingTail;
    _label1.numberOfLines= 0;
    [self.view addSubview:_label1];

    self.label2 = [[UILabel alloc]initWithFrame:CGRectMake( 5, _label1.frame.origin.y + _label1.frame.size.height ,200,30)];
    _label2.backgroundColor = [UIColor clearColor];
    _label2.font = [UIFont systemFontOfSize:15];
    _label2.textColor = [UIColor grayColor];
    _label2.text = @"2.打开设备上的按钮";
    _label2.textAlignment = NSTextAlignmentLeft;
    _label2.lineBreakMode = NSLineBreakByTruncatingTail;
    _label2.numberOfLines= 0;
    [self.view addSubview:_label2];
    
    
    self.label3 = [[UILabel alloc]initWithFrame:CGRectMake( 5, _label2.frame.origin.y + _label2.frame.size.height ,200,30)];
    _label3.backgroundColor = [UIColor clearColor];
    _label3.font = [UIFont systemFontOfSize:15];
    _label3.textColor = [UIColor grayColor];
    _label3.text = @"3.打开手机上的蓝牙";
    _label3.textAlignment = NSTextAlignmentLeft;
    _label3.lineBreakMode = NSLineBreakByTruncatingTail;
    _label3.numberOfLines= 0;
    [self.view addSubview:_label3];
    
    
}

- (void)refreshLink
{
    NSLog(@"尝试连接");
    
    [self.bc restartScan];
    [NSThread sleepForTimeInterval:2.0];
    //弹出提醒框
    UIAlertView *bLart = [[UIAlertView alloc] initWithTitle:@"无法连接设备" message:@"请删除此设备绑定，以便我们重新为你搜索" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    bLart.tag = 101;
    [bLart show];

 
    
}
//
//-(void)togglePeripheralByIndex:(NSUInteger)index{
//    
//    //根据index找到对应的peripheral
//    NSEnumerator * enumeratorValue = [_allPeripherals objectEnumerator];
//    BTBandPeripheral* bp = [[enumeratorValue allObjects] objectAtIndex:index];
//    
//    if (!bp.handle.isConnected) {
//        
//        [_cm connectPeripheral:bp.handle options:nil];
//        NSLog(@"!!!connect");
//        
//    }else{
//        
//        //删除coredata里的这条数据
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BTBleList" inManagedObjectContext:_context];
//        
//        NSFetchRequest* request = [[NSFetchRequest alloc] init];
//        [request setEntity:entity];
//        
//        NSError* error;
//        _localBleLIst = [_context executeFetchRequest:request error:&error];
//        
//        for (BTBleList* old in _localBleLIst) {
//            if ([old.name isEqualToString:bp.handle.name]){
//                [_context deleteObject:old];
//                NSLog(@"!!!2222222");
//            }
//        }
//        
//        //及时保存
//        NSError* err;
//        if(![_context save:&err]){
//            NSLog(@"%@", [err localizedDescription]);
//        }
//        
//        //断开连接
//        [_cm cancelPeripheralConnection:bp.handle];
//        NSLog(@"cancel connected");
//    }
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
