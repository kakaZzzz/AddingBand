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

#define kLeft 6.5
#define kTop 50
#define kWidth 80
#define kHeight 20
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

    self.view.backgroundColor = [UIColor yellowColor];
    [self createSubviews];
	// Do any additional setup after loading the view.
}
- (void)createSubviews
{
    
    
    UILabel *Lable1 = [[UILabel alloc] initWithFrame:CGRectMake(kLeft, kTop, kWidth, kHeight)];
    Lable1.text = @" 原来密码";
    Lable1.backgroundColor = [UIColor clearColor];
    Lable1.textColor = [BTColor getColor:@"797978"];;
    Lable1.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:Lable1];
    
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(6.5,kTop + kHeight + 5, 306.5, 46)];
    imageView2.image = [UIImage imageNamed:@"zhuceshur.png"];
    imageView2.userInteractionEnabled = YES;
    [self.view  addSubview:imageView2];
    
    self.oldPassordTextField = [[UITextField alloc] initWithFrame:CGRectMake(8,0, 306.5-8, 46)];
    _oldPassordTextField .font = [UIFont systemFontOfSize:14.0];
    _oldPassordTextField.textColor = [BTColor getColor:@"C0BFBE"];
    _oldPassordTextField.placeholder = @" 6~16位数字或字母,区分大小写";
    _oldPassordTextField.delegate = self;
    _oldPassordTextField.tag = 102;
    _oldPassordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //_userTf.text = [dic objectForKey:USER_NAME];
    _oldPassordTextField.returnKeyType = UIReturnKeyDone;
    [_oldPassordTextField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];

    [imageView2 addSubview:_oldPassordTextField];
    
    
    UILabel *Lable2 = [[UILabel alloc] initWithFrame:CGRectMake(kLeft, imageView2.frame.origin.y + imageView2.frame.size.height + 10, kWidth, kHeight)];
    Lable2.text = @" 新密码";
    Lable2.backgroundColor = [UIColor clearColor];
    Lable2.textColor = [BTColor getColor:@"797978"];
    Lable2.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:Lable2];
   
    
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(kLeft,Lable2.frame.origin.y +Lable2.frame.size.height + 10, 306.5, 46)];
    imageView3.image = [UIImage imageNamed:@"zhuceshur.png"];
    imageView3.userInteractionEnabled = YES;
    [self.view addSubview:imageView3];
    
    
    self.passordTextField = [[UITextField alloc] initWithFrame:CGRectMake(8,0, 306.5-8, 46)];
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
    
    
    
    UILabel *Lable3 = [[UILabel alloc] initWithFrame:CGRectMake(6.5, imageView3.frame.origin.y+imageView3.frame.size.height+9, 150, 17)];
    Lable3.text = @" 再次输入密码";
    Lable3.backgroundColor = [UIColor clearColor];
    Lable3.textColor = [BTColor getColor:@"797978"];
    Lable3.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:Lable3];
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(6.5,imageView3.frame.origin.y+imageView3.frame.size.height+33, 306.5, 46)];
    imageView4.image = [UIImage imageNamed:@"zhuceshur.png"];
    imageView4.userInteractionEnabled = YES;
    [self.view addSubview:imageView4];

    
    self.confirmPassordTextField = [[UITextField alloc] initWithFrame:CGRectMake(8,0, 306.5-8, 46)];
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
