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

#define FIRMWARE                              105

#define HI_UINT32(x)                          (((x) >> 16) & 0xffff)
#define LO_UINT32(x)                          ((x) & 0xffff)

// define LEDs

//#define LED0_PIO                              P0_5
//#define LED1_PIO                              P0_6
//#define LED2_PIO                              P0_7
//#define LED3_PIO                              P1_0
//#define LED4_PIO                              P1_1
//#define LED5_PIO                              P1_6
//#define LED6_PIO                              P1_7
//#define LED7_PIO                              P2_0
//#define LED8_PIO                              P2_1
//#define LED9_PIO                              P0_1
//#define LED10_PIO                             P0_2
//#define LED11_PIO                             P0_4

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
#define SBP_PERIODIC_EVT_PERIOD               200

// The led all on timing, READY is the time from power on to led all on
// GO is the time from led all on to led all off
#define SBP_START_DEVICE_EVT_READY_PERIOD			 3000
#define SBP_START_DEVICE_EVT_GO_PERIOD				 2000

// What is the advertising interval when device is discoverable (units of 625us, 160=100ms)
#define DEFAULT_ADVERTISING_INTERVAL          8000//16000

// Limited discoverable mode advertises for 30.72s, and then stops
// General discoverable mode advertises indefinitely

#define DEFAULT_DISCOVERABLE_MODE             GAP_ADTYPE_FLAGS_GENERAL

// Minimum connection interval (units of 1.25ms, 80=100ms) if automatic parameter update request is enabled
#define DEFAULT_DESIRED_MIN_CONN_INTERVAL     800

// Maximum connection interval (units of 1.25ms, 800=1000ms) if automatic parameter update request is enabled
#define DEFAULT_DESIRED_MAX_CONN_INTERVAL     1200

// Slave latency to use if automatic parameter update request is enabled
#define DEFAULT_DESIRED_SLAVE_LATENCY         4

// Supervision timeout value (units of 10ms, 1000=10s) if automatic parameter update request is enabled
#define DEFAULT_DESIRED_CONN_TIMEOUT          5000

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

#define LONG_PRESS_INTERVAL                 1000
#define NEXT_TAP_INTERVAL                   500
#define ACC_LOAD_INTERVAL                   2500    // 80MS * 30
#define CYCLE_LED_6_INTERVAL                80
#define CYCLE_LED_12_INTERVAL               60
#define TRIBLE_TAP_INTERVAL                 400
#define BLINK_LED_INTERVAL                  500
#define TIME_DISPLAY_INTERVAL               3000
#define READ_INTERVAL                       100

#define ACC_STATIC_COUNT_MAX                4


#define ALT_MIN_DEFAULT                     300
//#define AUTO_CONFIG		TRUE
#define MANUFACTURE_TEST	FASLE

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
mma_data_t mmaDataBA[DATA_BA_CNT_MAX];
mma_data_t mmaDataBA_diff[DATA_BA_CNT_MAX];
mma_data_t mmaDataB[DATA_B_CNT_MAX];

uint8 mmaCurSmoothestAxis=X_AXIS, mmaLastSmoothestAxis=X_AXIS;
uint8 accRunCnt_txbuf=0;
uint8 accRunCntAy[4]={0,0,0,0};
uint8 accRunCntValid=0;
uint8 accRunCntAyDebugCnt;
uint8 accRunK1=0;
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

// GAP - SCAN RSP data (max size = 31 bytes)
uint8 scanRspData[] =
{
    // complete name
    0x11,   // length of this data, p.s. contain header and body
    GAP_ADTYPE_LOCAL_NAME_COMPLETE,
    'A',
    'd',
    'd',
    'i',
    'n',
    'g',
    '_',
    'A',
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
uint8 attDeviceName[GAP_DEVICE_NAME_LEN] = "Adding_A1-000000";

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

static bool flagSBPStart=0;


/*********************************************************************
 * LOCAL FUNCTIONS
 */
static void simpleBLEPeripheral_ProcessOSALMsg( osal_event_hdr_t *pMsg );
static void peripheralStateNotificationCB( gaprole_States_t newState );
static void performPeriodicTask( void );
static void simpleProfileChangeCB( uint8 paramID );

static void battPeriodicTask( void );
static void battCB(uint8 event);

static void accInit(void);
static void accLoop(void);

// static void accGetIntData(void);
// static void accGetAccData(void);
static void accGetAccData(uint8 count);
static uint8 accDataProcess(uint8 count);

static void eepromWrite(uint8 type, uint8 cnt);
static uint8 eepromRead(void);

static void closeAllPIO(void);
static void openAllLED(void);

static void time(void);

static void longPressAndCycleLED6(void);
static void cycleLED12(void);

static void toggleLEDWithTime(uint8 num, uint8 io);
static void blinkLED(void);

static void toggleAdvert(uint8 status);

static void saveRawDataIndex(void);
static void loadRawDataIndex(void);

static void tribleTap(void);

static uint16 dataLength(void);

static int mpr03x_phys_init(void);
static void mpr03x_start(void);
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
    osal_memcpy(&scanRspData[12], sn, sizeof(sn));
    osal_memcpy(&attDeviceName[10], sn, sizeof(sn));

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

        uint8 enable_update_request = DEFAULT_ENABLE_UPDATE_REQUEST;
        uint16 desired_min_interval = DEFAULT_DESIRED_MIN_CONN_INTERVAL;
        uint16 desired_max_interval = DEFAULT_DESIRED_MAX_CONN_INTERVAL;
        uint16 desired_slave_latency = DEFAULT_DESIRED_SLAVE_LATENCY;
        uint16 desired_conn_timeout = DEFAULT_DESIRED_CONN_TIMEOUT;

        // Set the GAP Role Parameters
        GAPRole_SetParameter( GAPROLE_ADVERT_ENABLED, sizeof( uint8 ), &initial_advertising_enable );
        GAPRole_SetParameter( GAPROLE_ADVERT_OFF_TIME, sizeof( uint16 ), &gapRole_AdvertOffTime );

        GAPRole_SetParameter( GAPROLE_SCAN_RSP_DATA, sizeof ( scanRspData ), scanRspData );
        GAPRole_SetParameter( GAPROLE_ADVERT_DATA, sizeof( advertData ), advertData );

        GAPRole_SetParameter( GAPROLE_PARAM_UPDATE_ENABLE, sizeof( uint8 ), &enable_update_request );
        GAPRole_SetParameter( GAPROLE_MIN_CONN_INTERVAL, sizeof( uint16 ), &desired_min_interval );
        GAPRole_SetParameter( GAPROLE_MAX_CONN_INTERVAL, sizeof( uint16 ), &desired_max_interval );
        GAPRole_SetParameter( GAPROLE_SLAVE_LATENCY, sizeof( uint16 ), &desired_slave_latency );
        GAPRole_SetParameter( GAPROLE_TIMEOUT_MULTIPLIER, sizeof( uint16 ), &desired_conn_timeout );
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
        // SimpleProfile_SetParameter( HEALTH_SYNC, sizeof ( uint8 ), &healthSync );
        // SimpleProfile_SetParameter( HEALTH_CLOCK, sizeof ( uint32 ), &healthClock );
        SimpleProfile_SetParameter( HEALTH_DATA_HEADER, sizeof ( uint16 ), &healthDataHeader );
        SimpleProfile_SetParameter( HEALTH_FIRMWARE, sizeof ( uint16 ), &healthFirmware );
        // SimpleProfile_SetParameter( HEALTH_DATA_BODY, sizeof ( uint8 ), &healthDataBody );
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

    //sunshine
    // LED0_PIO = OPEN_PIO;
    // LED1_PIO = OPEN_PIO;
    // LED2_PIO = OPEN_PIO;
    // LED3_PIO = OPEN_PIO;
    // LED4_PIO = OPEN_PIO;
    // LED5_PIO = OPEN_PIO;
    // LED6_PIO = OPEN_PIO;
    // LED7_PIO = OPEN_PIO;
    // LED8_PIO = OPEN_PIO;
    // LED9_PIO = OPEN_PIO;
    // LED10_PIO = OPEN_PIO;
    // LED11_PIO = OPEN_PIO;


    // Register callback with SimpleGATTprofile
    VOID SimpleProfile_RegisterAppCBs( &simpleBLEPeripheral_SimpleProfileCBs );

    // Register for Battery service callback;
    Batt_Register ( battCB );

	 //read actualVref from eeprom
	 #if (MANUFACTURE_TEST==FALSE)
	 	battMeasureCalibration();
	 	WriteActualVref(1190);
	 #endif
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
	        osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_PERIODIC_EVT, SBP_PERIODIC_EVT_PERIOD );

			  // Set timer for led all on, READY period
			  osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT, SBP_START_DEVICE_EVT_READY_PERIOD );
			  flagSBPStart++;
			}
			else if(1==flagSBPStart)
			{
				//Open all LED and set timer for led all off, GO period
			  openAllLED();
	        osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_START_DEVICE_EVT, SBP_START_DEVICE_EVT_GO_PERIOD );
	        flagSBPStart++;
			}
			else if(2==flagSBPStart)
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
		accDataProcess(val);
		//accGetAccData(val);
        }

        // {
        //     uint8 d[8] = {val,0,0,0,0,0,0,0};

        //     // osal_memcpy(&d[0], &X_out, sizeof(int16));
        //     // osal_memcpy(&d[2], &Y_out, sizeof(int16));
        //     // osal_memcpy(&d[4], &Z_out, sizeof(int16));

        //     SimpleProfile_SetParameter( HEALTH_SYNC, 8, d );
        // }

        // restart timer
        // osal_start_timerEx( simpleBLEPeripheral_TaskID, ACC_PERIODIC_EVT, 100 );
        if(FALSE==flagAccStatic)
          osal_start_timerEx( simpleBLEPeripheral_TaskID, ACC_PERIODIC_EVT, accLoadInterval );

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
        // Restart timer
