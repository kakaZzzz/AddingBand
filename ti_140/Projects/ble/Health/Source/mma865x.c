/***********************************************************************************************\
* Freescale MMA865xQ Driver
*
* Filename: mma865x.c
*
* Description: Driver source file for Freescale MMA8652Q and MMA8653Q accelerometers
*
* (c) Copyright 2011, Freescale, Inc.  All rights reserved.
*
* No part of this document must be reproduced in any form - including copied,
* transcribed, printed or by any electronic means - without specific written
* permission from Freescale Semiconductor.
*
\***********************************************************************************************/

#include "system.h"

/***********************************************************************************************\
* Private macros
\***********************************************************************************************/

/***********************************************************************************************\
* Private type definitions
\***********************************************************************************************/

/***********************************************************************************************\
* Private prototypes
\***********************************************************************************************/

/***********************************************************************************************\
* Private memory declarations
\***********************************************************************************************/

/***********************************************************************************************\
* Public memory declarations
\***********************************************************************************************/

#pragma DATA_SEG __SHORT_SEG _DATA_ZEROPAGE

extern byte SlaveAddressIIC;

#pragma DATA_SEG DEFAULT

/***********************************************************************************************\
* Public functions
\***********************************************************************************************/

/*********************************************************\
* Put MMA865xQ into Active Mode
\*********************************************************/
void MMA865x_Active (void)
{
  /*
  ** Set the Active bit in System Control 1 Register.
  */
  IIC_RegWrite(SlaveAddressIIC, CTRL_REG1, (IIC_RegRead(SlaveAddressIIC, CTRL_REG1) | ACTIVE_MASK));
}


/*********************************************************\
* Put MMA865xQ into Standby Mode
\*********************************************************/
byte MMA865x_Standby (void)
{
  byte n;
  /*
  **  Read current value of System Control 1 Register.
  **  Put sensor into Standby Mode by clearing the Active bit.
  **  Return with previous value of System Control 1 Register.
  */
  n = IIC_RegRead(SlaveAddressIIC, CTRL_REG1);
  IIC_RegWrite(SlaveAddressIIC, CTRL_REG1, n & (~ACTIVE_MASK));
  return (n & ACTIVE_MASK);
}


/*********************************************************\
* Initialize MMA865xQ
\*********************************************************/
void MMA865x_Init (void)
{
  byte n;
  /*
  **  Reset sensor, and wait for reboot to complete
  */
  IIC_RegWrite(SlaveAddressIIC, CTRL_REG2, RST_MASK);
  do {
    n = IIC_RegRead(SlaveAddressIIC, CTRL_REG2);
  } while (n & RST_MASK);
  /*
  **  Configure sensor for:
  **    - Sleep Mode Poll Rate of 50Hz (20ms)
  **    - System Output Data Rate of 200Hz (5ms)
  **    - Full Scale of +/-8g
  */
  IIC_RegWrite(SlaveAddressIIC, CTRL_REG1, ASLP_RATE_20MS + DATA_RATE_5MS);
  /*
  **  Configure sensor data for:
  **    - Full Scale of +/-8g
  **
  **  XYZ Data Event Flag Enable
  */
  IIC_RegWrite(SlaveAddressIIC, XYZ_DATA_CFG_REG, FULL_SCALE_2G);
  full_scale = FULL_SCALE_2G;
}


/***********************************************************************************************\
* Private functions
\***********************************************************************************************/
