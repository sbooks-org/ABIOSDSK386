Windows Debug DLLs, Debug Symbol Files, and Retail Symbol Files

The \MSVC\DEBUG directory on the Visual C++ 1.5 CD-ROM contains 
one set of Windows Debug DLLs and Debug Symbols Files that is
compatible with Windows 3.1, Windows for Workgroups 3.1, and Windows
for Workgroups 3.11.  Visual C++ Setup installs these files to
the \MSVC\DEBUG directory on your hard drive if you choose the
Debug Kernel option in the Tools dialog.

Regardless of whether you have previously installed retail version 
of Win 3.1, WFW 3.1, or WFW 3.11, the D2N.BAT file copies the
single compatible version of the Windows debug DLLs and debug
symbol files to your Windows System directory.  These debug DLLs
and debug symbol files are for the latest version of Windows,
namely WFW 3.11.  


The \MSVC\NODEBUG directory on the Visual C++ 1.5 CD-ROM contains
the symbol files for retail Windows 3.1.  Visual C++ Setup installs
these files to the \MSVC\NODEBUG directory on your hard drive if
you choose the Debug Kernel option in the Tools dialog.  

The \MSVC\NODEBUG\WFW311 directory contains the symbol files for 
retail WFW 3.11.  If your system is installed with retail WFW 3.11,
then after running Setup with the Debug Kernel option, copy the
three filess (krnl386.exe, user.exe, and gdi.exe) from the
\MSVC\NODEBUG\WFW311 directory on the CD-ROM to your \MSVC\NODEBUG
directory.