//        if ( SBP_PERIODIC_EVT_PERIOD )
//       {
//            osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_PERIODIC_EVT, SBP_PERIODIC_EVT_PERIOD );
//        }

        // Perform periodic application task
	performPeriodicTask();
	if(flagTxAccData==TRUE)
	{
		osal_start_timerEx( simpleBLEPeripheral_TaskID, SBP_PERIODIC_EVT, SBP_PERIODIC_EVT_PERIOD );
	}

        return (events ^ SBP_PERIODIC_EVT);
    }

    if ( events & TAP_TIMEOUT_EVT )
    {

        // double tap!!!
        if (tapWaitFor == 3)
        {
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

    if ( events & CYCLE_LED_12_EVT )
    {
        
        if (ledCycleCount < 12)
        {
            toggleLEDWithTime(ledCycleCount, OPEN_PIO);
            toggleLEDWithTime(ledCycleCount - 1, CLOSE_PIO);
        }else if(ledCycleCount == 12)
        {
            toggleLEDWithTime(0, OPEN_PIO);
            toggleLEDWithTime(11, CLOSE_PIO);
        }else
        {
            toggleLEDWithTime(0, CLOSE_PIO);
        }
        
        ledCycleCount++;
        
        if (ledCycleCount < 14)
        {
            osal_start_timerEx( simpleBLEPeripheral_TaskID, CYCLE_LED_12_EVT, CYCLE_LED_12_INTERVAL );

        }else{

            ledCycleCount = 0;
            lockSlip = 0;
        }
        //test watchdog code
//        {
//          uint8 i = 1;
//          HAL_DISABLE_INTERRUPTS();
//          while(i)
//          {
//            toggleLEDWithTime(2, OPEN_PIO); 
//            toggleLEDWithTime(4, OPEN_PIO); 
//            toggleLEDWithTime(6, OPEN_PIO);
//            toggleLEDWithTime(8, OPEN_PIO);
//            toggleLEDWithTime(10, OPEN_PIO);
//            i++;
//            if(i>100)i=1;
//          }
//          HAL_ENABLE_INTERRUPTS();
//        }
       //end test code
        return (events ^ CYCLE_LED_12_EVT);
    }

    if ( events & CLOSE_ALL_EVT )
    {

        closeAllPIO();

        return (events ^ CLOSE_ALL_EVT);
    }

    if ( events & LONG_PRESS_EVT )
    {

        if (onTheKey)
        {
            longPressAndCycleLED6();
        }

        return (events ^ LONG_PRESS_EVT);
    }

    if ( events & RUN_TRIBLE_TAP_EVT )
    {

        cycleLED12();

        return (events ^ RUN_TRIBLE_TAP_EVT);
    }

    if ( events & READ_EVT )
    {

        eepromRead();

        if (readTheI < 3)
        {
            osal_start_timerEx( simpleBLEPeripheral_TaskID, READ_EVT, READ_INTERVAL );
        }

        return (events ^ READ_EVT);
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

      //fixed long press bug
      //onTheKey = keys ? 1 : 0;
        //set i2c device address
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
        
  
        // LED6_PIO = !onTheKey;
  
        if (lockSlip)
        {
            break;
        }
  
        // for long press
        if (onTheKey)
        {
            osal_start_timerEx( simpleBLEPeripheral_TaskID, LONG_PRESS_EVT , LONG_PRESS_INTERVAL );
        }else{
          osal_stop_timerEx( simpleBLEPeripheral_TaskID, LONG_PRESS_EVT );
        }
  
        if (onTheKey)
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
              tribleTap();
  
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
	toggleLEDWithTime(0,CLOSE_PIO);
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
        // LED2_PIO = OPEN_PIO;
			 //when disconnected, adc analog channel off
		  HalADCPeripheralSetting(HAL_ADC_CHANNEL_0,IO_FUNCTION_GPIO);
		  HalADCToggleChannel(HAL_ADC_CHANNEL_0,ADC_CHANNEL_OFF);
    }
    break;

    case GAPROLE_CONNECTED:
    {
        // LED3_PIO = OPEN_PIO;  
        //when connected, adc analog channel on
        HalADCPeripheralSetting(HAL_ADC_CHANNEL_0,IO_FUNCTION_PERI);
			HalADCToggleChannel(HAL_ADC_CHANNEL_0,ADC_CHANNEL_ON);
    }
    break;

    case GAPROLE_WAITING:
    {
        // LED4_PIO = OPEN_PIO;
    }
    break;

    case GAPROLE_WAITING_AFTER_TIMEOUT:
    {
        // LED5_PIO = OPEN_PIO;
    }
    break;

    case GAPROLE_ERROR:
    {
        // LED6_PIO = OPEN_PIO;
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
 * @fn      performPeriodicTask
 *
 * @brief   Perform a periodic application task. This function gets
 *          called every five seconds as a result of the SBP_PERIODIC_EVT
 *          OSAL event. In this example, the value of the third
 *          characteristic in the SimpleGATTProfile service is retrieved
 *          from the profile, and then copied into the value of the
 *          the fourth characteristic.
 *
 * @param   none
 *
 * @return  none
 */
static void performPeriodicTask( void )
{
	#if (ACC_POPUP_DATA_BLE==TRUE)
		uint8 i;
		uint8 d[8];
		if((flagTxAccData==TRUE)&&(dataAtxbufCnt>dataAtxbufpointer))
		{
			if((dataAtxbufCnt-dataAtxbufpointer)>5)
			{
				//send 5 data
				for(i=dataAtxbufpointer;i<(dataAtxbufpointer+5);i++)
				{
					X_out=mmaDataA_txbuf[i].mmaAxis[0].int16data;
					Y_out=mmaDataA_txbuf[i].mmaAxis[1].int16data;
					Z_out=mmaDataA_txbuf[i].mmaAxis[2].int16data;
					if(i==0)
					{
						ACC_CUR=accRunCnt_txbuf;//popup the last run_counter
					}
					else if(i==1)
					{
						ACC_CUR=(int16)dataAtxbufCnt;
					}
					else
					{
						ACC_CUR=0xFFFF;
					}
					osal_memcpy(&d[0], &X_out, sizeof(int16));
					osal_memcpy(&d[2], &Y_out, sizeof(int16));
					osal_memcpy(&d[4], &Z_out, sizeof(int16));
					osal_memcpy(&d[6], &ACC_CUR, sizeof(int16));
					SimpleProfile_SetParameter( HEALTH_SYNC, sizeof ( d ), d );
				}
				dataAtxbufpointer+=5;
				//reset timer
			}
			else
			{
				//send the rest
				for(i=dataAtxbufpointer;i<dataAtxbufCnt;i++)
				{
					X_out=mmaDataA_txbuf[i].mmaAxis[0].int16data;
					Y_out=mmaDataA_txbuf[i].mmaAxis[1].int16data;
					Z_out=mmaDataA_txbuf[i].mmaAxis[2].int16data;
					if(i==0)
					{
						ACC_CUR=accRunCnt_txbuf;//popup the last run_counter
					}
					else if(i==1)
					{
						ACC_CUR=(int16)dataAtxbufCnt;
					}
					else
					{
						ACC_CUR=0xFFFF;
					}
					osal_memcpy(&d[0], &X_out, sizeof(int16));
					osal_memcpy(&d[2], &Y_out, sizeof(int16));
					osal_memcpy(&d[4], &Z_out, sizeof(int16));
					osal_memcpy(&d[6], &ACC_CUR, sizeof(int16));
					SimpleProfile_SetParameter( HEALTH_SYNC, sizeof ( d ), d );	
				}
				dataAtxbufpointer=dataAtxbufCnt;
				//reset timer
			}
		}
		else
		{
			//end timer ,end sending
			flagTxAccData=FALSE;
		}
	#endif
    // if (testAddr < 32768)
    // {
    //     HalI2CInit(EEPROM_ADDRESS, I2C_CLOCK_RATE);

    //     uint8 addr[2] = {
    //         HI_UINT16(testAddr),    // address
    //         LO_UINT16(testAddr)
    //     };

    //     uint8 data[8] = {1,2,0,4,7,9,2,8};

    //     uint8 send[10], back[8];

    //     uint8 d[8] = {
    //             LO_UINT16(testAddr),
    //             HI_UINT16(testAddr),
    //             0,0,0,0,0,0
    //         };

    //     osal_memcpy(&send[0], addr, 2);
    //     osal_memcpy(&send[2], data, 8);

    //     // uint8 send[3] = {
    //     //     HI_UINT16(testAddr),
    //     //     LO_UINT16(testAddr),
    //     //     15
    //     // }, back;

    //     HalI2CWrite(sizeof(send), send);
    //     HalI2CAckPolling();

    //     HalI2CWrite(sizeof(addr), addr);
    //     HalI2CRead(sizeof(back), back);

    //     if(osal_memcmp(back, data, 8)){
    //         d[2] = 1;
    //     }

    //     SimpleProfile_SetParameter( HEALTH_SYNC, sizeof ( d ), d );

    //     testAddr += 8;
    // }
    
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

        // {
        //     uint8 d[8] = {1,2,3,4,5,6,7,8};

        //     // osal_memcpy(&d[0], &X_out, sizeof(int16));
        //     // osal_memcpy(&d[2], &Y_out, sizeof(int16));
        //     // osal_memcpy(&d[4], &Z_out, sizeof(int16));

        //     SimpleProfile_SetParameter( HEALTH_SYNC, 8, d );
        // }

        break;

    case HEALTH_DATA_BODY:

        // eepromRead();

        break;

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

    // P0 = 0xFF;

    // // open
    // P1 = 0xC1;

    // // close
    // // P1 = 0xC3;

    // P2 = 0x07;

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
}

/*********************************************************************
 * @fn      openAllLED
 *
 * @param   none
 *
 * @return  none
 */

static void openAllLED(void){

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
	 led_status=0x0FFF;
	 LED_POWER=BOOSTON;
}


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
		LED_POWER=BOOSTOFF;
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

    eepromWrite(TAP_DATA_TYPE, 1);
    osal_set_event( simpleBLEPeripheral_TaskID, CYCLE_LED_6_EVT );
}

static void cycleLED12(void){

    // lockSlip = 1;

    osal_set_event( simpleBLEPeripheral_TaskID, CYCLE_LED_12_EVT );
}

static void tribleTap(void){

    lockSlip = 1;

    eepromWrite(TAP_HOUR_START_TYPE, 1);
    osal_start_timerEx( simpleBLEPeripheral_TaskID, RUN_TRIBLE_TAP_EVT, TRIBLE_TAP_INTERVAL );
}

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

    //tap config

    // pBuf[0] = PULSE_CFG;
    // pBuf[1] = (DPA_MASK|PELE_MASK|ZDPEFE_MASK);
    // HalI2CWrite(2, pBuf);

    // pBuf[0] = PULSE_THSX;
    // pBuf[1] = 0x06;//0x01;//0x00;   
    // HalI2CWrite(2, pBuf); 

    // pBuf[0] = PULSE_THSY;
    // pBuf[1] = 0x06;//0x01;//0x00;   
    // HalI2CWrite(2, pBuf); 

    // pBuf[0] = PULSE_THSZ;
    // pBuf[1] = 0x08;//0x01;//0x00;   
    // HalI2CWrite(2, pBuf);

    // pBuf[0] = PULSE_TMLT;
    // pBuf[1] = 0x06;     //about 1 sec in 12.5Hz low power 
    // HalI2CWrite(2, pBuf);

    // pBuf[0] = PULSE_LTCY;
    // pBuf[1] = 0x06;//0x00;  
    // HalI2CWrite(2, pBuf);

    // pBuf[0] = PULSE_WIND;
    // pBuf[1] = 0x0C;     
    // HalI2CWrite(2, pBuf);     

    // pBuf[0] = HP_FILTER_CUTOFF_REG;
    // pBuf[1] = 0x00;     
    // HalI2CWrite(2, pBuf);   

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
    pBuf[1] = (ASLP_RATE_12_5HZ + DATA_RATE_12_5HZ) | ACTIVE_MASK;
    HalI2CWrite(2, pBuf);

}

static void accLoop(void)
{
    //todo
    // X_out = X_out >> 6;
    // Y_out = Y_out >> 6;
    // Z_out = Z_out >> 6;

    


    ACC_CUR = X_out * X_out + Y_out * Y_out + Z_out * Z_out - 4096;

    //SimpleProfile_SetParameter( HEALTH_SYNC, sizeof ( ACC_CUR ), &ACC_CUR );

    uint8 d[8];

    osal_memcpy(&d[0], &X_out, sizeof(int16));
    osal_memcpy(&d[2], &Y_out, sizeof(int16));
    osal_memcpy(&d[4], &Z_out, sizeof(int16));
    osal_memcpy(&d[6], &ACC_CUR, sizeof(int16));

    SimpleProfile_SetParameter( HEALTH_SYNC, sizeof ( d ), d );


    if (ACC_CUR > ALT_MIN || ACC_CUR < -ALT_MIN)
    {
        
        if (ACC_CUR > 0)
        {
            if (B1 < 0 && B2 < 0)
            {
                
                if (B_INTERVAL > PACE_DUR_MIN && B_INTERVAL < PACE_DUR_MAX)
                {
                    pace_count++;

                    accStaticCount = 0;

                    // eepromWrite(STEP_DATA_TYPE, 1);

                    if (VALID_STEP_CONUT >= 125)
                    {
                        if (pace_count >= 10)
                        {
                            eepromWrite(STEP_DATA_TYPE, pace_count);
                        }

                        pace_count = 0;
                        VALID_STEP_CONUT = 0;
                    }

                    // uint8 d[8];

                    // osal_memcpy(&d[0], &B1, sizeof(int16));
                    // osal_memcpy(&d[2], &B2, sizeof(int16));

                    // SimpleProfile_SetParameter( HEALTH_SYNC, sizeof ( d ), d );
                }

                B1 = B2;
                B2 = 0;
                PEAK = 0;

                TIME_LINE = TIME_LINE - B_INTERVAL;
            }

            if (B1 < 0)
            {
                if (ACC_CUR > PEAK)
                {
                    PEAK = ACC_CUR;
                }
            }

        }else{

            if (PEAK > 0)
            {
                
                if (ACC_CUR < B2)
                {
                    B2 = ACC_CUR;

                    B_INTERVAL = TIME_LINE;
                }

            }else{

                if (ACC_CUR < B1)
                {
                    B1 = ACC_CUR;

                    TIME_LINE = 0;
                }
            }
        }
    }

    TIME_LINE++;

    if (pace_count > 0)
    {
        VALID_STEP_CONUT++;
    }

     if ((DIR == 1) && (ACC_CUR > 0))
     {

         if (first_pace == 0)
         {
             cross_count = cross_count + 1;
             if (cross_count == 1)
             {

                 time_count = 0;
                 PACE_PEAK = ACC_CUR;
                 PACE_BOTTOM = 0;

             }
             else if (cross_count == 2)
             {

                 // uint8 d[6];

                 // int16 minus = PACE_PEAK - PACE_BOTTOM;

                 // osal_memcpy(&d[0], &minus, sizeof(int16));

                 // SimpleProfile_SetParameter( HEALTH_SYNC, sizeof ( d ), d );

                 if (((time_count) >= PACE_DUR_MIN) && ((time_count) <= PACE_DUR_MAX) && ((PACE_PEAK - PACE_BOTTOM) >= ALT_MIN))
                 {
                     // add one step
                     pace_count = pace_count + 1;


                     if (VALID_STEP_CONUT >= 50)
                     {
                         if (pace_count > 3)
                         {
                             eepromWrite(STEP_DATA_TYPE, pace_count);
                         }

                         pace_count = 0;

                         VALID_STEP_CONUT = 0;
                     }

                     // LED0_PIO = OPEN_PIO;
                     // LED3_PIO = OPEN_PIO;
                     // LED6_PIO = OPEN_PIO;
                     // LED9_PIO = OPEN_PIO;

                     // osal_start_timerEx( simpleBLEPeripheral_TaskID, CLOSE_ALL_EVT, 300 );

                     cross_count = 0;

                   

                     accStaticCount = 0;

                     accLoadInterval = ACC_LOAD_INTERVAL;
                     // ALT_MIN = ALT_MIN_DEFAULT;

                 }
                 else
                 {

                     time_count = 0;
                     PACE_PEAK = ACC_CUR;
                     PACE_BOTTOM = 0;
                     cross_count = 1;
                 }
             }
         }
         else
         {
             first_pace = 0;

             time_count = 0;
             PACE_PEAK = ACC_CUR;
             PACE_BOTTOM = 0;
         }
         DIR = 2;
     }
     else if ((DIR == 2) && (ACC_CUR >= 0))
     {
         if (ACC_CUR > PACE_PEAK) PACE_PEAK = ACC_CUR;
     }
     else if ((DIR == 2) && (ACC_CUR < 0))
     {
         PACE_BOTTOM = ACC_CUR;
         DIR = 1;
     }
     else if ((DIR == 1) && (ACC_CUR <= 0))
     {
         if (ACC_CUR < PACE_BOTTOM) PACE_BOTTOM = ACC_CUR;
     }

     // accGetIntData();//read INT registers

     // if (INT_STATUS & 0x80)
     // {

     //     // time();

     // }

     time_count++;

     if (pace_count > 0)
     {
         VALID_STEP_CONUT++;
     }
}


// static void accGetAccData(void)
static void accGetAccData(uint8 count)
{
    uint8 pBuf[2];
    HalI2CInit(ACC_ADDRESS, I2C_CLOCK_RATE);

    // uint8 addr = OUT_X_MSB, accBuf[6];

    // HalMotionI2CWrite(1, &addr);
    // HalMotionI2CRead(6, accBuf);

    // X_out = (int16)((accBuf[0] << 8) | accBuf[1]);
    // Y_out = (int16)((accBuf[2] << 8) | accBuf[3]);
    // Z_out = (int16)((accBuf[4] << 8) | accBuf[5]);

    accStaticCount++;

    if (accStaticCount > ACC_STATIC_COUNT_MAX)
    {
        accLoadInterval = ACC_LOAD_INTERVAL;// * ACC_STATIC_COUNT_MAX;
        // ALT_MIN = ALT_MIN_DEFAULT;

        flagAccStatic=TRUE;
        
        //set acc into standby, so can write
        pBuf[0] = CTRL_REG1;
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
        //LED0_PIO=CLOSE_PIO;
        //LED1_PIO=CLOSE_PIO;
    }

    uint8 addr = OUT_X_MSB, accBuf[MMA_FIFO_DEEPTH];

    HalMotionI2CWrite(1, &addr);
    HalMotionI2CRead(count * 6, accBuf);

    for (int i = 0; i < count * 6; i += 6)
    {
        X_out = (int16)((accBuf[i] << 8) | accBuf[i+1]);
        Y_out = (int16)((accBuf[i+2] << 8) | accBuf[i+3]);
        Z_out = (int16)((accBuf[i+4] << 8) | accBuf[i+5]);

        accLoop();
    }
}

static uint8 accDataProcess(uint8 count)
{
	uint8 pBuf[2];
	uint8 i,k;
	uint16 mmaDataCntTemp=0;
	//int32 accSlideSumTemp[3]={0,0,0};
	int32 accSlideSumTemp=0;
	#if ((MMA_DEBUG_SIMULATION==TRUE)&&(MMA_DEBUG_DATA_MODEL==1))
		int16 accBufDebug[32*3]={-12,42,48,-13,42,45,-10,38,46,-12,41,50,-12,36,41,\
			-9,32,36,-13,24,40,-14,20,44,-21,14,44,-38,9,49,-53,3,50,-66,1,42,-73,-6,31,\
			-82,-13,21,-83,-13,24,-78,-11,31,-81,-13,39,-70,-17,33,-73,-18,22,-90,-15,\
			12,-86,-15,5,-73,-15,3,-64,-11,3,-65,-4,-5,-60,4,-6,-72,-1,4,-75,-8,12,-59,\
			-13,17,-75,-14,22,-82,-23,30,-84,-29,30,-71,-25,21\
			};
	#endif
	#if((MMA_DEBUG_SIMULATION==TRUE)&&(MMA_DEBUG_DATA_MODEL==2))
/*		int16 accBufDebug[32*3]={-92,-20,10,-76,-16,6,-68,-14,4,-65,-8,0,-67,1,-7,\
			-62,1,-3,-91,-6,3,-65,-7,12,-54,-14,16,-65,-16,23,-81,-20,30,-87,-26,27,-81,\
			-23,18,-82,-19,7,-64,-15,6,-60,-13,4,-65,-7,-1,-68,0,-8,-71,-3,1,-87,-8,4,-50,\
			-8,14,-52,-12,17,-68,-16,23,-81,-17,30,-81,-21,26,-90,-21,17,-77,-15,9,-61,-12,\
			7,-55,-9,3,-65,-2,-4,-71,0,-9,-80,-3,3\
			};*/
		int16 accBufDebug[32*3]={128,-1248,3920,-1264,576,3104,-1568,1744,2944,\
		-1968,1840,2384,-2896,2720,2656,-3200,2928,2976,-3504,3216,2640,-2912,\
		2368,2256,-2432,1744,2000,-1664,512,2496,-336,-384,3408,640,-1536,4960,\
		368,-1392,5776,304,-1088,5312,224,-1568,4944,64,-1424,4288,-816,-800,\
		3840,-2416,800,3040,-3104,656,1088,-3856,912,1904,-3712,1280,1616,-4160,\
		1328,2256,-3728,1760,1808,-3680,2496,1856,-2752,1840,1504,-1792,1104,2512,\
		176,-80,3248,512,-608,5104,928,-1232,6080,1520,-1792,5840,784,-672,4800,\
		256,-608,4240\
		};
		mmaDataBA[0].mmaAxis[0].int16data=189;
		mmaDataBA[1].mmaAxis[0].int16data=183;
		mmaDataBA[2].mmaAxis[0].int16data=174;
		mmaDataBACnt=3;
	#endif
	#if((MMA_DEBUG_SIMULATION==TRUE)&&(MMA_DEBUG_DATA_MODEL==3))
		int16 accBufDebug[32*3]={-5024,-432,448,-3152,-592,832,-3616,-880,\
		1280,-4624,-1120,1808,-5344,-1296,1984,-4800,-1552,1568,-5840,-1344,\
		816,-5040,-976,416,-3936,-944,384,-3440,-672,192,-3872,-368,0,-4288,\
		-336,-80,-4464,-624,528,-5536,-672,496,-3456,-800,864,-3616,-1136,\
		1072,-4256,-1136,1488,-5280,-1392,1728,-5008,-1568,1488,-5632,-1408,\
		960,-5184,-976,384,-4096,-912,400,-3952,-672,128,-3952,-160,-256,-4352,\
		-32,-464,-4832,-432,400,-5136,-400,512,-3344,-608,928,-3664,-896,1248,\
		-4528,-1216,1712,-5440,-1520,1888,-4768,-1664,1520\
			};
		mmaDataBA[0].mmaAxis[0].int16data=57;
		mmaDataBA[1].mmaAxis[0].int16data=53;
		mmaDataBA[2].mmaAxis[0].int16data=51;
		mmaDataBA[3].mmaAxis[0].int16data=51;
		mmaDataBACnt=4;
	#endif
	#if((MMA_DEBUG_SIMULATION==TRUE)&&(MMA_DEBUG_DATA_MODEL==4))
		int16 accBufDebug[32*3]={-4896,-944,-272,-4160,320,176,-4000,32,96,\
		-6400,-1328,304,-4352,-1520,480,-3104,-1728,432,-4048,-2432,624,-5424,\
		-3312,640,-3856,-3200,624,-5408,-3008,48,-5760,-1712,96,-4048,-1616,96,\
		-4256,-1392,64,-4832,-512,16,-4224,64,144,-4624,-832,512,-5488,-1456,\
		560,-3072,-1440,672,-3440,-1872,448,-5280,-2816,592,-4608,-3360,528,\
		-3984,-3376,272,-6208,-2576,-176\
			};
		mmaDataBA[0].mmaAxis[0].int16data=60;
		mmaDataBACnt=1;
		uint8 accRunCntAyDebug[27]={0,0,1,2,2,1,1,1,1,1,2,3,0,1,1,1,1,1,1,1,1,1,0,2,0,0,0};
		accRunCntAyDebugCnt=27;
	#endif
/*
	//first piece of data, round mode
	int16 accBufDebug[32*3]={-43,-27,-36,-42,-30,-32,-42,-25,-38,-40,-26,-38,-35,-36,-39,-39,-34,-35,-39,\
		-34,-30,-46,-34,-22,-54,-31,-15,-61,-18,-8,-70,-14,-6,-72,-16,-4,-71,-20,-2,-68,-25,\
		-1,-64,-34,1,-59,-44,1,-57,-37,1,-50,-31,1,-72,-28,-1,-82,-21,1,-78,-20,3,-73,-15,6,\
		-72,0,8,-69,-1,6,-66,-9,6,-76,-16,9,-59,-24,8,-60,-28,7,-61,-36,9,-62,-41,7,-59,-34,9,-71,-30,2\
	};
	//second piece of data, round mode
	int16 accBufDebug[32*3]={-74,-21,6,-63,-20,4,-68,-17,4,-76,-5,8,-71,1,10,-60,-11,9,-77,-12,11,-55,\
	-23,8,-57,-25,7,-58,-35,9,-61,-41,7,-68,-39,6,-65,-34,3,-76,-21,4,-60,-18,1,-60,-13,4,-70,-11,2,-62,\
	-6,8,-61,-11,8,-81,-16,10,-58,-17,9,-47,-23,4,-52,-28,6,-63,-33,5,-79,-41,6,-61,-33,6,-73,-25,5,-54,\
	-21,3,-52,-16,3,-62,-15,-1,-68,-11,7,-65,-14,8\
	};	
	//third piece of data, round mode
	int16 accBufDebug[32*3]={-76,-17,9,-51,-17,11,-45,-23,4,-50,-26,9,-63,-39,9,-72,-38,8,-65,-32,5,-72,\
		-24,6,-55,-21,3,-50,-19,2,-58,-16,3,-66,-11,6,-65,-14,8,-79,-19,9,-55,-17,12,-43,-23,5,-51,-26,8,\
		-63,-33,10,-77,-38,10,-59,-32,10,-74,-26,9,-58,-21,5,-55,-16,6,-59,-13,4,-68,-3,9,-64,-8,9,-77,\
		-17,6,-59,-20,13,-46,-26,6,-51,-26,10,-59,-33,10,-74,-34,11\
	};*/
/*	//first piece of data, fix mode
	int16 accBufDebug[32*3]={-43,-27,-35,-41,-29,-32,-41,-24,-38,-40,-26,-37,-35,-36,-38,-38,-33,-35,\
		-39,-34,-29,-45,-34,-22,-53,-30,-15,-61,-18,-7,-70,-14,-6,-72,-16,-3,-71,-20,-2,-68,-25,0,-64,\
		-33,0,-59,-44,0,-56,-37,1,-49,-30,1,-71,-27,0,-81,-20,1,-77,-20,3,-73,-14,6,-71,0,8,-69,0,5,-65,\
		-9,5,-75,-15,8,-59,-23,7,-59,-28,7,-60,-35,8,-61,-40,7,-58,-34,8,-70,-30,2\
		};
	//second piece of data, fix mode
	int16 accBufDebug[32*3]={-73,-20,5,-62,-19,4,-67,-16,4,-76,-5,7,-70,0,9,-60,-11,9,-77,-12,11,-54,\
		-23,8,-57,-24,6,-58,-34,9,-61,-40,6,-68,-39,6,-64,-33,2,-75,-21,3,-60,-18,0,-60,-12,3,-70,\
		-10,1,-62,-6,8,-61,-11,7,-81,-16,9,-57,-17,9,-46,-22,3,-52,-28,5,-62,-32,5,-79,-41,6,-60,\
		-33,5,-73,-24,5,-53,-20,3,-52,-16,2,-62,-14,0,-68,-10,7,-64,-14,8\
	};
	//third piece of data, fix mode
	int16 accBufDebug[32*3]={-75,-17,9,-50,-16,10,-44,-22,4,-50,-26,9,-62,-39,9,-72,\
		-38,7,-65,-31,4,-72,-23,6,-55,-20,2,-50,-18,2,-57,-16,3,-66,-11,6,-64,-13,8,-78,\
		-19,9,-55,-16,11,-43,-22,4,-50,-25,8,-63,-32,9,-76,-37,9,-59,-31,9,-73,-25,8,-58,\
		-21,5,-55,-15,5,-59,-13,4,-67,-2,8,-63,-7,8,-77,-16,6,-59,-20,13,-46,-25,5,-51,\
		-26,10,-59,-32,10,-73,-34,10\
	};*/
		//debug usage
		//toggleLEDWithTime(1,OPEN_PIO);
	uint16 mmaDataPeakCnt[3]={0,0,0};
	uint16 accBufCutLineSuf=0;
	uint16 mmaCutLineCnt=0;
	int16 accBufMean=0;
	int32 accBufSum=0;
	int16 accBufLastPeakValue=5000;
	uint8 accLastValleySuf=ACC_LAST_VALLEY_SUF_DEFAULT;
	uint8 accRunCounter=0;
	//uint8 addr = OUT_X_MSB, accBufCur[MMA_FIFO_DEEPTH];
	uint8 addr = OUT_X_MSB;
	uint8 *accBufCur;
	int16 *mmaDataASum;
	uint8 flagAccDataError=FALSE;
	uint8 flagValleyFreeze=FALSE;
	uint8 mmaDataASumCnt;

	HalI2CInit(ACC_ADDRESS, I2C_CLOCK_RATE);
/*
	accStaticCount++;
	if (accStaticCount > ACC_STATIC_COUNT_MAX)
	{
		accLoadInterval = ACC_LOAD_INTERVAL;// * ACC_STATIC_COUNT_MAX;
		// ALT_MIN = ALT_MIN_DEFAULT;
		flagAccStatic=TRUE;
		//debug usage
		toggleLEDWithTime(0,OPEN_PIO);
		//set acc into standby, so can write
		pBuf[0] = CTRL_REG1;
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
	}*/
	//declare 
	accBufCur=osal_mem_alloc(MMA_FIFO_DEEPTH);
	mmaDataASum=osal_mem_alloc(DATA_A_CNT_MAX*sizeof(int16));
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
		flagAccDataError=TRUE;
		mmaDataACnt=0;
		return 0;
	}
	if(mmaDataACnt<=SLIDE_MEAN_WIDTH)
	{
		return 0;
	}
	
	#if (MMA_DEBUG_SIMULATION==TRUE)
		//debug build mmaDataA
		for(i=0;i<32;i++)
		{
			mmaDataA[i].mmaAxis[0].int16data=(int32)accBufDebug[i*3];
			mmaDataA[i].mmaAxis[1].int16data=(int32)accBufDebug[i*3+1];
			mmaDataA[i].mmaAxis[2].int16data=(int32)accBufDebug[i*3+2];
		}
		mmaDataACnt=32;
		/*
		//debug build mmaDataBA
		mmaDataBA[0].mmaAxis[1].int16data=32;
		mmaDataBA[1].mmaAxis[1].int16data=29;
		mmaDataBA[2].mmaAxis[1].int16data=23;
		mmaDataBA[3].mmaAxis[1].int16data=18;
		mmaDataBA[4].mmaAxis[1].int16data=15;
		mmaDataBA[5].mmaAxis[1].int16data=13;
		mmaDataBA[6].mmaAxis[1].int16data=12;
		mmaDataBA[7].mmaAxis[1].int16data=12;
		mmaDataBA[8].mmaAxis[1].int16data=14;
		for(i=0;i<9;i++)
		{
			mmaDataBACnt++;
		}	*/
	#else
		//change bytes into unions
		osal_memset(mmaDataA,0,sizeof(mmaDataA));
		for(i = 0; i < mmaDataACnt; i ++)
		{
			mmaDataA[i].mmaAxis[0].int16data=(int16)((accBufCur[i*6] << 8) | accBufCur[i*6+1]);
			//mmaDataA[i].mmaAxis[0].int16data=mmaDataA[i].mmaAxis[0].int16data>>6;
			mmaDataA[i].mmaAxis[1].int16data=(int16)((accBufCur[i*6+2] << 8) | accBufCur[i*6+3]);
			//mmaDataA[i].mmaAxis[1].int16data=mmaDataA[i].mmaAxis[1].int16data>>6;
			mmaDataA[i].mmaAxis[2].int16data=(int16)((accBufCur[i*6+4] << 8) | accBufCur[i*6+5]);
			//mmaDataA[i].mmaAxis[2].int16data=mmaDataA[i].mmaAxis[2].int16data>>6;
		}
	#endif
	#if (ACC_POPUP_DATA_BLE==TRUE)
		//save data into txbuf
		osal_memset(mmaDataA_txbuf,0,sizeof(mmaDataA));
		osal_memcpy(mmaDataA_txbuf,mmaDataA,sizeof(mmaDataA));
		dataAtxbufCnt=mmaDataACnt;
		dataAtxbufpointer=0;
		if(flagAccData221==TRUE)
			accRunCnt_txbuf=1;
		else
			accRunCnt_txbuf=accRunCntAy[2];	
		flagAccData221=FALSE;
//		accRunCnt_txbuf=accRunCntAy[2];		
		flagTxAccData=TRUE;
		osal_set_event( simpleBLEPeripheral_TaskID, SBP_PERIODIC_EVT);
	/*	
		//send data through bluetooth
		uint8 d[8];
		for(i = 0; i < mmaDataACnt; i ++)
		{
			//osal_memcpy(&d[0], &mmaDataA[i].mmaAxis[0].int16data, sizeof(int16));
			//osal_memcpy(&d[2], &mmaDataA[i].mmaAxis[1].int16data, sizeof(int16));
			//osal_memcpy(&d[4], &mmaDataA[i].mmaAxis[2].int16data, sizeof(int16));
			//osal_memcpy(&d[6], &ACC_CUR, sizeof(int16));
			X_out=mmaDataA[i].mmaAxis[0].int16data;
			Y_out=mmaDataA[i].mmaAxis[1].int16data;
			Z_out=mmaDataA[i].mmaAxis[2].int16data;
			if(i==0)
			{
				ACC_CUR=accRunCntAy[2];//popup the last run_counter
			}
			else if(i==1)
			{
				ACC_CUR=(int16)mmaLastSmoothestAxis;
			}
			else
			{
				ACC_CUR=0xFFFF;
			}
			osal_memcpy(&d[0], &X_out, sizeof(int16));
			osal_memcpy(&d[2], &Y_out, sizeof(int16));
			osal_memcpy(&d[4], &Z_out, sizeof(int16));
			osal_memcpy(&d[6], &ACC_CUR, sizeof(int16));
			SimpleProfile_SetParameter( HEALTH_SYNC, sizeof ( d ), d );
		}*/
	#endif
//	#if (MMA_DEBUG_SIMULATION==FALSE)
		for(i = 0; i < mmaDataACnt; i ++)
		{
			//mmaDataA[i].mmaAxis[0].int16data=(int16)((accBufCur[i*6] << 8) | accBufCur[i*6+1]);
			mmaDataA[i].mmaAxis[0].int16data=mmaDataA[i].mmaAxis[0].int16data>>6;
			//mmaDataA[i].mmaAxis[1].int16data=(int16)((accBufCur[i*6+2] << 8) | accBufCur[i*6+3]);
			mmaDataA[i].mmaAxis[1].int16data=mmaDataA[i].mmaAxis[1].int16data>>6;
			//mmaDataA[i].mmaAxis[2].int16data=(int16)((accBufCur[i*6+4] << 8) | accBufCur[i*6+5]);
			mmaDataA[i].mmaAxis[2].int16data=mmaDataA[i].mmaAxis[2].int16data>>6;
		}
//	#endif

	//calculate the min value of 3 axises
	int16 mmaDataAMin[3]={32767,32767,32767};
	for(i = 0; i < mmaDataACnt; i ++)
	{
		for(k=0;k<3;k++)
		{
			if(mmaDataAMin[k]>mmaDataA[i].mmaAxis[k].int16data)
			{
				mmaDataAMin[k]=mmaDataA[i].mmaAxis[k].int16data;
			}
		}
	}
	//clear mmaDataASum
	osal_memset(mmaDataASum,0,DATA_A_CNT_MAX*sizeof(int16));
	mmaDataASumCnt=0;
	//shifting all data of 3 axises towards positive side, meanwhile adding 3 axises
	for(i = 0; i < mmaDataACnt; i ++)
	{
		for(k=0;k<3;k++)
		{
			mmaDataA[i].mmaAxis[k].int16data=mmaDataA[i].mmaAxis[k].int16data-mmaDataAMin[k]+1;
			mmaDataASum[i]+=mmaDataA[i].mmaAxis[k].int16data;
		}				
	}
	mmaDataASumCnt=mmaDataACnt;	
	//average slide
	mmaDataCntTemp=mmaDataASumCnt-SLIDE_MEAN_WIDTH;
	for(i=0;i<mmaDataCntTemp;i++)	//slide part
	{
		for(k=i;k<i+SLIDE_MEAN_WIDTH;k++)
		{	
			accSlideSumTemp=accSlideSumTemp+(int32)mmaDataASum[k];
		}
		mmaDataASum[i]=(int16)(accSlideSumTemp/SLIDE_MEAN_WIDTH);	
		accSlideSumTemp=0;
	}
	for(i=0;i<SLIDE_MEAN_WIDTH;i++)
	{
		for(k=mmaDataCntTemp+i;k<mmaDataASumCnt;k++)
		{
			accSlideSumTemp=accSlideSumTemp+(int32)mmaDataASum[k];
		}
		mmaDataASum[mmaDataCntTemp+i]=(int16)(accSlideSumTemp/(SLIDE_MEAN_WIDTH-i));
		accSlideSumTemp=0;
	}
	
/*	//average slide
	mmaDataCntTemp=mmaDataACnt-SLIDE_MEAN_WIDTH;
	//mmaLastSmoothestAxis=Y_AXIS;
	for(i=0;i<mmaDataCntTemp;i++)	//slide part
	{
		for(k=i;k<i+SLIDE_MEAN_WIDTH;k++)
		{	
			accSlideSumTemp[0]=accSlideSumTemp[0]+(int32)mmaDataA[k].mmaAxis[0].int16data;
			accSlideSumTemp[1]=accSlideSumTemp[1]+(int32)mmaDataA[k].mmaAxis[1].int16data;
			accSlideSumTemp[2]=accSlideSumTemp[2]+(int32)mmaDataA[k].mmaAxis[2].int16data;
		}
		mmaDataA[i].mmaAxis[0].int16data=(int16)(accSlideSumTemp[0]/SLIDE_MEAN_WIDTH);	
		mmaDataA[i].mmaAxis[1].int16data=(int16)(accSlideSumTemp[1]/SLIDE_MEAN_WIDTH);	
		mmaDataA[i].mmaAxis[2].int16data=(int16)(accSlideSumTemp[2]/SLIDE_MEAN_WIDTH);	
		accSlideSumTemp[0]=0;
		accSlideSumTemp[1]=0;
		accSlideSumTemp[2]=0;	
	}
	for(i=0;i<SLIDE_MEAN_WIDTH;i++)
	{
		for(k=mmaDataCntTemp+i;k<mmaDataACnt;k++)
		{
			accSlideSumTemp[0]=accSlideSumTemp[0]+(int32)mmaDataA[k].mmaAxis[0].int16data;
			accSlideSumTemp[1]=accSlideSumTemp[1]+(int32)mmaDataA[k].mmaAxis[1].int16data;
			accSlideSumTemp[2]=accSlideSumTemp[2]+(int32)mmaDataA[k].mmaAxis[2].int16data;
		}
		mmaDataA[mmaDataCntTemp+i].mmaAxis[0].int16data=(int16)(accSlideSumTemp[0]/(SLIDE_MEAN_WIDTH-i));
		mmaDataA[mmaDataCntTemp+i].mmaAxis[1].int16data=(int16)(accSlideSumTemp[1]/(SLIDE_MEAN_WIDTH-i));
		mmaDataA[mmaDataCntTemp+i].mmaAxis[2].int16data=(int16)(accSlideSumTemp[2]/(SLIDE_MEAN_WIDTH-i));
		accSlideSumTemp[0]=0;
		accSlideSumTemp[1]=0;
		accSlideSumTemp[2]=0;
	}
*/	
/*
	//find Smoothest Axis
	for(i=0;i<(mmaDataACnt-1);i++)// diff
	{
		mmaDataA_diff[i].mmaAxis[0].int16data=mmaDataA[i+1].mmaAxis[0].int16data-mmaDataA[i].mmaAxis[0].int16data;
		mmaDataA_diff[i].mmaAxis[1].int16data=mmaDataA[i+1].mmaAxis[1].int16data-mmaDataA[i].mmaAxis[1].int16data;
		mmaDataA_diff[i].mmaAxis[2].int16data=mmaDataA[i+1].mmaAxis[2].int16data-mmaDataA[i].mmaAxis[2].int16data;
	}	
	mmaDataA_diff[mmaDataACnt-1].mmaAxis[0].int16data=0;
	mmaDataA_diff[mmaDataACnt-1].mmaAxis[1].int16data=0;
	mmaDataA_diff[mmaDataACnt-1].mmaAxis[2].int16data=0;
	mmaDataPeakCnt[0]=0;
	mmaDataPeakCnt[1]=0;
	mmaDataPeakCnt[2]=0;
	for(i=0;i<(mmaDataACnt-1);i++)// count peaks
	{
		if((mmaDataA_diff[i].mmaAxis[0].int16data>0)&&(mmaDataA_diff[i+1].mmaAxis[0].int16data<=0))
		{
			mmaDataPeakCnt[0]++;	
		}
		if((mmaDataA_diff[i].mmaAxis[1].int16data>0)&&(mmaDataA_diff[i+1].mmaAxis[1].int16data<=0))
		{
			mmaDataPeakCnt[1]++;	
		}
		if((mmaDataA_diff[i].mmaAxis[2].int16data>0)&&(mmaDataA_diff[i+1].mmaAxis[2].int16data<=0))
		{
			mmaDataPeakCnt[2]++;	
		}
	}
	if(mmaDataPeakCnt[0]<=mmaDataPeakCnt[1])//mmaDataPeakCnt[0] is smaller
	{
		if(mmaDataPeakCnt[0]<=mmaDataPeakCnt[2])//mmaDataPeakCnt[0] is smallest
		{
			mmaCurSmoothestAxis=X_AXIS;
		}
		else //mmaDataPeakCnt[2] is smallest
		{
			mmaCurSmoothestAxis=Z_AXIS;
		}
	}
	else //mmaDataPeakCnt[1] is smaller
	{
		if(mmaDataPeakCnt[1]<=mmaDataPeakCnt[2])//mmaDataPeakCnt[1] is smallest
		{
			mmaCurSmoothestAxis=Y_AXIS;
		}
		else //mmaDataPeakCnt[2] is smallest
		{
			mmaCurSmoothestAxis=Z_AXIS;
		}
	}
*/	
	//add tail
	for(i=0;i<mmaDataASumCnt;i++)//at this time mmaDataBACnt has tail length
	{
		mmaDataBA[mmaDataBACnt+i].mmaAxis[mmaCurSmoothestAxis].int16data=mmaDataASum[i];
	}
	mmaDataBACnt+=mmaDataASumCnt;//at this time, mmaDataBACnt has cur data plus tail length
	//calculate the ABS of smoothest axis data
//	for(i=0;i<mmaDataACnt;i++)
//	{
//		mmaDataA[i].mmaAxis[mmaCurSmoothestAxis].int16data=ABS((mmaDataA[i].mmaAxis[mmaCurSmoothestAxis].int16data));
//	}
	//calculate the min value of mmaDataA and offset all data towards positive direction by abs(min value)
/*	int16 minDataA=1;
	for(i=0;i<mmaDataACnt;i++)
	{
		if(minDataA>mmaDataA[i].mmaAxis[mmaCurSmoothestAxis].int16data)
		{
			minDataA=mmaDataA[i].mmaAxis[mmaCurSmoothestAxis].int16data;
		}
	}
	if(minDataA<0)
	{
		for(i=0;i<mmaDataACnt;i++)
		{
			mmaDataA[i].mmaAxis[mmaCurSmoothestAxis].int16data-=minDataA;
		}
	}*/
	
	//chose to add the last tail or not
//	if((mmaCurSmoothestAxis==mmaLastSmoothestAxis)&&(0!=mmaDataBACnt))//add cur data to last tail
//	{
//		for(i=0;i<mmaDataACnt;i++)//at this time mmaDataBACnt has tail length
//		{
//			mmaDataBA[mmaDataBACnt+i].mmaAxis[mmaCurSmoothestAxis].int16data=mmaDataA[i].mmaAxis[mmaCurSmoothestAxis].int16data;
//		}
//		mmaDataBACnt+=mmaDataACnt;//at this time, mmaDataBACnt has cur data plus tail length
//	}
//	else//move cur data to mmaDataBA
//	{
//		//osal_memcpy(mmaDataBA,mmaDataA,mmaDataACnt*3);//(void * dst, const void GENERIC * src, unsigned int len)
//		for(i=0;i<mmaDataACnt;i++) 
//		{
//			mmaDataBA[i].mmaAxis[mmaCurSmoothestAxis].int16data=\
//				mmaDataA[i].mmaAxis[mmaCurSmoothestAxis].int16data;
//		}
//		mmaDataBACnt=mmaDataACnt;
//	}
	//mmaDataBA diff
	osal_memset(mmaDataBA_diff,0,sizeof(mmaDataBA_diff));
	for(i=0;i<mmaDataBACnt-1;i++)
	{
		mmaDataBA_diff[i].mmaAxis[mmaCurSmoothestAxis].int16data=\
		mmaDataBA[i+1].mmaAxis[mmaCurSmoothestAxis].int16data-mmaDataBA[i].mmaAxis[mmaCurSmoothestAxis].int16data;
	}
	//identify the last peak
	for(i=mmaDataBACnt-2;i>0;i--)//because the last diff is meaningless, so decrece 2
	{
		if((mmaDataBA_diff[i-1].mmaAxis[mmaCurSmoothestAxis].int16data>0)&&(mmaDataBA_diff[i].mmaAxis[mmaCurSmoothestAxis].int16data<=0))
		{
			accBufCutLineSuf=i;
			break;
		}
	}
	//set the mmaCutLineCnt
	if(accBufCutLineSuf!=0)
	{
		mmaCutLineCnt=accBufCutLineSuf;		
	}
	else
	{
		mmaCutLineCnt=mmaDataBACnt;
	}	
	//arith mean calculation
	for(i=0;i<mmaDataBACnt;i++)
	{
		accBufSum=accBufSum+(int32)mmaDataBA[i].mmaAxis[mmaCurSmoothestAxis].int16data;
	}
	accBufMean=(int16)(accBufSum/(int32)mmaDataBACnt);
	accBufMean=accBufMean-accBufMean/10;
	
	//runcount step 1: count valleys
	uint8 final_min_step_interval=0;
	//for(i=0;i<mmaDataBACnt-1;i++)
	for(i=0;i<mmaCutLineCnt-1;i++)
	{
		if((mmaDataBA_diff[i].mmaAxis[mmaCurSmoothestAxis].int16data>0)&& \
			(mmaDataBA_diff[i+1].mmaAxis[mmaCurSmoothestAxis].int16data<=0))
		{
			accBufLastPeakValue=mmaDataBA[i+1].mmaAxis[mmaCurSmoothestAxis].int16data;
		}
		if(accLastValleySuf==ACC_LAST_VALLEY_SUF_DEFAULT)
		{
			final_min_step_interval=0;
		}
		else
		{
			final_min_step_interval=ACC_MIN_STEP_INTERVAL;
		}
		if(mmaDataBA[i].mmaAxis[mmaCurSmoothestAxis].int16data>=accBufMean)
		{
			flagValleyFreeze=FALSE;
		}
		if((mmaDataBA_diff[i].mmaAxis[mmaCurSmoothestAxis].int16data<0)&& \
			(mmaDataBA_diff[i+1].mmaAxis[mmaCurSmoothestAxis].int16data>=0)&& \
			(mmaDataBA[i+1].mmaAxis[mmaCurSmoothestAxis].int16data<accBufMean)&& \
			((accBufLastPeakValue-mmaDataBA[i+1].mmaAxis[mmaCurSmoothestAxis].int16data)>ACC_DEBOUNCE)&&\
			((i-accLastValleySuf)>=final_min_step_interval))
		{
			if(accLastValleySuf==ACC_LAST_VALLEY_SUF_DEFAULT)
			{
				accRunCounter++;
				accLastValleySuf=i+1;
				flagValleyFreeze=TRUE;
			}
			else
			{
				if(((i-accLastValleySuf)<=ACC_MAX_STEP_INTERVAL)&&(flagValleyFreeze==FALSE))
				{
					accRunCounter++;
					accLastValleySuf=i+1;
					flagValleyFreeze=TRUE;
				}
			}
		}
	}
	//put current run_count data into the recording array, run validation
	#if((MMA_DEBUG_SIMULATION==TRUE)&&(MMA_DEBUG_DATA_MODEL==4))
		accRunCntAy[RUNK]=accRunCntAyDebug[accRunK1];
		if(accRunK1<accRunCntAyDebugCnt)
			accRunK1++;
		else
			accRunK1=0;
	#else
		accRunCntAy[RUNK]=accRunCounter;
	#endif
	#if (ACC_RUN_COUNT_MODE==COUNT_ONE)//when we take one step in 32 data into counting, set mode COUNT_ONE
		//A condition
		if((accRunCntAy[RUNK]==1)&&(accRunCntAy[RUNK-1]>=2)&&(accRunCntAy[RUNK-2]>=2))
		{
			eepromWrite(STEP_DATA_TYPE, accRunCntAy[RUNK]*2);
			accRunCntAy[RUNK]=0;
			flagAccData221=TRUE;
		}
		//C condition
		if((accRunCntAy[RUNK]>=2)&&(accRunCntAy[RUNK-1]>=2)&&(accRunCntAy[RUNK-2]==1))
		{
			eepromWrite(STEP_DATA_TYPE, accRunCntAy[RUNK-2]*2);
		}
	#endif
	//B condition
	if(accRunCntAy[RUNK-1]>=2)
	{
		if((accRunCntAy[RUNK-2]+accRunCntAy[RUNK])>2)
		{
			eepromWrite(STEP_DATA_TYPE, accRunCntAy[RUNK-1]*2);
		}
		else
		{
			if((accRunCntAy[RUNK-2]==2)||(accRunCntAy[RUNK]==2))
			{
				eepromWrite(STEP_DATA_TYPE, accRunCntAy[RUNK-1]*2);
			}
		}
	}
	//rotate accRunCntAy
	accRunCntAy[0]=accRunCntAy[1];
	accRunCntAy[1]=accRunCntAy[2];
	accRunCntAy[2]=accRunCntAy[3];
	accRunCntAy[3]=0;
	//debug
	//accRunCounterTemp=accRunCounter;
	//store run counter
	//eepromWrite(STEP_DATA_TYPE, accRunCounter*2);
	//store accBufTail	
	osal_memset(mmaDataB,0,sizeof(mmaDataB));//clear mmaDataB
	mmaDataBCnt=0;
	if(mmaDataBACnt>(accBufCutLineSuf+1))//avoid i condition below zero
	{		
		if((mmaDataBACnt-accBufCutLineSuf-1)>=DATA_B_CNT_MAX)//store the last 32 bytes of mmaDataBA
		{
			for(i=0;i<DATA_B_CNT_MAX;i++)//move dataBA tail into dataB
			{
				mmaDataB[i].mmaAxis[mmaCurSmoothestAxis].int16data=mmaDataBA[mmaDataBACnt-DATA_B_CNT_MAX+i].mmaAxis[mmaCurSmoothestAxis].int16data;
			}
			mmaDataBCnt=DATA_B_CNT_MAX;
		}
		else//store all bytes of mmaDataBA
		{
			for(i=0;i<(mmaDataBACnt-accBufCutLineSuf-1);i++)//move dataBA tail into dataB
			{
				mmaDataB[i].mmaAxis[mmaCurSmoothestAxis].int16data=mmaDataBA[accBufCutLineSuf+1+i].mmaAxis[mmaCurSmoothestAxis].int16data;
			}	
			mmaDataBCnt=mmaDataBACnt-accBufCutLineSuf-1;
		}		
	}	/**/
	osal_memset(mmaDataBA,0,sizeof(mmaDataBA));//clear mmaDataBA
	mmaDataBACnt=0;   
//	for(i=0;i<DATA_BA_CNT_MAX;i++)//clear mmaDataBA
//	{
//		mmaDataBA[i]={0,0,0,0,0,0};
//	}	
	osal_memset(mmaDataA,0,sizeof(mmaDataA));//clear mmaDataBA
	mmaDataACnt=0;
//	for(i=0;i<DATA_A_CNT_MAX;i++)//clear mmaDataA
//	{
//		mmaDataA[i]={0,0,0,0,0,0};
//	}
	osal_memcpy(mmaDataBA,mmaDataB,mmaDataBCnt*MMA_DATA_STRUCT_LEGNTH);
	mmaDataBACnt=mmaDataBCnt;
	mmaLastSmoothestAxis=mmaCurSmoothestAxis;

	osal_mem_free(accBufCur);
	osal_mem_free(mmaDataASum);
	return 1;
		//debug usage
		//toggleLEDWithTime(1,CLOSE_PIO);
//	for(i=0;i<DATA_B_CNT_MAX;i++)
//	{
//		mmaDataBA[i]->mmaAxis[mmaCurSmoothestAxis].int16data=mmaDataB[i]->mmaAxis[mmaCurSmoothestAxis].int16data;
//	}

	//END OF NEW RUN COUNTER CALCULATION!
	
//	    for (int i = 0; i < count * 6; i += 6)
//	    {
//	        X_out = (int16)((accBufCur[i] << 8) | accBufCur[i+1]);
//	        Y_out = (int16)((accBufCur[i+2] << 8) | accBufCur[i+3]);
//	        Z_out = (int16)((accBufCur[i+4] << 8) | accBufCur[i+5]);
//
//	        accLoop();
//	    }
}
// static void accGetIntData(void)
// {
//     HalI2CInit(ACC_ADDRESS, I2C_CLOCK_RATE);

