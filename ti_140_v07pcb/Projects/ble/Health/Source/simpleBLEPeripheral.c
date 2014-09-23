/*********************************************************************
 * INCLUDES
 */

#include "bcomdef.h"
#include "OSAL.h"
#include "OSAL_PwrMgr.h"
#include "OSAL_Clock.h"

#include "OnBoard.h"
#include "hal_adc.h"
#include "hal_led.h"
#include "hal_key.h"

#include "hal_i2c.h"

#include "battservice.h"

#include "debug.h"

#include "gatt.h"

#include "hci.h"

#include "gapgattserver.h"
#include "gattservapp.h"
#include "devinfoservice.h"
#include "health_profile.h"

#include "peripheral.h"

#include "gapbondmgr.h"

#include "mma865x.h"

#include "simpleBLEPeripheral.h"

#if defined FEATURE_OAD
#include "oad.h"
#include "oad_target.h"
#endif
#include "mpr03x.h"

/*********************************************************************
 * MACROS
 */

/*********************************************************************
 * CONSTANTS
 */

#define FIRMWARE                              131

#define HI_UINT32(x)                          (((x) >> 16) & 0xffff)
#define LO_UINT32(x)                          ((x) & 0xffff)


#define LED0_PIO                              P1_0
#define LED1_PIO                              P1_1
#define LED2_PIO                              P1_6
#define LED3_PIO                              P1_7
#define LED4_PIO                              P2_0
#define LED5_PIO                              P2_1
#define LED6_PIO                              P0_1
#define LED7_PIO                             P0_2
#define LED8_PIO                             P0_4
#define LED9_PIO                              P0_5
#define LED10_PIO                              P0_6
#define LED11_PIO                              P0_7

#define OPEN_PIO                              0
#define CLOSE_PIO                             1
#define LED_POWER										P1_3
#define	BOOSTON										1
#define	BOOSTOFF										0

// How often to perform periodic event
//#define SBP_PERIODIC_EVT_PERIOD               200
#define SBP_PERIODIC_1s_EVT_PERIOD              1000
#define SBP_PERIODIC_60s_EVT_PERIOD             60000
#define MPR03X_CALIBRATION_EVT_1min_EVT_PERIOD  60000   
#define MPR03XCALIBRATIONCOUNT                  10
#define CLOSE_ALL_1s_EVT                      1000
     
//watchdog event

#define  WATCHDOG_CLEAR_EVT_PERIOD           900


//fetal movement record valid max time
#define  FETALMOVEMENTRECORD_MAX_EVT_PERIOD 8500


// The led all on timing, READY is the time from power on to led all on
// GO is the time from led all on to led all off
#define SBP_START_DEVICE_EVT_READY_PERIOD			 3000
//#define SBP_START_DEVICE_EVT_GO_PERIOD				 2000
#define SBP_START_DEVICE_EVT_GO_PERIOD				 1000
#define SBP_START_DEVICE_EVT_READY_500ms_PERIOD                  500

// What is the advertising interval when device is discoverable (units of 625us, 160=100ms)
#define DEFAULT_ADVERTISING_INTERVAL          3408//16000

// Limited discoverable mode advertises for 30.72s, and then stops
// General discoverable mode advertises indefinitely

#define DEFAULT_DISCOVERABLE_MODE             GAP_ADTYPE_FLAGS_GENERAL

// Minimum connection interval (units of 1.25ms, 80=100ms) if automatic parameter update request is enabled
//#define DEFAULT_DESIRED_MIN_CONN_INTERVAL     800
#define DEFAULT_DESIRED_MIN_CONN_INTERVAL     40

// Maximum connection interval (units of 1.25ms, 800=1000ms) if automatic parameter update request is enabled
//#define DEFAULT_DESIRED_MAX_CONN_INTERVAL     1200
#define DEFAULT_DESIRED_MAX_CONN_INTERVAL     60

// Slave latency to use if automatic parameter update request is enabled
#define DEFAULT_DESIRED_SLAVE_LATENCY         4

// Supervision timeout value (units of 10ms, 1000=10s) if automatic parameter update request is enabled
//#define DEFAULT_DESIRED_CONN_TIMEOUT          5000
#define DEFAULT_DESIRED_CONN_TIMEOUT          500

// Whether to enable automatic parameter update request when a connection is formed
#define DEFAULT_ENABLE_UPDATE_REQUEST         TRUE

// Connection Pause Peripheral time value (in seconds)
#define DEFAULT_CONN_PAUSE_PERIPHERAL         6

// Company Identifier: Texas Instruments Inc. (13)
#define TI_COMPANY_ID                         0x000D

#define INVALID_CONNHANDLE                    0xFFFF

// Length of bd addr as a string
#define B_ADDR_STR_LEN                        15

// Battery level is critical when it is less than this %
#define DEFAULT_BATT_CRITICAL_LEVEL           10

// Battery measurement period in ms
#define DEFAULT_BATT_PERIOD                   60000

// Battery measurement period in ms
#define DEFAULT_ACC_PERIOD                    100




// define i2c address
#define ACC_ADDRESS                           0x1D

//define registers for MMA8652FC
#define F_STATUS                    0x00
#define OUT_X_MSB                   0x01
#define OUT_X_LSB                   0x02
#define OUT_Y_MSB                   0x03
#define OUT_Y_LSB                   0x04
#define OUT_Z_MSB                   0x05
#define OUT_Z_LSB                   0x06

#define F_SETUP                     0x09
#define TRIG_CFG                    0x0A
#define SYSMOD                      0x0B
#define INT_SOURCE                  0x0C
#define WHO_AM_I                    0x0D
#define XYZ_DATA_CFG                0x0E
#define HP_FILTER_CUTOFF            0x0F

#define PL_STATUS                   0x10
#define PL_CFG                      0x11
#define PL_COUNT                    0x12
#define PL_BF_ZCOMP                 0x13
#define P_L_THS_REG                 0x14
#define FF_MT_CFG                   0x15
#define FF_MT_SRC                   0x16
#define FF_MT_THS                   0x17
#define FF_MT_COUNT                 0x18

#define TRANSIENT_CFG               0x1D
#define TRANSIENT_SRC               0x1E
#define TRANSIENT_THS               0x1F
#define TRANSIENT_COUNT             0x20

#define PULSE_CFG                   0x21
#define PULSE_SRC                   0x22
#define PULSE_THSX                  0x23
#define PULSE_THSY                  0x24
#define PULSE_THSZ                  0x25
#define PULSE_TMLT                  0x26
#define PULSE_LTCY                  0x27
#define PULSE_WIND                  0x28
#define ASLP_COUNT                  0x29
#define CTRL_REG1                   0x2A
#define CTRL_REG2                   0x2B
#define CTRL_REG3                   0x2C
#define CTRL_REG4                   0x2D
#define CTRL_REG5                   0x2E
#define OFF_X                       0x2F
#define OFF_Y                       0x30
#define OFF_Z                       0x31


#define EEPROM_ADDRESS                      0x50

//define i2c clock rate
#define I2C_CLOCK_RATE                      i2cClock_267KHZ

// define for eeprom
#define EEPROM_ADDRESS_BLOCK_SIZE           8
#define EEPROM_ADDRESS_BLOCK_COUNT          4000

#define EEPROM_ADDRESS_RESERVE_MAX          32768
#define EEPROM_ADDRESS_DATA_MAX             (EEPROM_ADDRESS_BLOCK_SIZE * EEPROM_ADDRESS_BLOCK_COUNT)

#define EEPROM_POSITION_STEP_DATA           (EEPROM_ADDRESS_DATA_MAX)

#define TAP_DATA_TYPE                       1
#define STEP_DATA_TYPE                      2
#define TAP_HOUR_START_TYPE                 3

#define DATA_TYPE_COUNT                     3
#define ADC_VREF_ADDRESS_L						0x7d64//address for low byte of actualVref
#define ADC_VREF_ADDRESS_H						0x7d65//address for high byte of actualVref
//define for touch sensor mpr
#define TOUCH_ADDRESS								  0x4A
#define TOUCH_BASELINE_DEFAULT					0
#define TOUCH_BASELINE_EVERYTIME					1
#define TOUCH_BASELINE_MODE						TOUCH_BASELINE_DEFAULT
//same with app
#define SYNC_CODE                           22

//#define LONG_PRESS_INTERVAL                 1000
#define LONG_PRESS_INTERVAL                 1500 //v123
#define NEXT_TAP_INTERVAL                   500
#define ACC_LOAD_INTERVAL                   2500    // 80MS * 30
#define CYCLE_LED_6_INTERVAL                80
#define CYCLE_LED_12_INTERVAL               60
#define TRIBLE_TAP_INTERVAL                 400
#define BLINK_LED_INTERVAL                  500
#define TIME_DISPLAY_INTERVAL               3000
#define READ_INTERVAL                       100

#define ACC_STATIC_COUNT_MAX                24  //24*2.5S = 60S 


#define ALT_MIN_DEFAULT                     300
//#define AUTO_CONFIG		TRUE
//#define MANUFACTURE_TEST	TRUE

#define SLIDE_MEAN_WIDTH	4
#define X_AXIS				0
#define Y_AXIS				1
#define Z_AXIS				2
#define DATA_SEG_CNT			32
#define DATA_A_CNT_MAX		DATA_SEG_CNT
#define DATA_BA_CNT_MAX		DATA_SEG_CNT*2
#define DATA_B_CNT_MAX		DATA_SEG_CNT//*2
#define MMA_FIFO_DEEPTH		DATA_SEG_CNT*6
#define ACC_DEBOUNCE		15//400
#define ACC_MIN_STEP_INTERVAL	4
#define ACC_MAX_STEP_INTERVAL	15
#define MMA_DATA_STRUCT_LEGNTH		6
#define MMA_DEBUG_SIMULATION	FALSE
#define MMA_DEBUG_DATA_MODEL	4
#define ACC_LAST_VALLEY_SUF_DEFAULT  	0
#define RUNK		3
#define COUNT_ONE	1
#define DONOT_COUNT_ONE	2
#define ACC_RUN_COUNT_MODE		COUNT_ONE
#define ACC_POPUP_DATA_BLE		TRUE
//#define ACC_POPUP_DATA_BLE		FALSE

#define ADVERCOUNT 60  //9*900ms = 54S

#define  WdctlModeWdog 0x02
#define  WdctlModeIdle 0x0
#define  WdctlClrFirst  0x0a
#define  WdctlClrSec  0x05
#define  WdctlInt  0x00

uint8 X0, X1, Y0, Y1, Z1, Z0;
int16 X_out, Y_out, Z_out;
uint8 INT_STATUS;

int16 PACE_DUR_MIN = 2; //0.16s
int16 PACE_DUR_MAX = 12; //1s
int16 ALT_MIN = ALT_MIN_DEFAULT;
int16 DIR = 1; //12
int16 first_pace = 1; //
int16 pace_count = 0; //
int16 PACE_PEAK = 0;
int16 PACE_BOTTOM = 0;
int16 time_count = 0;
int16 cross_count = 0; //0
int16 ACC_CUR = 0;
uint16 led_status=0x00;//BIT11~BIT0 represent LED11~LED0 status, 1-on, 0-off

uint16 VALID_STEP_CONUT = 0, TIME_LINE = 0, B_INTERVAL = 0;
int16 B1 = 0, B2 = 0, PEAK = 0;

uint8 mmaDataACnt=0;
uint8 mmaDataBACnt=0;
uint8 mmaDataBCnt=0;
uint8 dataAtxbufCnt=0;
uint8 dataAtxbufpointer=0;
uint8 flagTxAccData=FALSE;
uint8 flagAccData221=FALSE;
uint8 activeAccAction = TRUE;

union mma_data_u
{
//	int32	int32data;
	int16	int16data;
	uint8	u8data[2];	
};
typedef struct
{
	union mma_data_u mmaAxis[3];
}mma_data_t;

mma_data_t mmaDataA[DATA_A_CNT_MAX];
mma_data_t mmaDataA_txbuf[DATA_A_CNT_MAX];
//mma_data_t mmaDataBA[DATA_BA_CNT_MAX];
//mma_data_t mmaDataBA_diff[DATA_BA_CNT_MAX];
//mma_data_t mmaDataB[DATA_B_CNT_MAX];

uint8 mmaCurSmoothestAxis=X_AXIS, mmaLastSmoothestAxis=X_AXIS;
uint8 accRunCnt_txbuf=0;
uint8 accRunCntAy[4]={0,0,0,0};
uint8 accRunCntValid=0;
uint8 accRunCntAyDebugCnt;
uint8 accRunK1=0;

//***************************adding Bernie.hou
#define FilterCofdepth		11
#define DetectWindowWith     20
#define timeWindowCountMax 25
#define timeWindowCountMin  2
#define XyzAxisAbsdataAvgTH 2000000//500
#define DYNAMIC_PRECISE 100000//50
#define XyzAxisAbsdataDiffTH 16777216 //1g
uint8 filterCof[6] =  {14,31,74,127,170,186};
union mma_data_int32
{
	int32	int32data;
};
typedef struct
{
	union mma_data_int32 mmaAxis[2];
}mma_data_type;

mma_data_type mmaDataFilter[DATA_A_CNT_MAX];
mma_data_type mmaDataFilterTemp[DATA_A_CNT_MAX+FilterCofdepth-1];
mma_data_type mmaDataFilterPredata[FilterCofdepth-1] = {0,0,0,0,0,0,0,0,0,0};
//uint32 xyzAxisAbsdata[DATA_A_CNT_MAX];
uint32 xyzAxisAbsdataNew[DATA_A_CNT_MAX];
uint32 xyzAxisAbsdataOld[DATA_A_CNT_MAX];
uint32 xyzAxisAbsdataAvg[2];
uint32 xyzAxisAbsdataAvgPre = 0;
uint32 xyzAxisAbsdataDiff[2];
uint8 countPeriod = 0;
uint8 stepCount[4]={0,0,0,0};
uint8 stepCountTotal;
uint8 timeWindowCount = 0;
uint8 count0 = 0;
uint8 count1 = 0;
uint8 count2 = 0;
uint8 count3 = 0;
uint8 SilentCountPeriod = 0;
uint8 SilentCount = 0;
uint8 battADword = 153;
uint8 battMeasure( void );
uint8 countAdcSample = FALSE;
uint8 mpr03xCalCount;
uint8 mpr03xCalReadState = TRUE;
uint8 mpr03xCalDatePos = 0xCA;
uint8 mpr03xCalDateCur = 0xCA;
uint8 adverCount = ADVERCOUNT;
uint8 longPressJudgeFlag = 0; //v123
uint8 battMeasureCount = 0;
uint16 battADwordSum = 0;
uint8 battADwordMin = 153;
uint8 battADwordMax = 0;
uint8 battADwordTemp = 0;
/*********************************************************************
 * TYPEDEFS
 */

