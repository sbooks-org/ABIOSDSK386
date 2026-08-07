// sectset.cpp : implementation of the CSectionSet class
//

#include "stdafx.h"
#include "enroll.h"
#include "sectset.h"

/////////////////////////////////////////////////////////////////////////////
// CSectionSet implementation

IMPLEMENT_DYNAMIC(CSectionSet, CDynaRecordset)

CSectionSet::CSectionSet(CDatabase* pdb)
    : CDynaRecordset(pdb)
{
    //{{AFX_FIELD_INIT(CSectionSet)
    m_CourseID = "";
    m_SectionNo = "";
    m_InstructorID = "";
    m_RoomNo = "";
    m_Schedule = "";
    m_Capacity = 0;
    m_nFields = 6;
    //}}AFX_FIELD_INIT
    m_nParams = 1;
    m_strCourseIDParam = "";
}

CString CSectionSet::GetDefaultConnect()
{
    return "ODBC;DSN=Student Registration;";
}

CString CSectionSet::GetDefaultSQL()
{
    return "SECTION";
}

void CSectionSet::DoFieldExchange(CFieldExchange* pFX)
{
    //{{AFX_FIELD_MAP(CSectionSet)
    pFX->SetFieldType(CFieldExchange::outputColumn);
    Dyna_RFX_Text(pFX, "CourseID", m_CourseID);
    Dyna_RFX_Text(pFX, "SectionNo", m_SectionNo);
    Dyna_RFX_Text(pFX, "InstructorID", m_InstructorID);
    Dyna_RFX_Text(pFX, "RoomNo", m_RoomNo);
    Dyna_RFX_Text(pFX, "Schedule", m_Schedule);
    Dyna_RFX_Int(pFX, "Capacity", m_Capacity);
    //}}AFX_FIELD_MAP
    pFX->SetFieldType(CFieldExchange::param);
    Dyna_RFX_Text(pFX, "CourseIDParam", m_strCourseIDParam);
}
