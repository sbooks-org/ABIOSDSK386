; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CSectionForm
LastTemplate=CRecordset
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "enroll.h"
VbxHeaderFile=enroll.h
VbxImplementationFile=enroll.cpp
LastPage=1

ClassCount=7
Class1=CEnrollApp
Class2=CEnrollDoc
Class3=CSectionForm
Class4=CMainFrame
Class6=CAboutDlg

ResourceCount=3
Resource1=IDD_ABOUTBOX
Resource2=IDR_MAINFRAME
Class5=CSectionSet
Class7=CCourseSet
Resource3=IDD_ENROLL_FORM

[CLS:CEnrollApp]
Type=0
HeaderFile=enroll.h
ImplementationFile=enroll.cpp
Filter=N

[CLS:CEnrollDoc]
Type=0
HeaderFile=enroldoc.h
ImplementationFile=enroldoc.cpp
Filter=N

[CLS:CSectionForm]
Type=0
HeaderFile=sectform.h
ImplementationFile=sectform.cpp
Filter=D
LastObject=IDC_COURSELIST

[CLS:CSectionSet]
Type=0
HeaderFile=sectset.h
ImplementationFile=sectset.cpp
Filter=D

[DB:CSectionSet]
DB=1
ColumnCount=6
Column1=CourseID,1,8,1
Column2=SectionNo,1,4,1
Column3=InstructorID,1,8,1
Column4=RoomNo,1,10,1
Column5=Schedule,1,24,1
Column6=Capacity,5,2,1


[CLS:CMainFrame]
Type=0
HeaderFile=mainfrm.h
ImplementationFile=mainfrm.cpp
Filter=T

[CLS:CAboutDlg]
Type=0
HeaderFile=enroll.cpp
ImplementationFile=enroll.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308352
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889
Class=CAboutDlg

[MNU:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command7=ID_FILE_PRINT
Command8=ID_FILE_PRINT_PREVIEW
Command9=ID_FILE_PRINT_SETUP
Command10=ID_FILE_MRU_FILE1
Command11=ID_APP_EXIT
Command12=ID_EDIT_UNDO
Command13=ID_EDIT_CUT
Command14=ID_EDIT_COPY
Command15=ID_EDIT_PASTE
Command20=ID_RECORD_FIRST
Command21=ID_RECORD_PREV
Command22=ID_RECORD_NEXT
Command23=ID_RECORD_LAST
Command24=ID_VIEW_TOOLBAR
Command25=ID_VIEW_STATUS_BAR
Command28=ID_APP_ABOUT
CommandCount=28

[ACL:IDR_MAINFRAME]
Type=1
Class=CMainFrame
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
CommandCount=17

[DLG:IDD_ENROLL_FORM]
Type=1
Class=CSectionForm
ControlCount=12
Control1=IDC_STATIC,static,1342308352
Control2=IDC_STATIC,static,1342308352
Control3=IDC_SECTION,edit,1350633600
Control4=IDC_STATIC,static,1342308352
Control5=IDC_INSTRUCTOR,edit,1350631552
Control6=IDC_STATIC,static,1342308352
Control7=IDC_ROOM,edit,1350631552
Control8=IDC_STATIC,static,1342308352
Control9=IDC_SCHEDULE,edit,1350631552
Control10=IDC_STATIC,static,1342308352
Control11=IDC_CAPACITY,edit,1350631552
Control12=IDC_COURSELIST,combobox,1344340227

[CLS:CCourseSet]
Type=0
HeaderFile=coursset.h
ImplementationFile=coursset.cpp
Filter=N

[DB:CCourseSet]
DB=1
ColumnCount=3
Column1=CourseID,1,8,1
Column2=CourseTitle,1,50,1
Column3=Hours,7,4,1

