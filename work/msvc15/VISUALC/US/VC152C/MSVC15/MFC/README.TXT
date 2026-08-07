=======================================================================
				   MICROSOFT (R) FOUNDATION CLASSES 
							Version 2.5
=======================================================================


This sub directory contains the source code and example code for the 
Microsoft Foundation Classes 2.5 (MFC 2.5) C++ library.  MFC 2.5 is a 
C++ Application Framework designed for use in developing applications for 
Microsoft Windows.  MFC 2.5 works in concert with the entire Microsoft 
Visual C++ development system, including the Visual WorkBench, App Studio, 
AppWizard, and ClassWizard.

What's New
----------
	o   Recompile compatibility with MFC 1.0 and MFC 2.0 (see technical 
		note TN019 for migration tips).

	o   Integrated support for Object Linking and Embedding 2.0,
		including support for in-place activation, inter-application
		drag/drop, compound files, enhanced clipboard capabilities,
		and automation.
		
	o   Support for ODBC database access. The MFC database classes
		provide simplified access to your databases via ODBC.
	
	o   Double-byte character set support (DBCS). By default the Windows
		version of MFC automatically recognizes when your program is being run 
		on a DBCS system.  The CString and CEditView classes (as well as 
		others) automatically change their behavior for compatibility with 
		the DBCS character set in use.

	o   Shared DLL support.  You can now have all of your MFC 2.5 applications 
		share the same application framework code by using the efficient shared 
		DLL (see technical note TN033).

	o   Architectural classes to support commands, documents, views, printing, 
		and help.

	o   High level abstractions including ToolBars, status bars, edit views, 
		form views, print previews, scrolling views, splitter windows.

	o   Ability to use VBX 1.0 controls in MFC 2.5 dialogs and forms, and 
		access them with standard C++ syntax.

	o   Increased "canned" functionality for all the common Windows 
		user-interface commands, including file management, printing, and MDI.

	o   Improved support for Windows "wrapper" classes for basic window 
		management, GDI, and standard dialogs.

	o   Enhanced general-purpose classes for time, date, data-structures, 
		and file I/O.

	o   AppWizard helps you to get a fast start in using the
		MFC 2.5 application framework by creating a starter 
		project with your application's key features.

	o   ClassWizard assists you in maintaining the mapping of
		user-interface elements to C++ code.  With its "Edit Code"
		button you can seamlessly jump from your user-interface
		elements to the code that manages them.

	o   App Studio is a full blown resource editor that is integrated
		with MFC 2.5.  App Studio automatically maintains resource
		IDs and lets you design and edit all the major Windows resource
		types.

	o   New and improved sample applications including demonstrations of
		an MDI OLE Server, customized ToolBar and status bar management,
		custom controls, and startup splash screens.

	o   Better documentation of all MFC 2.5 APIs, including significantly
		more overview material.

	o   Entirely new tutorial which exploits many of the advanced
		features of MFC 2.5.

	o   All documentation, including technical notes, is now provided in 
		on-line WinHelp format.  


Directory Structure
-------------------

MFC 2.5 is located in the MFC sub directory of the Microsoft Visual C++
installation by default.  If you installed Visual C++ on your
C drive then MFC 2.5 would be located in C:\MSVC\MFC by default.

