// speakn.h : Declares the class interfaces for the SpeakN application.
//
// This is a part of the Microsoft Foundation Classes C++ library.
// Copyright (C) 1992 Microsoft Corporation
// All rights reserved.
//
// This source code is only intended as a supplement to the
// Microsoft Foundation Classes Reference and Microsoft
// QuickHelp and/or WinHelp documentation provided with the library.
// See these sources for detailed information regarding the
// Microsoft Foundation Classes product.
//

#ifndef __AFXPEN_H__
#include <afxpen.h>         // PenWindows extras
#endif

#include "resource.h"       // resource IDs

/////////////////////////////////////////////////////////////////////////////
// CSpeakNDlg:
//   The main user interface to this application is just one big dialog

class CSpeakNDlg : public CDialog
{
// Constructors
public:
	CSpeakNDlg(BOOL bNoPen);
	BOOL LoadLesson(LPCSTR lpLessonName);

	//{{AFX_DATA(CSpeakNDlg)
		enum { IDD = IDD_PENDIALOG };
	//}}AFX_DATA

// Operations
	void        AdvanceLesson();

// Attributes (the current question/lesson)
	// current question (from resource)
	CString         m_targetWord;           // target word (upper case)

	// resource containing all the questions
	LPCSTR          m_lpszNextQuestion; // empty string => done

// Implementation
protected:
	BOOL m_bNoPen;      // TRUE => no PenWindows (run less functional)
	BOOL m_bNoAnswerCheck;  // TRUE => disable test for answer

	// special controls
	CFont           m_biggerFont;
	CBitmapButton   m_pictureButton; // main bitmap done as a special button
	CBitmapButton   m_replayButton; // bitmap button for replay sound

	// normal Windows controls
	CStatic&    StatusFace()    // face which smiles or frowns
					{ return *(CStatic*)GetDlgItem(IDC_STATUS_FACE); }
	CStatic&    PromptText()    // prompt area
					{ return *(CStatic*)GetDlgItem(IDC_PROMPT_TEXT); }

	void        SetAnswerText(const char* psz);
	CEdit&      InputEdit()     // user input for answer text
								//  (a normal Edit or a Pen Boxed Edit)
					{ return *(CEdit*)GetDlgItem(IDC_INPUT_EDIT); }

	// message handlers
	//{{AFX_MSG(CSpeakNDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnReplaySound();
	afx_msg void OnUpdateStatus();
	virtual void OnOK();        // Guess
	virtual void OnGiveUp();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////
// CSpeakNApp:

class CSpeakNApp : public CWinApp
{
public:
	BOOL InitInstance();
};

/////////////////////////////////////////////////////////////////////////////
