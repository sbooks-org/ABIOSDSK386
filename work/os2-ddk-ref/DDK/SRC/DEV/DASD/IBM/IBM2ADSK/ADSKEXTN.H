/*static char *SCCSID = "src/dev/dasd/ibm/ibm2adsk/adskextn.h, adsk, ddk_subset, ddk2_r206.044 93/03/20";*/
/**************************************************************************
 *
 * SOURCE FILE NAME =  ADSKEXTN.H
 *
 * DESCRIPTIVE NAME =  IBM2ADSK.ADD - Adapter Driver for ABIOS DASD Devices
 *                     Static/Initialization external references
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
 * DESCRIPTION : Maps internal data used by this ADD in ADSKDATA.C
 *
 *               When editing this file, try to keep the text aligned with
 *               ADSKDATA.C. This will make tracking EXTERNS for data
 *               items a log easier!
 *
 *
 ***************************************************************************/




/*--------------*/
/* Static Data  */
/*--------------*/

extern PFN     Device_Help;

extern USHORT  InitComplete;
extern USHORT  TotalLids;
extern USHORT  TotalLCBs;

extern USHORT  ADDHandle;

extern NPUCB   npUCBAnchor;

extern NPLCB   npLCBCmpQHead;
extern NPLCB   npLCBCmpQFoot;

extern NPLCB   npLCBBusyQHead;

extern USHORT  MaxSGBuffers;
extern USHORT  ABIOSMaxXfer;

extern USHORT  CompletionProcessActive;

extern USHORT  InitPhaseComplete;
extern USHORT  DevIOCount;

extern USHORT  NestLevel;                                            

extern USHORT  LevelsInUse;
extern INTCB   IntLevelCB[MAX_HW_INT_LEVELS];




extern NPLCB   npLCBBufQHead;
extern NPLCB   npLCBBufQFoot;

extern NPIOBUF_POOL    npBufPoolHead;
extern NPIOBUF_POOL    npBufPoolFoot;
extern IOBUF_POOL      IOBufPool[];

extern UCHAR           LidIOCount[MAX_LIDS];



/* Refer to ADSKERRT.H for the following data items */

extern UCHAR   AB_8xxx_To_Index[];
extern USHORT  AB_8xxx_Max_Index;
extern USHORT  AB_8xxx_Index_To_IORBErr[];

extern UCHAR   AB_9xxx_To_Index[];
extern USHORT  AB_9xxx_Max_Index;
extern USHORT  AB_9xxx_Index_To_IORBErr[];
extern USHORT  AB_Axxx_Index_To_IORBErr[];

extern UCHAR   AB_Cxxx_To_Index[];
extern USHORT  AB_Cxxx_Max_Index;
extern USHORT  AB_Cxxx_Index_To_IORBErr[];



extern UCHAR AdapterName_ST506[17];
extern UCHAR AdapterName_ESDI [17];
extern UCHAR AdapterName_SCSI [17];


/*--------------------*/
/* Configuration Data */
/*--------------------*/

extern  BYTE   ConfigPool[MAX_CONFIG_DATA];

/*---------------------*/
/* Initialization Data */
/*---------------------*/

extern BYTE    InitDataStart;
extern USHORT  ConfigPoolAvail;
extern NPBYTE  npConfigPool;
extern NPUCB   npUCBPrevLID;
extern NPLCB   npLCBPrevLID;
extern BYTE    InitABRB1[GENERIC_ABRB_SIZE];
extern BYTE    InitABRB2[GENERIC_ABRB_SIZE];

extern USHORT  InitLidTable[];


