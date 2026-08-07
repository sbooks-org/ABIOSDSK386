// colorpge.cpp : implementation file
//

#include "stdafx.h"
#include "propdlg.h"
#include "stylepge.h"
#include "colorpge.h"
#include "shapeobj.h"
#include "preview.h"
#include "propsht.h"
#include "propsht2.h"

#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CColorPage property page


CColorPage::CColorPage()
	: CPropertyPage(CColorPage::IDD)
{
	//{{AFX_DATA_INIT(CColorPage)
	//}}AFX_DATA_INIT
	m_nColor = black;
}

void CColorPage::DoDataExchange(CDataExchange* pDX)
{
	CPropertyPage::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CColorPage)
	DDX_Radio(pDX, IDC_BLACK, m_nColor);
	//}}AFX_DATA_MAP
}

BOOL CColorPage::OnColorClicked(UINT /*nCmdID*/)
{
	// The CColorPage property page is used for both the
	// CModalShapePropSheet and the CModelessShapePropSheet.
	// Both these versions of the property sheet share a common
	// feature that they immediately update a shape.  In the
	// case of CModalShapePropSheet, the shape is in the preview
	// window.  In the case of CModelessShapePropSheet, the shape
	// is the currently selected shape in the view.

	CPropertySheet* pPropertySheet = (CPropertySheet*)GetParent();

	if (pPropertySheet->IsKindOf(RUNTIME_CLASS(CModalShapePropSheet)))
	{
		UpdateData();
		((CModalShapePropSheet*)pPropertySheet)->UpdateShapePreview();
		SetModified(); // enable Apply Now button
	}

	if (pPropertySheet->IsKindOf(RUNTIME_CLASS(CModelessShapePropSheet)))
	{
		CMDIFrameWnd* pMDIFrameWnd = (CMDIFrameWnd*)AfxGetMainWnd();
		ASSERT(pMDIFrameWnd->IsKindOf(RUNTIME_CLASS(CMDIFrameWnd)));
		CView* pView = pMDIFrameWnd->MDIGetActive()->GetActiveView();
		UpdateData();
		pView->SendMessage(WM_USER_CHANGE_OBJECT_PROPERTIES, 0, 0);
	}
	return TRUE;
}

BEGIN_MESSAGE_MAP(CColorPage, CPropertyPage)
	//{{AFX_MSG_MAP(CColorPage)
		// NOTE: the ClassWizard will add message map macros here
	//}}AFX_MSG_MAP
	ON_COMMAND_EX(IDC_BLACK, OnColorClicked)
	ON_COMMAND_EX(IDC_RED, OnColorClicked)
	ON_COMMAND_EX(IDC_GREEN, OnColorClicked)
	ON_COMMAND_EX(IDC_BLUE, OnColorClicked)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CColorPage message handlers
