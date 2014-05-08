//
//  BTSyncTwoViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-19.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTSyncTwoViewController.h"
#import "BTGlobals.h"
#import "BTBandCentral.h"
#import "LayoutDef.h"
#define kBackgroundHeaderViewHeight 170/2

#define kPeripheralNameX 24/2
#define kPeripheralNameY 10
#define kPeripheralNameWidth 170
#define kPeripheralNameHeight 30


#define kImageBgX 0
#define kImageBgY 100
#define kImageBgWidth 320
#define kImageBgHeight 200

#define kIconImageX 10
#define kIconImageY ((kImageBgHeight - 75)/2 - 20)
#define kIconImageWidth 75
#define kIconImageHeight 75

#define IPHONE_5_OR_LATER ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

static BTSyncTwoViewController *syncTwoVC = nil;
@interface BTSyncTwoViewController ()
{
    UITextField *lanyuTextField;
}
@property(nonatomic,strong)UIScrollView *aScrollView;
@end

@implementation BTSyncTwoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.g = [BTGlobals sharedGlobals];
         self.bc = [BTBandCentral sharedBandCentral];
        //监听设备变化
        [self.g addObserver:self forKeyPath:@"bleListCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
    }
    return self;
}
+ (BTSyncTwoViewController *)shareSyncTwoview
{
    @synchronized(self)//单例标准写法 防止多线程访问单例出错
    {
        if (syncTwoVC == nil) {
            syncTwoVC = [[BTSyncTwoViewController alloc]init];
            
        }
        return syncTwoVC;
        
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //底图用scrollView滚动视图
    self.aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _aScrollView.showsVerticalScrollIndicator = NO;//不显示垂直条
    _aScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 20);
    _aScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_aScrollView];
    
    
    //
    [self addSubviews];
  	// Do any additional setup after loading the view.
}
#pragma mark - 同步数据
- (void)shuchu
{
   
    NSLog(@"点击了傻逼同步按钮");
    //进行同步 这里也得判断设备是哪个设备啊
    [self.bc scanAndSync];

    
}
- (void)addSubviews
{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kBackgroundHeaderViewHeight)];
    bgView.backgroundColor = kTableViewSectionColor;
    [self.view addSubview:bgView];
    
    self.peripheralName = [[UILabel alloc] initWithFrame:CGRectMake(kPeripheralNameX, kPeripheralNameY, kPeripheralNameWidth, kPeripheralNameHeight)];
    _peripheralName.backgroundColor = [UIColor clearColor];
    _peripheralName.textColor = kBigTextColor;
    _peripheralName.font = [UIFont fontWithName:kCharacterAndNumberFont size:FIRST_TITLE_SIZE];
    _peripheralName.textAlignment = NSTextAlignmentLeft;
    _peripheralName.text = @"设备名称啊啊啊啊啊啊";
    [bgView addSubview:_peripheralName];
    
    self.batteryImage = [[UIImageView alloc] initWithFrame:CGRectMake(_peripheralName.frame.origin.x + _peripheralName.frame.size.width + 5, 30/2, 92/2, 34/2)];
    _batteryImage.image = [UIImage imageNamed:@"battery_icon_unknown"];
    [bgView addSubview:_batteryImage];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hand_icon"]];
    iconImage.frame = CGRectMake(_peripheralName.frame.origin.x, _peripheralName.frame.origin.y + _peripheralName.frame.size.height + 20, 12, 15);
    [bgView addSubview:iconImage];
    
    //连接状态
    self.linkLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.frame.origin.x + iconImage.frame.size.width + 3, iconImage.frame.origin.y - 3, 200,20)];
    _linkLabel.backgroundColor = [UIColor clearColor];
    _linkLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _linkLabel.textColor = kContentTextColor;
    _linkLabel.textAlignment = NSTextAlignmentLeft;
    _linkLabel.text = @"连接成功";
    _linkLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _linkLabel.numberOfLines= 0;
    [bgView addSubview:_linkLabel];
    
    
    //上次同步时间
    self.lastSyncTime = [[UILabel alloc]initWithFrame:CGRectMake((320 - 150 - 5), self.linkLabel.frame.origin.y, 150, self.linkLabel.frame.size.height)];
    _lastSyncTime.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _lastSyncTime.textAlignment = NSTextAlignmentRight;
    _lastSyncTime.backgroundColor = [UIColor clearColor];
    _lastSyncTime.text = @"使用时间:---";
    _lastSyncTime.textColor = kContentTextColor;
  //  [self.view addSubview:_lastSyncTime];

    
    //使用时间标签
