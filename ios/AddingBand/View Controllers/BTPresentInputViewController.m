//
//  BTPresentInputViewController.m
//  AddingBand
//
//  Created by wangpeng on 14-1-2.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import "BTPresentInputViewController.h"
#import "BTView.h"
#import "LayoutDef.h"
#import "IQKeyBoardManager.h"
#import "NSDate+DateHelper.h"
#import "BTUtils.h"
#import "BTGetData.h"
#import "BTUserData.h"
#import "BTUserSetting.h"
@interface BTPresentInputViewController ()
@property(nonatomic,strong)UILabel *kiloLabel;
@property(nonatomic,strong)BTView *bView;
@property(nonatomic,strong)BTView *cView;
@property(nonatomic,strong)UITextField *heightTextField;
@property(nonatomic,strong)UITextField *previousWeightField;
@property(nonatomic,strong)UIButton *completeButton;
@end

@implementation BTPresentInputViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
////        //创建 IQKeyBoardManager的实例对象
////        [IQKeyBoardManager installKeyboardManager];
////        //注册通知 监控键盘的状态
////        [IQKeyBoardManager enableKeyboardManger];
//
//       
//    }
//    return self;
//}
- (id)initWithPresentInputTypeStyle:(BTPresentInputTypeStyle)style Complete:(CompleteBlock)block
{
    self = [super init];
    if (self) {
        //创建 IQKeyBoardManager的实例对象
        [IQKeyBoardManager installKeyboardManager];
        //注册通知 监控键盘的状态
        [IQKeyBoardManager enableKeyboardManger];
        self.presentStyle = style;
        self.completeBlock = block;
    }
    return self;
}
- (void)dealloc
{
   
    NSLog(@"dealloc.............");
  
    [IQKeyBoardManager disableKeyboardManager];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backButton.hidden = YES;//隐藏返回按钮
     self.view.backgroundColor = [UIColor yellowColor];
    [self configureNavigationbarRightbar];
    //体重
    BTView *weightView = [[BTView alloc] initWithFrame:CGRectMake(0, 368/2, 320, 112/2)];
    weightView.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:weightView];
    
    
    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(320/2 - 40, (weightView.frame.size.height - 50)/2, 100, 50)];
    _inputField.textColor = kContentTextColor;
    _inputField.backgroundColor = [UIColor clearColor];
    _inputField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inputField.tag = TEXTFIELD_TAG + 0;
    _inputField.returnKeyType = UIReturnKeyDone;
    _inputField.delegate = self;
    _inputField.keyboardType = UIKeyboardTypeDecimalPad;
    [[IQKeyBoardManager installKeyboardManager] setScrollView:self.scrollView];//监听键盘通知 改变scrollview的偏移量
    _inputField.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _inputField.placeholder = @"目前体重";
    //让这个输入框成为第一响应者
    [_inputField becomeFirstResponder];
    [weightView addSubview:_inputField];

    
    self.kiloLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 30,(weightView.frame.size.height - 30)/2, 30, 30)];
    _kiloLabel.textColor = kBigTextColor;
    _kiloLabel.backgroundColor = [UIColor clearColor];
    _kiloLabel.textAlignment = NSTextAlignmentLeft;
    _kiloLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _kiloLabel.text = @"kg";
    [weightView addSubview:_kiloLabel];

    
    //
    self.bView = [[BTView alloc] initWithFrame:CGRectMake(0, weightView.frame.origin.y + weightView.frame.size.height, 320, 112/2)];
    weightView.backgroundColor = [UIColor whiteColor];
    _bView.hidden = YES;
    [self.scrollView addSubview:_bView];
    
    
    self.heightTextField = [[UITextField alloc] initWithFrame:CGRectMake(320/2 - 40, (_bView.frame.size.height - 50)/2, 100, 50)];
    _heightTextField.textColor = kContentTextColor;
    _heightTextField.backgroundColor = [UIColor clearColor];;
    _heightTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _heightTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _heightTextField.tag = TEXTFIELD_TAG + 1;
    _heightTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _heightTextField.returnKeyType = UIReturnKeyDone;
    _heightTextField.delegate = self;
    [[IQKeyBoardManager installKeyboardManager] setScrollView:self.scrollView];//监听键盘通知 改变scrollview的偏移量
    _heightTextField.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _heightTextField.placeholder = @"身高";
     [_bView addSubview:_heightTextField];
    
    
    UILabel *bLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 30,(_bView.frame.size.height - 30)/2, 30, 30)];
    bLabel.textColor = kBigTextColor;
    bLabel.backgroundColor = [UIColor clearColor];;
    bLabel.textAlignment = NSTextAlignmentLeft;
    bLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    bLabel.text = @"cm";
    [_bView addSubview:bLabel];

    //
    self.cView = [[BTView alloc] initWithFrame:CGRectMake(0, _bView.frame.origin.y + _bView.frame.size.height, 320, 112/2)];
    _cView.backgroundColor = [UIColor whiteColor];
    _cView.hidden = YES;
    [self.scrollView addSubview:_cView];
    
    
    self.previousWeightField = [[UITextField alloc] initWithFrame:CGRectMake(320/2 - 40, (_cView.frame.size.height - 50)/2, 100, 50)];
    _previousWeightField.textColor = kContentTextColor;
    _previousWeightField.backgroundColor = [UIColor clearColor];;
    _previousWeightField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _previousWeightField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _previousWeightField.tag = TEXTFIELD_TAG + 2;
    _previousWeightField.keyboardType = UIKeyboardTypeDecimalPad;
    _previousWeightField.returnKeyType = UIReturnKeyDone;
    _previousWeightField.delegate = self;
    [[IQKeyBoardManager installKeyboardManager] setScrollView:self.scrollView];//监听键盘通知 改变scrollview的偏移量
    _previousWeightField.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _previousWeightField.placeholder = @"孕前体重";
 
    [_cView addSubview:_previousWeightField];
    
    
    UILabel *cLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 30,(_cView.frame.size.height - 30)/2, 30, 30)];
    cLabel.textColor = kBigTextColor;
    cLabel.backgroundColor = [UIColor clearColor];;
    cLabel.textAlignment = NSTextAlignmentLeft;
    cLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    cLabel.text = @"kg";
    [_cView addSubview:cLabel];

    //重新调整布局
    [self layoutSubViewsByInputType:self.presentStyle];
    
    
  	// Do any additional setup after loading the view.
}
#pragma mark - 设置导航栏上面的按钮
- (void)configureNavigationbarRightbar
{
    self.completeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _completeButton.frame = CGRectMake(250, 5, 100/2, 48/2);
    [_completeButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_complete_unselected"] forState:UIControlStateNormal];
    [_completeButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_complete_selected"] forState:UIControlStateSelected];
    [_completeButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_complete_selected"] forState:UIControlStateHighlighted];
    [_completeButton addTarget:self action:@selector(completeInput:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_completeButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)_completeButton];
}
#pragma mark - 点击完成按钮
- (void)completeInput:(UIButton *)button
{
    //先要判断数据是不是输全  没有输全不能退出此页面
    if ([self isCompleted]) {
        //把数据存放在coredata里面
        [self writeToCoredataWithWeight:_inputField.text];
        
        if (self.presentStyle == BTPresentInputWeight) {
            [self writeToCoredataWithMamaHeight:_heightTextField.text previousWeight:_previousWeightField.text];
        }
        
        _completeBlock(_inputField.text,_heightTextField.text,_previousWeightField.text);
        //页面消失
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    //如果未完全输入数据  alert
    else{
        UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善数据" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil ,nil];
        [alertview show];

    }
 
    

}
#pragma mark - 根据传进来的参数 重新布局
- (void)layoutSubViewsByInputType:(BTPresentInputTypeStyle)inputType
{
    switch (inputType) {
        case BTPresentInputWeight:
        {
            _inputField.placeholder = @"目前体重";
            _kiloLabel.text = @"kg";
            _bView.hidden = NO;
            _cView.hidden = NO;
            [_inputField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];
            [_heightTextField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];

            [_previousWeightField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];

        }
            break;
        case BTPresentInputFuntalHeight:
        {
            _inputField.placeholder = @"目前宫高";
            _kiloLabel.text = @"cm";
            
        }
            break;
        case BTPresentInputGirth:
        {
            _inputField.placeholder = @"目前腹围";
            _kiloLabel.text = @"cm";
            
            
        }
            break;

        default:
            break;
    }
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


#pragma mark - 增加代码的鲁棒性 在此只允许输入数字和小数点
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.\n"] invertedSet];
    //NUMBERS在这里指@“0123456789\n”
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    if(!canChange)
    {
        UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"这里只能输入数字" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil ,nil];
        [alertview show];
    }
    return canChange;
}
#pragma mark - 按键盘retrn 键之后触发的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}
#pragma mark - 判断每个输入框是否都输完了
- (BOOL)isCompleted
{
    switch (self.presentStyle) {
        case BTPresentInputWeight:
        {
            if (![_inputField.text isEqualToString:@""] && ![_heightTextField.text isEqualToString:@""] && ![_previousWeightField.text isEqualToString:@""]) {
                return YES;
            }
            else{
                return NO;
            }
        }
            
            break;
        case BTPresentInputFuntalHeight:
        {
            if (![_inputField.text isEqualToString:@""]) {
                return YES;
            }
            else{
                return NO;
            }
            
        }
            break;
        case BTPresentInputGirth:
        {
            if (![_inputField.text isEqualToString:@""]) {
                return YES;
            }
            else{
                return NO;
            }
            
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 往coredata里面写入数据 此coredata是 BTUserData
- (void)writeToCoredataWithWeight:(NSString *)weight
{
    
    NSDate *localDate = [NSDate localdate];
    NSNumber *year = [BTUtils getYear:localDate];
    NSNumber *month = [BTUtils getMonth:localDate];
    NSNumber *day = [BTUtils getDay:localDate];

   
    NSManagedObjectContext *context = [BTGetData getAppContex];
    //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@",year, month, day];
    NSError *error;
    NSArray *dataArray = [BTGetData getFromCoreDataWithPredicate:predicate entityName:@"BTUserData" sortKey:nil];
    
    if (dataArray.count == 1) {
        
        //已经有条目了
        //进行coredata的更改数据操作
        BTUserData* one = [dataArray objectAtIndex:0];
        switch (self.presentStyle) {
            case BTPresentInputWeight:
                one.weight = weight;
                break;
            case BTPresentInputFuntalHeight:
                one.fundalHeight = weight;
                break;
            case BTPresentInputGirth:
                one.girth = weight;
                break;

            default:
                break;
        }
        
        
        
    }else if(dataArray.count == 0){
        
        //木有啊,就新建一条  进行coredata的插入数据操作
        
        NSLog(@"there no");
        
        BTUserData* new = [NSEntityDescription insertNewObjectForEntityForName:@"BTUserData" inManagedObjectContext:context];
        
        new.year = year;
        new.month = month;
        new.day = day;
        switch (self.presentStyle) {
            case BTPresentInputWeight:
                new.weight = weight;
                break;
            case BTPresentInputFuntalHeight:
                new.fundalHeight = weight;
                break;
            case BTPresentInputGirth:
                new.girth = weight;
                break;
                
            default:
                break;
        }

     
    }
    
    [context save:&error];
    // 及时保存
    if(![context save:&error]){
        NSLog(@"%@", [error localizedDescription]);
    }
    
}

#pragma mark - 往coredata里面写入数据 此coredata是 BTUerSetting
- (void)writeToCoredataWithMamaHeight:(NSString *)height previousWeight:(NSString *)previousWeight
{
    
    
    NSManagedObjectContext *context = [BTGetData getAppContex];
    //设置查询条件
    NSError *error;
    NSArray *dataArray = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    
    if (dataArray.count == 1) {
        
        //已经有条目了
        //进行coredata的更改数据操作
        BTUserSetting* one = [dataArray objectAtIndex:0];
        one.mamHeight = height;
        one.previousWeight = previousWeight;
        
    }
    
  else if(dataArray.count == 0){
        
        //木有啊,就新建一条  进行coredata的插入数据操作
        
        NSLog(@"there no");
        
        BTUserSetting *new = [NSEntityDescription insertNewObjectForEntityForName:@"BTUserSetting" inManagedObjectContext:context];
       new.mamHeight = height;
       new.previousWeight = previousWeight;
      
        }
    
    [context save:&error];
    // 及时保存
    if(![context save:&error]){
        NSLog(@"%@", [error localizedDescription]);
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