/*********************************************************************
 * GLOBAL VARIABLES
 */

/*********************************************************************
 * EXTERNAL VARIABLES
 */

/*********************************************************************
 * EXTERNAL FUNCTIONS
 */

/*********************************************************************
 * LOCAL VARIABLES
 */
static uint8 simpleBLEPeripheral_TaskID;   // Task ID for internal task/event processing

static gaprole_States_t gapProfileState = GAPROLE_INIT;

int8 timezone = 0;
//int8 sysnonactive = FALSE;
int8 sysnonactive = TRUE;

// GAP - SCAN RSP data (max size = 31 bytes)
uint8 scanRspData[] =
{
    // complete name
    0x0a,   // length of this data, p.s. contain header and body
    GAP_ADTYPE_LOCAL_NAME_COMPLETE,
    'L',
    '1',
    '-',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    // connection interval range
    0x05,   // length of this data
    GAP_ADTYPE_SLAVE_CONN_INTERVAL_RANGE,
    LO_UINT16( DEFAULT_DESIRED_MIN_CONN_INTERVAL ),
    HI_UINT16( DEFAULT_DESIRED_MIN_CONN_INTERVAL ),
    LO_UINT16( DEFAULT_DESIRED_MAX_CONN_INTERVAL ),
    HI_UINT16( DEFAULT_DESIRED_MAX_CONN_INTERVAL ),

    // Tx power level
    0x02,   // length of this data
    GAP_ADTYPE_POWER_LEVEL,
    0       // 0dBm
};

// GAP - Advertisement data (max size = 31 bytes, though this is
// best kept short to conserve power while advertisting)
static uint8 advertData[] =
{
    // Flags; this sets the device to use limited discoverable
    // mode (advertises for 30 seconds at a time) instead of general
    // discoverable mode (advertises indefinitely)
    0x02,   // length of this data
    GAP_ADTYPE_FLAGS,
    DEFAULT_DISCOVERABLE_MODE | GAP_ADTYPE_FLAGS_BREDR_NOT_SUPPORTED,

    // service UUID, to notify central devices what services are included
    // in this peripheral
    
    
    #if defined FEATURE_OAD
    0x07,   // length of this data
    #else
    0x05,
    #endif
    
    GAP_ADTYPE_16BIT_MORE,      // some of the UUID's, but not all
    LO_UINT16( HEALTH_SERV_UUID ),
    HI_UINT16( HEALTH_SERV_UUID ),
    LO_UINT16(BATT_SERVICE_UUID),
    HI_UINT16(BATT_SERVICE_UUID)
      
    #if defined FEATURE_OAD
    ,
    LO_UINT16(OAD_SERVICE_UUID),
    HI_UINT16(OAD_SERVICE_UUID)
    #endif

};

// GAP GATT Attributes
//uint8 attDeviceName[GAP_DEVICE_NAME_LEN] = "Adding_A1-000000";
uint8 attDeviceName[GAP_DEVICE_NAME_LEN] = "L1-000000";  //V1007 MODIFY

// define for eeprom
uint16 rawDataStart = 0, rawDataStop = 0;

typedef struct
{
    UTCTimeStruct       tm;
    UTCTime             hourSeconds;
    uint16              count;
    uint8               type;
}one_data_t;

one_data_t oneData[DATA_TYPE_COUNT];

// RAM DB
// uint8 db[EEPROM_ADDRESS_DATA_MAX];

// define for keys
uint8 tapWaitFor = 0, lockSlip = 0, blinkPIO = 0, blinkMinutes = 13, onTheKey = 0, ledCycleCount = 0;

// uint16 testAddr = 0;

uint8 readTheI = 0;

uint32 accLoadInterval = ACC_LOAD_INTERVAL, accStaticCount = 0;
bool    flagAccStatic=FALSE;
struct mpr03x_touchkey_data {
	uint8 CDC;
	uint8 CDT;
};

//static bool flagSBPStart=0;
uint8 flagSBPStart=0;


/*********************************************************************
 * LOCAL FUNCTIONS
 */
static void simpleBLEPeripheral_ProcessOSALMsg( osal_event_hdr_t *pMsg );
static void peripheralStateNotificationCB( gaprole_States_t newState );
//static void performPeriodicTask( void );
static void simpleProfileChangeCB( uint8 paramID );

static void battPeriodicTask( void );
static void battCB(uint8 event);

static void accInit(void);

static uint8 accDataProcess(uint8 count);

static void eepromWrite(uint8 type, uint8 cnt);
static uint8 eepromRead(void);

static void closeAllPIO(void);
//static void openAllLED(void);

static void time(void);

static void longPressAndCycleLED6(void);
//static void cycleLED12(void);

static void toggleLEDWithTime(uint8 num, uint8 io);
static void blinkLED(void);

static void toggleAdvert(uint8 status);

static void saveRawDataIndex(void);
static void loadRawDataIndex(void);

//static void tribleTap(void);

static uint16 dataLength(void);

static int mpr03x_phys_init(void);
static void mpr03x_start(void);
static void mpr03x_stop(void); //v114
void Delay1(uint16 cnt);
void Delay2(uint16 cnt);
void DelayMs(uint16 cnt);

/*********************************************************************
 * PROFILE CALLBACKS
 */

// GAP Role Callbacks
static gapRolesCBs_t simpleBLEPeripheral_PeripheralCBs =
{
    peripheralStateNotificationCB,  // Profile State Change Callbacks
    NULL                            // When a valid RSSI is read from controller (not used by application)
};

// GAP Bond Manager Callbacks
static gapBondCBs_t simpleBLEPeripheral_BondMgrCBs =
{
    NULL,                     // Passcode callback (not used by application)
    NULL                      // Pairing / Bonding state Callback (not used by application)
};

// Simple GATT Profile Callbacks
static simpleProfileCBs_t simpleBLEPeripheral_SimpleProfileCBs =
{
    simpleProfileChangeCB    // Charactersitic value change callback
};

/*********************************************************************
 * PUBLIC FUNCTIONS
 */

/*********************************************************************
 * @fn      SimpleBLEPeripheral_Init
 *
 * @brief   Initialization function for the Simple BLE Peripheral App Task.
 *          This is called during initialization and should contain
 *          any application specific initialization (ie. hardware
 *          initialization/setup, table initialization, power up
 *          notificaiton ... ).
 *
 * @param   task_id - the ID assigned by OSAL.  This ID should be
 *                    used to send messages and set timers.
 *
 * @return  none
 */
void SimpleBLEPeripheral_Init( uint8 task_id )
{
    simpleBLEPeripheral_TaskID = task_id;

    // Debug_init(simpleBLEPeripheral_TaskID);

    // init accelerater
    accInit();
    //watchdog init

    WDCTL = (WdctlModeIdle<<2); //设置关门狗为空闲模式
    WDCTL = WdctlInt | (WDCTL & 0xFC);
    WDCTL = (WdctlModeWdog<<2) | (WDCTL & 0xF3);     //设置关门狗模式\设置关门狗间隔为1S

    // use low 6 bytes mac address of cc2541 to be our sn
    char hex[] = "0123456789ABCDEF";
    uint8 ownAddress[B_ADDR_LEN];

    // read unique ieee address
    LL_ReadBDADDR(ownAddress);

    uint8 sn[] =
    {
        hex[HI_UINT8(ownAddress[2])],
        hex[LO_UINT8(ownAddress[2])],
        hex[HI_UINT8(ownAddress[1])],
        hex[LO_UINT8(ownAddress[1])],
        hex[HI_UINT8(ownAddress[0])],
        hex[LO_UINT8(ownAddress[0])]
    };

    // rewrite device name
    //osal_memcpy(&scanRspData[12], sn, sizeof(sn));
    osal_memcpy(&scanRspData[5], sn, sizeof(sn));  //v1007 modify
    //osal_memcpy(&attDeviceName[10], sn, sizeof(sn));
    osal_memcpy(&attDeviceName[3], sn, sizeof(sn));//v1007 modify

    // Setup the GAP
    VOID GAP_SetParamValue( TGAP_CONN_PAUSE_PERIPHERAL, DEFAULT_CONN_PAUSE_PERIPHERAL );

    // Setup the GAP Peripheral Role Profile
    {
        // For other hardware platforms, device starts advertising upon initialization
        uint8 initial_advertising_enable = TRUE;

        // By setting this to zero, the device will go into the waiting state after
        // being discoverable for 30.72 second, and will not being advertising again
        // until the enabler is set back to TRUE
        uint16 gapRole_AdvertOffTime = 0;

        //uint8 enable_update_request = DEFAULT_ENABLE_UPDATE_REQUEST;
        //uint16 desired_min_interval = DEFAULT_DESIRED_MIN_CONN_INTERVAL;
        //uint16 desired_max_interval = DEFAULT_DESIRED_MAX_CONN_INTERVAL;
        //uint16 desired_slave_latency = DEFAULT_DESIRED_SLAVE_LATENCY;
        //uint16 desired_conn_timeout = DEFAULT_DESIRED_CONN_TIMEOUT;

        // Set the GAP Role Parameters
        GAPRole_SetParameter( GAPROLE_ADVERT_ENABLED, sizeof( uint8 ), &initial_advertising_enable );
        GAPRole_SetParameter( GAPROLE_ADVERT_OFF_TIME, sizeof( uint16 ), &gapRole_AdvertOffTime );

        GAPRole_SetParameter( GAPROLE_SCAN_RSP_DATA, sizeof ( scanRspData ), scanRspData );
        GAPRole_SetParameter( GAPROLE_ADVERT_DATA, sizeof( advertData ), advertData );

       // GAPRole_SetParameter( GAPROLE_PARAM_UPDATE_ENABLE, sizeof( uint8 ), &enable_update_request );
      //  GAPRole_SetParameter( GAPROLE_MIN_CONN_INTERVAL, sizeof( uint16 ), &desired_min_interval );
      //  GAPRole_SetParameter( GAPROLE_MAX_CONN_INTERVAL, sizeof( uint16 ), &desired_max_interval );
      //  GAPRole_SetParameter( GAPROLE_SLAVE_LATENCY, sizeof( uint16 ), &desired_slave_latency );
      //  GAPRole_SetParameter( GAPROLE_TIMEOUT_MULTIPLIER, sizeof( uint16 ), &desired_conn_timeout );
    }

    // Set the GAP Characteristics
    GGS_SetParameter( GGS_DEVICE_NAME_ATT, GAP_DEVICE_NAME_LEN, attDeviceName );

    // Set advertising interval
    {
        uint16 advInt = DEFAULT_ADVERTISING_INTERVAL;

        GAP_SetParamValue( TGAP_LIM_DISC_ADV_INT_MIN, advInt );
        GAP_SetParamValue( TGAP_LIM_DISC_ADV_INT_MAX, advInt );
        GAP_SetParamValue( TGAP_GEN_DISC_ADV_INT_MIN, advInt );
        GAP_SetParamValue( TGAP_GEN_DISC_ADV_INT_MAX, advInt );
    }

    // Setup the GAP Bond Manager
    {
        uint32 passkey = 0; // passkey "000000"
        uint8 pairMode = GAPBOND_PAIRING_MODE_WAIT_FOR_REQ;
        // uint8 pairMode = GAPBOND_PAIRING_MODE_NO_PAIRING;
        uint8 mitm = TRUE;
        uint8 ioCap = GAPBOND_IO_CAP_DISPLAY_ONLY;
        uint8 bonding = TRUE;
        GAPBondMgr_SetParameter( GAPBOND_DEFAULT_PASSCODE, sizeof ( uint32 ), &passkey );
        GAPBondMgr_SetParameter( GAPBOND_PAIRING_MODE, sizeof ( uint8 ), &pairMode );
        GAPBondMgr_SetParameter( GAPBOND_MITM_PROTECTION, sizeof ( uint8 ), &mitm );
        GAPBondMgr_SetParameter( GAPBOND_IO_CAPABILITIES, sizeof ( uint8 ), &ioCap );
        GAPBondMgr_SetParameter( GAPBOND_BONDING_ENABLED, sizeof ( uint8 ), &bonding );
    }

    // Initialize GATT attributes
    GGS_AddService( GATT_ALL_SERVICES );            // GAP
    GATTServApp_AddService( GATT_ALL_SERVICES );    // GATT attributes
    // DevInfo_AddService();                           // Device Information Service
    SimpleProfile_AddService( GATT_ALL_SERVICES );  // Simple GATT Profile
	 Batt_AddService();

#if defined FEATURE_OAD
    VOID OADTarget_AddService();                    // OAD Profile
#endif

    // Setup the SimpleProfile Characteristic Values
    {
        // uint8   healthSync = 1;
        // uint32  healthClock = 0;
        uint16  healthDataHeader = DATA_TYPE_COUNT;
        uint16  healthFirmware = FIRMWARE;
        // uint8   healthDataBody = 0;

        SimpleProfile_SetParameter( HEALTH_DATA_HEADER, sizeof ( uint16 ), &healthDataHeader );
        SimpleProfile_SetParameter( HEALTH_FIRMWARE, sizeof ( uint16 ), &healthFirmware );
    }

    // Setup Battery Characteristic Values
    {
        uint8 critical = DEFAULT_BATT_CRITICAL_LEVEL;
        Batt_SetParameter( BATT_PARAM_CRITICAL_LEVEL, sizeof (uint8 ), &critical );
    }

    // see the name
    RegisterForKeys( simpleBLEPeripheral_TaskID );

    // initialize IO's settings    

    P0DIR = 0xF6;
    P0SEL = 0x01;

    P1DIR = 0xFB;
    P1SEL = 0x00;

    P2DIR = 0xFF;
    P2SEL = 0x00;

    //close all
    closeAllPIO();

	 mpr03x_phys_init();
	 mpr03x_start();

    // Register callback with SimpleGATTprofile
    VOID SimpleProfile_RegisterAppCBs( &simpleBLEPeripheral_SimpleProfileCBs );

    // Register for Battery service callback;
    Batt_Register ( battCB );

	 //read actualVref from eeprom
//	 #if (MANUFACTURE_TEST==FALSE)
//	 	battMeasureCalibration();
//	 	WriteActualVref(1190);
//	 #endif
	 ReadActualVref();

    // Enable clock divide on halt
    // This reduces active current while radio is active and CC254x MCU
    // is halted
    HCI_EXT_ClkDivOnHaltCmd( HCI_EXT_ENABLE_CLK_DIVIDE_ON_HALT );

#if defined ( DC_DC_P0_7 )

    // Enable stack to toggle bypass control on TPS62730 (DC/DC converter)
    HCI_EXT_MapPmIoPortCmd( HCI_EXT_PM_IO_PORT_P0, HCI_EXT_PM_IO_PORT_PIN7 );

#endif // defined ( DC_DC_P0_7 )

    // start accelerater periodic event
    osal_set_event( simpleBLEPeripheral_TaskID, ACC_PERIODIC_EVT );

    // load raw data index from eeprom
    loadRawDataIndex();

    uint16 length = dataLength();
    SimpleProfile_SetParameter( HEALTH_DATA_HEADER, 2,  &length);

    // Setup a delayed profile startup
    osal_set_event( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT );
    //battery ADC read  period funtion
    osal_set_event( simpleBLEPeripheral_TaskID, SBP_PERIODIC_EVT);
    //MPR03X self-calibration funciton
    osal_set_event( simpleBLEPeripheral_TaskID, MPR03X_CALIBRATION_EVT);
    //close power
    osal_set_event( simpleBLEPeripheral_TaskID,CLOSE_ALL_EVT);
    //set watchdog clear event
    osal_set_event( simpleBLEPeripheral_TaskID,WATCHDOG_CLEAR_EVT);
    //set fetal movement record event
    osal_set_event( simpleBLEPeripheral_TaskID,FETALMOVEMENTRECORD_MAX_EVT);
    
}

