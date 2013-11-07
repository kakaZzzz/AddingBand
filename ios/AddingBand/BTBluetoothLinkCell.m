//
//  BTBluetoothLinkCell.m
//  AddingBand
//
//  Created by kaka' on 13-11-6.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBluetoothLinkCell.h"

@implementation BTBluetoothLinkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        [self createSubControls];
    }
    return self;
}

- (void)createSubControls
{
    
    
//    //内容气泡图片
//    self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 30, self.iconImageView.frame.origin.y, kContentLabelWidth, kContentLabelHeight)];
//    _contentImageView.backgroundColor = [UIColor blueColor];
//    [self addSubview:_contentImageView];
//    
//    //内容Label
//    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageView.frame.origin.x , self.iconImageView.frame.origin.y, 100, 40)];
//    // _contentLabel.backgroundColor = [UIColor blueColor];
//    _contentLabel.font = [UIFont systemFontOfSize:kContentFontSize];
//    _contentLabel.textColor = [UIColor redColor];
//    _contentLabel.textAlignment = NSTextAlignmentLeft;
//    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    _contentLabel.numberOfLines= 0;
//    [self.contentImageView addSubview:_contentLabel];
    
    self.testButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _testButton.frame = CGRectMake(200, 10, 100, 50);
    [_testButton setTitle:@"测试按钮" forState:UIControlStateNormal];
    
    [self addSubview:_testButton];
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tatget:(id)target
{
  self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.testButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        _testButton.frame = CGRectMake(200, 10, 80, 30);
        [_testButton setTitle:@"测试按钮" forState:UIControlStateNormal];
        [_testButton addTarget:target action:@selector(testButtonOut:event:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_testButton];

    }
    return self;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
