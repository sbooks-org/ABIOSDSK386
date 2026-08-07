/**************************************************************************
 *  TEST.H
 *
 *      Header file for the TOOLHELP.DLL test program
 *
 **************************************************************************/

#include "resource.h"

/* ----- Function prototypes ----- */

void PASCAL Fault(WORD wType);

void __export CALLBACK MyFaultHandler(void);

