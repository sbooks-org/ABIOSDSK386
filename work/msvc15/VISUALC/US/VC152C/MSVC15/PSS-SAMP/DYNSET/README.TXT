SAMPLE: Using Dynasets with the 16-bit MFC Database Classes

-----------------------------------------------------------------------
The information in this article applies to:

     - Microsoft Visual C++ for Windows, version 1.51
-----------------------------------------------------------------------


SUMMARY
=======

With some additional code, dynasets may be used with the Visual 
C++ 1.51 Microsoft Foundation Classes database classes. This sample 
contains the following components:

    DYNA.H          - single header file used by next 3 files 
    DYNACORE.CPP    - defines CDynaRecordset and CDynaDatabase
    DYNARFX.CPP     - defines new RFX functions 
    DYNAVIEW.CPP    - defines CDynaRecordView        
    ENROLL          - Modified ENROLL Step 3 sample which 
                      demonstrates how the code can be used.
    
To successfully use this code, you must have:

    - An ODBC driver which supports keyset-driven cursors and 
      SQLSetPos() functionality (see below for more information)
    - Visual C++ version 1.51 (contains newer header files)
    - The ODBC 2.1 or greater components (see below for more
      information)

MORE INFORMATION
================

WHAT IS A DYNASET?

The Visual C++ MFC Encyclopedia in the books online states the following:

"A dynaset is a recordset with dynamic properties. During its lifetime,
a recordset object in dynaset mode (usually called simply a "dynaset") 
stays synchronized with the data source in the following way. In a 
multi-user environment, other users may edit or delete records that 
are in your dynaset or add records to the table your dynaset 
represents. Records your application updates or deletes from the 
recordset are reflected in your dynaset. Records that other users add 
to the table will not be reflected in your dynaset until you rebuild 
the dynaset by calling its Requery member function. Records that other
users delete appear as "holes" in your recordset, marked as "deleted."
Other users' editing changes to existing records are reflected in your 
dynaset as soon as you scroll to the affected record.

Similarly, edits you make to records in a dynaset are reflected in 
dynasets in use by other users. Records you add are not reflected in 
other users' dynasets until they requery their dynasets. Records you 
delete are marked as "deleted" in others' recordsets. If you have 
multiple connections to the same database (multiple CDatabase 
objects), recordsets associated with those connections have the same 
status as the recordsets of other users.Dynasets are most valuable when 
data must be dynamic, as, for example,in an airline reservation system."

WHAT ARE THE ADVANTAGES OF USING DYNASETS?
As mentioned above, dynaset recordsets read directly from the data 
source for each record fetched in the recordset. Therefore the record 
can change values between subsequent fetches.  There are two additonal
big advantages which dynasets provide; speed and decreased memory 
usage. By not using snapshots and instead using dynasets, you don't 
load the cursor library (ODBCCURS.DLL).  The cursor library reads each 
record for a recordset and stores it into memory as you traverse through
the records. Thus, it saves the data for that moment in time.  This can
slow application performance.  The cursor library creates temporary 
files which are used for storing the temporary records. It is using 
more memory and disk space which you wouldn't use if you use dynasets. 
Lastly, the cursor library traps ODBC API calls before they are sent 
to the driver and this can slow an application.  

WHAT ARE THE REQUIREMENTS FOR USING DYNASETS?
Not all ODBC drivers support MFC dynasets.  For example, the ODBC 
drivers included with Visual C++ version 1.50 and 1.51 do not support 
dynasets. If you use the ODBC drivers provided with the ODBC 2.0 
Desktop Driver Pack and the code provided with this sample,
you can utilize dynasets for the desktop drivers (Access 2.0, 
FoxPro, etc.). 

NOTE: The Microsoft SQL Server ODBC driver doesn't support MFC 
      dynasets.

When using this code, it is important that your ODBC
driver support the following:

    - keyset driven cursors 
    - SQLSetPos() ODBC 2.0 functionality - SQL_POS_UPDATE,
                        SQL_POS_DELETE, and SQL_POS_ADD

Look at the CDynaRecordset::OnSetOptions() function in DYNACORE.CPP
to see the SQLGetInfo() calls which are used to determine if a driver 
supports MFC dynasets. Specifically, SQL_SO_KEYSET_DRIVEN and 
SQL_POS_OPERATIONS functionality is checked.  If 
SQL_POS_OPERATIONS isn't supported by the driver, the dynaset 
can not be modified and therefore will be read-only.
                                               
Look at the helpfile or other documentation for the ODBC driver
you're using to discover whether it supports the items mentioned
above.

Note, the ODBC drivers which came with Visual C++ 1.50 and 1.51 
didn't support SQLSetPos(). You must be using the ODBC drivers 
provided with the ODBC 2.0 Driver pack or something newer.


HOW TO USE THE CODE
A modified version of the ENROLL Step 3 tutorial sample is provided.
It demonstrates how to use the dynaset code. To use the code 
do the following:

   - Replace all references in your code to 'CRecordset' with 
     'CDynaRecordset'.
     
   - Replace CDatabase objects with CDynaDatabase. The CDynaDatabase 
     class contains an Open() function with a parameter which permits 
     you to conditionally load the cursor library.  When you use 
     dynasets, you don't want to load the cursor library. 
     
   - Derive your CRecordView class from CDynaRecordView. The 
     CDynaRecordView contains modified versions of OnInitialUpdate() 
     as well as OnMove() which require you to use a CDynaRecordset 
     rather than a CRecordset. 
     
   - Replace all RFX function calls in the recordset's 
     DoFieldExchange() function with their related Dyna_RFX... 
     functions included in DYNARFX.CPP. Place the Dyna_RFX... 
     functions outside the ClassWizard tagged section otherwise
     ClassWizard will produce a parsing error the next time it 
     tries to read your file.  The ClassWizard section is 
     delimited by "//{{AFX_FIELD_MAP(CYourRecordset)" and 
     "//}}AFX_FIELD_MAP".

WHY ARE THE ODBC 2.10 COMPONENTS NECESSARY?
The ODBC 2.10 Driver Manager is required to avoid a bug with the previous 
versions of the driver manager.  If you use the driver manager (ODBC.DLL)
included in the ODBC Driver Pack, you will receive an "Invalid Cursor State" 
error when using dynasets and trying to add a record to a table following 
an query which produced an empty recordset. In other words, if you open a 
CRecordset object and the query returns an empty recordset, a subsequent 
AddNew()/Update() call will cause the error. The ODBC 2.1 driver fixes this 
problem.

REFERENCES
==========

For more information about the ODBC functions used, see the ODBC 2.0 
Programmer's Reference.  This is included in the Visual C++ 
version 2.0 online books.

Last modified: 3/10
