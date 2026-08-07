/*static char *SCCSID = "src/dev/dasd/ibm/ibm2adsk/adskinth.c, adsk, ddk_subset, ddk2_r206.044 93/03/20";*/
/**************************************************************************
 *
 * SOURCE FILE NAME =  ADSKINTH.C
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
 * DESCRIPTION : Interrupt Handling Routines
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

/*-------------------------------------------------------------------------*/
/*                                                                         */
/* Interrupt Handler Entry Points                                          */
/* ------------------------------                                          */
/*                                                                         */
/* Call the common interrupt handler code with the appropriate interrupt   */
/* control block. On return the interrupt handler will indicate whether    */
/* or not it has handled the interrupt via its return code. The return     */
/* code is right shifted to set or reset the CF flag which the kernel      */
/* tests.                                                                  */
/*                                                                         */
/*-------------------------------------------------------------------------*/


USHORT FAR IRQEntry0()
{
  return (InterruptHandler( &IntLevelCB[0] ) >> 1);
}

USHORT FAR IRQEntry1()
{
  return (InterruptHandler( &IntLevelCB[1] ) >> 1);
}

USHORT FAR IRQEntry2()
{
  return (InterruptHandler( &IntLevelCB[2] ) >> 1);
}

USHORT FAR IRQEntry3()
{
  return (InterruptHandler( &IntLevelCB[3] ) >> 1);
}

USHORT NEAR InterruptHandler( npIntCB )

NPINTCB npIntCB;

{
  NPLCB         npLCB;
  USHORT        Claimed = 0;
  SHORT         ABIOSRc;

  NestLevel++;

  ENABLE

  npLCB    = npIntCB->npFirstLCB;

  while ( npLCB )
    {
      if ( npLCB->IntFlags & LCBF_ACTIVE )
        {
          ABIOSRc = ((NPABRBH) npLCB->ABIOSReq)->RC;
          if ( (ABIOSRc & ABRC_STAGEONINTERRUPT) && (ABIOSRc != ABRC_START) )
            {
              ABIOSRc = StageABIOSRequest( npLCB, ABIOS_EP_INTERRUPT );

              Claimed |= !( ( ABIOSRc == ABRC_SPURIOUSINTERRUPT)
                                      || (ABIOSRc == ABRC_NOTMYINTERRUPT));

              if ( ABIOSRc <= 0 && ABIOSRc != -1 )
                {
                  QueueLCBComplete( npLCB );
                }
            }
        }
      npLCB = npLCB->npNextIntLCB;
    }

  /*------------------------------------------------------------*/
  /*                                                            */
  /* Default Interrupt Handler Processing                       */
  /* ------------------------------------                       */
  /*                                                            */
  /* If there were no request blocks active, we may need to     */
  /* call the ABIOS Default Interrupt Handler.                  */
  /*                                                            */
  /*------------------------------------------------------------*/

  if ( !Claimed )
    {
      Claimed = ProcessDefaultInt( npIntCB );
    }

  /*-------------------------------------------------*/              
  /* If we have exceeded the allowable nesting level */              
  /* for this driver:                                */              
  /*                                                 */              
  /*    1.) The IRQ level is held until we have      */              
  /*        processed LCB completions.               */              
  /*                                                 */              
  /*    2.) System interrupts are disabled           */              
  /*        prior to issuing the EOI for the         */              
  /*        level.                                   */              
  /*-------------------------------------------------*/              
                                                                     
  if ( NestLevel > MAX_INTERRUPT_NESTING )                           
    {                                                                
      ProcessLCBComplete();                                          
                                                                     
      DISABLE                                                        
                                                                     
      if ( Claimed )                                                 
        {                                                            
          DevHelp_EOI( npIntCB->HwIntLevel );                        
        }                                                            
    }                                                                
  else                                                               
    {                                                                
      if ( Claimed )                                                 
        {                                                            
          DevHelp_EOI( npIntCB->HwIntLevel );                        
        }                                                            
                                                                     
      ProcessLCBComplete();                                          
    }                                                                
                                                                     
  NestLevel--;                                                       

  return( ~Claimed );
}


/*------------------------------------------*/
/*                                          */
/*                                          */
/*                                          */
/*                                          */
/*------------------------------------------*/

USHORT NEAR StageABIOSRequest( npLCB, Abios_EP_Type )