//    self.useTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake((320 - 100), self.linkLabel.frame.origin.y, 100, self.linkLabel.frame.size.height)];
//    _useTimeLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
//    _useTimeLabel.textAlignment = NSTextAlignmentRight;
//    _useTimeLabel.backgroundColor = [UIColor clearColor];
//    _useTimeLabel.text = @"使用时间:---";
//    _useTimeLabel.textColor = kContentTextColor;
//    [self.view addSubview:_useTimeLabel];

    
  
    self.aRedView = [[UIView alloc] initWithFrame:CGRectMake(0, 170/2, 320, self.view.frame.size.height - 170/2)];
    _aRedView.backgroundColor = kGlobalColor;
    [self.view addSubview:_aRedView];


    //电量
    
    self.batteryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 90,30)];
    NSLog(@"电量标签的坐标%@", NSStringFromCGRect(_batteryLabel.frame));
    _batteryLabel.backgroundColor = [UIColor clearColor];
    _batteryLabel.font = [UIFont systemFontOfSize:15];
    _batteryLabel.textColor = [UIColor whiteColor];
    _batteryLabel.textAlignment = NSTextAlignmentCenter;
    _batteryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _batteryLabel.numberOfLines= 0;
   // [_aRedView addSubview:_batteryLabel];
    

    
     //同步按钮
//    self.syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _syncButton.frame = CGRectMake((self.view.frame.size.width - 120)/2, (_aImageView.frame.size.height - 120)/2, 120, 120);
////    if (IPHONE_5_OR_LATER) {
////        _testButton.frame = CGRectMake((self.view.frame.size.width - 120)/2, self.view.frame.size.height - 260, 120, 120);
////    }
//   
//    [_syncButton setBackgroundImage:[UIImage imageNamed:@"sync_image1"] forState:UIControlStateNormal];
//    [_syncButton addTarget:self action:@selector(shuchu) forControlEvents:UIControlEventTouchUpInside];
//    [_aImageView addSubview:_syncButton];
    
    
    self.syncIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sync_image0"]];
    _syncIcon.frame = CGRectMake((self.view.frame.size.width - 120)/2, 50, 120, 120);
    if (IPHONE_5_OR_LATER) {
    _syncIcon.frame = CGRectMake((self.view.frame.size.width - 120)/2, 100, 120, 120);
    }
    
    NSMutableArray * imageArray = [NSMutableArray arrayWithCapacity:1];
    
    for (int i=0;i<13;i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"sync_image%d",i]];
        [imageArray addObject:image];
    }
    _syncIcon.animationImages = imageArray;
    _syncIcon.animationDuration = 1.5;
    _syncIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSyncByYourself:)];
    [_syncIcon addGestureRecognizer:tap];
    [_aRedView addSubview:_syncIcon];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((_syncIcon.frame.size.width - 40)/2,(_syncIcon.frame.size.height - 30)/2, 40, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:40/2];
    label.text = @"同步";
    [_syncIcon addSubview:label];
    
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake((320 - 300)/2, _syncIcon.frame.origin.y + _syncIcon.frame.size.height + 30, 300, 20)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    contentLabel.textColor = kWhiteColor;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = @"美妈，我们会5分钟为您自动同步一次哦";
    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    contentLabel.numberOfLines= 0;
    [_aRedView addSubview:contentLabel];

    
 
    //
    self.syncProgress = [[UILabel alloc]initWithFrame:CGRectMake(150,0,150,50)];
    _syncProgress.backgroundColor = [UIColor blueColor];
    _syncProgress.font = [UIFont systemFontOfSize:15];
    _syncProgress.textColor = [UIColor whiteColor];
    _syncProgress.text = @"进度:";
    _syncProgress.textAlignment = NSTextAlignmentLeft;
    _syncProgress.lineBreakMode = NSLineBreakByTruncatingTail;
    _syncProgress.numberOfLines= 0;
   // [_aRedView addSubview:_syncProgress];

    
    
    //添加兰宇需要的输入框
    lanyuTextField = [[UITextField alloc] initWithFrame:CGRectMake((320 - 300)/2, 0, 300, 40)];
    lanyuTextField.backgroundColor = [UIColor whiteColor];
    lanyuTextField.delegate = self;
    [_aRedView addSubview:lanyuTextField];
    
    
    //
    UIButton *buttonStart = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonStart.frame = CGRectMake(0, _syncIcon.frame.origin.y, 50, 50);
    [buttonStart setTitle:@"开始" forState:UIControlStateNormal];
    [buttonStart setBackgroundColor:[UIColor blueColor]];
    [buttonStart addTarget:self action:@selector(startWrite:) forControlEvents:UIControlEventTouchUpInside];
    [_aRedView addSubview:buttonStart];
    
    UIButton *buttonEnd = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonEnd.frame = CGRectMake(320 - 50, _syncIcon.frame.origin.y, 50, 50);
    [buttonEnd setTitle:@"结束" forState:UIControlStateNormal];
    [buttonEnd setBackgroundColor:[UIColor blueColor]];
    [buttonEnd addTarget:self action:@selector(endWrite:) forControlEvents:UIControlEventTouchUpInside];
    [_aRedView addSubview:buttonEnd];

}
 -(void)startWrite:(UIButton *)button
{
    self.g.writeArray = [NSMutableArray arrayWithCapacity:1];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_WRITEFILE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)endWrite:(UIButton *)button
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_WRITEFILE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self writeXYZDataTofile:self.g.writeArray];
}

