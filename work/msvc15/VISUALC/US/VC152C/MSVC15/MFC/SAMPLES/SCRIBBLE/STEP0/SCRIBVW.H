// scribvw.h : interface of the CScribView class
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


class CScribView : public CView
{
protected: // create from serialization only
	CScribView();
	DECLARE_DYNCREATE(CScribView)

// Attributes
public:
	CScribDoc* GetDocument();

// Operations
public:

// Implementation
public:
	virtual ~CScribView();
	virtual void OnDraw(CDC* pDC);  // overridden to draw this view

#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

	// Printing support
protected:
	virtual BOOL OnPreparePrinting(CPrintInfo* pInfo);
	virtual void OnBeginPrinting(CDC* pDC, CPrintInfo* pInfo);
	virtual void OnEndPrinting(CDC* pDC, CPrintInfo* pInfo);

// Generated message map functions
protected:
	//{{AFX_MSG(CScribView)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

#ifndef _DEBUG  // debug version in scribvw.cpp
inline CScribDoc* CScribView::GetDocument()
   { return (CScribDoc*) m_pDocument; }
#endif

/////////////////////////////////////////////////////////////////////////////