NPLCB           npLCB;
USHORT          Abios_EP_Type;
{
  NPABRBH       npABRBH;
  USHORT        ABIOSRc;
  USHORT        IntClaimed;
  ULONG         Timeout;


  npABRBH = (NPABRBH)npLCB->ABIOSReq;

  if ( Abios_EP_Type == ABIOS_EP_START )
    {
      npABRBH->RC = ABRC_START;
      LidIOCount[npLCB->LidIndex]++;
    }
  else
    {
      npLCB->IntFlags &= ~LCBF_STARTPENDING;
    }

  do
    {
      ENABLE

      if ( DevHelp_ABIOSCall( npABRBH->LID, (NPBYTE) npABRBH,
                                                       Abios_EP_Type ) )
        {
          _asm { int 3 }
        }
      DISABLE
      ABIOSRc = npABRBH->RC;
    }
  while ( ABIOSRc == ABRC_STAGEONTIME &&
                             ((NPABRB_DISK_RWV) npABRBH)->WaitTime == 1 );

  /*                         A                                 */
  /*                         |                                 */
  /*-----------------------------------------------------------*/
  /* ABIOS hack for problems with Mod 80 ESDI controllers      */
  /*-----------------------------------------------------------*/


  IntClaimed = !( ( ABIOSRc == ABRC_SPURIOUSINTERRUPT)
                                    || (ABIOSRc == ABRC_NOTMYINTERRUPT));

  if ( IntClaimed )
    {
      if ( npLCB->IntTimerHandle )
        {
          ADD_CancelTimer((ULONG) npLCB->IntTimerHandle);
          npLCB->IntTimerHandle = 0;
        }

      if ( npLCB->DlyTimerHandle )
        {
          _asm { int 3 }
        }
    }

  if ( ABIOSRc == ABRC_STAGEONINTERRUPT )
    {
      /*---------------------------------------------------------*/
      /* Note: ABIOS Interrupt Time Out in (Sec) is in Bits 15-3 */
      /*---------------------------------------------------------*/

      if ( (Timeout=npLCB->Timeout) != -1L )
        {
          Timeout = ULONGmulULONG( 1000L,
                                   ((!Timeout) ? (ULONG)(npABRBH->Timeout >> 3)
                                               : Timeout                     ));

          if ( ADD_StartTimerMS((PULONG) &npLCB->IntTimerHandle,
                                (ULONG)  Timeout,
                                (PFN)    InterruptTimeoutHandler,
                                (PVOID)  npLCB,
                                (PVOID)  0            ) )
            {
              _asm { int 3 }
            }
        }

      ENABLE
    }
  else if ( ABIOSRc == ABRC_STAGEONTIME )
    {
      /*--------------------------------*/
      /* Note: ABIOS WaitTime in (uSec) */
      /*--------------------------------*/
      ENABLE
      if ( ADD_StartTimerMS(
                        (PULONG) &npLCB->IntTimerHandle,
                        (ULONG)  ULONGdivUSHORT(
                                  ((NPABRB_DISK_RWV) npABRBH)->WaitTime, 1000, 0),
                        (PFN)    DelayTimeoutHandler,
                        (PVOID)  npLCB,
                        (PVOID)  0            ) )
        {
          _asm { int 3 }
        }
    }

  ENABLE

  return( ABIOSRc );
}


/*------------------------------------------*/
/*                                          */
/*                                          */
/*                                          */
/*                                          */
/*------------------------------------------*/

USHORT NEAR ProcessDefaultInt( npIntCB )

