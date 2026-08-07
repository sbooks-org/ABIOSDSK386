========================================================================
	   MICROSOFT FOUNDATION CLASS LIBRARY : SCRIBBLE
========================================================================




The AppWizard has generated this SCRIBBLE application for you.
This application not only demonstrate the basics of using the
Microsoft Foundation Classes, but is also a starting point for
writing your SCRIBBLE application.

This file contains a summary of what you will find in each of the files
that make up your SCRIBBLE application.


SCRIBBLE.MAK
	This is a project file compatible with Visual C++ IDE.
	It is also an NMAKE compatible file.

	To use the project file from the DOS prompt, type
		nmake -f DEBUG=1 SCRIBBLE.MAK
	to build a debug version of the program, or
		nmake -f DEBUG=0 SCRIBBLE.MAK
	for a retail version of the program.

SCRIBBLE.H
	This is the main include file for the application.
	It includes all global symbols and #includes for other headers.
	This header file will be pre-compiled by the makefile.

SCRIBBLE.CPP
	This is the main application source file that contains the
	application class CScribbleApp.

SCRIBBLE.RC
	This is a listing of all of the Microsoft Windows resources which
	the program uses.  It includes the icons, bitmaps, cursors which
	are stored in the RES sub-directory.

RES\SCRIBBLE.ICO
	This is an icon file, which is used by the main resource file scribble.rc
	as the application's icon.
	This is also the icon for the main MDI Frame window.

SCRIBBLE.DEF
	All applications for use with Microsoft Windows have some
	parameters such as the name and description of the application,
	which are defined for SCRIBBLE in this file.  Also, the size and type
	of the runtime heap and runtime stack are set.  The numbers in this
	file are typical for applications made with the Microsoft
	Foundation Class Library.

SCRIBBLE.CLW
	This file contains information used by the ClassWizard
	to edit existing classes as well as adding new classes.
	The ClassWizard also uses this file to store information
	needed to generate and edit message maps and dialog data maps
	as well as to generate prototype member functions.

/////////////////////////////////////////////////////////////////////////////

For the main frame window:

MAINFRM.H, MAINFRM.CPP
	These files contain the frame class CMainFrame which is derived from
	CMDIFrameWnd and controls all MDI frame features.

RES\TOOLBAR.BMP
	This is the bitmap used for creating tiled images for the toolbar.
	The CMainFrame class is where the initial toolbar and status bar
	are constructed.  Edit this toolbar bitmap along with the
	array in MAINFRM.CPP to add more toolbar buttons.

/////////////////////////////////////////////////////////////////////////////

There is one document type/template generated:

SCRIBDOC.H, SCRIBDOC.CPP - the document
	These files contain your CScribDoc class.  Edit these
	files to add your special document data as well as file saving
	and loading (via CScribDoc::Serialize).

SCRIBVW.H, SCRIBVW.CPP - the view of the document
	These files contain your CScribView class.
	CScribView objects are used to view CScribDoc objects.


/////////////////////////////////////////////////////////////////////////////
Other standard files:

STDAFX.H, STDAFX.CPP
	These files are used to build a pre-compiled header (PCH) file
	named STDAFX.PCH and a pre-compiled types (PCT) file named
	STDAFX.OBJ.

RESOURCE.H
	This is the standard header file where new resource IDs are defined.
	This file will be read and updated by the Visual Object Editor.

/////////////////////////////////////////////////////////////////////////////
Other informative notes:

The AppWizard uses "TODO:" to indicate parts of the source code you
should add to or customize.

/////////////////////////////////////////////////////////////////////////////
/* This file generated with the MFC AppWizard version 2.0.1 */