- (void)writeXYZDataTofile:(NSArray *)array
{
    NSDate* date = [NSDate date];//得到0时区日期
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
   
    NSString*rootPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    NSLog(@"文件路径是 11 %@",rootPath);
    NSString*plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-.txt",localeDate]];
    
    NSLog(@"文件路径是  %@",plistPath);
    NSFileManager*fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:plistPath]) {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];//创建一个dictionary文件
    }
    
    [array writeToFile:plistPath atomically:YES];//将数组中的数据写入document下xxx.txt。
    
}

#pragma  mark - 输入框的代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    self.g.modelcode = [textField.text intValue];
    NSLog(@"textFieldDidEndEditing");
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}


- (void)toSyncByYourself:(UITapGestureRecognizer *)tap
{
    
    NSLog(@"自己点击同步");
    [[NSNotificationCenter defaultCenter] postNotificationName:HANDLETOSYNCNOTICE object:nil];
    [self.bc scanAndSync];
    if ([_syncIcon isAnimating]) {
        [_syncIcon stopAnimating];
        [_syncIcon startAnimating];
    }
    else
    {
        [_syncIcon startAnimating];
    }
}
//监控参数，更新显示  当连接  断开的时候也会调用此方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    
    //侦听 同步进度
    if([keyPath isEqualToString:@"dlPercent"])
    {
        BTBandPeripheral *bp = [self.bc getBpByModel:MAM_BAND_MODEL];
        //bp.dlPercent表示同步进度
        NSLog(@"同步进度dl: %f", bp.dlPercent);
        _syncProgress.text = [NSString stringWithFormat:@"进度:%f",bp.dlPercent];
        //  NSDictionary *dicProgress = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:bp.dlPercent] forKey:@"progress"];
        
        if (bp.dlPercent == 1) {
            
            
            
            //同步完成逻辑
            //在这里发送通知  刷新需要显示运动量之类页面的数据 包括进度条  label  柱形图
            //同步完成之后要通知数据页面进行数据刷新
            //    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATACIRCULARPROGRESSNOTICE object:nil userInfo:dicProgress];//接受通知页面必须存在
        }
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
