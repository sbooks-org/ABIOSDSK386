// This is a part of the Microsoft Foundation Classes C++ library.
// Copyright (C) 1992 Microsoft Corporation
// All rights reserved.
//
// This source code is only intended as a supplement to the
// Microsoft Foundation Classes Reference and Microsoft
// WinHelp documentation provided with the library.
// See these sources for detailed information regarding the
// Microsoft Foundation Classes product.


#include "stdafx.h"
#include "padview.h"
#include "paddoc.h"
#include "paditem.h"
#include "linkitem.h"
#include <limits.h>

IMPLEMENT_DYNAMIC(CPadLinkItem, CEmbeddedItem)

CPadLinkItem::CPadLinkItem(CPadDoc* pContainerDoc, LPCSTR pszItemName)
	: CEmbeddedItem(pContainerDoc)
{
	CString strItemName(pszItemName);
	SetItemName(strItemName);
	sscanf(strItemName, "%d %d", &m_nBeg, &m_nEnd);
}

CPadLinkItem::CPadLinkItem(CPadDoc* pContainerDoc, int nFrom, int nTo)
	: CEmbeddedItem(pContainerDoc)
{
	m_nBeg = nFrom;
	m_nEnd = nTo;
	char buf[30];
	wsprintf(buf, "%d %d", m_nBeg, m_nEnd);
	SetItemName(buf);
}

void CPadLinkItem::OnShow()
{
	CPadDoc* pDoc = (CPadDoc*)GetDocument();
	ASSERT(pDoc != NULL);
	ASSERT_VALID(pDoc);
	ASSERT(pDoc->IsKindOf(RUNTIME_CLASS(CPadDoc)));
	pDoc->SetSelection(m_nBeg, m_nEnd);

	CEmbeddedItem::OnShow();
}

/////////////////////////////////////////////////////////////////////////////
