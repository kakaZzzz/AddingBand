//
//  BTBluetoothLinkCell.m
//  AddingBand
//
//  Created by kaka' on 13-11-6.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBluetoothLinkCell.h"
#import "LayoutDef.h"
@implementation BTBluetoothLinkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createSubControls];
               NSLog(@"父视图  cell 加载子图    ");
           }
    return self;
}

- (void)createSubControls
{
    
 
     //显示外部设备名字和电量
    self.bluetoothName = [[UILabel alloc]initWithFrame:CGRectMake(kBluetoothNameX, kBluetoothNameY, kBluetoothNameWidth, kBluetoothNameHeight)];
     _bluetoothName.backgroundColor = [UIColor clearColor];
    _bluetoothName.font = [UIFont systemFontOfSize:20];
    _bluetoothName.textColor = [UIColor whiteColor];
    _bluetoothName.textAlignment = NSTextAlignmentLeft;
    _bluetoothName.lineBreakMode = NSLineBreakByTruncatingTail;
    _bluetoothName.numberOfLines= 0;
  //  [self addSubview:_bluetoothName];
    
//    self.testButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _testButton.frame = CGRectMake(200, 10, 100, 50);
//    [_testButton setTitle:@"测试按钮" forState:UIControlStateNormal];
//    
//    [self addSubview:_testButton];
    
}
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tatget:(id)target
//{
//  self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//        self.testButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        _testButton.frame = CGRectMake(200, 10, 80, 30);
//        [_testButton setTitle:@"测试按钮" forState:UIControlStateNormal];
//        [_testButton addTarget:target action:@selector(testButtonOut:event:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_testButton];
//
//    }
//    return self;
//    
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