/*********************************************************************
 * @fn      SimpleBLEPeripheral_ProcessEvent
 *
 * @brief   Simple BLE Peripheral Application Task event processor.  This function
 *          is called to process all events for the task.  Events
 *          include timers, messages and any other user defined events.
 *
 * @param   task_id  - The OSAL assigned task ID.
 * @param   events - events to process.  This is a bit map and can
 *                   contain more than one event.
 *
 * @return  events not processed
 */
uint16 SimpleBLEPeripheral_ProcessEvent( uint8 task_id, uint16 events )
{

    VOID task_id; // OSAL required parameter that isn't used in this function

    if ( events & SYS_EVENT_MSG )
    {
        uint8 *pMsg;

        if ( (pMsg = osal_msg_receive( simpleBLEPeripheral_TaskID )) != NULL )
        {
            simpleBLEPeripheral_ProcessOSALMsg( (osal_event_hdr_t *)pMsg );

            // Release the OSAL message
            VOID osal_msg_deallocate( pMsg );
        }
        // return unprocessed events
        return (events ^ SYS_EVENT_MSG);
    }

    if ( events & SBP_START_DEVICE_EVT )
    {
    		if(0==flagSBPStart)
    		{
	        // Start the Device
	        VOID GAPRole_StartDevice( &simpleBLEPeripheral_PeripheralCBs );

	        // Start Bond Manager
	        VOID GAPBondMgr_Register( &simpleBLEPeripheral_BondMgrCBs );

	        toggleAdvert(TRUE);

	        // Set timer for first periodic event
	       // osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_PERIODIC_EVT, SBP_PERIODIC_EVT_PERIOD );
                osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_PERIODIC_EVT, SBP_PERIODIC_1s_EVT_PERIOD );
                
                osal_start_timerEx( simpleBLEPeripheral_TaskID, MPR03X_CALIBRATION_EVT, MPR03X_CALIBRATION_EVT_1min_EVT_PERIOD );
                
                osal_start_timerEx( simpleBLEPeripheral_TaskID,WATCHDOG_CLEAR_EVT,WATCHDOG_CLEAR_EVT_PERIOD);
			  // Set timer for led all on, READY period
			  osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT, SBP_START_DEVICE_EVT_READY_PERIOD );
			  flagSBPStart++;
			}
                      else if(1==flagSBPStart)
			{
				//Open all LED and set timer for led all off, GO period
			  //openAllLED();
                              LED0_PIO = OPEN_PIO;
                              LED1_PIO = CLOSE_PIO;
                              LED2_PIO = CLOSE_PIO;
                              LED3_PIO = CLOSE_PIO;
                              LED4_PIO = CLOSE_PIO;
                              LED5_PIO = CLOSE_PIO;
                              LED6_PIO = CLOSE_PIO;
                              LED7_PIO = CLOSE_PIO;
                              LED8_PIO = CLOSE_PIO;
                              LED9_PIO = CLOSE_PIO;
                              LED10_PIO =CLOSE_PIO;
                              LED11_PIO = CLOSE_PIO;
	                      led_status=0x0021;
	                      LED_POWER=BOOSTON;
	                      osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT, SBP_START_DEVICE_EVT_GO_PERIOD );
	                      flagSBPStart++;
			}			
                      else if(2==flagSBPStart)
			{
				//Open all LED and set timer for led all off, GO period
			  //openAllLED();
                              LED0_PIO = OPEN_PIO;
                              LED1_PIO = CLOSE_PIO;
                              LED2_PIO = CLOSE_PIO;
                              LED3_PIO = CLOSE_PIO;
                              LED4_PIO = CLOSE_PIO;
                              LED5_PIO = CLOSE_PIO;
                              LED6_PIO = OPEN_PIO;
                              LED7_PIO = CLOSE_PIO;
                              LED8_PIO = CLOSE_PIO;
                              LED9_PIO = CLOSE_PIO;
                              LED10_PIO =CLOSE_PIO;
                              LED11_PIO = CLOSE_PIO;
	                      led_status=0x0021;
	                      LED_POWER=BOOSTON;
	                      osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT, SBP_START_DEVICE_EVT_GO_PERIOD );
	                      flagSBPStart++;
			}
			else if(3==flagSBPStart)
			{
                              LED0_PIO = CLOSE_PIO;
                              LED1_PIO = OPEN_PIO;
                              LED2_PIO = CLOSE_PIO;
                              LED3_PIO = CLOSE_PIO;
                              LED4_PIO = CLOSE_PIO;
                              LED5_PIO = CLOSE_PIO;
                              LED6_PIO = CLOSE_PIO;
                              LED7_PIO = OPEN_PIO;
                              LED8_PIO = CLOSE_PIO;
                              LED9_PIO = CLOSE_PIO;
                              LED10_PIO =CLOSE_PIO;
                              LED11_PIO = CLOSE_PIO;
	                      led_status=0x0042;
	                      LED_POWER=BOOSTON;
				osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT,SBP_START_DEVICE_EVT_GO_PERIOD);
				flagSBPStart++;
			}
 			else if(4==flagSBPStart)
			{
                              LED0_PIO = CLOSE_PIO;
                              LED1_PIO = CLOSE_PIO;
                              LED2_PIO = OPEN_PIO;
                              LED3_PIO = CLOSE_PIO;
                              LED4_PIO = CLOSE_PIO;
                              LED5_PIO = CLOSE_PIO;
                              LED6_PIO = CLOSE_PIO;
                              LED7_PIO = CLOSE_PIO;
                              LED8_PIO = OPEN_PIO;
                              LED9_PIO = CLOSE_PIO;
                              LED10_PIO =CLOSE_PIO;
                              LED11_PIO = CLOSE_PIO;
	                      led_status=0x0084;
	                      LED_POWER=BOOSTON;
				osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT,SBP_START_DEVICE_EVT_GO_PERIOD);
				flagSBPStart++;
			}
  			else if(5==flagSBPStart)
			{
                              LED0_PIO = CLOSE_PIO;
                              LED1_PIO = CLOSE_PIO;
                              LED2_PIO = CLOSE_PIO;
                              LED3_PIO = OPEN_PIO;
                              LED4_PIO = CLOSE_PIO;
                              LED5_PIO = CLOSE_PIO;
                              LED6_PIO = CLOSE_PIO;
                              LED7_PIO = CLOSE_PIO;
                              LED8_PIO = CLOSE_PIO;
                              LED9_PIO = OPEN_PIO;
                              LED10_PIO =CLOSE_PIO;
                              LED11_PIO = CLOSE_PIO;
	                      led_status=0x0108;
	                      LED_POWER=BOOSTON;
				osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT,SBP_START_DEVICE_EVT_GO_PERIOD);
				flagSBPStart++;
			}
  			else if(6==flagSBPStart)
			{
                              LED0_PIO = CLOSE_PIO;
                              LED1_PIO = CLOSE_PIO;
                              LED2_PIO = CLOSE_PIO;
                              LED3_PIO = CLOSE_PIO;
                              LED4_PIO = OPEN_PIO;
                              LED5_PIO = CLOSE_PIO;
                              LED6_PIO = CLOSE_PIO;
                              LED7_PIO = CLOSE_PIO;
                              LED8_PIO = CLOSE_PIO;
                              LED9_PIO = CLOSE_PIO;
                              LED10_PIO =OPEN_PIO;
                              LED11_PIO = CLOSE_PIO;
	                      led_status=0x0210;
	                      LED_POWER=BOOSTON;
				osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT,SBP_START_DEVICE_EVT_GO_PERIOD);
				flagSBPStart++;
			}
  			else if(7==flagSBPStart)
			{
                              LED0_PIO = CLOSE_PIO;
                              LED1_PIO = CLOSE_PIO;
                              LED2_PIO = CLOSE_PIO;
                              LED3_PIO = CLOSE_PIO;
                              LED4_PIO = CLOSE_PIO;
                              LED5_PIO = OPEN_PIO;
                              LED6_PIO = CLOSE_PIO;
                              LED7_PIO = CLOSE_PIO;
                              LED8_PIO = CLOSE_PIO;
                              LED9_PIO = CLOSE_PIO;
                              LED10_PIO =CLOSE_PIO;
                              LED11_PIO = OPEN_PIO;
	                      led_status=0x0420;
	                      LED_POWER=BOOSTON;
				osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT,SBP_START_DEVICE_EVT_GO_PERIOD);
				flagSBPStart++;
			}
   			else if(8==flagSBPStart)
			{
                              LED0_PIO = OPEN_PIO;
                              LED1_PIO = CLOSE_PIO;
                              LED2_PIO = CLOSE_PIO;
                              LED3_PIO = CLOSE_PIO;
                              LED4_PIO = CLOSE_PIO;
                              LED5_PIO = CLOSE_PIO;
                              LED6_PIO = OPEN_PIO;
                              LED7_PIO = CLOSE_PIO;
                              LED8_PIO = CLOSE_PIO;
                              LED9_PIO = CLOSE_PIO;
                              LED10_PIO =CLOSE_PIO;
                              LED11_PIO = CLOSE_PIO;
	                      led_status=0x0840;
	                      LED_POWER=BOOSTON;
				osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT,SBP_START_DEVICE_EVT_GO_PERIOD);
				flagSBPStart++;
			}
   			else if(9==flagSBPStart)
			{
				//Close all LED and the timer
				closeAllPIO();
				osal_stop_timerEx( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT);
				flagSBPStart++;
			}
			else
			{}
        return ( events ^ SBP_START_DEVICE_EVT );
    }

    if ( events & ACC_PERIODIC_EVT )
    {

        // accLoop();

        HalI2CInit(ACC_ADDRESS, I2C_CLOCK_RATE);

        uint8 addr, val;

        addr = F_STATUS;
        HalMotionI2CWrite(1, &addr);
        HalMotionI2CRead(1, &val);

        val &= ~(BV(6)|BV(7));

        if (val)//if F_CNTX[5:0]!=0
        {
            if(gapProfileState != GAPROLE_CONNECTED) //avoid the time of connected interals
            {
             accDataProcess(val);
            }
		//accGetAccData(val);
        }

        if(FALSE==flagAccStatic)
        {
          osal_start_timerEx( simpleBLEPeripheral_TaskID, ACC_PERIODIC_EVT, accLoadInterval );
        }
        
     //fixed non adv problem
    //  if(gapProfileState == GAPROLE_ADVERTISING)
     // {
     //   if(adverCount >= ADVERCOUNT)
     //      adverCount = ADVERCOUNT;
     //   else
     //       adverCount = adverCount + 1;
     // }
     // else
     // {
//        if(adverCount > 0)
//            adverCount = adverCount - 1;
//        else
//        {
//        adverCount = ADVERCOUNT;
//        toggleAdvert(FALSE);//FIXED NON ADV
//        toggleAdvert(TRUE);
//        }
   //   }
      //////////////////////////////////////////////////////
        return (events ^ ACC_PERIODIC_EVT);
    }



    if ( events & BATT_PERIODIC_EVT )
    {
        // Perform periodic battery task
        battPeriodicTask();

        return (events ^ BATT_PERIODIC_EVT);
    }

    if ( events & SBP_PERIODIC_EVT )
    {
      if(countAdcSample == FALSE)
      {
      HalADCPeripheralSetting(HAL_ADC_CHANNEL_0,IO_FUNCTION_PERI);
      HalADCToggleChannel(HAL_ADC_CHANNEL_0,ADC_CHANNEL_ON);
      countAdcSample = TRUE;
      osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_PERIODIC_EVT, SBP_PERIODIC_1s_EVT_PERIOD );
      }  
      else
      {
       if(gapProfileState == GAPROLE_ADVERTISING) 
      {
        battMeasureCount = battMeasureCount + 1;
        if(battMeasureCount <= 10)
        {
            battADwordTemp = battMeasure();
            battADwordSum = battADwordTemp + battADwordSum; 
            if(battADwordTemp>=  battADwordMax)
              battADwordMax = battADwordTemp;  
            else
              battADwordMax = battADwordMax;   
            if(battADwordTemp <=  battADwordMin)
              battADwordMin = battADwordTemp;  
            else
              battADwordMin = battADwordMin;       
        }   
        else
        {
          battADword = (uint8)((battADwordSum-battADwordMax-battADwordMin)>>3);
          battMeasureCount = 0; 
          battADwordSum = 0;
        }
     }
      HalADCPeripheralSetting(HAL_ADC_CHANNEL_0,IO_FUNCTION_GPIO);
      HalADCToggleChannel(HAL_ADC_CHANNEL_0,ADC_CHANNEL_OFF);
      countAdcSample = FALSE;
      osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_PERIODIC_EVT, SBP_PERIODIC_60s_EVT_PERIOD );     
      }
      return (events ^ SBP_PERIODIC_EVT);
    }

    if ( events & TAP_TIMEOUT_EVT )
    {

        // double tap!!!
        if (tapWaitFor == 3)
        {
           LED0_PIO = CLOSE_PIO; //when KEY VALIDD 
           LED1_PIO = CLOSE_PIO;
           LED2_PIO = CLOSE_PIO;
           LED3_PIO = CLOSE_PIO;
           LED4_PIO = CLOSE_PIO;
           LED5_PIO = CLOSE_PIO;
           LED6_PIO = CLOSE_PIO;
           LED7_PIO = CLOSE_PIO;
           LED8_PIO = CLOSE_PIO;
           LED9_PIO = CLOSE_PIO;
           LED10_PIO = CLOSE_PIO;
           LED11_PIO = CLOSE_PIO;
           osal_stop_timerEx( simpleBLEPeripheral_TaskID, CLOSE_ALL_EVT);//v122
            time();

            //stop long press
            osal_stop_timerEx( simpleBLEPeripheral_TaskID, LONG_PRESS_EVT );
        }

        tapWaitFor = 0;

        return (events ^ TAP_TIMEOUT_EVT);
    }

    if ( events & BLINK_LED_EVT )
    {
        
        blinkLED();

        return (events ^ BLINK_LED_EVT);
    }

    if ( events & TIME_STOP_EVT )
    {
        
        osal_stop_timerEx(simpleBLEPeripheral_TaskID, BLINK_LED_EVT);

        closeAllPIO();

        blinkPIO = 0;

        blinkMinutes = 13;

        lockSlip = 0;

        return (events ^ TIME_STOP_EVT);
    }

    if ( events & CYCLE_LED_6_EVT )
    {
        
        if (ledCycleCount < 7)
        {
            toggleLEDWithTime(ledCycleCount, OPEN_PIO);
            toggleLEDWithTime(12 - ledCycleCount, OPEN_PIO);
        }
        
        toggleLEDWithTime(ledCycleCount - 1, CLOSE_PIO);
        toggleLEDWithTime(13 - ledCycleCount, CLOSE_PIO);
        
        ledCycleCount++;
        
        if (ledCycleCount < 8)
        {
            osal_start_timerEx( simpleBLEPeripheral_TaskID, CYCLE_LED_6_EVT, CYCLE_LED_6_INTERVAL );

        }else{

            ledCycleCount = 0;
            lockSlip = 0;
        }

        return (events ^ CYCLE_LED_6_EVT);
    }
     if ( events & FETALMOVEMENTRECORD_MAX_EVT)
     {
         if(longPressJudgeFlag == 0)
         {
             eepromWrite(TAP_DATA_TYPE, 1);
         }
         return (events ^ FETALMOVEMENTRECORD_MAX_EVT);
     }
       
       