//     uint8 pBuf[2];

//     //read INT
//     pBuf[0] = PULSE_SRC;
//     HalMotionI2CWrite(1, pBuf);
//     HalMotionI2CRead(1, &pBuf[1]);
//     INT_STATUS = pBuf[1];

//     //DebugValue(INT_STATUS);
// }

// for memcpy

// static void eepromWrite(uint8 type){

//     toggleAdvert(TRUE);

//     uint8 pointer = type - 1;

//     UTCTime current;
//     UTCTimeStruct currentTm;

//     current = osal_getClock();
//     osal_ConvertUTCTime(&currentTm, current);

//     // if there is step data, count it by hour
//     if (type == STEP_DATA_TYPE)
//     {
//         currentTm.minutes = 0;
//     }

//     currentTm.seconds = 0;

//     if (oneData[pointer].hourSeconds == 0)       // data is empty
//     {
//         oneData[pointer].tm = currentTm;
//         oneData[pointer].hourSeconds = osal_ConvertUTCSecs(&oneData[pointer].tm);

//         oneData[pointer].count = 1;
//         oneData[pointer].type = type;

//     }else if(oneData[pointer].tm.year != currentTm.year ||
//              oneData[pointer].tm.month != currentTm.month ||
//              oneData[pointer].tm.day != currentTm.day ||
//              oneData[pointer].tm.minutes != currentTm.minutes ||         // for test, one minutes
//              oneData[pointer].tm.hour != currentTm.hour){                // pass a hour, need to write

