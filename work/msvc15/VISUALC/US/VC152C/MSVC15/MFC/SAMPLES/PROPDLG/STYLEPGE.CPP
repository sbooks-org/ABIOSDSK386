// stylepge.cpp : implementation file
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
// CStylePage dialog


CStylePage::CStylePage() : CPropertyPage(CStylePage::IDD)
{
	//{{AFX_DATA_INIT(CStylePage)
	//}}AFX_DATA_INIT
	m_nShapeStyle = rectangle;
}

void CStylePage::DoDataExchange(CDataExchange* pDX)
{
	CPropertyPage::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CStylePage)
	DDX_Radio(pDX, IDC_RECTANGLE, m_nShapeStyle);
	//}}AFX_DATA_MAP
}

BOOL CStylePage::OnStyleClicked(UINT /*nCmdID*/)
{
	// The CStylePage property page is used for both the
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
	return TRUE;
}

BEGIN_MESSAGE_MAP(CStylePage, CPropertyPage)
	//{{AFX_MSG_MAP(CStylePage)
		// NOTE: the ClassWizard will add message map macros here
	//}}AFX_MSG_MAP
	ON_COMMAND_EX(IDC_RECTANGLE, OnStyleClicked)
	ON_COMMAND_EX(IDC_ROUND_RECTANGLE, OnStyleClicked)
	ON_COMMAND_EX(IDC_ELLIPSE, OnStyleClicked)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CStylePage message handlers