//    if ( events & CYCLE_LED_12_EVT )
//    {
//        
//        if (ledCycleCount < 12)
//        {
//            toggleLEDWithTime(ledCycleCount, OPEN_PIO);
//            toggleLEDWithTime(ledCycleCount - 1, CLOSE_PIO);
//        }else if(ledCycleCount == 12)
//        {
//            toggleLEDWithTime(0, OPEN_PIO);
//            toggleLEDWithTime(11, CLOSE_PIO);
//        }else
//        {
//            toggleLEDWithTime(0, CLOSE_PIO);
//        }
//        
//        ledCycleCount++;
//        
//        if (ledCycleCount < 14)
//        {
//            osal_start_timerEx( simpleBLEPeripheral_TaskID, CYCLE_LED_12_EVT, CYCLE_LED_12_INTERVAL );
//
//        }else{
//
//            ledCycleCount = 0;
//            lockSlip = 0;
//        }
//        return (events ^ CYCLE_LED_12_EVT);
//    }

    if ( events & CLOSE_ALL_EVT )
    {
    LED0_PIO = OPEN_PIO;
    LED1_PIO = OPEN_PIO;
    LED2_PIO = OPEN_PIO;
    LED3_PIO = OPEN_PIO;
    LED4_PIO = OPEN_PIO;
    LED5_PIO = OPEN_PIO;
    LED6_PIO = OPEN_PIO;
    LED7_PIO = OPEN_PIO;
    LED8_PIO = OPEN_PIO;
    LED9_PIO = OPEN_PIO;
    LED10_PIO = OPEN_PIO;
    LED11_PIO = OPEN_PIO;
        return (events ^ CLOSE_ALL_EVT);
    }

    if ( events & LONG_PRESS_EVT )
    {
           LED0_PIO = CLOSE_PIO; //when KEY VALIDD 
           LED1_PIO = CLOSE_PIO;
           LED2_PIO = CLOSE_PIO;
           LED3_PIO = CLOSE_PIO;
           LED4_PIO = CLOSE_PIO;
           LED5_PIO = CLOSE_PIO;
           LED6_PIO = CLOSE_PIO;
           LED7_PIO = CLOSE_PIO;
           LED8_PIO = CLOSE_PIO;
           LED9_PIO = CLOSE_PIO;
           LED10_PIO = CLOSE_PIO;
           LED11_PIO = CLOSE_PIO;
           osal_stop_timerEx( simpleBLEPeripheral_TaskID, CLOSE_ALL_EVT);//v122
        //if (onTheKey && (activeAccAction == TRUE)) //119      
           if (onTheKey && (sysnonactive  == FALSE)&& (activeAccAction == FALSE))
        {
            longPressAndCycleLED6();
        }
        //else if(onTheKey && (activeAccAction == FALSE))
        else if(onTheKey && (sysnonactive == TRUE)&& (activeAccAction == TRUE))
        {
        flagSBPStart = 1;
        osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT, SBP_START_DEVICE_EVT_READY_500ms_PERIOD );
        }

        return (events ^ LONG_PRESS_EVT);
    }

//    if ( events & RUN_TRIBLE_TAP_EVT )
//    {
//
//        cycleLED12();
//
//        return (events ^ RUN_TRIBLE_TAP_EVT);
//    }

    if ( events & READ_EVT )
    {

        eepromRead();

        if (readTheI < 3)
        {
            osal_start_timerEx( simpleBLEPeripheral_TaskID, READ_EVT, READ_INTERVAL );
        }

        return (events ^ READ_EVT);
    }
    
    if ( events & MPR03X_CALIBRATION_EVT )
    {
        uint8 mpr03xaddr,mpr03xdata1,mpr03xval,mpr03xdata2;
        uint8 mpr03xpbuf[2];     
       	//set i2c device address
	HalI2CInit(TOUCH_ADDRESS, I2C_CLOCK_RATE); 
        mpr03xaddr=MPR03X_E0FDH_REG;
	HalMotionI2CWrite(1, &mpr03xaddr);
	HalMotionI2CRead(1,&mpr03xval);
	mpr03xdata1=mpr03xval<<6;
	mpr03xaddr=MPR03X_E0FDL_REG;
	HalMotionI2CWrite(1, &mpr03xaddr);
	HalMotionI2CRead(1,&mpr03xval);
	mpr03xdata2=(mpr03xval>>2)&0xF8;        
        mpr03xCalDateCur = mpr03xdata1 | mpr03xdata2;
        //if match need ,write baseline to the address
        if(mpr03xCalDatePos == mpr03xCalDateCur)
        {
           mpr03xCalCount = mpr03xCalCount + 1;
           if(mpr03xCalCount >= MPR03XCALIBRATIONCOUNT)
           {
           mpr03xCalCount = 0;
           mpr03x_stop();//(client);
           mpr03xpbuf[0]= MPR03X_E0BV_REG;
	   mpr03xpbuf[1]= mpr03xCalDateCur;
	   HalI2CWrite(2,mpr03xpbuf);
           mpr03x_start();//(client);
           }
        }
        else
        {
          mpr03xCalCount = 0;
        }
        //refresh data
        mpr03xCalDatePos = mpr03xCalDateCur;
        //set events per minutus
        osal_start_timerEx( simpleBLEPeripheral_TaskID, MPR03X_CALIBRATION_EVT, MPR03X_CALIBRATION_EVT_1min_EVT_PERIOD );
        return (events ^ MPR03X_CALIBRATION_EVT);
    }  
    
        if ( events & WATCHDOG_CLEAR_EVT )
    {       
     if(gapProfileState == GAPROLE_CONNECTED)
        adverCount = ADVERCOUNT;
     else
     {
      if(adverCount > 1)
            adverCount = adverCount - 1;
        else
        {
         if(adverCount == 1)
         {
           adverCount = adverCount - 1;
           toggleAdvert(FALSE);//FIXED NON ADV
         }
         else if(adverCount == 0)
         {
         adverCount = ADVERCOUNT;
         toggleAdvert(TRUE);
         }
        }
     }
      WDCTL = (WDCTL & 0x0F) | WdctlClrFirst<<4;     //设置关门狗模式\设置关门狗间隔为1S
        WDCTL = (WDCTL & 0x0F) | WdctlClrSec<<4;     //设置关门狗模式\设置关门狗间隔为1S
        
         osal_start_timerEx( simpleBLEPeripheral_TaskID, WATCHDOG_CLEAR_EVT, WATCHDOG_CLEAR_EVT_PERIOD );

        return (events ^ WATCHDOG_CLEAR_EVT);
    }
    
    // Discard unknown events
    return 0;
}

/*********************************************************************
 * @fn      simpleBLEPeripheral_ProcessOSALMsg
 *
 * @brief   Process an incoming task message.
 *
 * @param   pMsg - message to process
 *
 * @return  none
 */
static void simpleBLEPeripheral_ProcessOSALMsg( osal_event_hdr_t *pMsg )
{
    switch ( pMsg->event )
    {

    case KEY_CHANGE:

    {
      
      // press > 0
      // release == 0
      uint8 keys = ((keyChange_t *)pMsg)->keys;
      uint8 pBuf[2];
      uint8 addr,val;
      HalI2CInit(TOUCH_ADDRESS, I2C_CLOCK_RATE);
      addr=MPR03X_TS_REG;
      HalMotionI2CWrite(1, &addr);
      HalMotionI2CRead(1,&val);
      if((val&0x01)==0)
	 onTheKey=0;
      else
	 onTheKey=1;

      if((keys&HAL_KEY_SW_1)!=0)//sw_1
      {
        
         if(onTheKey == 0)
         {
         longPressJudgeFlag = 0;  //used for judge valid of longpress before break
         }
        // LED6_PIO = !onTheKey;
  
        if (lockSlip)
        {
            break;
        }
  
        // for long press
        if (onTheKey)
        {
            osal_start_timerEx( simpleBLEPeripheral_TaskID, LONG_PRESS_EVT , LONG_PRESS_INTERVAL );   
        }else {
          osal_stop_timerEx( simpleBLEPeripheral_TaskID, LONG_PRESS_EVT );      
        }
       // if (onTheKey)
       // if (onTheKey && (activeAccAction == TRUE)) //v119
         if (onTheKey && (sysnonactive == FALSE)&& (activeAccAction == FALSE))
        {
            
            // for tap
            if (tapWaitFor == 0)
            {
              tapWaitFor = 2;
  
            }else if (tapWaitFor == 2){
  
              tapWaitFor = 3;
  
              osal_stop_timerEx( simpleBLEPeripheral_TaskID, TAP_TIMEOUT_EVT );
  
            }else if (tapWaitFor == 3){
  
              // trible tap!!
              //tribleTap();   //remove 3 tick function
  
              osal_stop_timerEx( simpleBLEPeripheral_TaskID, TAP_TIMEOUT_EVT );
  
              //stop long press
              osal_stop_timerEx( simpleBLEPeripheral_TaskID, LONG_PRESS_EVT );
  
              tapWaitFor = 0;
            }
        }
  
        if (tapWaitFor != 0)
        {
            osal_start_timerEx( simpleBLEPeripheral_TaskID, TAP_TIMEOUT_EVT , NEXT_TAP_INTERVAL );
        }
      }
      if((keys&HAL_KEY_SW_2)!=0)//sw_2 motion int
      { 
        HalI2CInit(ACC_ADDRESS, I2C_CLOCK_RATE);
        //set acc into standby, so can write
        pBuf[0] = CTRL_REG1;
        pBuf[1] = 0;
        HalI2CWrite(2, pBuf);
        //read register to clr interrupt flag in acc
        pBuf[0] = FF_MT_SRC;
        HalMotionI2CWrite(1, pBuf);
        HalMotionI2CRead(1, &pBuf[1]);
        //disable motion int
        pBuf[0] = CTRL_REG4;
        pBuf[1] = 0;
        HalI2CWrite(2, pBuf);
        //set acc back into active
        pBuf[0] = CTRL_REG1;
        pBuf[1] = (ASLP_RATE_12_5HZ + DATA_RATE_12_5HZ) | ACTIVE_MASK;
        HalI2CWrite(2, pBuf);
        //restart acc periodic evt and static count
        accStaticCount=0;
        flagAccStatic=FALSE;
	//debug usage
	//toggleLEDWithTime(0,CLOSE_PIO);
        osal_start_timerEx( simpleBLEPeripheral_TaskID, ACC_PERIODIC_EVT, accLoadInterval );
        //LED0_PIO=OPEN_PIO;
        //LED1_PIO=OPEN_PIO;
      }
    }

      break;

    default:
        // do nothing
        break;
    }
}

/*********************************************************************
 * @fn      peripheralStateNotificationCB
 *
 * @brief   Notification from the profile of a state change.
 *
 * @param   newState - new state
 *
 * @return  none
 */