//         // uint8 aBuf[2];
//         uint8 dBuf[8] = {
//             LO_UINT16(LO_UINT32(oneData[pointer].hourSeconds)),
//             HI_UINT16(LO_UINT32(oneData[pointer].hourSeconds)),
//             LO_UINT16(HI_UINT32(oneData[pointer].hourSeconds)),
//             HI_UINT16(HI_UINT32(oneData[pointer].hourSeconds)),
//             LO_UINT16(oneData[pointer].count),
//             HI_UINT16(oneData[pointer].count),
//             oneData[pointer].type,
//             0
//         };

//         osal_memcpy(&db[rawDataStop], &dBuf[0], 8);

//         rawDataStop += 8;

//         // arrive maxsize
//         if (rawDataStop >= EEPROM_ADDRESS_DATA_MAX)
//         {
//             rawDataStop = 0;
//         }

//         // space is full
//         if (rawDataStop == rawDataStart)
//         {
//             rawDataStart += 8;
//         }

//         uint16 length = dataLength();

//         // SimpleProfile_SetParameter( HEALTH_DATA_HEADER, 2,  &rawDataStop);
//         SimpleProfile_SetParameter( HEALTH_DATA_HEADER, 2,  &length);
//         SimpleProfile_SetParameter( HEALTH_SYNC, 8, dBuf);