NPINTCB         npIntCB;
{
  NPLCB         npLCB;
  NPABRBH       npABRBH;
  USHORT        PrevLid;
  USHORT        ThisLid;
  USHORT        LCBIntStage;
  USHORT        Claimed =  0;


  npABRBH = (NPABRBH) npIntCB->DefaultABIOSReq;
  npABRBH->Unit     = 0;
  npABRBH->Function = ABFC_DEFAULT_INT_HANDLER;

  npLCB   = npIntCB->npFirstLCB;
  ThisLid = ((NPABRBH) npLCB->ABIOSReq)->LID;

  DISABLE

  while( npLCB )
    {
      LCBIntStage = 0;
      PrevLid     = ThisLid;

      while ( npLCB && (ThisLid == PrevLid) )
        {
          LCBIntStage |= (((NPABRBH) npLCB->ABIOSReq)->RC == ABRC_NOTMYINTERRUPT);

          PrevLid = ThisLid;
          if ( npLCB = npLCB->npNextIntLCB )
            {
              ThisLid = ((NPABRBH) npLCB->ABIOSReq)->LID;
            }
        }

      if ( !LCBIntStage )
        {
          npABRBH->LID = PrevLid;
          npABRBH->RC  = ABRC_START;
          if ( DevHelp_ABIOSCall( npABRBH->LID, (NPBYTE) npABRBH,
                                                    ABIOS_EP_INTERRUPT ) )
            {
              _asm { int 3 }
            }
          Claimed |= ( npABRBH->RC == ABRC_COMPLETEOK ) ? 1 : 0;
        }
    }

  ENABLE

  return( Claimed );
}

/*------------------------------------------*/
/*                                          */
/*                                          */
/*                                          */
/*                                          */
/*------------------------------------------*/

VOID NEAR QueueLCBComplete( npLCB )

NPLCB           npLCB;
{
  DISABLE

  if ( npLCB->IntFlags & LCBF_ONCOMPLETEQ )
    {
      _asm { int 3 }
    }

  if ( !npLCBCmpQHead )
    {
      npLCBCmpQHead = npLCB;
    }
  else
    {
      npLCBCmpQFoot->npNextCmpQLCB = npLCB;
    }

  npLCBCmpQFoot        = npLCB;
  npLCB->npNextCmpQLCB = 0;

  npLCB->IntFlags |= LCBF_ONCOMPLETEQ;

  ENABLE
}

/*------------------------------------------*/
/*                                          */
/*                                          */
/*                                          */
/*                                          */
/*------------------------------------------*/

VOID NEAR ProcessLCBComplete( )

{
  NPLCB    npLCB;

  DISABLE
  if ( !CompletionProcessActive )
    {
      CompletionProcessActive = 1;

      while ( npLCB = npLCBCmpQHead )
        {
          if ( !(npLCBCmpQHead = npLCB->npNextCmpQLCB) )
            {
              npLCBCmpQFoot = 0;
            }

          npLCB->IntFlags      &= ~LCBF_ONCOMPLETEQ;
          npLCB->npNextCmpQLCB  =  0;

          ENABLE

          if ( ContinueDeviceIO( npLCB ) == REQUEST_DONE )
            {
              CompleteDeviceIO( npLCB );
              StartLCB( npLCB );
            }

          DISABLE
        }

      CompletionProcessActive = 0;

    }
  ENABLE
}

/*------------------------------------------*/
/*                                          */
/*                                          */
/*                                          */
/*                                          */
/*------------------------------------------*/

VOID FAR InterruptTimeoutHandler( hTimer, LCBAddr, Unused )

ULONG   hTimer;
PVOID   LCBAddr;
PVOID   Unused;
{
  NPLCB    npLCB   = (NPLCB) OFFSETOF( LCBAddr );
  USHORT   ABIOSRc;

  npLCB->IntTimerHandle = 0;
  ADD_CancelTimer( hTimer );

  ABIOSRc = StageABIOSRequest( npLCB, ABIOS_EP_TIMEOUT );

  if ( ((SHORT) ABIOSRc) <= 0 && ABIOSRc != -1 )
    {
      QueueLCBComplete( npLCB );
      ProcessLCBComplete();
    }
}


/*------------------------------------------*/
/*                                          */
/*                                          */
/*                                          */
/*                                          */
/*------------------------------------------*/

VOID FAR DelayTimeoutHandler( hTimer, LCBAddr, Unused )

ULONG   hTimer;
PVOID   LCBAddr;
PVOID   Unused;
{
  NPLCB    npLCB   = (NPLCB) OFFSETOF( LCBAddr );
  USHORT   ABIOSRc;

  npLCB->DlyTimerHandle = 0;
  ADD_CancelTimer( hTimer );

  ABIOSRc = StageABIOSRequest( npLCB, ABIOS_EP_INTERRUPT );

  if (  ((SHORT) ABIOSRc) <= 0 && ABIOSRc != -1 )
    {
      QueueLCBComplete( npLCB );
      ProcessLCBComplete();
    }
}




