/*static char *SCCSID = "src/dev/dasd/ibm/ibm2adsk/adskiorb.c, adsk, ddk_subset, ddk2_r206.044 93/03/20";*/
/**************************************************************************
 *
 * SOURCE FILE NAME =  ADSKIORB.C
 *
 * DESCRIPTIVE NAME =  IBM2ADSK.ADD - Adapter Driver for ABIOS DASD Devices
 *                     IORB routing/processing
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
 * DESCRIPTION : Routes commands received from the DASD manager to the
 *               appropriate function.
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

/*-------------------------------------------------------------------*/
/* IORB Request Router                                               */
/* -------------------                                               */
/* This routine receives the I/O Request Blocks from client          */
/* device drivers.                                                   */
/*-------------------------------------------------------------------*/

VOID FAR _loadds ADSKIORBEntr( pIORB )

PIORB pIORB;
{

  USHORT        CommandCode     = pIORB->CommandCode;
  USHORT        CommandModifier = pIORB->CommandModifier;


  /*-----------------------------*/
  /* Start processing IORB's     */
  /*-----------------------------*/

 if (CommandCode < IOCC_CONFIGURATION &&
     CommandCode > IOCC_ADAPTER_PASSTHRU)
   {
     NotifyIORB(pIORB,IOERR_CMD_SYNTAX);
     goto IORBEntr_Failed;
   }

 if ( (CommandCode != IOCC_EXECUTE_IO) && (pIORB->RequestControl & IORB_CHAIN))
   {
     NotifyIORB(pIORB,IOERR_CMD_SYNTAX);
     goto IORBEntr_Failed;
   }

 switch (CommandCode)
   {
    case IOCC_CONFIGURATION:
       switch (CommandModifier)
       {
         case IOCM_GET_DEVICE_TABLE:
              Get_Device_Table((PIORB_CONFIGURATION) pIORB);
              break;

         case IOCM_COMPLETE_INIT:
              Complete_Init((PIORB_CONFIGURATION) pIORB);
              break;

         default:
              NotifyIORB(pIORB,IOERR_CMD_NOT_SUPPORTED);
              break;
       }
       break;

    case IOCC_UNIT_CONTROL:
       switch (CommandModifier)
       {
        case IOCM_ALLOCATE_UNIT:
             Allocate((PIORB_UNIT_CONTROL) pIORB);
             break;

        case IOCM_DEALLOCATE_UNIT:
             DeAllocate((PIORB_UNIT_CONTROL) pIORB);
             break;

        case IOCM_CHANGE_UNITINFO:
             Change_UnitInfo( (PIORB_UNIT_CONTROL) pIORB );
             break;

        default:
             NotifyIORB(pIORB,IOERR_CMD_NOT_SUPPORTED);
             break;
       }
       break;

    case IOCC_GEOMETRY:
       switch (CommandModifier)
       {
        case  IOCM_GET_MEDIA_GEOMETRY:
        case  IOCM_GET_DEVICE_GEOMETRY:
              Get_Device_Geometry( (PIORB_GEOMETRY) pIORB );
              break;

       default:
              NotifyIORB( pIORB, IOERR_CMD_NOT_SUPPORTED );
              break;
       }
         break;

    case IOCC_EXECUTE_IO:
        {
           switch (CommandModifier)
            {
           case IOCM_READ:
           case IOCM_READ_VERIFY:
           case IOCM_WRITE:
           case IOCM_WRITE_VERIFY:
              Device_IO( pIORB );
              break;

           default:
              NotifyIORB(pIORB,IOERR_CMD_NOT_SUPPORTED );
              break;
            }
        }
         break;
    case IOCC_UNIT_STATUS:
      if (CommandModifier == IOCM_GET_UNIT_STATUS)
       {
         Device_IO( pIORB );
       }
      else
       {
        NotifyIORB( pIORB,IOERR_CMD_NOT_SUPPORTED );
       }
     break;

    default:
        NotifyIORB( pIORB,IOERR_CMD_NOT_SUPPORTED );
        break;
   }

IORBEntr_Failed: ;
  return;

}

/*-------------------------------------------------------------------*/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/

VOID NEAR Get_Device_Table( pIORB )

 PIORB_CONFIGURATION pIORB;

