//
//  BTWeightViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-3.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTWeightViewController.h"
#import "FYChartView.h"
#import "BTPhysicalModel.h"
#import "LayoutDef.h"
#import "BTView.h"
#import "BTSheetPickerview.h"
#import "BTGetData.h"
#import "NSDate+DateHelper.h"
#import "BTUtils.h"
#import "BTUserData.h"
#import "IQKeyBoardManager.h"//键盘管理类
#import "BTPresentInputViewController.h"//模态输入页面
#import "BTNavicationController.h"
#import "BTUserSetting.h"

@interface BTWeightViewController ()<FYChartViewDataSource>
@property(nonatomic,strong) UIScrollView *chartScrollView;
@property (nonatomic, retain) FYChartView *chartView;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property(nonatomic,strong)UILabel *heightLabel;
@property(nonatomic,strong)UILabel *previousWeightLabel;
@property(nonatomic,strong)UILabel *recreaseLabel;
@property(nonatomic,strong)NSArray *onLimit;
@end

#define ARC4RANDOM_MAX  0x100000000
@implementation BTWeightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //创建 IQKeyBoardManager的实例对象
        [IQKeyBoardManager installKeyboardManager];
        //注册通知 监控键盘的状态
        [IQKeyBoardManager enableKeyboardManger];

    }
    return self;
}
- (void)dealloc
{
    [IQKeyBoardManager disableKeyboardManager];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"体重";
    self.scrollView.scrollEnabled = NO;
    
    self.chartScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, RED_BACKGROUND_HEIGHT)];
    _chartScrollView.contentSize = CGSizeMake(1200, 200);
    _chartScrollView.scrollEnabled = NO;
    _chartScrollView.backgroundColor = [UIColor greenColor];
    [self.scrollView addSubview:_chartScrollView];
    
    //配置数据
    self.onLimit = [self getOnLimetArray];
    self.values = [NSMutableArray arrayWithCapacity:1];
    
    self.values = [NSMutableArray arrayWithArray:[self configureDrawCharValue]];
    [self drawLineChartViewWithModelArray:self.values onLimit:_onLimit];
    
    if ([self.values count] == 0) {
        [self performSelector:@selector(presentInputView) withObject:nil afterDelay:1.0];//延迟1秒模态出页面
    }
    
    //
    //体重
    BTView *weightView = [[BTView alloc] initWithFrame:CGRectMake(0, _chartScrollView.frame.origin.y + _chartScrollView.frame.size.height, 320, 112/2)];
    weightView.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:weightView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(weightView.frame.origin.x + 36/2, 10, 80, 30)];
    titleLabel.textColor =kBigTextColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
    titleLabel.text = @"目前体重:";
    [weightView addSubview:titleLabel];
    
    self.weightField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width, titleLabel.frame.origin.y, 170, 30)];
    _weightField.textColor = kContentTextColor;
    _weightField.backgroundColor = [UIColor clearColor];
    _weightField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _weightField.keyboardType = UIKeyboardTypeDecimalPad;
    _weightField.returnKeyType = UIReturnKeyDone;
    _weightField.delegate = self;
    [[IQKeyBoardManager installKeyboardManager] setScrollView:self.scrollView];//监听键盘通知 改变scrollview的偏移量
    _weightField.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _weightField.text = [self getWeight];
    [weightView addSubview:_weightField];

    UILabel *kiloLabel = [[UILabel alloc] initWithFrame:CGRectMake(_weightField.frame.origin.x + _weightField.frame.size.width - 30, _weightField.frame.origin.y, 30, 30)];
    kiloLabel.textColor = kBigTextColor;
    kiloLabel.backgroundColor = [UIColor clearColor];
    kiloLabel.textAlignment = NSTextAlignmentLeft;
    kiloLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    kiloLabel.text = @"kg";
    [weightView addSubview:kiloLabel];

    
    //修改按钮
    UIButton *modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [modifyButton setTitle:@"修改" forState:UIControlStateNormal];
    modifyButton.backgroundColor = [UIColor redColor];
    [modifyButton addTarget:self action:@selector(modifyData:) forControlEvents:UIControlEventTouchUpInside];
    modifyButton.frame = CGRectMake(320 - 10 - 40, (weightView.frame.size.height - 40)/2, 40, 40);
    [weightView addSubview:modifyButton];

    //体重情况
    
    BTView *weightConditionView = [[BTView alloc] initWithFrame:CGRectMake(0, weightView.frame.origin.y + weightView.frame.size.height, 320, 170/2)];
    weightConditionView.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:weightConditionView];
    
    self.heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(weightView.frame.origin.x + 36/2, 36/2, 100, 15)];
    _heightLabel.textColor = kContentTextColor;
    _heightLabel.backgroundColor = [UIColor clearColor];
    _heightLabel.textAlignment = NSTextAlignmentLeft;
    _heightLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _heightLabel.text = [self getHeight];
    [weightConditionView addSubview:_heightLabel];
    
    self.previousWeightLabel = [[UILabel alloc] initWithFrame:CGRectMake(_heightLabel.frame.origin.x, _heightLabel.frame.origin.y + _heightLabel.frame.size.height + 1, 170, 15)];
    _previousWeightLabel.textColor = kContentTextColor;
    _previousWeightLabel.backgroundColor = [UIColor clearColor];
    _previousWeightLabel.textAlignment = NSTextAlignmentLeft;
    _previousWeightLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _previousWeightLabel.text = [self getPreviousWeight];
    [weightConditionView addSubview:_previousWeightLabel];
    
    self.recreaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(_heightLabel.frame.origin.x, _previousWeightLabel.frame.origin.y + _previousWeightLabel.frame.size.height + 1, 200, 15)];
    _recreaseLabel.textColor = kContentTextColor;
    _recreaseLabel.backgroundColor = [UIColor clearColor];
    _recreaseLabel.textAlignment = NSTextAlignmentLeft;
    _recreaseLabel.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _recreaseLabel.text = [self getIncreaseWeight:nil];
    [weightConditionView addSubview:_recreaseLabel];

    
    self.weightConditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 10 - weightConditionView.frame.size.height, 0, weightConditionView.frame.size.height, weightConditionView.frame.size.height)];
    _weightConditionLabel.textColor = kContentTextColor;
    _weightConditionLabel.backgroundColor = [UIColor clearColor];
    _weightConditionLabel.textAlignment = NSTextAlignmentLeft;
    _weightConditionLabel.font = [UIFont systemFontOfSize:40];
    [self updateConditionLabel:nil];
    [weightConditionView addSubview:_weightConditionLabel];

    
 	// Do any additional setup after loading the view.
}
#pragma mark - 如果是第一次进入此页面 木有数据 模态出输入数据页面
- (void)presentInputView
{
    BTPresentInputViewController *presentVC = [[BTPresentInputViewController alloc]
                                               initWithPresentInputTypeStyle:BTPresentInputWeight
                                               Complete:^(NSString *str1, NSString *str2, NSString *str3)
                                                         {
                                                         [self updateUIWithCurrentWeight:str1 withHeight:str2 withPreviousWeight:str3];
                                                        }];
    self.nav = [[BTNavicationController alloc] initWithRootViewController:presentVC];
    presentVC.navigationItem.title = @"填写体重";
    [self presentViewController:_nav animated:YES completion:nil];
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
    
    NSLog(@"====+++++++++%@",textField.text);
    
    [self updateUIWithValue:textField.text];
    [self writeToCoredataWithWeight:textField.text];
    

    return YES;
}
#pragma mark - event
- (void)modifyData:(UIButton *)btn
{
    [_weightField becomeFirstResponder];
 
}


