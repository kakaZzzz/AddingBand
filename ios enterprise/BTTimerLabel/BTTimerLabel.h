//
//  BTTimerLabel.h
//  Version 0.2
//  Created by MineS Chan on 2013-10-16
//  Updated 2013-12-03


// Copyright (c) 2013 peng wang

#import <UIKit/UIKit.h>


/**********************************************
 BTTimerLabel TimerType Enum
 **********************************************/
typedef enum{
    BTTimerLabelTypeStopWatch,
    BTTimerLabelTypeTimer
}BTTimerLabelType;


/**********************************************
 Delegate Methods
 @optional
 
  - timerLabel:finshedCountDownTimerWithTimeWithTime:
    ** BTTimerLabel Delegate method for finish of countdown timer

 - timerLabelCountingTo:timertype:
    ** BTTimerLabel Delegate method for monitering the current counting progress
**********************************************/
 
@class BTTimerLabel;
@protocol BTTimerLabelDelegate <NSObject>
@optional
-(void)timerLabel:(BTTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime;
-(void)timerLabel:(BTTimerLabel*)timerlabel countingTo:(NSTimeInterval)time timertype:(BTTimerLabelType)timerType;
@end




/**********************************************
 BTTimerLabel Class Defination
 **********************************************/

@interface BTTimerLabel : UILabel{
    
#if NS_BLOCKS_AVAILABLE
    void (^endedBlock)(NSTimeInterval);
#endif
    
    NSTimeInterval timeUserValue;
    
    NSDate *startCountDate;
    NSDate *pausedTime;
    
    NSDate *date1970;
    NSDate *timeToCountOff;
}

/*Delegate for finish of countdown timer */
@property (strong) id<BTTimerLabelDelegate> delegate;

/*Time format wish to display in label*/
@property (nonatomic,strong) NSString *timeFormat;

/*Target label obejct, default self if you do not initWithLabel nor set*/
@property (strong) UILabel *timeLabel;

/*Type to choose from stopwatch or timer*/
@property (assign) BTTimerLabelType timerType;

/*is The Timer Running?*/
@property (assign,readonly) BOOL counting;

/*do you reset the Timer after countdown?*/
@property (assign) BOOL resetTimerAfterFinish;


/*--------Init method to choose*/
-(id)initWithTimerType:(BTTimerLabelType)theType;
-(id)initWithLabel:(UILabel*)theLabel andTimerType:(BTTimerLabelType)theType;
-(id)initWithLabel:(UILabel*)theLabel;


/*--------Timer control method to use*/
-(void)start;
#if NS_BLOCKS_AVAILABLE
-(void)startWithEndingBlock:(void(^)(NSTimeInterval countTime))end; //use it if you are not going to use delegate
#endif
-(void)pause;
-(void)reset;

/*--------Setter methods*/
-(void)setCountDownTime:(NSTimeInterval)time;
-(void)setStopWatchTime:(NSTimeInterval)time;


@end