{
 PDEVICETABLE                    pDeviceTable;
 PADAPTERINFO                    pAdapterInfo;
 PADAPTERINFO                    pNextAdapterInfo;
 PUNITINFO                       pUnitInfo;
 PUNITINFO                       pUnitDefn;
 NPUCB                           npUCB;
 NPSZ                            npAdapterName;

 USHORT                          UnitLid;
 USHORT                          CurrentLid;
 USHORT                          DevBusType;
 USHORT                          i;

 i = 0 ;

 /*-------------------------------------------------*/
 /*      Calculate where the Adapter Device Table   */
 /*      will be                                    */
 /*-------------------------------------------------*/

 pDeviceTable  = pIORB->pDeviceTable;

 pDeviceTable->ADDLevelMajor    = ADD_LEVEL_MAJOR;
 pDeviceTable->ADDLevelMinor    = ADD_LEVEL_MINOR;
 pDeviceTable->ADDHandle        = (USHORT) ADDHandle;
 pDeviceTable->TotalAdapters    = TotalLids;

 /*-------------------------------------------------*/
 /*      Set-up Adapter information pointers        */
 /*      equivalent to a number of adapters.        */
 /*-------------------------------------------------*/


 /*-------------------------------*/
 /* Get each adapter information, */
 /* starting with the first one   */
 /*-------------------------------*/

 pAdapterInfo          = (PADAPTERINFO)(pDeviceTable + 1);
 (PBYTE) pAdapterInfo += sizeof(NPADAPTERINFO) * (TotalLids - 1);
 pNextAdapterInfo      = pAdapterInfo;

 npUCB= npUCBAnchor;

 CurrentLid = -1;

 while ( npUCB )
   {
     UnitLid = ((NPABRBH)(npUCB->npLCB->ABIOSReq))->LID;
     if ( UnitLid != CurrentLid )
       {
         CurrentLid = UnitLid;

         pDeviceTable->pAdapter[i++]        =
                                   (NPADAPTERINFO) OFFSETOF(pNextAdapterInfo);
         pAdapterInfo                       = pNextAdapterInfo;
         pAdapterInfo->AdapterUnits         = 0;
         pAdapterInfo->AdapterIOAccess      = AI_IOACCESS_DMA_SLAVE;
         pAdapterInfo->AdapterHostBus       = (AI_HOSTBUS_uCHNL
                                                       | AI_BUSWIDTH_UNKNOWN);
         pAdapterInfo->AdapterSCSITargetID  = 0;
         pAdapterInfo->AdapterSCSILUN       = 0;
         pAdapterInfo->AdapterFlags         = AF_16M;
         pAdapterInfo->MaxHWSGList          = 0;
         pAdapterInfo->MaxCDBTransferLength = 0;

         if ( npUCB->ABIOSFlags & DP_ST506 )
           {
             DevBusType = AI_DEVBUS_ST506;
             npAdapterName = AdapterName_ST506;
           }
         else if ( npUCB->ABIOSFlags & DP_SCSI_DEVICE )
           {
             DevBusType = AI_DEVBUS_SCSI_1;
             npAdapterName = AdapterName_SCSI;
           }
         else
           {
             DevBusType = AI_DEVBUS_ESDI;
             npAdapterName = AdapterName_ESDI;
           }

         memcpy( (PBYTE)  pAdapterInfo->AdapterName,
                 (PBYTE)  npAdapterName,
                 (USHORT) sizeof(pAdapterInfo->AdapterName));

         pAdapterInfo->AdapterDevBus = DevBusType;

         pUnitInfo = pAdapterInfo->UnitInfo;

         pNextAdapterInfo++;
       }

     pUnitDefn = ( npUCB->Flags & UCBF_INFOCHANGED ) ?
                                     npUCB->pChngUnitInfo : &npUCB->UnitInfo;

     memcpy( (PBYTE) pUnitInfo, (PBYTE) pUnitDefn, sizeof(UNITINFO) );
     pUnitInfo->AdapterIndex = i - 1;

     pUnitInfo++;
     pAdapterInfo->AdapterUnits++;
     (PBYTE) pNextAdapterInfo += sizeof(UNITINFO);

     npUCB = npUCB->npNextUCB;
   }

 NotifyIORB( (PIORB) pIORB, 0 );

}

/*-------------------------------------------------------------------*/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/

VOID NEAR Allocate( pIORB )

 PIORB_UNIT_CONTROL  pIORB;
{
  NPUCB         npUCB;

  npUCB = (NPUCB) pIORB->iorbh.UnitHandle;

  if ( !(npUCB->Flags & UCBF_ALLOCATED) )
    {
      npUCB->Flags |= UCBF_ALLOCATED;
      NotifyIORB( (PIORB) pIORB, 0 );
    }
  else
    {
      NotifyIORB((PIORBH) pIORB,IOERR_UNIT_ALLOCATED);
    }
}

/*-------------------------------------------------------------------*/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/

VOID NEAR DeAllocate( pIORB )

 PIORB_UNIT_CONTROL  pIORB;
{
  NPUCB         npUCB;

  npUCB = (NPUCB) pIORB->iorbh.UnitHandle;

  if ( npUCB->Flags & UCBF_ALLOCATED )
    {
      npUCB->Flags &= ~UCBF_ALLOCATED;
      NotifyIORB( (PIORB) pIORB, 0 );
    }
  else
    {
      NotifyIORB((PIORBH) pIORB,IOERR_UNIT_NOT_ALLOCATED);
    }
}

/*-------------------------------------------------------------------*/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/

VOID NEAR Change_UnitInfo( pIORB )

 PIORB_UNIT_CONTROL  pIORB;
{
  NPUCB         npUCB;

  npUCB = (NPUCB) pIORB->iorbh.UnitHandle;

  if ( pIORB->UnitInfoLen != sizeof(UNITINFO) )
    {
      NotifyIORB((PIORBH) pIORB, IOERR_CMD_SYNTAX);
    }
  else if ( !(npUCB->Flags & UCBF_ALLOCATED) )
    {
      NotifyIORB((PIORBH) pIORB,IOERR_UNIT_NOT_ALLOCATED);
    }
  else
    {
      npUCB->Flags         |= UCBF_INFOCHANGED;
      npUCB->pChngUnitInfo  = pIORB->pUnitInfo;
      NotifyIORB( (PIORB) pIORB, 0 );
    }
}

