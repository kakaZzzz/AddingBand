//
//  LayoutDef.h
//  AddingBand
//
//  Created by kaka' on 13-11-4.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#ifndef AddingBand_LayoutDef_h
#define AddingBand_LayoutDef_h
//整体布局数据
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

//首页头像 frame 宏定义
#define kLeftMargin 10
#define kTopMargin 10
#define kHeightMargin 50
#define kWidthMargin 60

//时间线 frame 宏定义
#define kTimeLineX (kLeftMargin + kWidthMargin + 10)
#define kTimeLineY  0
#define kTimeLineWidth  0.5
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


/*以下为同步页面连接蓝牙设备时的cell高度*/
//BTBluetoothConnectedCell的高度
#define kBluetoothConnectedHeight (kbreakConnectY + kbreakConnectHeight + 10)
//发现设备的cell的高度
#define kBluetoothFindHeight (kLastSyncTimeY + kLastSyncTimeHeight + 10)
//未发现设备的cell的高度
#define kBluetoothNotFindHeight (kBluetoothNameY + kBluetoothNameHeight + 10)


//通知中心发出得各个通知
#define UPDATACIRCULARPROGRESSNOTICE @"updateCircleProgressNotice"//更新圆形进度条通知
#define DATEPICKERDISMISSNOTICE @"datePickerDismissNotice"//时间选择器将要消失的时候的通知
#define FETALVIEWUPDATENOTICE @"fetalViewUpdate"//胎动详情页面刷新数据
#define HANDLETOSYNCNOTICE @"handleToSyncNotice"//手动同步手环通知
#define MODIFYMENSTRUATIONDATENOTICE @"modifyMenstruationDateNotice" //手动修改末次月经时间


//第一次进入首页通知 及其参数
#define FIRSTENTERNOTICE @"firstEnterNotice"//胎动详情页面刷新数据
#define FIRSTENTERNOTICE_MENSTRUAL_KEY  @"menstrual"
#define FIRSTENTERNOTICE_TODAY_KEY  @"today"

//在设置页面修改完末次月经后 发出通知的各参数
#define MODIFY_MENSTRUATION_KEY @"modifayMenstruationKey"

//App整体布局 宏
#define RED_BACKGROUND_HEIGHT 368/2


/*体征页面 布局宏定义*/
#define kPhysicalImageX 35
#define kPhysicalImageY 0
#define kPhysicalImageWidth 100
#define kPhysicalImageHeight 100


#define kSeparatorLineHeight 0.5f
//字体大小

#define FIRST_TITLE_SIZE 34/2
#define SECOND_TITLE_SIZE 28/2

//颜色转换
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0] 

/*系统所用到的颜色*/
#define kBarColor @"EE4966"
#define titleLabelColor @"333333"
#define contentLabelColor @"999999"

/**
 *  系统英文和字体所用字体
 */
#define kCharacterAndNumberFont @"STHeitiJ-Light"

#define kGlobalColor [UIColor colorWithRed:255/255.0 green:35/255.0 blue:80/255.0 alpha:1.0]
#define kBigTextColor [UIColor colorWithRed:94/255.0 green:101/255.0 blue:113/255.0 alpha:1.0]
#define kContentTextColor [UIColor colorWithRed:145/255.0 green:154/255.0 blue:170/255.0 alpha:1.0]
#define kBlueColor [UIColor colorWithRed:66/255.0 green:156/255.0 blue:239/255.0 alpha:1.0]
#define kTableViewSectionColor [UIColor colorWithRed:245/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]
#define kWhiteColor  [UIColor colorWithRed:255/255.0 green:180/255.0 blue:195/255.0 alpha:1.0]
#define kRedColor  [UIColor colorWithRed:236/255.0 green:0/255.0 blue:73/255.0 alpha:1.0]

/**
 *  全局图片名字
 */

#define kNavigationbarIcon [UIImage imageNamed:@"navigation_logo"]
//程序中各种tag值
#define BREAK_CONNECT_ALERT 100
#define TIME_OUT_ALERT 101
#define FETAL_BAR_TAG 1000
#define MAIN_BUTTON_TAG 2000

#define PHYSICAL_BUTTON_TAG 1050
//体征页面的tag值
#define PHYSICAL_CONTROL_TAG 3000

//首次输入体重，宫高，腹围等 textField的tag值
#define TEXTFIELD_TAG 500
//刷新小雨滴
#define POINT_X 40 //小雨滴距离X轴的距离
#define POINT_LARGE 12.0f //小雨滴大小
#define POINT_TOP 90 //小雨滴距离上边的距离

//RAW数据类型
#define DEVICE_FETAL_TYPE 1
#define DEVICE_SPORT_TYPE 2
#define DEVICE_START_TIME_TYPE 3

#define PHONE_FETAL_TYPE 11
#define PHONE_START_TIME_TYPE 13

//蓝牙同步 连接部分宏
#define SCAN_PERIPHERAL_TIMEOUT 10.0
#define UPDATE_PREVIOUSSYNC_TIME 5.0
#define LINkBLE_TIMEOUT 40.0

#define LASTSYNC_TEXT @"上次同步"
//修改设置日期的宏  生日 预产期 末次月经时间
#define MODIFY_BIRTHDAY_TYPE 1//生日
#define MODIFY_DUEDATE_TYPE 3//预产期
#define MODIFY_MENSTRUATION_TYPE 2//末次月经时间


//
#define ANTENATEL_DATE @"antenatelDate"
#define FUNDAL_HEIGHT @"fundalHeight"
#define MAMA_GIRTH @"girth"
#define MAMA_WEIGHT @"weight"

#define FUNDAL_HEIGHT_CONDITION @"fundalHeightCondition"
#define MAMA_GIRTH_CONDITION @"girthCondition"
#define MAMA_WEIGHT_CONDITION @"weightCondition"

#define ON_LIMIT @"onLimit"
#define OFF_LIMIT @"offLimit"

//网络接口
#define HTTP_HEADER @"http://www.addinghome.com"
#define HTTP_HOSTNAME @"addinghome.com"

//友盟统计
#define UMAPP_KEY @"52b7fae256240bd52f18fdd2"

/**
 *  首次进入程序 和 首次进入首页
 */

#define EVER_LAUNCHED @"everLaunched"
#define FIRST_LAUNCHED @"firstLaunch"
#define EVER_APPEAR @"everAppear"
#define FIRST_APPEAR @"firstAppear"

#endif
