/*static char *SCCSID = "@(#)adskstr1.c 6.4 92/05/05";*/
/**************************************************************************
 *
 * SOURCE FILE NAME =  ADSKSTR1.C
 *
 * DESCRIPTIVE NAME =  IBM2ADSK.ADD - Adapter Driver for ABIOS DASD Devices
 *                     Strategy 1 Entry Point
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
 * DESCRIPTION : Routes initialization packet, accepts open/close packets,
 *               rejects all others.
 *
 *
 ***************************************************************************/




#define INCL_NOBASEAPI
#define INCL_NOPMAPI
#include <os2.h>

#include <devcmd.h>

#define INCL_INITRP_ONLY
#include <reqpkt.h>

#include <scb.h>
#include <abios.h>

#include <iorb.h>
#include <addcalls.h>

#include <adskcons.h>
#include <adsktype.h>
#include <adskpro.h>
#include <adskextn.h>

extern USHORT InitComplete;

VOID NEAR ADSKStr1()
{

 PRPH           pRPH;
 USHORT         Cmd;

 _asm
   {
     mov word ptr pRPH[0], bx
     mov word ptr pRPH[2], es
   }

 Cmd = pRPH->Cmd;
 if ((Cmd == CMDInitBase) && !InitComplete )
   {
     pRPH->Status = ADSKInit( (PRPINITIN) pRPH );
   }
 else
   if ((Cmd == CMDOpen) || (Cmd == CMDClose))                        
     {                                                               
       pRPH->Status |= STATUS_DONE;                                  
     }                                                               
   else
     {
       StatusError( pRPH, STATUS_ERR_UNKCMD );
     }

  _asm
    {
      leave
      retf
    }

 }


/*---------------------------------------------------------------------------*/
/* Strategy 1 Error Processing                                               */
/* ---------------------------                                               */
/*                                                                           */
/*                                                                           */
/*---------------------------------------------------------------------------*/

 VOID NEAR StatusError( pRPH, ErrorCode )
 PRPH           pRPH;
 USHORT         ErrorCode;
 {
   pRPH->Status |= ErrorCode;
   pRPH->Status |= STATUS_DONE;                                      
   return;
 }


