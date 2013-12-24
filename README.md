AddingBand
==========

##部署

###目录结构

    ti - 2541蓝牙芯片的C代码
    ios - app的obj-c代码

###开发环境

    ti - IAR：代码编辑、编译；
       - SmartRF_Flash_Programmer：下载程序到芯片里
       - 安装文件在：快盘/!!Develper/CC2541
    ios - xcode已经装好了
    
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
