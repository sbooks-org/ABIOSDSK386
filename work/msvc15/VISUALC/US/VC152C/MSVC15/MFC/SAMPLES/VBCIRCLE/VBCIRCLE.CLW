; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CVBCircleApp
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "vbcircle.h"
VbxHeaderFile=vbcircle.h
VbxImplementationFile=vbcircle.cpp

ClassCount=3
Class1=CCircleDialog
Class2=CVBCircleFrame
Class3=CVBCircleApp

ResourceCount=3
Resource1=IDR_MAINFRAME
Resource2=IDD_ABOUTBOX
Resource3=IDD_CIRCLE_DLG

[CLS:CVBCircleFrame]
Type=0
HeaderFile=frame.h
ImplementationFile=frame.cpp

[CLS:CVBCircleApp]
Type=0
HeaderFile=vbcircle.h
ImplementationFile=vbcircle.cpp
LastObject=ID_EDIT_UNDO

[MNU:IDR_MAINFRAME]
Type=1
Command1=ID_APP_EXIT
Command2=ID_EDIT_CIRCLE
Command3=ID_APP_ABOUT
CommandCount=3
Class=?

[ACL:IDR_MAINFRAME]
Type=1
Command1=ID_FILE_NEW
Command2=ID_FILE_OPEN
Command3=ID_FILE_SAVE
Command4=ID_EDIT_UNDO
Command5=ID_EDIT_CUT
Command6=ID_EDIT_COPY
Command7=ID_EDIT_PASTE
Command8=ID_EDIT_UNDO
Command9=ID_EDIT_CUT
Command10=ID_EDIT_COPY
Command11=ID_EDIT_PASTE
Command12=ID_NEXT_PANE
Command13=ID_PREV_PANE
CommandCount=13
Class=?

[DLG:IDD_ABOUTBOX]
Type=1
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308352
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889
Class=?

[DLG:IDD_CIRCLE_DLG]
Type=1
ControlCount=11
Control1=IDC_CAPTION,edit,1350631552
Control2=IDC_SHAPE_CIRCLE,button,1342373897
Control3=IDC_SHAPE_ELLIPSE,button,1342242825
Control4=IDC_BORDER,button,1342373891
Control5=IDC_CIRCLE,VBControl,1342242816,CIRC3.VBX;Circ3
Control6=IDOK,button,1342373889
Control7=IDC_UPDATE_CIRCLE,button,1342373888
Control8=IDC_HIT_MESSAGE,static,1342373888
Control9=IDC_STATIC,static,1342373888
Control10=IDC_STATIC,button,1342177287
Control11=IDC_STATIC,static,1342308352
Class=CCircleDialog

[CLS:CCircleDialog]
Type=0
HeaderFile=dialog.h
ImplementationFile=dialog.cpp
LastObject=CCircleDialog

