//
//  LayoutDef.h
//  AddingBand
//
//  Created by kaka' on 13-11-4.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#ifndef AddingBand_LayoutDef_h
#define AddingBand_LayoutDef_h
//首页头像 frame 宏定义
#define kLeftMargin 10
#define kTopMargin 10
#define kHeightMargin 60
#define kWidthMargin 60

//时间线 frame 宏定义
#define kTimeLineX (kLeftMargin + kWidthMargin + 10)
#define kTimeLineY  0
#define kTimeLineWidth  5
#define kTimeLineHeirht  60


//同步页面 各种控件frame 的宏定义
#define kBluetoothNameX 10
#define kBluetoothNameY 10
#define kBluetoothNameWidth 200
#define kBluetoothNameHeight 60

#define kLastSyncTimeX 80
#define kLastSyncTimeY  (kBluetoothNameY + kBluetoothNameHeight + 5)
#define kLastSyncTimeWidth  220
#define kLastSyncTimeHeight 60

#define kToSyncX kLastSyncTimeX
#define kToSyncY  (kLastSyncTimeY + kLastSyncTimeHeight + 5)
#define kToSyncWidth  200
#define kToSyncHeight 60

#define kbreakConnectX kToSyncX
#define kbreakConnectY  (kToSyncY + kToSyncHeight + 5)
#define kbreakConnectWidth  200
#define kbreakConnectHeight 60

//BTBluetoothConnectedCell的高度
#define kBluetoothConnectedHeight (kbreakConnectY + kbreakConnectHeight + 10)

//发现设备的cell的高度
#define kBluetoothFindHeight (kLastSyncTimeY + kLastSyncTimeHeight + 10)

//未发现设备的cell的高度
#define kBluetoothNotFindHeight (kBluetoothNameY + kBluetoothNameHeight + 10)
//通知中心发出得各个通知
#define UPDATACIRCULARPROGRESSNOTICE @"updateCircleProgressNotice"//更新圆形进度条通知
#endif