//         // refresh oneData[pointer]
//         oneData[pointer].tm = currentTm;
//         oneData[pointer].hourSeconds = osal_ConvertUTCSecs(&oneData[pointer].tm);

//         oneData[pointer].count = 1;

//     }else{      // in same hour

//         oneData[pointer].count ++;
//     }

// }

// static void eepromRead(void){

//     while(rawDataStart != rawDataStop){
//         uint8 dBuf[8];

//         osal_memcpy(&dBuf[0], &db[rawDataStart], 8);

//         rawDataStart += 8;

//         // arrive maxsize
//         if (rawDataStart >= EEPROM_ADDRESS_DATA_MAX)
//         {
//             rawDataStart = 0;
//         }

//         SimpleProfile_SetParameter( HEALTH_DATA_BODY, 8,  dBuf);
//         SimpleProfile_SetParameter( HEALTH_SYNC, 8, dBuf);
//     }

//     if (rawDataStart == rawDataStop)
//     {
        
//         int i;

//         for (i = 0; i < DATA_TYPE_COUNT; i++)
//         {
//             uint8 dBuf[8] = {
//                 LO_UINT16(LO_UINT32(oneData[i].hourSeconds)),
//                 HI_UINT16(LO_UINT32(oneData[i].hourSeconds)),
//                 LO_UINT16(HI_UINT32(oneData[i].hourSeconds)),
//                 HI_UINT16(HI_UINT32(oneData[i].hourSeconds)),
//                 LO_UINT16(oneData[i].count),
//                 HI_UINT16(oneData[i].count),
//                 oneData[i].type,
//                 0
//             };