static void peripheralStateNotificationCB( gaprole_States_t newState )
{
    
    // closeAllPIO();
    uint8 pBuf[2]; //v1008 modify
    uint8 CDT = 1;
    switch ( newState )
    {
    case GAPROLE_STARTED:
    {
        uint8 ownAddress[B_ADDR_LEN];
        uint8 systemId[DEVINFO_SYSTEM_ID_LEN];

        GAPRole_GetParameter(GAPROLE_BD_ADDR, ownAddress);

        // use 6 bytes of device address for 8 bytes of system ID value
        systemId[0] = ownAddress[0];
        systemId[1] = ownAddress[1];
        systemId[2] = ownAddress[2];

        // set middle bytes to zero
        systemId[4] = 0x00;
        systemId[3] = 0x00;

        // shift three bytes up
        systemId[7] = ownAddress[5];
        systemId[6] = ownAddress[4];
        systemId[5] = ownAddress[3];


        DevInfo_SetParameter(DEVINFO_SYSTEM_ID, DEVINFO_SYSTEM_ID_LEN, systemId);

        // LED1_PIO = OPEN_PIO; 
    }
    break;

    case GAPROLE_ADVERTISING:
    { 
      if((sysnonactive == TRUE) && (activeAccAction == FALSE))
        {
         HalI2CInit(TOUCH_ADDRESS, I2C_CLOCK_RATE); 
         mpr03x_stop();//(client);
        //avtive acc //v1008 modify
        pBuf[0]=MPR03X_FC_REG; //v1008 modify
        pBuf[1]=CDT<<5 | MPR03X_SFI_4 | MPR03X_ESI_64MS;//MPR03X_ESI_1MS;
	HalI2CWrite(2,pBuf);         //v1008 modify  
        activeAccAction = TRUE;
        mpr03x_start();//(client);
        ///////////////////////////////////
            HalI2CInit(ACC_ADDRESS, I2C_CLOCK_RATE);
            pBuf[0] = CTRL_REG1;
            pBuf[1] = (ASLP_RATE_12_5HZ + DATA_RATE_12_5HZ) | (!ACTIVE_MASK);
           HalI2CWrite(2, pBuf);
        ///////////////////////////////////////
         oneData[0].count = 0;
         oneData[1].count = 0;
         oneData[2].count = 0;
         rawDataStart = 0;
         rawDataStop  = 0;
         saveRawDataIndex();
        } 
      else if((sysnonactive == FALSE) && (activeAccAction == TRUE))
        {
          HalI2CInit(TOUCH_ADDRESS, I2C_CLOCK_RATE);
          mpr03x_stop();//(client);
        //avtive acc //v1008 modify
        pBuf[0]=MPR03X_FC_REG; //v1008 modify
        pBuf[1]=CDT<<5 | MPR03X_SFI_4 | MPR03X_ESI_8MS;//MPR03X_ESI_1MS;
	HalI2CWrite(2,pBuf);         //v1008 modify  
        activeAccAction = FALSE;
        mpr03x_start();//(client);
        /////////////////////////////////////////
                ///////////////////////////////////
            HalI2CInit(ACC_ADDRESS, I2C_CLOCK_RATE);
            pBuf[0] = CTRL_REG1;
            pBuf[1] = (ASLP_RATE_12_5HZ + DATA_RATE_12_5HZ) | (ACTIVE_MASK);
           HalI2CWrite(2, pBuf);
        /////////////////////////////////////
        ////////////////////////////////////////
        }        
        // LED2_PIO = OPEN_PIO;
			 //when disconnected, adc analog channel off
//		  HalADCPeripheralSetting(HAL_ADC_CHANNEL_0,IO_FUNCTION_GPIO);
//		  HalADCToggleChannel(HAL_ADC_CHANNEL_0,ADC_CHANNEL_ON);
    }
    break;

    case GAPROLE_CONNECTED:
    {
        // LED3_PIO = OPEN_PIO;  
        //when connected, adc analog channel on
        //HalADCPeripheralSetting(HAL_ADC_CHANNEL_0,IO_FUNCTION_PERI);
	//HalADCToggleChannel(HAL_ADC_CHANNEL_0,ADC_CHANNEL_ON);       
        //set i2c device address  //v112 modify
//	HalI2CInit(TOUCH_ADDRESS, I2C_CLOCK_RATE);                         //v112 modify
//        if(sysnonactive == TRUE)
//        {
//          mpr03x_stop();//(client);
//        //avtive acc //v1008 modify
//        pBuf[0]=MPR03X_FC_REG; //v1008 modify
//        pBuf[1]=CDT<<5 | MPR03X_SFI_4 | MPR03X_ESI_8MS;//MPR03X_ESI_1MS;//v1008 modify	
//	HalI2CWrite(2,pBuf);         //v1008 modify  
//        //activeAccAction = TRUE;
//        mpr03x_start();//(client);
//        sysnonactive = FALSE;
//        }         
    }
    break;

    case GAPROLE_WAITING:
    {
    }
    break;

    case GAPROLE_WAITING_AFTER_TIMEOUT:
    {
    }
    break;

    case GAPROLE_ERROR:
    {
    }
    break;

    default:
    {

    }
    break;

    }

    gapProfileState = newState;

    VOID gapProfileState;     // added to prevent compiler warning with
    // "CC2540 Slave" configurations


}

/*********************************************************************
 * @fn      battCB
 *
 * @brief   Callback function for battery service.
 *
 * @param   event - service event
 *
 * @return  none
 */
static void battCB(uint8 event)
{
    if (event == BATT_LEVEL_NOTI_ENABLED)
    {
        // if connected start periodic measurement
       if (gapProfileState == GAPROLE_CONNECTED)
        {
            osal_start_timerEx( simpleBLEPeripheral_TaskID, BATT_PERIODIC_EVT, DEFAULT_BATT_PERIOD );
        }
    }
    else if (event == BATT_LEVEL_NOTI_DISABLED)
    {
        // stop periodic measurement
        osal_stop_timerEx( simpleBLEPeripheral_TaskID, BATT_PERIODIC_EVT );
    }
}

/*********************************************************************
 * @fn      battPeriodicTask
 *
 * @brief   Perform a periodic task for battery measurement.
 *
 * @param   none
 *
 * @return  none
 */
static void battPeriodicTask( void )
{
    if (gapProfileState == GAPROLE_CONNECTED)
    {
        // perform battery level check
        Batt_MeasLevel( ); 

        // Restart timer
        osal_start_timerEx( simpleBLEPeripheral_TaskID, BATT_PERIODIC_EVT, DEFAULT_BATT_PERIOD );
    }
}

/*********************************************************************
 * @fn      simpleProfileChangeCB
 *
 * @brief   Callback from SimpleBLEProfile indicating a value change
 *
 * @param   paramID - parameter ID of the value that was changed.
 *
 * @return  none
 */
static void simpleProfileChangeCB( uint8 paramID )
{
    uint16 newValue;
    uint32 clock;

    switch ( paramID )
    {
    case HEALTH_SYNC:

        SimpleProfile_GetParameter( HEALTH_SYNC, &newValue );

        // if (newValue == SYNC_CODE)
        {

            ALT_MIN = (int16)newValue;
            
            // send data length
            uint16 length = dataLength();
            SimpleProfile_SetParameter( HEALTH_DATA_HEADER, 2,  &length);

            // to 0
            readTheI = 0;

            osal_start_timerEx( simpleBLEPeripheral_TaskID, READ_EVT, READ_INTERVAL );
        }

        break;

    case HEALTH_TIMEZONE:

        // init clock form app
        SimpleProfile_GetParameter( HEALTH_TIMEZONE, &timezone );

        break;

    case HEALTH_CLOCK:

        // init clock form app
        SimpleProfile_GetParameter( HEALTH_CLOCK, &clock );

        osal_setClock(clock);

        UTCTime now;

        now = osal_getClock();

        UTCTimeStruct date;

        osal_ConvertUTCTime(&date, now);

        break;
    case HEALTH_DATA_BODY:

        // eepromRead();

        break;
///////////////////////////////////////////////////
        case HEALTH_SYSACTIVE:

        // init clock form app
        SimpleProfile_GetParameter( HEALTH_SYSACTIVE, &sysnonactive );

        break;
///////////////////////////////////////////////////
    default:
        // should not reach here!
        break;
    }
}

/*********************************************************************
 * @fn      closeAllPIO
 *
 * @param   none
 *
 * @return  none
 */

static void closeAllPIO(void){  
    LED0_PIO = CLOSE_PIO;
    LED1_PIO = CLOSE_PIO;
    LED2_PIO = CLOSE_PIO;
    LED3_PIO = CLOSE_PIO;
    LED4_PIO = CLOSE_PIO;
    LED5_PIO = CLOSE_PIO;
    LED6_PIO = CLOSE_PIO;
    LED7_PIO = CLOSE_PIO;
    LED8_PIO = CLOSE_PIO;
    LED9_PIO = CLOSE_PIO;
    LED10_PIO = CLOSE_PIO;
    LED11_PIO = CLOSE_PIO;
	 led_status=0x0000;
	 LED_POWER=BOOSTOFF;
	 //P1_3 = 0;
	 P0_0 = 0;//VBAT ANALOG INPUT PORT

    P1_4 = 0;
    P1_5 = 0;
    osal_start_timerEx( simpleBLEPeripheral_TaskID, CLOSE_ALL_EVT, CLOSE_ALL_1s_EVT );
}

/*********************************************************************
 * @fn      openAllLED
 *
 * @param   none
 *
 * @return  none
 */

//static void openAllLED(void){
//
//    LED0_PIO = OPEN_PIO;
//    LED1_PIO = OPEN_PIO;
//    LED2_PIO = OPEN_PIO;
//    LED3_PIO = OPEN_PIO;
//    LED4_PIO = OPEN_PIO;
//    LED5_PIO = OPEN_PIO;
//    LED6_PIO = OPEN_PIO;
//    LED7_PIO = OPEN_PIO;
//    LED8_PIO = OPEN_PIO;
//    LED9_PIO = OPEN_PIO;
//    LED10_PIO = OPEN_PIO;
//    LED11_PIO = OPEN_PIO;
//	 led_status=0x0FFF;
//	 LED_POWER=BOOSTON;
//}


/*********************************************************************
 * @fn      time
 *
 * @param   none
 *
 * @return  none
 */

static void toggleLEDWithTime(uint8 num, uint8 io){

	if(CLOSE_PIO==io)
		led_status &=~ BV(num);
	else
		led_status |= BV(num);
	if(0 == led_status)
        {
		LED_POWER=BOOSTOFF;
                osal_start_timerEx( simpleBLEPeripheral_TaskID, CLOSE_ALL_EVT, CLOSE_ALL_1s_EVT );
        }
	else
		LED_POWER=BOOSTON;

    switch(num){
        case 1:
            LED1_PIO = io;
            break;
        case 2:
            LED2_PIO = io;
            break;
        case 3:
            LED3_PIO = io;
            break;
        case 4:
            LED4_PIO = io;
            break;
        case 5:
            LED5_PIO = io;
            break;
        case 6:
            LED6_PIO = io;
            break;
        case 7:
            LED7_PIO = io;
            break;
        case 8:
            LED8_PIO = io;
            break;
        case 9:
            LED9_PIO = io;
            break;
        case 10:
            LED10_PIO = io;
            break;
        case 11:
            LED11_PIO = io;
            break;
        case 0:
            LED0_PIO = io;
            break;
        default:
            break; 
    }
}

static void blinkLED(void){

    blinkPIO = !blinkPIO;

    toggleLEDWithTime(blinkMinutes, blinkPIO);

    osal_start_timerEx( simpleBLEPeripheral_TaskID, BLINK_LED_EVT, BLINK_LED_INTERVAL );
}

static void time(void){

    lockSlip = 1;

    // get current time
    UTCTime current;
    UTCTimeStruct currentTm;

    current = osal_getClock();
    osal_ConvertUTCTime(&currentTm, current);

    // display hour
    uint8 hour = currentTm.hour;

    if (hour >= 12)
    {
        hour = hour - 12;
    }

    // display minutes
    blinkMinutes = currentTm.minutes / 5;

    if (hour == blinkMinutes)
    {
        if (blinkMinutes ==11)
        {
            blinkMinutes = 10;
        }else{
            blinkMinutes++;
        }
    }

    toggleLEDWithTime(hour, OPEN_PIO);

    blinkLED();

    // stop time
    osal_start_timerEx( simpleBLEPeripheral_TaskID, TIME_STOP_EVT, TIME_DISPLAY_INTERVAL );

}

static void longPressAndCycleLED6(void){

    lockSlip = 1;

   // eepromWrite(TAP_DATA_TYPE, 1);//123
    osal_start_timerEx( simpleBLEPeripheral_TaskID,FETALMOVEMENTRECORD_MAX_EVT,FETALMOVEMENTRECORD_MAX_EVT_PERIOD);
    longPressJudgeFlag = 1;
    osal_set_event( simpleBLEPeripheral_TaskID, CYCLE_LED_6_EVT );
}

//static void cycleLED12(void){
//
//    // lockSlip = 1;
//
//    osal_set_event( simpleBLEPeripheral_TaskID, CYCLE_LED_12_EVT );
//}


static void toggleAdvert(uint8 status){

    uint8 turnOnAdv = status;
    GAPRole_SetParameter(GAPROLE_ADVERT_ENABLED, sizeof( uint8 ), &turnOnAdv);
}

static uint16 dataLength(){
    if (rawDataStop >= rawDataStart)
    {
        return ((rawDataStop - rawDataStart) / 8) + DATA_TYPE_COUNT;
    }else{
        return ((rawDataStop - rawDataStart + EEPROM_ADDRESS_BLOCK_COUNT) / 8) + DATA_TYPE_COUNT;
    }
}

/*********************************************************************
 * @fn      accInit
 *
 * @param   none
 *
 * @return  none
 */
