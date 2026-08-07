/***
*windgrpx.c - defines the exported stub function for _GetDGROUP() to check.
*
*   Copyright (c) 1989-1992, Microsoft Corporation.  All rights reserved.
*
*Purpose:
*   Defines an exported function.  _GetDGROUP() will check the prolog of this
*   function to see if we are running in a dll or an exe.
*
*******************************************************************************/


int _far _export _cdecl __ExportedStub( void );

int _far _export _cdecl __ExportedStub()
{
    return( 0 );
}
