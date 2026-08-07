/*static char *SCCSID = "src/dev/dasd/ibm/ibm2adsk/adsksgb.c, adsk, ddk_subset, ddk2_r206.044 93/03/20";*/
/**************************************************************************
 *
 * SOURCE FILE NAME =  ADSKSGB.C
 *
 * DESCRIPTIVE NAME =  IBM2ADSK.ADD - Adapter Driver for ABIOS DASD Devices
 *                     Scatter/Gather Buffer Management
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
 * DESCRIPTION : Handles Allocation/Deallocation of S/G Buffers
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

#include <dhcalls.h>

#include <adskcons.h>
#include <adsktype.h>
#include <adskpro.h>
#include <adskextn.h>


/*-----------------------------------------------------------*/
/*                                                           */
/* Obtain a Scatter/Gather Emulation Buffer                  */
/* ----------------------------------------                  */
/*                                                           */
/*                                                           */
/*-----------------------------------------------------------*/

NPIOBUF_POOL NEAR AllocSGBuffer( npLCB, CallBackRoutine )

NPLCB   npLCB;
VOID    (NEAR *CallBackRoutine)();
{
  NPIOBUF_POOL npBufPool;

  DISABLE


  /*---------------------------------------------------*/
  /* If a S/G buffer is available, then remove the     */
  /* buffer from the pool and return it to the         */
  /* requestor.                                        */
  /*---------------------------------------------------*/

  if ( npBufPool = npBufPoolHead )
    {
      if ( !(npBufPoolHead = npBufPool->npNextBuf) )
        {
          npBufPoolFoot = 0;
        }
      npBufPool->npNextBuf = 0;
     }
  /*---------------------------------------------------*/
  /* Otherwise, mark the LCB in a buffer wait. Record  */
  /* the CallBack address in the LCB and add the LCB   */
  /* to the list of LCBs waiting on S/G buffers.       */
  /*---------------------------------------------------*/

  else
    {
      npLCB->IntFlags      |= LCBF_ONBUFWAITQ;

      npLCB->npBufNotifyRtn = CallBackRoutine;

      if ( !npLCBBufQFoot )
        {
          npLCBBufQHead = npLCB;
        }
      else
        {
          npLCBBufQFoot->npNextBufQLCB = npLCB;
        }

      npLCBBufQFoot        = npLCB;
      npLCB->npNextBufQLCB = 0;
    }

  ENABLE

  return ( npBufPool );
}


/*-----------------------------------------------------------*/
/*                                                           */
/* Release a Scatter/Gather Emulation Buffer                 */
/* -----------------------------------------                 */
/*                                                           */
/*                                                           */
/*-----------------------------------------------------------*/

VOID NEAR FreeSGBuffer( npIOBuf )

NPIOBUF_POOL   npIOBuf;
{
  NPLCB     npLCB;

  DISABLE

  /*---------------------------------------------------*/
  /* If an LCB was waiting on a buffer, remove the LCB */
  /* from the buffer wait Q and call the LCB's notify  */
  /* address.                                          */
  /*---------------------------------------------------*/

  npIOBuf->npNextBuf = 0;

  if ( npLCB = npLCBBufQHead )
    {
      if ( !(npLCBBufQHead = npLCB->npNextBufQLCB) )
        {
          npLCBBufQFoot = 0;
        }

      npLCB->IntFlags      &= ~LCBF_ONBUFWAITQ;
      npLCB->npNextBufQLCB  =  0;

      ENABLE

      (*npLCB->npBufNotifyRtn)( npLCB, npIOBuf );
    }
  /*---------------------------------------------------*/
  /* Otherwise, return the buffer to the S/G buffer    */
  /* pool.                                             */
  /*---------------------------------------------------*/
  else
    {
      if ( !npBufPoolHead )
        {
          npBufPoolHead = npIOBuf;
        }
      else
        {
          npBufPoolFoot->npNextBuf = npIOBuf;
        }

      npBufPoolFoot = npIOBuf;
    }

  ENABLE
}

