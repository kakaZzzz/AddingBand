//
//  BTBluetoothConnectedCell.m
//  AddingBand
//
//  Created by kaka' on 13-11-7.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBluetoothConnectedCell.h"
#import "LayoutDef.h"
@implementation BTBluetoothConnectedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initSubControls];
    }
    return self;
}
- (void)initSubControls

{
    
    
    NSLog(@"cell 加载子图    ");
    //显示外部设备名字和电量
    self.lastSyncTime = [[UILabel alloc]initWithFrame:CGRectMake(kLastSyncTimeX, kLastSyncTimeY, kLastSyncTimeWidth, kLastSyncTimeHeight)];
    _lastSyncTime.backgroundColor = [UIColor blueColor];
    _lastSyncTime.font = [UIFont systemFontOfSize:15];
    _lastSyncTime.textColor = [UIColor whiteColor];
    _lastSyncTime.textAlignment = NSTextAlignmentLeft;
    _lastSyncTime.lineBreakMode = NSLineBreakByTruncatingTail;
    _lastSyncTime.numberOfLines= 0;
    [self addSubview:_lastSyncTime];
    
    //    self.testButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    _testButton.frame = CGRectMake(200, 10, 100, 50);
    //    [_testButton setTitle:@"测试按钮" forState:UIControlStateNormal];
    //
    //    [self addSubview:_testButton];
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tatget:(id)target
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubControls];
        self.toSync =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        _toSync.frame = CGRectMake(kToSyncX, kToSyncY, kToSyncWidth, kToSyncHeight);
        [_toSync setTitle:@"立即同步" forState:UIControlStateNormal];
        [_toSync addTarget:target action:@selector(toSync:event:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_toSync];
        
        self.breakConnect =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        _breakConnect.frame = CGRectMake(kbreakConnectX, kbreakConnectY, kbreakConnectWidth, kbreakConnectHeight);
        [_breakConnect setTitle:@"立即断开" forState:UIControlStateNormal];
        [_breakConnect addTarget:target action:@selector(breakConnect:event:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_breakConnect];
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
