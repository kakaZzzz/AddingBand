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
