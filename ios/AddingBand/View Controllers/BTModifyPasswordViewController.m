//
//  BTModifyPasswordViewController.m
//  AddingBand
//
//  Created by kaka' on 13-11-18.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTModifyPasswordViewController.h"
#import "BTColor.h"
#import "IQKeyBoardManager.h"//键盘管理类

#define kLeft 0
#define kTop 100
#define kWidth 320
#define kHeight 50

#define kTitleLabelWidth 80//原密码 新密码 重复密码等Lable
@interface BTModifyPasswordViewController ()

@end

@implementation BTModifyPasswordViewController

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
    //创建 IQKeyBoardManager的实例对象
    [IQKeyBoardManager installKeyboardManager];
    //注册通知 监控键盘的状态
    [IQKeyBoardManager enableKeyboardManger];
    self.navigationItem.title = @"修改密码";//导航栏标题
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubviews];
	// Do any additional setup after loading the view.
}
//创建子视图
- (void)createSubviews
{
    
    
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(kLeft,kTop , kWidth, kHeight)];
    imageView2.image = [UIImage imageNamed:@"settingcell_bg.png"];
    imageView2.userInteractionEnabled = YES;
    [self.view  addSubview:imageView2];
    
    UILabel *Lable1 = [[UILabel alloc] initWithFrame:CGRectMake(kLeft + 10 , 0, kTitleLabelWidth, kHeight)];
    Lable1.text = @"原密码";
    Lable1.backgroundColor = [UIColor clearColor];
    Lable1.textColor = [BTColor getColor:@"797978"];;
    Lable1.font = [UIFont boldSystemFontOfSize:17];
    [imageView2 addSubview:Lable1];
    
    
    self.oldPassordTextField = [[UITextField alloc] initWithFrame:CGRectMake(Lable1.frame.origin.x + Lable1.frame.size.width,0, 320 - _oldPassordTextField.frame.origin.x, kHeight)];
    _oldPassordTextField .font = [UIFont systemFontOfSize:14.0];
    _oldPassordTextField.textColor = [BTColor getColor:@"C0BFBE"];
    _oldPassordTextField.placeholder = @" 6~16位数字或字母,区分大小写";
    _oldPassordTextField.delegate = self;
    _oldPassordTextField.tag = 102;
    _oldPassordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //_userTf.text = [dic objectForKey:USER_NAME];
    _oldPassordTextField.returnKeyType = UIReturnKeyDone;
    [_oldPassordTextField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];
    //让这个输入框成为第一响应者
    [_oldPassordTextField becomeFirstResponder];
    [imageView2 addSubview:_oldPassordTextField];
    
    
    
    
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(kLeft, imageView2.frame.origin.y + imageView2.frame.size.height , kWidth, kHeight)];
    imageView3.image = [UIImage imageNamed:@"settingcell_bg.png"];
    imageView3.userInteractionEnabled = YES;
    [self.view addSubview:imageView3];
    
    UILabel *Lable2 = [[UILabel alloc] initWithFrame:CGRectMake(kLeft + 10 , 0, kTitleLabelWidth, kHeight)];
    Lable2.text = @"新密码";
    Lable2.backgroundColor = [UIColor clearColor];
    Lable2.textColor = [BTColor getColor:@"797978"];
    Lable2.font = [UIFont boldSystemFontOfSize:17];
    [imageView3 addSubview:Lable2];
    
    
    
    self.passordTextField = [[UITextField alloc] initWithFrame:CGRectMake(Lable2.frame.origin.x + Lable2.frame.size.width,0, 320 - _oldPassordTextField.frame.origin.x, kHeight)];
    _passordTextField.font = [UIFont systemFontOfSize:14.0];
    _passordTextField.textColor = [BTColor getColor:@"C0BFBE"];
    _passordTextField.placeholder = @" 6~16位数字或字母,区分大小写";
    _passordTextField.delegate = self;
    _passordTextField.tag = 103;
    _passordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_passordTextField setSecureTextEntry:YES];
    _passordTextField.returnKeyType = UIReturnKeyDone;
    [_passordTextField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];
    [imageView3 addSubview:_passordTextField];
    
    
    
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(kLeft, imageView3.frame.origin.y + imageView3.frame.size.height, kWidth, kHeight)];
    imageView4.image = [UIImage imageNamed:@"settingcell_bg"];
    imageView4.userInteractionEnabled = YES;
    [self.view addSubview:imageView4];
    
    UILabel *Lable3 = [[UILabel alloc] initWithFrame:CGRectMake(kLeft + 10 , 0, kTitleLabelWidth, kHeight)];
    Lable3.text = @"确认密码";
    Lable3.backgroundColor = [UIColor clearColor];
    Lable3.textColor = [BTColor getColor:@"797978"];
    Lable3.font = [UIFont boldSystemFontOfSize:17];
    [imageView4 addSubview:Lable3];
    
    
    
    self.confirmPassordTextField = [[UITextField alloc] initWithFrame:CGRectMake(Lable3.frame.origin.x + Lable3.frame.size.width,0, 320 - _oldPassordTextField.frame.origin.x, kHeight)];
    _confirmPassordTextField.font = [UIFont systemFontOfSize:14.0];
    _confirmPassordTextField.textColor = [BTColor getColor:@"C0BFBE"];
    _confirmPassordTextField.placeholder = @" 6~16位数字或字母,区分大小写";
    _confirmPassordTextField.delegate = self;
    _confirmPassordTextField.tag = 104;
    [_confirmPassordTextField setSecureTextEntry:YES];
    _confirmPassordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //_userTf.text = [dic objectForKey:USER_NAME];
    _confirmPassordTextField.returnKeyType = UIReturnKeyDone;
    [_confirmPassordTextField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];
    [imageView4 addSubview:_confirmPassordTextField];
    


}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    selectedTextFieldTag = textField.tag;
}

-(void)previousClicked:(UISegmentedControl*)segmentedControl
{
    [(UITextField*)[self.view viewWithTag:selectedTextFieldTag-1] becomeFirstResponder];
}

-(void)nextClicked:(UISegmentedControl*)segmentedControl
{
    [(UITextField*)[self.view viewWithTag:selectedTextFieldTag+1] becomeFirstResponder];
}
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