#pragma mark - 更新页面UI
- (void)updateUIWithValue:(NSString *)weight
{
    //更新折线图和页面显示
    //1）更新折线
    [self.chartView removeFromSuperview];
    //改变self.values 的值即可
    
    NSDate *localDate = [NSDate localdate];
    NSNumber *minute = [BTUtils getMinutes:localDate];
    BTPhysicalModel *model = [[BTPhysicalModel alloc] initWithTitle:@"体重" content:weight day:[NSString stringWithFormat:@"%@",minute]];
    [self.values addObject:model];
    self.onLimit = [self getOnLimetArray];
    [self drawLineChartViewWithModelArray:self.values onLimit:self.onLimit];
    
    //2)更新"目前体重 显示"
    self.weightField.text = weight;
    //3)更新"正常 异常显示"
    [self updateConditionLabel:weight];
    //4)更新 体重增长label
    self.recreaseLabel.text = [self getIncreaseWeight:weight];
    
}
#pragma mark - 判断体重是否正常
- (void)updateConditionLabel:(NSString *)weight
{
    //正常或者不正常 与上线值相比较
    float now = 0.0;
    if (weight) {
        now = [weight floatValue];
    }
   
    else
    {
      now = [[self getWeight] floatValue];
    }
    BTPhysicalModel *modelLimit = [self.onLimit objectAtIndex:0];
    float limit = [modelLimit.content floatValue];
    if (now > limit) {
        self.weightConditionLabel.text = @"异常";
        self.weightConditionLabel.textColor = kGlobalColor;
    }
    else{
        self.weightConditionLabel.text = @"正常";
        self.weightConditionLabel.textColor = kBigTextColor;

    }
}
#pragma mark - 首次输入数据后的回调方法
- (void)updateUIWithCurrentWeight:(NSString *)weight withHeight:(NSString *)height withPreviousWeight:(NSString *)previousWeight
{
    //更新折线图和页面显示
    //1）更新折线
    [self.chartView removeFromSuperview];
    //改变self.values 的值即可
    
    NSDate *localDate = [NSDate localdate];
    NSNumber *minute = [BTUtils getMinutes:localDate];
    BTPhysicalModel *model = [[BTPhysicalModel alloc] initWithTitle:@"体重" content:weight day:[NSString stringWithFormat:@"%@",minute]];
    [self.values addObject:model];
    self.onLimit = [self getOnLimetArray];
    [self drawLineChartViewWithModelArray:self.values onLimit:self.onLimit];
    
    //2)更新"正常 异常显示"
    self.weightField.text = weight;
    self.heightLabel.text = [NSString stringWithFormat:@"身高: %@cm",height];
    self.previousWeightLabel.text = [NSString stringWithFormat:@"孕前体重: %@kg",previousWeight];
    int recrease = [weight intValue] - [previousWeight intValue];
    self.recreaseLabel.text = [NSString stringWithFormat:@"目前比孕前体重增长: %dkg",recrease];
}