/*-------------------------------------------------------------------*/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/

VOID NEAR Get_Device_Geometry( pIORB )

 PIORB_GEOMETRY  pIORB;
{
  NPUCB         npUCB;

  npUCB = (NPUCB) pIORB->iorbh.UnitHandle;


  if ( pIORB->GeometryLen != sizeof(GEOMETRY) )
    {
      NotifyIORB((PIORBH) pIORB, IOERR_CMD_SYNTAX);
    }
  else if ( !(npUCB->Flags & UCBF_ALLOCATED) )
    {
      NotifyIORB((PIORBH) pIORB,IOERR_UNIT_NOT_ALLOCATED);
    }
  else
    {
      memcpy( (PBYTE) pIORB->pGeometry, (PBYTE) &npUCB->Geometry,
                                                            sizeof(GEOMETRY) );
      NotifyIORB( (PIORB) pIORB, 0 );
    }
}

/*-------------------------------------------------------------------*/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/

VOID NEAR Complete_Init( pIORB )

 PIORB_CONFIGURATION  pIORB;
{

  if ( DevIOCount )
    {
      _asm { int 3 }
    }

  HookIRQLevels();

  InitPhaseComplete = 1;

  NotifyIORB( (PIORB) pIORB, 0 );

}

/*-------------------------------------------------------------------*/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/

VOID NEAR HookIRQLevels( VOID )
{
  USHORT        i;
  NPINTCB       npIntCB;


  for (i = 0, npIntCB = &IntLevelCB[0]; i < LevelsInUse; i++,npIntCB++ )
    {
      if ( DevHelp_SetIRQ( (NPFN)   OFFSETOF(npIntCB->IntHandlerRtn),
                           (USHORT) npIntCB->HwIntLevel,
                           (USHORT) 1                             ) )
        {
          _asm { int 3 }
        }

    }
}

/*-------------------------------------------------------------------*/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/

VOID NEAR UnHookIRQLevels( VOID )
{
  USHORT        i;
  NPINTCB       npIntCB;

  for (i = 0, npIntCB = &IntLevelCB[0]; i < LevelsInUse; i++,npIntCB++)
    {
      if ( DevHelp_UnSetIRQ( (USHORT) npIntCB->HwIntLevel ))
        {
          _asm { int 3 }
        }

    }
}


/*-------------------------------------------------------------------*/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/

VOID Device_IO( pIORB )

PIORB    pIORB;
{
  PIORBH   pIORBH;
  NPUCB    npUCB = (NPUCB) pIORB->UnitHandle;
  NPLCB    npLCB;


  if ( !(npUCB->Flags & UCBF_ALLOCATED) )
    {
      NotifyIORB(pIORB,IOERR_UNIT_NOT_ALLOCATED);
    }

  /*------------------------------------------------------*/
  /* Find Last IORB if chained set of IORBs were received */
  /* from device manager.                                 */
  /*------------------------------------------------------*/
  for (pIORBH=pIORB; pIORBH->RequestControl & IORB_CHAIN;
       pIORBH=pIORBH->pNxtIORB)
    ;
  pIORBH->pNxtIORB = 0;


  /*-----------------------------------------------*/
  /*                                               */
  /*                                               */
  /*-----------------------------------------------*/

  DISABLE

  if ( !InitPhaseComplete && !DevIOCount++ )
    {
      HookIRQLevels();
    }

  if (npUCB->pQueueHead == NULL)
    {
      npUCB->pQueueHead = pIORB;
    }
  else
    {
      npUCB->pQueueFoot->pNxtIORB = pIORB;
    }

  npUCB->pQueueFoot = pIORBH;

  ENABLE

  /*-----------------------------------------------*/
  /*                                               */
  /*                                               */
  /*-----------------------------------------------*/

  DISABLE

  npLCB = npUCB->npLCB;

  if (!(npLCB->IntFlags & LCBF_ACTIVE) )
    {
      StartLCB( npLCB );
    }

  ENABLE
}

/*-------------------------------------------------------------------*/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/

VOID NEAR NotifyIORB( pIORB, ErrorCode)
PIORBH    pIORB;
USHORT    ErrorCode;
{

  /*---------------------------------------------------------*/
  /* Set IORB_ERROR in pIORB->Status if there is a non-zero  */
  /* error code AND the RECOVERED ERROR bit is not set in    */
  /* the IORB status field.                                  */
  /*---------------------------------------------------------*/

  pIORB->Status |= (IORB_DONE |
                    ((ErrorCode && !(pIORB->Status & IORB_RECOV_ERROR))
                                                           ? IORB_ERROR : 0));
  pIORB->ErrorCode = ErrorCode;

  if (pIORB->RequestControl & IORB_ASYNC_POST)
    {
      (*pIORB->NotifyAddress)( pIORB );
    }
}
