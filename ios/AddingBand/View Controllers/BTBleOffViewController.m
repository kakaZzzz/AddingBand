//
//  BTBleOffViewController.m
//  AddingBand
//
//  Created by wangpeng on 14-1-8.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import "BTBleOffViewController.h"
#import "LayoutDef.h"
@interface BTBleOffViewController ()

@end

@implementation BTBleOffViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
- (id)initWithWarntext:(NSString *)warnText aImageName:(NSString *)aImage bImageName:(NSString *)bImage
{
    self = [super init];
    if (self) {
        self.warnText = warnText;
        self.aImageName = aImage;
        self.bImageName = bImage;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor whiteColor];
    self.aImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-270/3)/2, 20, 270/3, 270/3)];
    if (IPHONE_5_OR_LATER) {
        _aImageView.frame = CGRectMake((320-270/2)/2, 20, 270/2, 270/2);
    }
    _aImageView.image = [UIImage imageNamed:_aImageName];
    [self.view addSubview:_aImageView];
    
    
    self.warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, _aImageView.frame.origin.y + _aImageView.frame.size.height + 10, 200, 30)];
    _warnLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    _warnLabel.textColor = kBigTextColor;
    _warnLabel.text = _warnText;
    _warnLabel.attributedText =[[self illuminatedString:_warnLabel.text] copy];
    [self.view addSubview:_warnLabel];
    
    self.bImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-270/3)/2, _warnLabel.frame.origin.y + _warnLabel.frame.size.height + 10, 270/3, 270/3)];
    if (IPHONE_5_OR_LATER) {
        _bImageView.frame = CGRectMake((320-270/2)/2, _warnLabel.frame.origin.y + _warnLabel.frame.size.height + 10, 270/2, 270/2);
    }
    _bImageView.image = [UIImage imageNamed:_bImageName];
    [self.view addSubview:_bImageView];

    
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49 - 100/2 - 50, 320, 100/2)];
    aView.backgroundColor = kGlobalColor;
    [self.view addSubview:aView];
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(24/2, (aView.frame.size.height - 30)/2 , 150, 30)];
    aLabel.textColor = [UIColor whiteColor];
    aLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    aLabel.text = @"连接加丁胎动手环";
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textAlignment = NSTextAlignmentLeft;
    aLabel.numberOfLines= 0;
    [aView addSubview:aLabel];
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailButton.frame = CGRectMake((320 - 224/2), 0, 224/2, 100/2);
    [detailButton setBackgroundImage:[UIImage imageNamed:@"detain_button_unselected"] forState:UIControlStateNormal];
    [detailButton setBackgroundImage:[UIImage imageNamed:@"detain_button_selected"] forState:UIControlStateSelected];
    [detailButton setBackgroundImage:[UIImage imageNamed:@"detain_button_selected"] forState:UIControlStateHighlighted];
    [aView addSubview:detailButton];
    
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake((detailButton.frame.size.width - 70)/2, (detailButton.frame.size.height - 30)/2, 70, 30)];
    buttonLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    buttonLabel.backgroundColor = [UIColor clearColor];
    buttonLabel.textColor = [UIColor whiteColor];
    buttonLabel.text = @"了解详情";
    buttonLabel.textAlignment = NSTextAlignmentCenter;
    [detailButton addSubview:buttonLabel];
    
    UIImageView *accessorImage = [[UIImageView alloc] initWithFrame:CGRectMake((detailButton.frame.size.width - 20), (detailButton.frame.size.height - 20)/2, 20, 20)];
    accessorImage.image = [UIImage imageNamed:@"accessory_gray"];
    [detailButton addSubview:accessorImage];

    
	// Do any additional setup after loading the view.
}
- (NSMutableAttributedString *)illuminatedString:(NSString *)text
{
  
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [mutaString beginEditing];
    
    if ([text isEqualToString:@"请打开手机的蓝牙功能"]) {
        [mutaString addAttribute:NSForegroundColorAttributeName
                           value:(id)[UIColor blueColor]
                           range:NSMakeRange(6, 4)];

    }
    
    if ([text isEqualToString:@"请您将手环与手机靠近"]) {
        [mutaString addAttribute:NSForegroundColorAttributeName
                           value:(id)kGlobalColor
                           range:NSMakeRange(3, 2)];

        [mutaString addAttribute:NSForegroundColorAttributeName
                           value:(id)kGlobalColor
                           range:NSMakeRange(6, 2)];

    }
    [mutaString endEditing];
    
    return mutaString;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
