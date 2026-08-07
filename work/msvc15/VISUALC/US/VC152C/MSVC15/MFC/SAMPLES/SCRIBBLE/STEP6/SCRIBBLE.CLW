; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CScribFrame
LastTemplate=splitter
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "scribble.h"
VbxHeaderFile=scribble.h
VbxImplementationFile=scribble.cpp

ClassCount=7
ResourceCount=4
Class1=CScribbleApp
Class2=CScribDoc
Class3=CScribView
Class4=CMainFrame
Class5=CAboutDlg
Class6=CPenWidthsDlg
Class7=CScribFrame

Resource1=IDR_MAINFRAME
Resource2=IDR_SCRIBTYPE
Resource3=IDD_ABOUTBOX
Resource4=IDD_PEN_WIDTHS

[CLS:CScribbleApp]
Type=0
HeaderFile=scribble.h
ImplementationFile=scribble.cpp
Filter=N

[CLS:CScribDoc]
Type=0
HeaderFile=scribdoc.h
ImplementationFile=scribdoc.cpp
Filter=N

[CLS:CScribView]
Type=0
HeaderFile=scribvw.h
ImplementationFile=scribvw.cpp
Filter=Child Window

[CLS:CMainFrame]
Type=0
HeaderFile=mainfrm.h
ImplementationFile=mainfrm.cpp
Filter=T

[CLS:CAboutDlg]
Type=0
HeaderFile=scribble.cpp
ImplementationFile=scribble.cpp
Filter=D

[CLS:CPenWidthsDlg]
Type=0
HeaderFile=pendlg.h
ImplementationFile=pendlg.cpp
Filter=D
Resource=IDD_PEN_WIDTHS

[DLG:IDD_PEN_WIDTHS]
Type=1
ControlCount=7
Control1=IDC_TEXT1,static,1342373888
Control2=IDC_TEXT2,static,1342373888
Control3=IDC_THIN_PEN_WIDTH,edit,1350631552
Control4=IDC_THICK_PEN_WIDTH,edit,1350631552
Control5=IDC_DEFAULT_PEN_WIDTHS,button,1342373888
Control6=IDOK,button,1342373889
Control7=IDCANCEL,button,1342373888
Class=CPenWidthsDlg

[MNU:IDR_SCRIBTYPE]
Type=1
Class=CScribView
CommandCount=21
Command1=ID_APP_ABOUT
Command2=ID_APP_EXIT
Command3=ID_EDIT_COPY
Command4=ID_EDIT_CUT
Command5=ID_EDIT_PASTE
Command6=ID_EDIT_UNDO
Command7=ID_FILE_MRU_FILE1
Command8=ID_FILE_NEW
Command9=ID_FILE_OPEN
Command10=ID_FILE_PRINT
Command11=ID_FILE_PRINT_PREVIEW
Command12=ID_FILE_PRINT_SETUP
Command13=ID_FILE_SAVE
Command14=ID_FILE_SAVE_AS
Command15=ID_HELP_INDEX
Command16=ID_HELP_USING
Command17=ID_VIEW_STATUS_BAR
Command18=ID_VIEW_TOOLBAR
Command19=ID_EDIT_CLEAR_ALL
Command20=ID_PEN_THICK_OR_THIN
Command21=ID_PEN_WIDTHS

[MNU:IDR_MAINFRAME]
Type=1
Class=CMainFrame
CommandCount=10
Command1=ID_APP_ABOUT
Command2=ID_APP_EXIT
Command3=ID_FILE_MRU_FILE1
Command4=ID_FILE_NEW
Command5=ID_FILE_OPEN
Command6=ID_FILE_PRINT_SETUP
Command7=ID_HELP_INDEX
Command8=ID_HELP_USING
Command9=ID_VIEW_STATUS_BAR
Command10=ID_VIEW_TOOLBAR

[ACL:IDR_MAINFRAME]
Type=1
Class=CScribView
Command1=ID_FILE_NEW
Command2=ID_FILE_OPEN
Command3=ID_FILE_SAVE
Command4=ID_FILE_PRINT
Command5=ID_EDIT_UNDO
Command6=ID_EDIT_CUT
Command7=ID_EDIT_COPY
Command8=ID_EDIT_PASTE
Command9=ID_EDIT_UNDO
Command10=ID_EDIT_CUT
Command11=ID_EDIT_COPY
Command12=ID_EDIT_PASTE
Command13=ID_NEXT_PANE
Command14=ID_PREV_PANE
CommandCount=14

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg

[CLS:CScribFrame]
Type=0
HeaderFile=scribfrm.h
ImplementationFile=scribfrm.cpp
Filter=T

