/******************** (C) COPYRIGHT 2012 Freescale Semiconductor, Inc. *************
 *
 * File Name		: mpr03x.h
 * Authors		: Rick Zhang(rick.zhang@freescale.com)
 			  Rick is willing to be considered the contact and update points 
 			  for the driver
 * Version		: V.1.0.0
 * Date			: 2012/Feb/1
 * Description		: Header file for Freescale MPR03x (MPR031, MPR032) Capacitive Touch Sensor Controllor.
 *
 ******************************************************************************
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * THE PRESENT SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
 * OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, FOR THE SOLE
 * PURPOSE TO SUPPORT YOUR APPLICATION DEVELOPMENT.
 * AS A RESULT, FREESCALE SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
 * INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
 * CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
 * INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
 *
 * THIS SOFTWARE IS SPECIFICALLY DESIGNED FOR EXCLUSIVE USE WITH FREESCALE PARTS.

 ******************************************************************************
 * Revision 1.0.0 2/1/2012 First Release;
 ******************************************************************************
*/

#ifndef MPR03X_H
#define MPR03X_H

/* Register definitions */

#define MPR03X_TS_REG   	    0x00
#define MPR03X_E0FDL_REG      	0x02
#define MPR03X_E0FDH_REG      	0x03
#define MPR03X_E1FDL_REG      	0x04
#define MPR03X_E1FDH_REG      	0x05
#define MPR03X_E2FDL_REG      	0x06
#define MPR03X_E2FDH_REG      	0x07

#define MPR03X_E0BV_REG      	0x1a
#define MPR03X_E1BV_REG      	0x1b
#define MPR03X_E2BV_REG      	0x1c

#define MPR03X_MHD_REG      	0x26
#define MPR03X_NHD_REG      	0x27
#define MPR03X_NCL_REG      	0x28


#define MPR03X_E0TTH_REG      	0x29
#define MPR03X_E0RTH_REG      	0x2a
#define MPR03X_E1TTH_REG      	0x2b
#define MPR03X_E1RTH_REG      	0x2c
#define MPR03X_E2TTH_REG      	0x2d
#define MPR03X_E2RTH_REG      	0x2e

#define MPR03X_AFEC_REG      	0x41
#define MPR03X_FC_REG       	0x43
#define MPR03X_EC_REG       	0x44

//adjust according to system SNR
//Set to lower threshold to optimize sensitivity vs. noise
//make sure touch delta change >> MPR03X_TOUCH_THRESHOLD >> MPR03X_RELEASE_THRESHOLD >> noise
#define MPR03X_TOUCH_THRESHOLD 	  	0x08//0x0f //0x08
#define MPR03X_RELEASE_THRESHOLD 	0x05//0x0a //0x05

#define MPR03X_FFI_6     		0x00
#define MPR03X_FFI_10    		0x40
#define MPR03X_FFI_18    		0x80
#define MPR03X_FFI_34    		0xC0

#define MPR03X_SFI_4     		0x00
#define MPR03X_SFI_6     		0x08
#define MPR03X_SFI_10    		0x10
#define MPR03X_SFI_18    		0x18

#define MPR03X_ESI_1MS   		0x00
#define MPR03X_ESI_2MS   		0x01
#define MPR03X_ESI_4MS   		0x02
#define MPR03X_ESI_8MS   		0x03
#define MPR03X_ESI_16MS  		0x04
#define MPR03X_ESI_32MS  		0x05
#define MPR03X_ESI_64MS  		0x06
#define MPR03X_ESI_128MS 		0x07

#define MPR03X_CALI_DISABLE  	0x40
#define MPR03X_RUN2_MODE     	0x10
#define MPR03X_E1_IRQ        	0x01
#define MPR03X_E1_E2_IRQ     	0x02
#define MPR03X_E1_E2_E3      	0x03        


#define MPR03X_AC_VDD			2.2	// 1.8
#define MPR03X_AC_USL_CT		698  //900   // USL_CT =(MPR03X_AC_VDD-0.7)/MPR03X_AC_VDD*1024 if for linear cap detection
#define MPR03X_AC_LSL_CT		349  //450  		//equ: MPR03X_AC_ LSL_CT=MPR03X_AC_USL_CT / 2
#define MPR03X_AC_USL_CS		MPR03X_AC_USL_CT  //USL_CT		//equ: MPR03X_AC_USL_CS= MPR03X_AC_USL_CT
#define	MPR03X_AC_LSL_CS		628  //850	equ: MPR03X_AC_LSL_CS=MPR03X_AC_USL_CS * 0.9	


#define MPR03X_MAX_KEY_COUNT    3
/**
 * @keycount: how many key maped
 * @vdd_uv: voltage of vdd supply the chip in uV
 * @matrix: maxtrix of keys
 * @wakeup: can key wake up system.
 */
struct mpr03x_platform_data {
	uint16 keycount;//u16
	uint16 *matrix;//u16
	int wakeup;//int
};

#endif
