// dynaview.cpp
//

#include "stdafx.h"
#include "dyna.h"

/////////////////////////////////////////////////////////////////////////////
// CDynaRecordView implementation

IMPLEMENT_DYNAMIC(CDynaRecordView, CRecordView)

CDynaRecordView::CDynaRecordView(LPCSTR lpszTemplateName)
    : CRecordView(lpszTemplateName)
{
}

CDynaRecordView::CDynaRecordView(UINT nIDTemplate)
    : CRecordView(nIDTemplate)
{
}

void CDynaRecordView::OnInitialUpdate()
{
    CDynaRecordset* pRecordset = (CDynaRecordset*)OnGetRecordset();
  
    // recordset must be allocated already
    ASSERT(pRecordset != NULL);
  
    // recordset object must be derived from CDynaRecordset
    ASSERT(pRecordset->IsKindOf(RUNTIME_CLASS(CDynaRecordset)));
    
  
    if (!pRecordset->IsOpen())
    {
        BeginWaitCursor();
        TRY
        {
            pRecordset->Open(CRecordset::dynaset);
        }
        CATCH(CDBException, e)
        {
            EndWaitCursor();
            AfxMessageBox(e->m_strError, MB_ICONEXCLAMATION);
            THROW_LAST();
        }
        AND_CATCH_ALL(e)
        {
            EndWaitCursor();
            THROW_LAST();
        }
        END_CATCH_ALL
        EndWaitCursor();
    }

    CFormView::OnInitialUpdate();
}

BOOL CDynaRecordView::OnMove(UINT nIDMoveCommand)
{
    if (CDatabase::InWaitForDataSource())
    {
#ifdef _DEBUG
        if (afxTraceFlags & 0x20)
            TRACE0("Warning: ignored move request\n");
#endif // _DEBUG
        return TRUE;
    }

    CDynaRecordset* pSet = (CDynaRecordset*)OnGetRecordset();
    if (pSet->CanUpdate())
    {
        pSet->Edit();
        if (!UpdateData())
            return TRUE;

        pSet->Update();
    }

    switch (nIDMoveCommand)
    {
        case ID_RECORD_PREV:
            pSet->MovePrev();
            if (!pSet->IsBOF())
                break;

        case ID_RECORD_FIRST:
            pSet->MoveFirst();
            break;

        case ID_RECORD_NEXT:
            pSet->MoveNext();
            if (!pSet->IsEOF())
                break;
            if (!pSet->CanScroll())
            {
                // clear out screen since we're sitting on EOF
                pSet->SetFieldNull(NULL);
                break;
            }

        case ID_RECORD_LAST:
            pSet->MoveLast();
            break;

        default:
            // Unexpected case value
            ASSERT(FALSE);
    }

    // Show results of move operation
    UpdateData(FALSE);
    return TRUE;
}

