AddingBand
==========

##部署

###目录结构

    ti - 2541蓝牙芯片的C代码
       - 工程文件：ti\Projects\ble\Health\CC2541DB\SimpleBLEPeripheral.eww
    ios - app的obj-c代码
        - 工程文件：ios\AddingBand.xcodeproj

###开发环境

    ti - IAR：代码编辑、编译
       - SmartRF_Flash_Programmer：下载程序到芯片里
       - ble_Stack_1.3.2：蓝牙协议栈，包括库、驱动、示例代码等
       
       - 安装文件在：快盘/!!Develper/CC2541
       
       - 调试方法：
         1. IAR打开工程文件，左侧workspace里右键点击根节点选“Rebuild All”
         2. 调试点右上角绿色按钮“Download And Debug”
         3. 下载打开SmartRF_Flash_Programmer，“flash image”选ti\Projects\ble\Health\CC2541DB\CC2541\Exe\SimpleBLEPeripheral.hex，然后点“Perform actions”。
       
    ios - xcode已经装好了
    
        - 调试方法：
        1. 连上设备，左上角三角、方块按钮右边，选择到自己的设备名（下面是模拟器）
        2. 点三角就下载并调试了，中间可能需要输入apple开发者账号信息：
           账号：isodev@addinghome.com
           密码：Batone520
    
##程序结构

###CC2541

####主要文件

平时开发就主要在改这些文件

    ti\Projects\ble\Health\Source
    - OSAL_SimpleBLEPeripheral.c：系统层初始化
    - simpleBLEPeripheral.c：主要逻辑都在这里
    - simpleBLEPeripheral.h：上面的头文件
    - SimpleBLEPeripheral_Main.c：程序入口
    
    ti\Projects\ble\Profiles\Health
    - health_profile.c：蓝牙特征初始化、读、写各种操作
    - health_profile.h：定义蓝牙特征的UUID
    
    ti\Components\hal\target\CC2540EB
    - hal_key.c：处理按键输入逻辑，包括电容按键
    
    ti\Components\hal\target\CC2541ST
    - hal_i2c.c：封装I2C底层操作
    
####特征和服务

特征（Characteristic）是最基础的元素，相当于具体变量，可以对它进行读、写、通知操作  
服务（Service）是聚合n个特征的集合，服务可以套服务，但不能进行各种操作
    
具体特征含义：
    
    #define HEALTH_SERV_UUID              0x2300    //主要功能服务
    #define HEALTH_SYNC_UUID              0x2301    //发起同步标志
    #define HEALTH_CLOCK_UUID             0x2302    //现在时间的偏移量
    #define HEALTH_DATA_HEADER_UUID       0x2303    //待同步数据的总长度
    #define HEALTH_DATA_BODY_UUID         0x2304    //具体一条待同步数据
    
    #define BATT_SERVICE_UUID             0x180F    //Battery Service
    #define BATT_LEVEL_UUID               0x2A19    //Battery Level
    
对特征的初始化定义在health_profile.c文件中，例如：

    static uint8 healthSyncProps = GATT_PROP_READ | GATT_PROP_NOTIFY | GATT_PROP_WRITE;
    static uint8 healthSync[8] = {0,0,0,0,0,0,0,0};                                         // uint8*8
    static gattCharCfg_t healthSyncConfig[GATT_MAX_NUM_CONN];                               // used for notify
    static uint8 healthSyncUserDesp[17] = "Do Sync\0";

通知（Notify）的作用是：读、写操作都是主机（Central）发起对周边（Peripheral）里的特征进行操作，通知则是周边自己对特征进行修改后主动告知主机

####记录胎动

    1. 长按电容屏（详见simpleBLEPeripheral_ProcessOSALMsg）
    2. 记下时间戳，存在缓存或eepROM里（详见eepromWrite）
    
####记录胎动1小时开始时间

    1. 三击电容屏（详见simpleBLEPeripheral_ProcessOSALMsg）
    2. 记下时间戳，存在缓存或eepROM里（详见eepromWrite）
    3. app里处理胎动1小时记录的展示（计算在1小时范围内胎动的总数）
    
####运动量

    1. 加速计设为fifo模式（详见accInit）
    2. 每2.5s读取一次数据，读出数据后调用accGetAccData进行数据处理，算法见“走路识别算法说明文档”
    3. 每检测到一次走路行为，调用eepromWrite储存

####设备和app交互程序流程

主机：指手机App  
周边：指手环设备

    1. 周边进行初始化操作，发起广播
    2. 主机扫描到设备后，手动或自动尝试连接
    3. 主机和周边连接成功后，主机先发现所有服务，再发现指定服务里所有的特征
    4. 主机对特征2A19、2301、2303、2304注册通知的回调，在注册成功的回调里，读取2A19电量
    5. 主机写入2302，当前时刻距离2001-1-1的秒数，周边收到后初始化自己的时间
    6. 主机对2301写入同步密钥（22），发起同步
    7. 周边收到同步密钥后，修改2303通知给主机，所有数据的总长度（多少个uint8）
    8. 周边每100ms发送1个uint8的数据片段，通过修改2304来通知给主机
    9. 主机收到所有数据后，断开连接，等待下一次自动同步
    
####函数的作用

    SimpleBLEPeripheral_Init：函数入口，初始化广播参数、io、加速计，读取eeprOM里保存的数据下标，然后发起SBP_START_DEVICE_EVT事件，让设备开始工作
    SimpleBLEPeripheral_ProcessEvent：所有通过osal_set_event、osal_start_timerEx发起的事件，都在这个函数里处理
    simpleBLEPeripheral_ProcessOSALMsg：处理按键事件
    peripheralStateNotificationCB：蓝牙广播状态发生改变时的回调
    battCB：注册电量通知后的回调
    battPeriodicTask：检测电池电量的周期函数
    performPeriodicTask：目前没用
    simpleProfileChangeCB：特征值被app改变后的回调
    closeAllPIO：关闭所有io
    toggleLEDWithTime：传入参数，开关指定的io
    blinkLED：分针的io闪烁
    time：显示时间
    cycleLED6：长按电容屏1s后，led分两侧点亮
    cycleLED12：三击后，led按顺时针点亮
    tribleTap：三击后，过400ms再点亮led
    dataLength：计算数据总数（1条长度为8byte）
    accInit：初始化加速计
    accLoop：处理加速器返回的每条数据
    accGetAccData：读取xyz三轴加速度
    eepromWrite：往eepROM里写入数据，每1m（胎动）或1h（运动量）一次
    eepromRead：从eepROM里读取数据，并通过SimpleProfile_SetParameter传到app里
    saveRawDataIndex：将数据下标存到eepROM里
    loadRawDataIndex：从eepROM里读取下标

###OAD实施

####烧录imageA

    1. 用Erase and program方式烧进去ti_utils/BIM_CC254xF256.hex
    2. 用Append and verify方式烧进去imageA.hex
    
####编译imageB

    修改oad_target.c文件中#define OAD_IMAGE_VERSION的值
    
####第一次OAD

    直接更新imageB.bin
    
####以后OAD

    1. 先更新一个最小体积的imageA.bin
    2. 这时运行的是imageA
    3. 然后再更新新的imageB
