//
//  BTBluetoothFindCell.m
//  AddingBand
//
//  Created by kaka' on 13-11-7.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBluetoothFindCell.h"
#import "LayoutDef.h"
@implementation BTBluetoothFindCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)initSubControls

{
    
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tatget:(id)target
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.toConnect =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        _toConnect.frame = CGRectMake(kLastSyncTimeX, kLastSyncTimeY, kLastSyncTimeWidth, kLastSyncTimeHeight);
        [_toConnect setTitle:@"立即连接" forState:UIControlStateNormal];
        [_toConnect addTarget:target action:@selector(toConnect:event:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_toConnect];
        
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