static void accInit( void )
{
    HalI2CInit(ACC_ADDRESS, I2C_CLOCK_RATE);

    uint8 pBuf[2], n;

    pBuf[0] = CTRL_REG2;
    pBuf[1] = RST_MASK;
    HalI2CWrite(2, pBuf);

    // make sure reset is ok
    do {
      pBuf[0] = CTRL_REG2;
      HalMotionI2CWrite(1, pBuf);
      HalMotionI2CRead(1, &pBuf[1]);
      n = pBuf[1];

    } while (n & RST_MASK);

    pBuf[0] = XYZ_DATA_CFG;
    pBuf[1] = FULL_SCALE_8G;
    HalI2CWrite(2, pBuf);      

    //use fifo
    pBuf[0] = F_SETUP;
    pBuf[1] = 0x40;
    HalI2CWrite(2, pBuf);
     
    pBuf[0] = FF_MT_CFG;//11 111 111
    pBuf[1] = 0xFF;
    HalI2CWrite(2, pBuf);
          
    pBuf[0] = FF_MT_THS;//1010 0000
    pBuf[1] = 0x11;
    HalI2CWrite(2, pBuf); 
          
    pBuf[0] = FF_MT_COUNT;//0000 0011
    pBuf[1] = 0x03;
    HalI2CWrite(2, pBuf); 
          
    pBuf[0] = CTRL_REG3;
    pBuf[1] = WAKE_FF_MT_MASK;//|PP_OD_MASK;
    HalI2CWrite(2, pBuf);
     
    pBuf[0] = CTRL_REG4;
    pBuf[1] = INT_EN_FF_MT_MASK;//|INT_EN_DRDY_MASK;//0
    HalI2CWrite(2, pBuf);
     
    pBuf[0] = CTRL_REG5;
    pBuf[1] = INT_CFG_FF_MT_MASK;
    HalI2CWrite(2, pBuf);
    
    // 50hz + low power mode, 15ua
    // put acc to active
    pBuf[0] = CTRL_REG2;
    pBuf[1] = SMOD_LOW_POWER | MOD_LOW_POWER | SLPE_MASK;
    HalI2CWrite(2, pBuf);

    pBuf[0] = CTRL_REG1;
    //pBuf[1] = (ASLP_RATE_12_5HZ + DATA_RATE_12_5HZ) | ACTIVE_MASK;
    pBuf[1] = (ASLP_RATE_12_5HZ + DATA_RATE_12_5HZ) | (!ACTIVE_MASK);
    HalI2CWrite(2, pBuf);

}


static uint8 accDataProcess(uint8 count)
{
	uint8 pBuf[2];
//	uint8 i,k;
        uint8 i;
        uint32 xyzAxisAbsdataMax[2] = {0,0};
        uint32 xyzAxisAbsdataMin[2] = {100000000,100000000};

	uint8 addr = OUT_X_MSB;
	uint8 *accBufCur;
        uint32 *xyzAxisAbsdata;

	HalI2CInit(ACC_ADDRESS, I2C_CLOCK_RATE);
        
     accStaticCount++;          
	accBufCur=osal_mem_alloc(MMA_FIFO_DEEPTH);
	osal_memset(accBufCur,0,MMA_FIFO_DEEPTH);
	if(accBufCur!=NULL)
	{
		osal_memset(accBufCur,0,MMA_FIFO_DEEPTH);
		HalMotionI2CWrite(1, &addr);//read from mma into accBuf and locate them begin in last tail
		HalMotionI2CRead(count * 6, accBufCur);
		mmaDataACnt=count;
	}
	else
	{
		//flagAccDataError=TRUE;
		mmaDataACnt=0;
		return 0;
	}
	if(mmaDataACnt<=SLIDE_MEAN_WIDTH)
	{
		return 0;
	}
	
		//change bytes into unions
//		osal_memset(mmaDataA,0,sizeof(mmaDataA));
		for(i = 0; i < mmaDataACnt; i ++)
		{
			mmaDataA[i].mmaAxis[0].int16data=(int16)((accBufCur[i*6] << 8) | accBufCur[i*6+1]);
			//mmaDataA[i].mmaAxis[0].int16data=mmaDataA[i].mmaAxis[0].int16data>>6;
			mmaDataA[i].mmaAxis[1].int16data=(int16)((accBufCur[i*6+2] << 8) | accBufCur[i*6+3]);
			//mmaDataA[i].mmaAxis[1].int16data=mmaDataA[i].mmaAxis[1].int16data>>6;
			mmaDataA[i].mmaAxis[2].int16data=(int16)((accBufCur[i*6+4] << 8) | accBufCur[i*6+5]);
			//mmaDataA[i].mmaAxis[2].int16data=mmaDataA[i].mmaAxis[2].int16data>>6;
		}
		for(i = 0; i < mmaDataACnt; i ++)
		{
			//mmaDataA[i].mmaAxis[0].int16data=(int16)((accBufCur[i*6] << 8) | accBufCur[i*6+1]);
			//mmaDataA[i].mmaAxis[0].int16data=mmaDataA[i].mmaAxis[0].int16data>>6;
                        mmaDataA[i].mmaAxis[0].int16data=mmaDataA[i].mmaAxis[0].int16data;
			//mmaDataA[i].mmaAxis[1].int16data=(int16)((accBufCur[i*6+2] << 8) | accBufCur[i*6+3]);
			//mmaDataA[i].mmaAxis[1].int16data=mmaDataA[i].mmaAxis[1].int16data>>6;
                        mmaDataA[i].mmaAxis[1].int16data=mmaDataA[i].mmaAxis[1].int16data;
			//mmaDataA[i].mmaAxis[2].int16data=(int16)((accBufCur[i*6+4] << 8) | accBufCur[i*6+5]);
			//mmaDataA[i].mmaAxis[2].int16data=mmaDataA[i].mmaAxis[2].int16data>>6;
                        mmaDataA[i].mmaAxis[2].int16data=mmaDataA[i].mmaAxis[2].int16data;
		}
    ///////////////三轴滤波,取Y轴、Z轴的模: 滤波系数放大1024倍，需要右移10?
	for(i=0;i< FilterCofdepth-1; i++)
		{
		mmaDataFilterTemp[i].mmaAxis[0].int32data= (int32)mmaDataFilterPredata[i].mmaAxis[0].int32data;
		mmaDataFilterTemp[i].mmaAxis[1].int32data= (int32)mmaDataFilterPredata[i].mmaAxis[1].int32data;
		//mmaDataFilterTemp[i].mmaAxis[2].int32data= (int32)mmaDataFilterPredata[i].mmaAxis[2].int32data;
		}
	for(i=FilterCofdepth-1;i< mmaDataACnt+FilterCofdepth; i++)
		{
		mmaDataFilterTemp[i].mmaAxis[0].int32data = (int32)mmaDataA[i-FilterCofdepth+1].mmaAxis[1].int16data;
		mmaDataFilterTemp[i].mmaAxis[1].int32data = (int32)mmaDataA[i-FilterCofdepth+1].mmaAxis[2].int16data;
		//mmaDataFilterTemp[i].mmaAxis[2].int32data = (int32)mmaDataA[i-FilterCofdepth].mmaAxis[2].int16data;
		}	
	xyzAxisAbsdata=osal_mem_alloc(DATA_A_CNT_MAX);
	osal_memset(xyzAxisAbsdata,0,DATA_A_CNT_MAX);
         for(i=0;i<mmaDataACnt;i++)
	{
		/*mmaDataFilter[i].mmaAxis[0].int32data =   ( (mmaDataFilterTemp[0+i].mmaAxis[0].int32data+ mmaDataFilterTemp[10+i].mmaAxis[0].int32data)*filterCof[0]+\
	                                                                          (mmaDataFilterTemp[1+i].mmaAxis[0].int32data+ mmaDataFilterTemp[9+i].mmaAxis[0].int32data)*filterCof[1]+\
	                                                                          (mmaDataFilterTemp[2+i].mmaAxis[0].int32data+ mmaDataFilterTemp[8+i].mmaAxis[0].int32data)*filterCof[2]+\
	                                                                          (mmaDataFilterTemp[3+i].mmaAxis[0].int32data+ mmaDataFilterTemp[7+i].mmaAxis[0].int32data)*filterCof[3]+\
	                                                                          (mmaDataFilterTemp[4+i].mmaAxis[0].int32data+ mmaDataFilterTemp[6+i].mmaAxis[0].int32data)*filterCof[4]+\
	                                                                           mmaDataFilterTemp[5+i].mmaAxis[0].int32data*filterCof[5])>>10;*/
		mmaDataFilter[i].mmaAxis[0].int32data =   ( (mmaDataFilterTemp[0+i].mmaAxis[0].int32data+ mmaDataFilterTemp[10+i].mmaAxis[0].int32data)*filterCof[0]+\
	                                                    (mmaDataFilterTemp[1+i].mmaAxis[0].int32data+ mmaDataFilterTemp[9+i].mmaAxis[0].int32data)*filterCof[1]+\
	                                                    (mmaDataFilterTemp[2+i].mmaAxis[0].int32data+ mmaDataFilterTemp[8+i].mmaAxis[0].int32data)*filterCof[2]+\
	                                                    (mmaDataFilterTemp[3+i].mmaAxis[0].int32data+ mmaDataFilterTemp[7+i].mmaAxis[0].int32data)*filterCof[3]+\
	                                                    (mmaDataFilterTemp[4+i].mmaAxis[0].int32data+ mmaDataFilterTemp[6+i].mmaAxis[0].int32data)*filterCof[4]+\
	                                                     mmaDataFilterTemp[5+i].mmaAxis[0].int32data*filterCof[5])>>10;	
		mmaDataFilter[i].mmaAxis[1].int32data =   ( (mmaDataFilterTemp[0+i].mmaAxis[1].int32data+ mmaDataFilterTemp[10+i].mmaAxis[1].int32data)*filterCof[0]+\
	                                                    (mmaDataFilterTemp[1+i].mmaAxis[1].int32data+ mmaDataFilterTemp[9+i].mmaAxis[1].int32data)*filterCof[1]+\
	                                                    (mmaDataFilterTemp[2+i].mmaAxis[1].int32data+ mmaDataFilterTemp[8+i].mmaAxis[1].int32data)*filterCof[2]+\
	                                                    (mmaDataFilterTemp[3+i].mmaAxis[1].int32data+ mmaDataFilterTemp[7+i].mmaAxis[1].int32data)*filterCof[3]+\
	                                                    (mmaDataFilterTemp[4+i].mmaAxis[1].int32data+ mmaDataFilterTemp[6+i].mmaAxis[1].int32data)*filterCof[4]+\
	                                                     mmaDataFilterTemp[5+i].mmaAxis[1].int32data*filterCof[5])>>10;         
                xyzAxisAbsdata[i] = (uint32)(mmaDataFilter[i].mmaAxis[0].int32data*mmaDataFilter[i].mmaAxis[0].int32data + mmaDataFilter[i].mmaAxis[1].int32data*mmaDataFilter[i].mmaAxis[1].int32data);
     
        }


       for(i=0;i<mmaDataACnt;i++)
       {
		if(i <( mmaDataACnt>>1))
			{
//                          xyzAxisAbsdataMax[0] = MAX(xyzAxisAbsdata[i],xyzAxisAbsdata[i+1]);
//                          xyzAxisAbsdataMin[0] = MIN(xyzAxisAbsdata[i],xyzAxisAbsdata[i+1]);
			 if(xyzAxisAbsdata[i] > xyzAxisAbsdataMax[0])
			     {
			     xyzAxisAbsdataMax[0]  = xyzAxisAbsdata[i];
			 	}
			 else
			 	{
			       xyzAxisAbsdataMax[0]  = xyzAxisAbsdataMax[0];
			 	}
			 if(xyzAxisAbsdata[i] <  xyzAxisAbsdataMin[0])
			 	{
			       xyzAxisAbsdataMin[0]  = xyzAxisAbsdata[i];
			 	}
			 else
			 	{
			        xyzAxisAbsdataMin[0]  =  xyzAxisAbsdataMin[0];
			 	}
			}
		 else
			{
//                          xyzAxisAbsdataMax[1] = MAX(xyzAxisAbsdata[i-1],xyzAxisAbsdata[i]);
//                          xyzAxisAbsdataMin[1] = MIN(xyzAxisAbsdata[i-1],xyzAxisAbsdata[i]);
			 if(xyzAxisAbsdata[i] > xyzAxisAbsdataMax[1])
			     {
			     xyzAxisAbsdataMax[1]  = xyzAxisAbsdata[i];
			 	}
			 else
			 	{
			       xyzAxisAbsdataMax[1]  = xyzAxisAbsdataMax[1];
			 	}
			 if(xyzAxisAbsdata[i] <  xyzAxisAbsdataMin[1])
			 	{
			       xyzAxisAbsdataMin[1]  = xyzAxisAbsdata[i];
			 	}
			 else
			 	{
			        xyzAxisAbsdataMin[1]  =  xyzAxisAbsdataMin[1];
			 	}
			}		 	
             	}
	    
             xyzAxisAbsdataAvg[0] = (xyzAxisAbsdataMax[0]+ xyzAxisAbsdataMin[0])>>1;
	      xyzAxisAbsdataDiff[0] = xyzAxisAbsdataMax[0]- xyzAxisAbsdataMin[0];
             xyzAxisAbsdataAvg[1] = (xyzAxisAbsdataMax[1]+ xyzAxisAbsdataMin[1])>>1;
	      xyzAxisAbsdataDiff[1] = xyzAxisAbsdataMax[1]- xyzAxisAbsdataMin[1];

		///////////////////////////////////////////重新量化 门限判断 初步估计步数

             for (i=0;i<mmaDataACnt-1;i++)
             	{
             	    if(xyzAxisAbsdata[i+1]>xyzAxisAbsdata[i])
             	    	{
			 if(xyzAxisAbsdata[i+1] - xyzAxisAbsdata[i]>DYNAMIC_PRECISE)
			 	{
			 	xyzAxisAbsdataNew[i+1] = xyzAxisAbsdata[i+1];
			 	}
			 else
			 	{
			 	xyzAxisAbsdataNew[i+1] = xyzAxisAbsdataNew[i];
			 	}
             	    	}
	            else
	            	{
			  if(xyzAxisAbsdata[i] - xyzAxisAbsdata[i+1]>DYNAMIC_PRECISE)
			 	{
			 	xyzAxisAbsdataNew[i+1] = xyzAxisAbsdata[i+1];
			 	}
			  else
			 	{
			 	xyzAxisAbsdataNew[i+1] = xyzAxisAbsdataNew[i];
			 	}		
             	    	}           
			
                        xyzAxisAbsdataOld[i+1] = xyzAxisAbsdataNew[i];
			if(i <( mmaDataACnt>>1))
				{
                             if(((xyzAxisAbsdataOld[i+1]>xyzAxisAbsdataAvg[0]) && (xyzAxisAbsdataAvg[0]> xyzAxisAbsdataNew[i+1] )) ||((xyzAxisAbsdataOld[i+1] < xyzAxisAbsdataAvg[0]) && (xyzAxisAbsdataAvg[0]< xyzAxisAbsdataNew[i+1] )))
                             	{
                             	if ((timeWindowCount < timeWindowCountMax) && (timeWindowCount > timeWindowCountMin) )
				     {
                                       if(xyzAxisAbsdataDiff[0] < XyzAxisAbsdataDiffTH)
                                           {
                                            if(xyzAxisAbsdataAvgPre >xyzAxisAbsdataAvg[0])
                                                 {
                                                 if(xyzAxisAbsdataAvgPre- xyzAxisAbsdataAvg[0] < XyzAxisAbsdataAvgTH)
                                                     {
                                                     stepCount[countPeriod] = stepCount[countPeriod] + 1;
                                                     }
                                                 } 
                                            else
                                               {  
                                               if(xyzAxisAbsdataAvg[0]-xyzAxisAbsdataAvgPre < XyzAxisAbsdataAvgTH)
                                                     {
                                                     stepCount[countPeriod] = stepCount[countPeriod] + 1;
                                                     }
                                                 }                                            
                                           }
                                       else
                                           {
                                           stepCount[countPeriod] = stepCount[countPeriod] + 1;
                                           }			   
                                     }
                                 timeWindowCount = 0;
                             	 }
			  else
			     {
                              timeWindowCount = timeWindowCount + 1;
			      }
				}
		      else
				{
                             if(((xyzAxisAbsdataOld[i+1]>xyzAxisAbsdataAvg[1]) && (xyzAxisAbsdataAvg[1]> xyzAxisAbsdataNew[i+1] )) ||((xyzAxisAbsdataOld[i+1] < xyzAxisAbsdataAvg[1]) && (xyzAxisAbsdataAvg[1]< xyzAxisAbsdataNew[i+1] )))
                             	{
                             	if ((timeWindowCount < timeWindowCountMax) && (timeWindowCount > timeWindowCountMin) )
				    {
                                       if(xyzAxisAbsdataDiff[1] < XyzAxisAbsdataDiffTH)
                                           {
                                            if(xyzAxisAbsdataAvg[1] >xyzAxisAbsdataAvg[0])
                                                 {
                                                 if(xyzAxisAbsdataAvg[1]- xyzAxisAbsdataAvg[0] < XyzAxisAbsdataAvgTH)
                                                     {
                                                     stepCount[countPeriod] = stepCount[countPeriod] + 1;
                                                     }
                                                 } 
                                            else
                                               {  
                                               if(xyzAxisAbsdataAvg[0]-xyzAxisAbsdataAvg[1] < XyzAxisAbsdataAvgTH)
                                                     {
                                                     stepCount[countPeriod] = stepCount[countPeriod] + 1;
                                                     }
                                                 }                                            
                                           }
                                       else
                                           {
                                           stepCount[countPeriod] = stepCount[countPeriod] + 1;
                                           }    
                                    }
                                    timeWindowCount = 0;
                             	    }
				    else
				        {
                                        timeWindowCount = timeWindowCount + 1;
					}
				}
             	}
       xyzAxisAbsdataAvgPre = xyzAxisAbsdataAvg[1];
       osal_mem_free(xyzAxisAbsdata);
	//**********************************************观察5S中，4个TIMEZONE周期
        countPeriod = countPeriod + 2; 
	if(countPeriod > 2)
		{
               count0 = stepCount[countPeriod-1] ; 
               count1 = stepCount[countPeriod-2] ; 
               count2 = stepCount[countPeriod-3] ; 
               count3 = stepCount[countPeriod-4] ; 
	       if( count0 + count1 + count2+ count3 >= 4)
                      	{
                             stepCountTotal =  count0 +  count1 +  count2+ count3;
			       eepromWrite(STEP_DATA_TYPE, stepCountTotal);
		        }
//	       else 
//	        	{                            
//	        	stepCountTotal =  0;
//			       eepromWrite(STEP_DATA_TYPE, stepCountTotal);
//			}
             countPeriod = 0;
             stepCount[0]   = 0;
             stepCount[1]   = 0;
             stepCount[2]   = 0;
             stepCount[3]   = 0;
	};  
        osal_mem_free(accBufCur);
        ///////////////////////////////////////补位
        for(i=0;i< FilterCofdepth-1; i++)
	    {
	     mmaDataFilterPredata[i].mmaAxis[0].int32data = mmaDataA[mmaDataACnt-FilterCofdepth+i+1].mmaAxis[1].int16data;
	     mmaDataFilterPredata[i].mmaAxis[1].int32data = mmaDataA[mmaDataACnt-FilterCofdepth+i+1].mmaAxis[2].int16data;;
	     //mmaDataFilterPredata[i].mmaAxis[2].int32data = mmaDataA[mmaDataACnt-FilterCofdepth+i+1].mmaAxis[2].int16data;;
	     }
        //////////////////////////////////////静止算法
        SilentCountPeriod = SilentCountPeriod + 1; 
	if(SilentCountPeriod <= ACC_STATIC_COUNT_MAX)
		{
               SilentCount  = SilentCount + stepCountTotal;
                }
        else
             {
             SilentCountPeriod  = 0;
             if(SilentCount == 0 )
                {
                //////////////////////////////////silent operation
                flagAccStatic=TRUE;   
                HalI2CInit(ACC_ADDRESS, I2C_CLOCK_RATE); //v121 
                //set acc into standby, so can write
                pBuf[0] = CTRL_REG1; //0x2A
                pBuf[1] = 0;
                HalI2CWrite(2, pBuf);
                //enable motion int
                pBuf[0] = CTRL_REG4;
                pBuf[1] = INT_EN_FF_MT_MASK;
                HalI2CWrite(2, pBuf);
                //set acc back into active
                pBuf[0] = CTRL_REG1;
                pBuf[1] = (ASLP_RATE_12_5HZ + DATA_RATE_12_5HZ) | ACTIVE_MASK;
                HalI2CWrite(2, pBuf);  
                //////////////////////////////////////////////////                
                }
             else
                {
                SilentCount = 0;
                }
             }    
       ////////////////////////////////////////////////////////        
        return 1;
} 

