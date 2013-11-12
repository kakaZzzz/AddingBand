//
//  BTPhysicalViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTPhysicalViewController.h"
#import "BTPhysicSportViewController.h"
#import "BTPhysicQuickeningViewController.h"
#import "LayoutDef.h"
@interface BTPhysicalViewController ()
@property(nonatomic,strong)UIScrollView *aScrollView;

@end

@implementation BTPhysicalViewController

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
    [self addSubViews];
    self.view.backgroundColor = [UIColor blueColor];
    NSLog(@"2222222222222222%@",NSStringFromCGRect(self.view.frame));
	// Do any additional setup after loading the view.
}
- (void)addSubViews
{
    //添加滚动视图
    self.aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSLog(@"%@..........",NSStringFromCGRect(self.aScrollView.frame));
    _aScrollView.delegate = self;
    _aScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 50);
    _aScrollView.showsVerticalScrollIndicator = NO;
    _aScrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_aScrollView];
    
    //配置图片 传得参数为图片数量
    [self addImageViewByNumber:5];
    
    
}
//根据图片数目添加图片
- (void)addImageViewByNumber:(NSInteger)imageNumber
{
    int lineNumber = imageNumber/2.0 + 0.5;
    //创建imageView
    CGFloat x = kPhysicalImageX, y = kPhysicalImageY;
    for (int i = 0; i < lineNumber; i++) {
        if ((i == (int)lineNumber - 1) && imageNumber % 2 != 0) {
            UIImageView *aImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demo1.png"]];
            aImageView.frame = CGRectMake(x, y, kPhysicalImageWidth, kPhysicalImageHeight);
            aImageView.backgroundColor = [UIColor whiteColor];
            aImageView.tag = 100 + 2 *i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
            [aImageView addGestureRecognizer:tap];
            aImageView.userInteractionEnabled = YES;
            [_aScrollView addSubview:aImageView];
            x += self.view.frame.size.width - kPhysicalImageX * 2 - kPhysicalImageWidth;
            
        }
        else
        {
            for (int j = 0; j < 2; j++) {
                UIImageView *aImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demo1.png"]];
                aImageView.frame = CGRectMake(x, y, kPhysicalImageWidth, kPhysicalImageHeight);
                aImageView.backgroundColor = [UIColor whiteColor];
                aImageView.tag = 100 + 2 *i + j;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
                [aImageView addGestureRecognizer:tap];
                aImageView.userInteractionEnabled = YES;
                [_aScrollView addSubview:aImageView];
                x += self.view.frame.size.width - kPhysicalImageX * 2 - kPhysicalImageWidth;
            }
        }
        x = kPhysicalImageX;
        y += kPhysicalImageHeight + 10;
    }
}

#pragma mark - 点击图片触发事件
- (void)doTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击的图片的tag值是 %d",tap.view.tag);
    //tag值100 表示运动  101表示胎动
    switch (tap.view.tag) {
        case 100:
        {
            BTPhysicSportViewController *sportVC = [[BTPhysicSportViewController alloc] init];
            sportVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sportVC animated:YES];
            break;
        }
            case 101:
        {
            BTPhysicQuickeningViewController *quickeningVC = [[BTPhysicQuickeningViewController alloc] init];
            quickeningVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:quickeningVC animated:YES];

            break;
        }
        default:
            break;
    }
 }

- (void)viewDidLayoutSubviews{

    
        NSLog(@"viewDidLayoutSubviews");
        if ([[[UIDevice currentDevice] systemVersion] intValue] == 7) {
            
            NSLog(@"改变视图大小");
            NSLog(@"%@",NSStringFromCGRect(self.aScrollView.frame));

            
        }
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