//             SimpleProfile_SetParameter( HEALTH_DATA_BODY, 8,  dBuf);

//             oneData[i].count = 0;
//         }
//     }

//     uint16 length = DATA_TYPE_COUNT;
//     SimpleProfile_SetParameter( HEALTH_DATA_HEADER, 2,  &length);
// }






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

        uint16 length = dataLength();

        // for debug
        // SimpleProfile_SetParameter( HEALTH_DATA_HEADER, 2,  &rawDataStop);
        SimpleProfile_SetParameter( HEALTH_DATA_HEADER, 2,  &length);
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
	//load 5MSB to set E2 baseline, baseline<=signal level
	//data1 = (i2c_smbus_read_byte_data(client,MPR03X_E1FDH_REG)<<6);
	//data2 = (i2c_smbus_read_byte_data(client,MPR03X_E1FDL_REG)>>2) & 0xF8;
	//data = data1 | data2;
	//i2c_smbus_write_byte_data(client,MPR03X_E1BV_REG,data); 

	//addr=MPR03X_E1FDH_REG;
	//HalMotionI2CWrite(1, &addr);
	//HalMotionI2CRead(1,&val);
	//data1=val<<6;
	//addr=MPR03X_E1FDL_REG;
	//HalMotionI2CWrite(1, &addr);
	//HalMotionI2CRead(1,&val);
	//data2=(val>>2)&0xF8;
	//pBuf[0]=MPR03X_E1BV_REG;
	//pBuf[1]= data1 | data2;
	//HalI2CWrite(2,pBuf);
	//because we use one electrode only
	
	//load 5MSB to set E3 baseline, baseline<=signal level
	//data= (i2c_smbus_read_byte_data(client,MPR03X_E2FDH_REG)<<6)|(i2c_smbus_read_byte_data(client,MPR03X_E2FDL_REG)>>2) & 0xF8;;  
	//i2c_smbus_write_byte_data(client,MPR03X_E2BV_REG,data); 
	  
	//Set baseline filtering
	//i2c_smbus_write_byte_data(client,MPR03X_MHD_REG,0x01); 
	//i2c_smbus_write_byte_data(client,MPR03X_NHD_REG,0x01); 
	//i2c_smbus_write_byte_data(client,MPR03X_NCL_REG,0x0f); 	
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
	//i2c_smbus_write_byte_data(client,MPR03X_E0TTH_REG,MPR03X_TOUCH_THRESHOLD); 
	//i2c_smbus_write_byte_data(client,MPR03X_E0RTH_REG,MPR03X_RELEASE_THRESHOLD);
	//i2c_smbus_write_byte_data(client,MPR03X_E1TTH_REG,MPR03X_TOUCH_THRESHOLD); 
	//i2c_smbus_write_byte_data(client,MPR03X_E1RTH_REG,MPR03X_RELEASE_THRESHOLD);
	//i2c_smbus_write_byte_data(client,MPR03X_E2TTH_REG,MPR03X_TOUCH_THRESHOLD); 
	//i2c_smbus_write_byte_data(client,MPR03X_E2RTH_REG,MPR03X_RELEASE_THRESHOLD);	
	pBuf[0]=MPR03X_E0TTH_REG;
	pBuf[1]=MPR03X_TOUCH_THRESHOLD;
	HalI2CWrite(2,pBuf);
	pBuf[0]=MPR03X_E0RTH_REG;
	pBuf[1]=MPR03X_RELEASE_THRESHOLD;
	HalI2CWrite(2,pBuf);
	
	//Set AFE  
	//i2c_smbus_write_byte_data(client,MPR03X_AFEC_REG,MPR03X_FFI_6| CDC); 
	//i2c_smbus_write_byte_data(client,MPR03X_FC_REG,CDT<<5 | MPR03X_SFI_4 | MPR03X_ESI_4MS);
	pBuf[0]=MPR03X_AFEC_REG;
	pBuf[1]=MPR03X_FFI_6| CDC;
	HalI2CWrite(2,pBuf);
	pBuf[0]=MPR03X_FC_REG;
	pBuf[1]=CDT<<5 | MPR03X_SFI_4 | MPR03X_ESI_8MS;//MPR03X_ESI_4MS
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