// for eeprom

static void eepromWrite(uint8 type, uint8 cnt){

    // convert type to pointer
    uint8 pointer = type - 1;

    // get current time, then convert to struct
    UTCTime current;
    UTCTimeStruct currentTm;

    current = osal_getClock();
    osal_ConvertUTCTime(&currentTm, current);

    //count step by hour
    if (type == STEP_DATA_TYPE)
    {
        currentTm.minutes = 0;
    }

    currentTm.seconds = 0;

    if (oneData[pointer].hourSeconds == 0)       // if data is empty
    {
        oneData[pointer].tm = currentTm;
        oneData[pointer].hourSeconds = osal_ConvertUTCSecs(&oneData[pointer].tm);

        oneData[pointer].count = cnt;
        oneData[pointer].type = type;

    }else if(oneData[pointer].tm.year != currentTm.year ||
             oneData[pointer].tm.month != currentTm.month ||
             oneData[pointer].tm.day != currentTm.day ||
             oneData[pointer].tm.minutes != currentTm.minutes ||         
             oneData[pointer].tm.hour != currentTm.hour){                // if pass a hour or a minute, should write into eeprom

        // inti i2c
        HalI2CInit(EEPROM_ADDRESS, I2C_CLOCK_RATE);

        // define array with address and data
        uint8 dBuf[10] = {
            HI_UINT16(rawDataStop),    // address
            LO_UINT16(rawDataStop),    // address
            LO_UINT16(LO_UINT32(oneData[pointer].hourSeconds)),
            HI_UINT16(LO_UINT32(oneData[pointer].hourSeconds)),
            LO_UINT16(HI_UINT32(oneData[pointer].hourSeconds)),
            HI_UINT16(HI_UINT32(oneData[pointer].hourSeconds)),
            LO_UINT16(oneData[pointer].count),
            HI_UINT16(oneData[pointer].count),
            oneData[pointer].type,
            timezone
        };

        HalI2CWrite(sizeof(dBuf), dBuf);
        HalI2CAckPolling();

        rawDataStop += 8;

        // arrive maxsize
        if (rawDataStop >= EEPROM_ADDRESS_DATA_MAX)
        {
            rawDataStop = 0;
        }

        // space is full
        if (rawDataStop == rawDataStart)
        {
            rawDataStart += 8;
        }

       // uint16 length = dataLength();//127

        // for debug
        // SimpleProfile_SetParameter( HEALTH_DATA_HEADER, 2,  &rawDataStop);
        //SimpleProfile_SetParameter( HEALTH_DATA_HEADER, 2,  &length);//v127
        //SimpleProfile_SetParameter( HEALTH_SYNC, 8, dBuf);


        // refresh oneData[pointer] with new data
        oneData[pointer].tm = currentTm;
        oneData[pointer].hourSeconds = osal_ConvertUTCSecs(&oneData[pointer].tm);

        oneData[pointer].count = cnt;

        // save start and stop index of raw data
        saveRawDataIndex();

    }else{      // if in same hour

        oneData[pointer].count += cnt;
    }

}

static uint8 eepromRead(void){

    if (gapProfileState != GAPROLE_CONNECTED)
    {
        //fixed BLE NON ADV
        readTheI = 99;
        return FALSE;
    }

    HalI2CInit(EEPROM_ADDRESS, I2C_CLOCK_RATE);

    // if eeprom still have data
    if(rawDataStart != rawDataStop){

        uint8 dBuf[8], addr[2] = {
            HI_UINT16(rawDataStart),
            LO_UINT16(rawDataStart)
        };

        HalI2CWrite(sizeof(addr), addr);
        HalI2CRead(sizeof(dBuf), dBuf);

        rawDataStart += 8;

        // arrive maxsize
        if (rawDataStart >= EEPROM_ADDRESS_DATA_MAX)
        {
            rawDataStart = 0;
        }

        SimpleProfile_SetParameter( HEALTH_DATA_BODY, 8,  dBuf);
        //SimpleProfile_SetParameter( HEALTH_SYNC, 8, dBuf);

        saveRawDataIndex();

        readTheI = 0;
    }

    // read no-saved data
    if (rawDataStart == rawDataStop)
    {
        
        uint8 dBuf[8] = {
            LO_UINT16(LO_UINT32(oneData[readTheI].hourSeconds)),
            HI_UINT16(LO_UINT32(oneData[readTheI].hourSeconds)),
            LO_UINT16(HI_UINT32(oneData[readTheI].hourSeconds)),
            HI_UINT16(HI_UINT32(oneData[readTheI].hourSeconds)),
            LO_UINT16(oneData[readTheI].count),
            HI_UINT16(oneData[readTheI].count),
            oneData[readTheI].type,
            timezone
        };

        SimpleProfile_SetParameter( HEALTH_DATA_BODY, 8,  dBuf);
        //SimpleProfile_SetParameter( HEALTH_SYNC, 8, dBuf);

        oneData[readTheI].count = 0;

        readTheI++;
    }

    return TRUE;
}

static void saveRawDataIndex(void){

    HalI2CInit(EEPROM_ADDRESS, I2C_CLOCK_RATE);

    uint8 dBuf[6] = {
        HI_UINT16(EEPROM_POSITION_STEP_DATA),    // address
        LO_UINT16(EEPROM_POSITION_STEP_DATA),    // address
        LO_UINT16(rawDataStart),
        HI_UINT16(rawDataStart),
        LO_UINT16(rawDataStop),
        HI_UINT16(rawDataStop)
    };

    HalI2CWrite(sizeof(dBuf), dBuf);
    HalI2CAckPolling();

}

static void loadRawDataIndex(void){

    HalI2CInit(EEPROM_ADDRESS, I2C_CLOCK_RATE);

    uint8 addr1[2] = {
        HI_UINT16(EEPROM_POSITION_STEP_DATA),
        LO_UINT16(EEPROM_POSITION_STEP_DATA)
    }, dBuf[4];

    HalI2CWrite(sizeof(addr1), addr1);
    HalI2CRead(sizeof(dBuf), dBuf);

    // if eeprom saved index previously
    if (!(dBuf[0] == 0xff && dBuf[1] == 0xff))
    {
        rawDataStart = (uint16)((dBuf[1] << 8) | dBuf[0]);
        rawDataStop = (uint16)((dBuf[3] << 8) | dBuf[2]);
    }

    // for debug
    // uint8 d[8];

    // osal_memcpy(d, &rawDataStart, 2);
    // osal_memcpy(&d[2], &rawDataStop, 2);
    // SimpleProfile_SetParameter( HEALTH_SYNC, 8, d);
}

/*********************************************************************
 * @fn      touchInit
 *
 * @param   none
 *
 * @return  none
*********************************************************************/
	
	void Delay1(uint16 cnt)
	{
		uint16 i;
		for(i=0;i<cnt;i++)
                {}
	}

	void Delay2(uint16 cnt)
	{
		uint16 i;
		for(i=0;i<cnt;i++)
                { 
		  Delay1(1000);
		}
	}
        void DelayMs(uint16 cnt)
        {
          uint16 i;
          for(i=0;i<cnt;i++)
          {
            Delay1(360);;
            Delay2(1);
          }
        }

//static void mpr03x_soft_reset(void)//(struct i2c_client *client)
//{
//    i2c_smbus_write_byte_data(client,0x5f,0x55);  
//}
//there's no register in address 0x5f

static void  mpr03x_stop(void)//(struct i2c_client *client)
{
 	//u8 data;
  	//data = i2c_smbus_read_byte_data(client , MPR03X_EC_REG);
  	//i2c_smbus_write_byte_data(client ,MPR03X_EC_REG, (data & 0x40));    

	uint8 addr, val;
	uint8 pBuf[2];

	//read MPR03X_EC_REG
	addr=MPR03X_EC_REG;
	HalMotionI2CWrite(1, &addr);
	HalMotionI2CRead(1,&val);
	//write MPR03X_EC_REG
	pBuf[0]=MPR03X_EC_REG;
	pBuf[1]=val&0x40;
	HalI2CWrite(2,pBuf);
}
static void mpr03x_start(void)//(struct i2c_client *client)
{
	//set mpr031 run mode with Run1 mode, 2 pad with INT 
	//u8 data;
  	//data = i2c_smbus_read_byte_data(client , MPR03X_EC_REG);
	//data &= ~0x0f;
	//i2c_smbus_write_byte_data(client ,MPR03X_EC_REG, (data | MPR03X_E1_E2_IRQ));    

	uint8 addr, val;
	uint8 pBuf[2];

	//read MPR03X_EC_REG
	addr=MPR03X_EC_REG;
	HalMotionI2CWrite(1, &addr);
	HalMotionI2CRead(1,&val);
	//write MPR03X_EC_REG
	val &=~0x0f;
	pBuf[0]=MPR03X_EC_REG;
	pBuf[1]=val | MPR03X_E1_IRQ|MPR03X_CALI_DISABLE ;//MPR03X_E1_E2_IRQ;
	HalI2CWrite(2,pBuf);
} 

