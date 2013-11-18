/**************************************************************************************************
  Filename:       hal_i2c.h
  Revised:        $Date: 2012-09-21 06:30:38 -0700 (Fri, 21 Sep 2012) $
  Revision:       $Revision: 31581 $

  Description:    HAL I2C API for the CC2541ST. It implements the I2C master only.

  Copyright 2012  Texas Instruments Incorporated. All rights reserved.

  IMPORTANT: Your use of this Software is limited to those specific rights
  granted under the terms of a software license agreement between the user
  who downloaded the software, his/her employer (which must be your employer)
  and Texas Instruments Incorporated (the "License").  You may not use this
  Software unless you agree to abide by the terms of the License. The License
  limits your use, and you acknowledge, that the Software may not be modified,
  copied or distributed unless embedded on a Texas Instruments microcontroller
  or used solely and exclusively in conjunction with a Texas Instruments radio
  frequency transceiver, which is integrated into your product.  Other than for
  the foregoing purpose, you may not use, reproduce, copy, prepare derivative
  works of, modify, distribute, perform, display or sell this Software and/or
  its documentation for any purpose.

  YOU FURTHER ACKNOWLEDGE AND AGREE THAT THE SOFTWARE AND DOCUMENTATION ARE
  PROVIDED “AS IS?WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED,
  INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, TITLE,
  NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL
  TEXAS INSTRUMENTS OR ITS LICENSORS BE LIABLE OR OBLIGATED UNDER CONTRACT,
  NEGLIGENCE, STRICT LIABILITY, CONTRIBUTION, BREACH OF WARRANTY, OR OTHER
  LEGAL EQUITABLE THEORY ANY DIRECT OR INDIRECT DAMAGES OR EXPENSES
  INCLUDING BUT NOT LIMITED TO ANY INCIDENTAL, SPECIAL, INDIRECT, PUNITIVE
  OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, COST OF PROCUREMENT
  OF SUBSTITUTE GOODS, TECHNOLOGY, SERVICES, OR ANY CLAIMS BY THIRD PARTIES
  (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF), OR OTHER SIMILAR COSTS.

  Should you have any questions regarding your right to use this Software,
  contact Texas Instruments Incorporated at www.TI.com.
**************************************************************************************************/

#ifndef HAL_I2C_H
#define HAL_I2C_H

/* ------------------------------------------------------------------------------------------------
 *                                          Includes
 * ------------------------------------------------------------------------------------------------
 */
#include "comdef.h"

/* ------------------------------------------------------------------------------------------------
 *                                          Constants
 * ------------------------------------------------------------------------------------------------
 */
#define HAL_I2C_SLAVE_ADDR_DEF           0x41

/* ------------------------------------------------------------------------------------------------
 *                                           Typedefs
 * ------------------------------------------------------------------------------------------------
 */
typedef enum
{
  i2cClock_123KHZ = 0x00,
  i2cClock_144KHZ = 0x01,
  i2cClock_165KHZ = 0x02,
  i2cClock_197KHZ = 0x03,
  i2cClock_33KHZ  = 0x80,
  i2cClock_267KHZ = 0x81,
  i2cClock_533KHZ = 0x82
} i2cClock_t;


/* ------------------------------------------------------------------------------------------------
 *                                       Global Functions
 * ------------------------------------------------------------------------------------------------
 */
void     HalI2CInit(uint8 address, i2cClock_t clockRate);
uint8    HalI2CRead(uint8 len, uint8 *pBuf);
uint8    HalI2CWrite(uint8 len, uint8 *pBuf);
uint8    HalMotionI2CRead(uint8 len, uint8 *pBuf);
uint8    HalMotionI2CWrite(uint8 len, uint8 *pBuf);
void     HalI2CDisable(void);


// fixed by weizhong
uint8    HalI2CAckPolling(void);

#endif
/**************************************************************************************************
 */