#pragma mark - 往coredata里面写入数据
- (void)writeToCoredataWithWeight:(NSString *)weight
{
    
    NSDate *localDate = [NSDate localdate];
    NSNumber *year = [BTUtils getYear:localDate];
    NSNumber *month = [BTUtils getMonth:localDate];
    NSNumber *day = [BTUtils getDay:localDate];
    NSNumber *minute = [BTUtils getMinutes:localDate];
    _context = [BTGetData getAppContex];
    //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@ AND minute == %@",year, month, day,minute];
    NSError *error;
    NSArray *dataArray = [BTGetData getFromCoreDataWithPredicate:predicate entityName:@"BTUserData" sortKey:nil];
    
    if (dataArray.count == 1) {
        
        //已经有条目了
        //进行coredata的更改数据操作
        BTUserData* one = [dataArray objectAtIndex:0];
        one.weight = weight;
       

       }else if(dataArray.count == 0){
        
        //木有啊,就新建一条  进行coredata的插入数据操作
        
        NSLog(@"there no");
        
        BTUserData* new = [NSEntityDescription insertNewObjectForEntityForName:@"BTUserData" inManagedObjectContext:_context];
        
        new.year = year;
        new.month = month;
        new.day = day;
        new.weight = weight;
        new.minute = minute;
    }
    
    [_context save:&error];
    // 及时保存
    if(![_context save:&error]){
        NSLog(@"%@", [error localizedDescription]);
    }
    
}
#pragma mark - 得到绘制折线用的数据
- (NSArray *)configureDrawCharValue
{
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    NSArray *array = [self getNewdataFromCoredata];
    for (BTUserData *one in array) {
        NSLog(@"数据数组是%@",one.minute);
        BTPhysicalModel *model = [[BTPhysicalModel alloc] initWithTitle:@"体重" content:one.weight day:[NSString stringWithFormat:@"%@",one.minute]];
        [resultArray addObject:model];

    }
    
    
    return resultArray;
  
}
#pragma mark - 从coredata 里面取出目前体重的数组
- (NSArray *)getNewdataFromCoredata
{
    NSMutableArray *weightArray = [NSMutableArray arrayWithCapacity:1];
    
    NSDictionary *sortDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"minute",@"sortkey1", nil];
    NSArray *dataArray = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserData" sortKey:sortDic];
   
    
    if (dataArray.count > 0) {
        for (BTUserData *userData in dataArray) {
            if (userData.weight) {
                [weightArray addObject:userData];
            }
        }
        return weightArray;
      }
    
    
    return nil;
}
#pragma mark - 得到目前体重
- (NSString *)getWeight
{
    
    NSArray *dataArray = [self getNewdataFromCoredata];
    if (dataArray.count > 0) {
        BTUserData * one = [dataArray lastObject];
        
        return one.weight;
     
    }
    
    
    return [NSString stringWithFormat:@"%@",@"还未记录"];


}
#pragma mark - 得到身高
- (NSString *)getHeight
{
    
    NSArray *dataArray = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    
    if (dataArray.count > 0) {
        BTUserSetting *one = [dataArray lastObject];
        if (one.mamHeight) {
            return [NSString stringWithFormat:@"身高: %@cm",one.mamHeight];

        }
        
    }
    
    return [NSString stringWithFormat:@"身高: %@",@"还未记录"];
    
}
#pragma mark - 孕前体重
- (NSString *)getPreviousWeight
{
    
    NSArray *dataArray = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    
    if (dataArray.count > 0) {
        BTUserSetting *one = [dataArray lastObject];
        if (one.previousWeight) {
            return [NSString stringWithFormat:@"孕前体重: %@kg",one.previousWeight];
        }
       
    }
    
    return [NSString stringWithFormat:@"孕前体重: %@",@"还未记录"];
    
}
#pragma mark - 体重增长
- (NSString *)getIncreaseWeight:(NSString *)weight
{
    
    float a = 0;
    float b = 0;
    if (weight) {
      b = [weight floatValue];
    }
    else{
        
    NSString *weight1 = [self getWeight];
    b = [weight1 floatValue];

    }
    NSArray *dataArray = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    if (dataArray.count > 0) {
        BTUserSetting *one = [dataArray lastObject];
        a = [one.previousWeight floatValue];
    }
    
     return [NSString stringWithFormat:@"目前比孕前体重增长: %.1fkg",(b - a)];
    
}
#pragma mark - 获得上线数组
- (NSArray *)getOnLimetArray
{
    NSArray *dataArray = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    NSArray *array;
    if (dataArray.count > 0) {
        BTUserSetting *one = [dataArray lastObject];
        if (one.mamHeight && one.previousWeight) {
            
            float a = [one.previousWeight floatValue];
            float b = [one.mamHeight intValue]/100;
            float c = a/(b * b);
            if (c < 18.5) {
            //配置数据
            NSString *content = [NSString stringWithFormat:@"%0.1f",(a+15)];
            BTPhysicalModel *model1 = [[BTPhysicalModel alloc] initWithTitle:@"体重" content:content day:@"1"];
            BTPhysicalModel *model2 = [[BTPhysicalModel alloc] initWithTitle:@"体重" content:content day:@"280"];
            array = [NSArray arrayWithObjects:model1,model2, nil];
            return array;
            }
            else if(c > 23.9)
            {
                NSString *content = [NSString stringWithFormat:@"%0.1f",(a+10)];
                BTPhysicalModel *model1 = [[BTPhysicalModel alloc] initWithTitle:@"体重" content:content day:@"1"];
                BTPhysicalModel *model2 = [[BTPhysicalModel alloc] initWithTitle:@"体重" content:content day:@"280"];
                array = [NSArray arrayWithObjects:model1,model2, nil];
                return array;

            }
            else{
                NSString *content = [NSString stringWithFormat:@"%0.1f",(a+12)];
                BTPhysicalModel *model1 = [[BTPhysicalModel alloc] initWithTitle:@"体重" content:content day:@"1"];
                BTPhysicalModel *model2 = [[BTPhysicalModel alloc] initWithTitle:@"体重" content:content day:@"280"];
                array = [NSArray arrayWithObjects:model1,model2, nil];
                return array;

            }
    }
        
    }
         return nil;
}
#pragma mark - 绘制折线图
- (void)drawLineChartViewWithModelArray:(NSArray *)array onLimit:(NSArray *)onLimit
{
    
    
    self.chartView = [[FYChartView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1200.0f, RED_BACKGROUND_HEIGHT)];
    self.chartView.hideDescriptionViewWhenTouchesEnd = YES;
    self.chartView.backgroundColor = kGlobalColor;
    self.chartView.rectangleLineColor = [UIColor grayColor];
    self.chartView.lineColor = [UIColor whiteColor];
    self.chartView.dataSource = self;
    self.chartView.style = BTChartWeight;
    self.chartView.onLimit = onLimit;//上限
    self.chartView.modelArray = array;
    //在图标上添加手势 取消键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    [self.chartView addGestureRecognizer:tap];
    [self.chartScrollView addSubview:self.chartView];

    
    
   
}
#pragma mark - 关闭键盘
- (void)closeKeyboard:(UITapGestureRecognizer *)tap
{
    [self updateUIWithValue:_weightField.text];
    [self writeToCoredataWithWeight:_weightField.text];
    [_weightField resignFirstResponder];
}
#pragma mark - FYChartViewDataSource