#if defined AUTO_CONFIG
//Auto config CDC CDT with Run1 mode, 2 pad with INT
//For other senario, set the MPR03X_EC_REG accordingly, and use Exdata accordingly
//reture CDC and CDT with optimized value  
static int  mpr03x_autoconfig(struct mpr03x_touchkey_data  *pdata) 
{
  uint8 i;                                                             
  uint16 result, e1data;//, e2data;
  uint8 CDC = 30;  		
  uint8 CDT = 0x00;
  uint8 addr,value1,value2;
  uint8 pBuf[2];
  //struct i2c_client * client = pdata->client;
  //i2c_smbus_write_byte_data(client,MPR03X_EC_REG, 0x00);
	pBuf[0]=MPR03X_EC_REG;
	pBuf[1]=0x00;
	HalI2CWrite(2,pBuf);
  
  for( i=0; i<3; i++ ) 
  {
    CDT = CDT | (1<<(3-1-i));
    //i2c_smbus_write_byte_data(client,MPR03X_AFEC_REG,MPR03X_FFI_6| CDC); 
    //i2c_smbus_write_byte_data(client,MPR03X_FC_REG,CDT<<5 | MPR03X_SFI_4 | MPR03X_ESI_1MS);
    //i2c_smbus_write_byte_data(client,MPR03X_EC_REG, MPR03X_E1_E2_IRQ);
	pBuf[0]=MPR03X_AFEC_REG;
	pBuf[1]=MPR03X_FFI_6| CDC;
	HalI2CWrite(2,pBuf);
	pBuf[0]=MPR03X_FC_REG;
	pBuf[1]=CDT<<5 | MPR03X_SFI_4 | MPR03X_ESI_1MS;
	HalI2CWrite(2,pBuf);
	pBuf[0]=MPR03X_EC_REG;
	pBuf[1]=MPR03X_E1_IRQ;//MPR03X_E1_E2_IRQ
	HalI2CWrite(2,pBuf);
	 
    //msleep(10);
	 DelayMs(10);
	 
	//i2c_smbus_write_byte_data(client,MPR03X_EC_REG, 0x00);
   // e1data=((u16)i2c_smbus_read_byte_data(client,MPR03X_E0FDL_REG)) | 
	//				(((u16)i2c_smbus_read_byte_data(client,MPR03X_E0FDH_REG))<<8);
	//e2data=((u16)i2c_smbus_read_byte_data(client,MPR03X_E1FDL_REG)) | 
	//				(((u16)i2c_smbus_read_byte_data(client,MPR03X_E1FDH_REG))<<8);	
	pBuf[0]=MPR03X_EC_REG;
	pBuf[1]=0x00;
	HalI2CWrite(2,pBuf);
	addr=MPR03X_E0FDL_REG;
	HalMotionI2CWrite(1, &addr);
	HalMotionI2CRead(1,&value1);
	addr=MPR03X_E0FDH_REG;
	HalMotionI2CWrite(1, &addr);
	HalMotionI2CRead(1,&value2);
	e1data=((uint16)value1)|(((uint16)value2)<<8);
	
    //not used for Run1 mode, 2 pad with INT
	//if (e1data > e2data) 
	   result=e1data;
	//else 
	//   result=e2data;
	
	if(result > MPR03X_AC_USL_CT)
	   CDT = CDT ^ (1<<(3-1-i));	
  } 
  if(CDT== 0) CDT = 1;
	   CDC = 0x00;
  for( i=0; i < 6; i++ ) 
  {
    CDC = CDC | (1 << (6 - 1 - i));
    //i2c_smbus_write_byte_data(client,MPR03X_AFEC_REG,MPR03X_FFI_6| CDC); 
    //i2c_smbus_write_byte_data(client,MPR03X_FC_REG,CDT << 5 | MPR03X_SFI_4 | MPR03X_ESI_1MS);
    //i2c_smbus_write_byte_data(client,MPR03X_EC_REG, MPR03X_E1_E2_IRQ);
	pBuf[0]=MPR03X_AFEC_REG;
	pBuf[1]=MPR03X_FFI_6| CDC;
	HalI2CWrite(2,pBuf);
	pBuf[0]=MPR03X_FC_REG;
	pBuf[1]=CDT << 5 | MPR03X_SFI_4 | MPR03X_ESI_1MS;
	HalI2CWrite(2,pBuf);
	pBuf[0]=MPR03X_EC_REG;
	pBuf[1]=MPR03X_E1_IRQ;//MPR03X_E1_E2_IRQ
	HalI2CWrite(2,pBuf);
	
    //msleep(10);
	 DelayMs(10);
	//i2c_smbus_write_byte_data(client,MPR03X_EC_REG, 0x00);
	//e1data=((u16)i2c_smbus_read_byte_data(client,MPR03X_E0FDL_REG)) | 
	//				(((u16)i2c_smbus_read_byte_data(client,MPR03X_E0FDH_REG))<<8);
	//e2data=((u16)i2c_smbus_read_byte_data(client,MPR03X_E1FDL_REG)) | 
	//				(((u16)i2c_smbus_read_byte_data(client,MPR03X_E1FDH_REG))<<8);	
	//not used 
	//e3data=((u16)i2c_smbus_read_byte_data(client,MPR03X_E2FDL_REG)) | 
	//				(((u16)i2c_smbus_read_byte_data(client,MPR03X_E2FDH_REG))<<8);
	pBuf[0]=MPR03X_EC_REG;
	pBuf[1]=0x00;
	HalI2CWrite(2,pBuf);
	addr=MPR03X_E0FDL_REG;
	HalMotionI2CWrite(1, &addr);
	HalMotionI2CRead(1,&value1);
	addr=MPR03X_E0FDH_REG;
	HalMotionI2CWrite(1, &addr);
	HalMotionI2CRead(1,&value2);
	e1data=((uint16)value1)|(((uint16)value2)<<8);	
	
	//if (e1data > e2data) 
	//	result = e1data;
	//else 
	//	result = e2data;

	if ( result > MPR03X_AC_LSL_CS ) 
		  CDC = CDC ^(1 << (6 - 1 - i)) ;
   } 
		
	if (result > MPR03X_AC_USL_CT || result < MPR03X_AC_LSL_CT ) 
	  return 0;
	else
	{
	  pdata->CDC = CDC;
	  pdata->CDT = CDT;
	  return 1;
	}
}
#endif
static int mpr03x_phys_init(void)
	//(struct mpr03x_platform_data *platdata,
		//	    struct mpr03x_touchkey_data *pdata,
			//    struct i2c_client *client)
{
	uint8 CDC , CDT; //u8 CDC , CDT , data ,data1,data2; 
	//uint8 flagAutoConfigReturn=FALSE;
	//uint8 addr, val;
	uint8 pBuf[2];
	#if (TOUCH_BASELINE_MODE==TOUCH_BASELINE_EVERYTIME)
		uint8 data1, data2, addr, val;
	#endif
	struct mpr03x_touchkey_data *pdata;
	
	//set i2c device address
	HalI2CInit(TOUCH_ADDRESS, I2C_CLOCK_RATE);

	//Reset if has not reset properly
	//mpr03x_soft_reset();//(client);
	//if(i2c_smbus_read_byte_data(client,MPR03X_AFEC_REG)!=0x10 
	//		&& i2c_smbus_read_byte_data(client,MPR03X_EC_REG)!=0x00)
	//	dev_info(&client->dev,"mpr03x reset fail\n");
   pdata=osal_mem_alloc(sizeof(struct mpr03x_touchkey_data));
  	pdata->CDC =0x30; //0x24;
   pdata->CDT =1;
#ifdef AUTO_CONFIG
		//Auto search CDC, CDT
	//if (mpr03x_autoconfig(pdata))
	//   dev_info(&client->dev, "mpr03x auto Config Success\r\n"); 
	//else
	//   dev_info(&client->dev, "mpr03x auto Config Fail\r\n");
	flagAutoConfigReturn=mpr03x_autoconfig(pdata);
#endif
   CDC =  pdata->CDC;
  	CDT =  pdata->CDT ;
	//Configure AFE,then set into Run1 mode, 2 pad with INT
	mpr03x_stop();//(client);	
	//i2c_smbus_write_byte_data(client,MPR03X_AFEC_REG,MPR03X_FFI_6| CDC); 
	//i2c_smbus_write_byte_data(client,MPR03X_FC_REG,CDT<<5 | MPR03X_SFI_4 |MPR03X_ESI_1MS);
	pBuf[0]=MPR03X_AFEC_REG;
	pBuf[1]=MPR03X_FFI_6| CDC;
	HalI2CWrite(2,pBuf);
	pBuf[0]=MPR03X_FC_REG;
	pBuf[1]=CDT<<5 | MPR03X_SFI_4 | MPR03X_ESI_8MS;//MPR03X_ESI_1MS;	
	HalI2CWrite(2,pBuf);
	mpr03x_start();//(client);
	  
	//Wait for enough time (10ms example here) to get stable electrode data
	//msleep(10);	
        DelayMs(10);
        
	mpr03x_stop();//(client);
	//load 5MSB to set E1 baseline, baseline<=signal level
	//data1 = (i2c_smbus_read_byte_data(client,MPR03X_E0FDH_REG)<<6);
	//data2 = (i2c_smbus_read_byte_data(client,MPR03X_E0FDL_REG)>>2) & 0xF8;  
	//data = data1 | data2;
	//i2c_smbus_write_byte_data(client,MPR03X_E0BV_REG,data);

	#if (TOUCH_BASELINE_MODE==TOUCH_BASELINE_EVERYTIME)
		//if define baseline value on power up everytime
		/**/
		addr=MPR03X_E0FDH_REG;
		HalMotionI2CWrite(1, &addr);
		HalMotionI2CRead(1,&val);
		data1=val<<6;
		addr=MPR03X_E0FDL_REG;
		HalMotionI2CWrite(1, &addr);
		HalMotionI2CRead(1,&val);
		data2=(val>>2)&0xF8;
		pBuf[0]=MPR03X_E0BV_REG;
		pBuf[1]= data1 | data2;
		HalI2CWrite(2,pBuf);
	#else//TOUCH_BASELINE_MODE==TOUCH_BASELINE_DEFAULT
		//if define baseline value defaultly
		pBuf[0]=MPR03X_E0BV_REG;
		pBuf[1]=0xCA;//0xBA;
		HalI2CWrite(2,pBuf);
	#endif

	//Set baseline filtering	
	pBuf[0]=MPR03X_MHD_REG;
	pBuf[1]=0x01;
	HalI2CWrite(2,pBuf);	
	pBuf[0]=MPR03X_NHD_REG;
	pBuf[1]=0x01;
	HalI2CWrite(2,pBuf);	
	pBuf[0]=MPR03X_NCL_REG;
	pBuf[1]=0x0f;
	HalI2CWrite(2,pBuf);
	  
	//Set touch/release threshold
	pBuf[0]=MPR03X_E0TTH_REG;
	pBuf[1]=MPR03X_TOUCH_THRESHOLD;
	HalI2CWrite(2,pBuf);
	pBuf[0]=MPR03X_E0RTH_REG;
	pBuf[1]=MPR03X_RELEASE_THRESHOLD;
	HalI2CWrite(2,pBuf);
	
	//Set AFE  
	pBuf[0]=MPR03X_AFEC_REG;
	pBuf[1]=MPR03X_FFI_6| CDC;
	HalI2CWrite(2,pBuf);
	pBuf[0]=MPR03X_FC_REG;
	//pBuf[1]=CDT<<5 | MPR03X_SFI_4 | MPR03X_ESI_8MS;//MPR03X_ESI_4MS
        pBuf[1]=CDT<<5 | MPR03X_SFI_4 | MPR03X_ESI_64MS;//MPR03X_ESI_4MS //v1008 modify
	HalI2CWrite(2,pBuf);
	return 0;
		 
}
/*********************************************************************
 * @fn      ReadActualVref
 *
 * @brief  read actualVref from eeprom 
 *			if value is in correct range, it return 1 and use the reading result as the actualVref
 *			if value is not in correct range, it return 0 and use default 1240 as the actualVref
 *
 * @return  1: read success		0: read fail
 */
uint8 ReadActualVref(void)
{
	HalI2CInit(EEPROM_ADDRESS, I2C_CLOCK_RATE);
	uint8 dBuf[2], addr[2] = {
					HI_UINT16(ADC_VREF_ADDRESS_L),
					LO_UINT16(ADC_VREF_ADDRESS_L)
			  };
	HalI2CWrite(sizeof(addr), addr);
   HalI2CRead(sizeof(dBuf), dBuf);
	actualVref=BUILD_UINT16(dBuf[0],dBuf[1]);//dBuf[0]=low byte, dBuf[1]=high byte	
	if((actualVref>1040)&&(actualVref<1440))// correct range of vref is 1.04v~1.44v
	{
		return 1;
	}
	else
	{
		actualVref=1240;
		return 0;
	}
		
}
/*********************************************************************
 * @fn      WriteActualVref
 *
 * @brief  write actualVref into eeprom 
 *
 * @param : temp - the value which will be writen into eeprom and used as actualVref
 *
 * @return  none
 */
void WriteActualVref(uint16 temp)
{
	HalI2CInit(EEPROM_ADDRESS, I2C_CLOCK_RATE);

  // define array with address and data
  uint8 dBuf[4] = {
      HI_UINT16(ADC_VREF_ADDRESS_L),    // address
      LO_UINT16(ADC_VREF_ADDRESS_L),    // address
      LO_UINT16(temp),
      HI_UINT16(temp)
  };
  HalI2CWrite(sizeof(dBuf), dBuf);
  HalI2CAckPolling();
}

/*********************************************************************
*********************************************************************/
