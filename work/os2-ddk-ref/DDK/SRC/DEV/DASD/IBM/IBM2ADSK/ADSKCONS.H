/*static char *SCCSID = "src/dev/dasd/ibm/ibm2adsk/adskcons.h, adsk, ddk_subset, ddk2_r206.044 93/03/20";*/
/**************************************************************************
 *
 * SOURCE FILE NAME =  ADSKCONS.H
 *
 * DESCRIPTIVE NAME =  IBM2ADSK.ADD - Adapter Driver for ABIOS DASD Devices
 *
 *
 * 
 * 
 * COPYRIGHT    Copyright (C) 1992 IBM Corporation
 *              Copyright (C) 1989 Microsoft Corporation
 * 
 * The following IBM OS/2 2.1 source code is provided to you solely for
 * the purpose of assisting you in your development of OS/2 2.x device
 * drivers. You may use this code in accordance with the IBM License
 * Agreement provided in the IBM Device Driver Source Kit for OS/2. This
 * Copyright statement may not be removed.
 * 
 * 
 *
 * VERSION = V2.0
 *
 * DATE
 *
 * DESCRIPTION : Miscellaneous constants and macros
 *
 *
 *
 ***************************************************************************/




/*---------------------------------------------------*/
/*                                                   */
/*                                                   */
/*---------------------------------------------------*/

#define ENABLE  _asm{ sti }
#define DISABLE _asm{ cli }

/*---------------------------------------------------*/
/*                                                   */
/*                                                   */
/*---------------------------------------------------*/

#define ADDNAME                "IBM_ABIOS_DISK  "
#define ADDFLAGS               0
#define DRIVERCLASS_ADD        1

/*---------------------------------------------------*/
/*                                                   */
/*                                                   */
/*---------------------------------------------------*/

#define SECTOR_SHIFT            9

/*---------------------------------------------------*/
/*                                                   */
/*                                                   */
/*---------------------------------------------------*/

#define MAX_CONFIG_DATA        (16*1024)
#define MAX_LIDS                32
#define MAX_HW_INT_LEVELS       4
#define MAX_SG_BUFFERS          4
#define MAX_INTERRUPT_NESTING   4                                    

/*---------------------------------------------------*/
/*                                                   */
/*                                                   */
/*---------------------------------------------------*/

#define REQUEST_DONE            0
#define REQUEST_NOT_DONE        1
#define REQUEST_RETRY           2

/*---------------------------------------------------*/
/*                                                   */
/*                                                   */
/*---------------------------------------------------*/

#define STAGE_START             ABIOS_EP_START
#define STAGE_INT               ABIOS_EP_INTERRUPT

/*---------------------------------------------------*/
/*                                                   */
/*                                                   */
/*---------------------------------------------------*/

#define ABRC_PARMERROR          0x4000
#define ABRC_TIMEOUTERROR       0x2000
#define ABRC_DEVERROR           0x1000

/*---------------------------------------------------*/
/*                                                   */
/*                                                   */
/*---------------------------------------------------*/
#define STERR_GENERAL_FAILURE   0x810c