//number of value count
- (NSInteger)numberOfValueItemCountInChartView:(FYChartView *)chartView;
{
    //return self.values ? self.values.count : 0;
    return 20;
}


//horizontal title alignment at index
- (HorizontalTitleAlignment)chartView:(FYChartView *)chartView horizontalTitleAlignmentAtIndex:(NSInteger)index
{
    HorizontalTitleAlignment alignment = HorizontalTitleAlignmentCenter;
    if (index == 0)
    {
        alignment = HorizontalTitleAlignmentCenter;
    }
    else if (index == self.values.count - 1)
    {
        alignment = HorizontalTitleAlignmentRight;
    }
    
    return alignment;
}

//description view at index
- (UIView *)chartView:(FYChartView *)chartView descriptionViewAtIndex:(NSInteger)index model:(BTPhysicalModel *)model
{
    
    
    //显示第几周第几周第几天 体重
    int week = [model.day intValue]%7 == 0  ? [model.day intValue]/7 : ([model.day intValue]/7 + 1);
    int day = [model.day intValue]%7 == 0 ? 7 : [model.day intValue]%7;
    
    //如何根据 index找到model
    NSString *description = [NSString stringWithFormat:@"孕%d周%d天\n %0.1fkg", week,day,[model.content floatValue]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"markview_ba_middle"]];
    imageView.frame = CGRectMake(0,0, 91/2, 85/2);
   // imageView.backgroundColor = [UIColor redColor];
    CGRect frame = imageView.frame;
    frame.size = CGSizeMake(80.0f, 40.0f);
    imageView.frame = frame;
    UILabel *label = [[UILabel alloc]
                       initWithFrame:CGRectMake(10.0f, -5.0f, imageView.frame.size.width, imageView.frame.size.height)];
  
    label.backgroundColor = [UIColor clearColor];
    label.textColor = kGlobalColor;
    label.text = description;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:10.0f];
    [imageView addSubview:label];
    
    return imageView;
    
    //  return nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
