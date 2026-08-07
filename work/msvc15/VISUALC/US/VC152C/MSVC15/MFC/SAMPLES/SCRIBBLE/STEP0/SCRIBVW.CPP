// scribvw.cpp : implementation of the CScribView class
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


#include "stdafx.h"
#include "scribble.h"

#include "scribdoc.h"
#include "scribvw.h"

#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CScribView

IMPLEMENT_DYNCREATE(CScribView, CView)


BEGIN_MESSAGE_MAP(CScribView, CView)
	//{{AFX_MSG_MAP(CScribView)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG_MAP

	// Standard printing commands
	ON_COMMAND(ID_FILE_PRINT, CView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_PREVIEW, CView::OnFilePrintPreview)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CScribView construction/destruction

CScribView::CScribView()
{
	// TODO: add construction code here
}

CScribView::~CScribView()
{
}







/////////////////////////////////////////////////////////////////////////////
// CScribView drawing

void CScribView::OnDraw(CDC* pDC)
{
	CScribDoc* pDoc = GetDocument();

	// TODO: add draw code here

}

/////////////////////////////////////////////////////////////////////////////
// CScribView printing

BOOL CScribView::OnPreparePrinting(CPrintInfo* pInfo)
{
	// default preparation
	return DoPreparePrinting(pInfo);
}

void CScribView::OnBeginPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add extra initialization before printing
}

void CScribView::OnEndPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add cleanup after printing
}




/////////////////////////////////////////////////////////////////////////////
// CScribView diagnostics

#ifdef _DEBUG
void CScribView::AssertValid() const
{
	CView::AssertValid();
}

void CScribView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CScribDoc* CScribView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CScribDoc)));
	return (CScribDoc*) m_pDocument;
}

#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CScribView message handlers