The contents of the MFC sub directory are as follows:

	INCLUDE
		
		This directory contains included C++ header files, resource
		definitions, help contexts, and resource IDs.  These files
		are used by both the MFC 2.5 source code and by applications
		built using MFC 2.5.

	LIB

		This directory contains the static link libraries for 
		MFC 2.5 and the DLL import libraries for the shared DLL.
		If you decide to build custom variants of the MFC 2.5 
		application framework, your library will be placed in
		this directory as well.

	SAMPLES
		
		This directory contains all of the MFC 2.5 sample applications.
		There are over 20 sample programs that demonstrate most of the
		common MFC 2.5 features and show off many advanced idioms and
		techniques.

		The WinHelp file MFCSAMP.HLP is installed as a program
		item in the Microsoft Visual C++ Program Manager group which can
		be used to launch this file.  This file describes all of the
		sample applications and any information required to build
		them.

		The SCRIBBLE application is the tutorial.  All six major
		steps are included so there is no need to type in the code
		as you follow along with the tutorial text.

		The APSTUDIO directory contains a collection of cursors, icons,
		and bitmaps for you to use freely or modify.  This directory
		also contains the resources used by Windows for the standard
		dialogs (COMMDLG).

		A batch file is provided for building most of the samples from
		the command line.  Simply run the MKSAMPLE.BAT file from
		a DOS box.  Be sure that your INCLUDE and LIB environment
		variables are correctly set.  Once this batch file is complete
		you can install the Program Group SAMPLES\MFCSAMP.GRP 
		in the Program Manager to run the samples.  Three of the sample
		applications must be built by hand because they require
		variants of the MFC 2.5 library that are not in the installation.
		See the MFCSAMP.HLP file for more information on these samples.


	SRC

		This directory contains the source code to the MFC 2.5 application
		framework.  You should take care not to modify accidentally any
		of the files in this directory.  

		Should you require a memory model that is not supplied by
		the standard and professional installation, or require custom
		build options a standard makefile is provided that can be
		used to build MFC 2.5.  Please see the file SRC\README.TXT
		for instructions on building MFC 2.5 yourself.

		Also in this directory are several binary files used to
		build MFC 2.5.  These files should not be deleted since
		you cannot regenerate them yourself.  The implementation
		of VBX controls is contained in the three static link
		libraries (.LIB files) in this directory.  In addition
		there are two implementation files for rebuilding the
		MFC 2.5 shared DLL.

		Four files found in this directory (CTLSTATE.CPP, DLLCTL.CPP,
		MFCOCX.MAK, MFCOCX1.MAK) are used to create the DLL used
		by the OLE Controls.  They are included primarily for source
		level debugging, and they are not valid unless the CDK has
		also been installed.

	OTHER FILES

		The on-line documentation for MFC 2.5 is placed in the
		\MSVC\HELP sub directory with all of the Visual C++
		documentation.  The MFC 2.5 Technical Notes and
		sample program help files are also there.

		MFC250.DLL, MFC250D.DLL, MFCO250.DLL, MFCO250D.DLL, MFCD250.DLL, 
		and MFCD250D.DLL, the shared DLLs for MFC 2.5, are placed in your 
		Windows directory by the installation process.  Remember that you 
		can redistribute MFC250.DLL, MFCO250.DLL, and MFCD250D.DLL to users 
		of your application if you need to.
		
		MFCO250.DLL and MFCO250D.DLL, the shared DLL for the MFC 2.5
		OLE 2.0 implementation are placed in your Windows directory
		by the installation process if you chose

		Three MFC 2.5 helper tools are placed in the \MSVC\BIN
		directory.  These are MAKEHM (for help support), TEMPLDEF
		(for limited template functionality), and TRACER (a Windows
		application for customizing MFC 2.5 diagnostic output).


NOTE
----

The Microsoft Foundation Classes (MFC) library source code is
shipped "as is" and is designed for your own use and modification.
Microsoft Product Support can only offer limited support regarding
the MFC source code because of this benefit. 

Microsoft grants you a non-exclusive royalty-free right to use and 
modify the source code contained in any Microsoft Foundation Classes 
source code file for purposes of creating a software product.  
However, you may not include this code in source form (or 
any modified version of it) within any software product.   You have
the right to redistribute MFC250.DLL, MFCO250.DLL, and MFCD250.DLL with 
your MFC 2.5 derived application.

Notwithstanding the Microsoft End User License Agreement, THIS SOURCE 
CODE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.  YOU AGREE THAT 
NEITHER MICROSOFT NOR ANYONE ELSE INVOLVED IN CREATING, PRODUCING OR 
DELIVERING THE SOURCE CODE SHALL BE LIABLE FOR ANY DIRECT, INDIRECT, 
CONSEQUENTIAL, OR INCIDENTAL DAMAGES RELATING TO THE SOURCE CODE.

