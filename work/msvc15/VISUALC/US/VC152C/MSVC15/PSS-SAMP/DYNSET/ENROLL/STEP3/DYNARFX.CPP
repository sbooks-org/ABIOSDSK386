// dynarfx.cpp
//

#include "stdafx.h"
#include "dyna.h"
#include <limits.h>

/////////////////////////////////////////////////////////////////////////////
// Field exchange helpers

void DynaRfxDefault(CFieldExchange* pFX, CRecordset* prs,
    LONG* plLength, UINT cbValue)
{
    switch(pFX->m_nOperation)
    {
    default:
        ASSERT(FALSE);
        return;
        
    case BIND_FIELD_FOR_UPDATE:
        if (!prs->IsFieldFlagDirty(pFX->m_nFields, pFX->m_nFieldType))
        {
            // If field is not dirty, set bound length to SQL_IGNORE for SQLSetPos updates
            *plLength = SQL_IGNORE;
        }
        else if (!prs->IsFieldFlagNull(pFX->m_nFields, pFX->m_nFieldType))
        {
            // plLength always set to SQL_NULL_DATA in AddNew mode
            *plLength = cbValue;
        }
        return;


    case UNBIND_FIELD_FOR_UPDATE:
        // Reset bound length to actual length to clear SQL_IGNOREs
        if (!prs->IsFieldFlagDirty(pFX->m_nFields, pFX->m_nFieldType))
            *plLength = cbValue;
        return;  
    }
}

// Note: CString.m_pchData must not be changed.  This address is registered
// with ODBC and must remain valid until the recordset is released.
void AFXAPI Dyna_RFX_Text(CFieldExchange* pFX, const char *szName,
    CString& value, int nMaxLength, int nColumnType)
{
    ASSERT(AfxIsValidAddress(pFX, sizeof(CFieldExchange)));

    switch (pFX->m_nOperation)
    {
    default:
        RFX_Text(pFX, szName, value, nMaxLength, nColumnType);
        return;

    case BIND_FIELD_FOR_UPDATE:
    case UNBIND_FIELD_FOR_UPDATE:
        if(pFX->m_nFieldType == CFieldExchange::param)
            return;

        {
            pFX->m_nFields++;
            LONG* plLength = pFX->m_prs->GetFieldLength(pFX);
            DynaRfxDefault(pFX, pFX->m_prs, plLength, value.GetLength());
        }
        return;
    }
}

void AFXAPI Dyna_RFX_Int(CFieldExchange* pFX, const char *szName,
    int& value)
{
    ASSERT(AfxIsValidAddress(pFX, sizeof(CFieldExchange)));

    switch (pFX->m_nOperation)
    {
    default:
        RFX_Int(pFX, szName, value);
        return;

    case BIND_FIELD_FOR_UPDATE:
    case UNBIND_FIELD_FOR_UPDATE:
        if(pFX->m_nFieldType == CFieldExchange::param)
            return;

        {
            pFX->m_nFields++;
            LONG* plLength = pFX->m_prs->GetFieldLength(pFX);
            DynaRfxDefault(pFX, pFX->m_prs, plLength, sizeof(value));
        }
        return;
    }
}

void AFXAPI Dyna_RFX_Long(CFieldExchange* pFX, const char *szName, long& value)
{
    ASSERT(AfxIsValidAddress(pFX, sizeof(CFieldExchange)));

    switch (pFX->m_nOperation)
    {
    default:
        RFX_Long(pFX, szName, value);
        return;

    case BIND_FIELD_FOR_UPDATE:
    case UNBIND_FIELD_FOR_UPDATE:
        if(pFX->m_nFieldType == CFieldExchange::param)
            return;

        {
            pFX->m_nFields++;
            LONG* plLength = pFX->m_prs->GetFieldLength(pFX);
            DynaRfxDefault(pFX, pFX->m_prs, plLength, sizeof(value));
        }
        return;
    }
}

void AFXAPI Dyna_RFX_Byte(CFieldExchange* pFX, const char *szName,
    BYTE& value)
{
    ASSERT(AfxIsValidAddress(pFX, sizeof(CFieldExchange)));

    switch (pFX->m_nOperation)
    {
    default:
        RFX_Byte(pFX, szName, value);
        return;

    case BIND_FIELD_FOR_UPDATE:
    case UNBIND_FIELD_FOR_UPDATE:
        if(pFX->m_nFieldType == CFieldExchange::param)
            return;

        {
            pFX->m_nFields++;
            LONG* plLength = pFX->m_prs->GetFieldLength(pFX);
            DynaRfxDefault(pFX, pFX->m_prs, plLength, sizeof(value));
        }
        return;
    }
}

void AFXAPI Dyna_RFX_Bool(CFieldExchange* pFX, const char *szName,
    BOOL& value)
{
    ASSERT(AfxIsValidAddress(pFX, sizeof(CFieldExchange)));

    switch (pFX->m_nOperation)
    {
    default:
        RFX_Bool(pFX, szName, value);
        return;

    case BIND_FIELD_FOR_UPDATE:
    case UNBIND_FIELD_FOR_UPDATE:
        if(pFX->m_nFieldType == CFieldExchange::param)
            return;

        {
            pFX->m_nFields++;
            LONG* plLength = pFX->m_prs->GetFieldLength(pFX);
            DynaRfxDefault(pFX, pFX->m_prs, plLength, sizeof(value));
        }
        return;
    }
}

void AFXAPI Dyna_RFX_Single(CFieldExchange* pFX, const char *szName,
    float& value)
{
    ASSERT(AfxIsValidAddress(pFX, sizeof(CFieldExchange)));

    switch (pFX->m_nOperation)
    {
    default:
        RFX_Single(pFX, szName, value);
        return;

    case BIND_FIELD_FOR_UPDATE:
    case UNBIND_FIELD_FOR_UPDATE:
        if(pFX->m_nFieldType == CFieldExchange::param)
            return;

        {
            pFX->m_nFields++;
            LONG* plLength = pFX->m_prs->GetFieldLength(pFX);
            DynaRfxDefault(pFX, pFX->m_prs, plLength, sizeof(value));
        }
        return;
    }
}

void AFXAPI Dyna_RFX_Double(CFieldExchange* pFX, const char *szName,
    double& value)
{
    ASSERT(AfxIsValidAddress(pFX, sizeof(CFieldExchange)));

    switch (pFX->m_nOperation)
    {
    default:
        RFX_Double(pFX, szName, value);
        return;

    case BIND_FIELD_FOR_UPDATE:
    case UNBIND_FIELD_FOR_UPDATE:
        if(pFX->m_nFieldType == CFieldExchange::param)
            return;

        {
            pFX->m_nFields++;
            LONG* plLength = pFX->m_prs->GetFieldLength(pFX);
            DynaRfxDefault(pFX, pFX->m_prs, plLength, sizeof(value));
        }
        return;
    }
}

// Note: CByteArray.m_pData must not be changed.  This address is registered
// with ODBC and must remain valid until the recordset is released.
void AFXAPI Dyna_RFX_Binary(CFieldExchange* pFX, const char *szName,
    CByteArray& value, int nMaxLength)
{
    ASSERT(AfxIsValidAddress(pFX, sizeof(CFieldExchange)));

    switch (pFX->m_nOperation)
    {
    default:
        RFX_Binary(pFX, szName, value, nMaxLength);
        return;

    case BIND_FIELD_FOR_UPDATE:
    case UNBIND_FIELD_FOR_UPDATE:
        if(pFX->m_nFieldType == CFieldExchange::param)
            return;

        {
            pFX->m_nFields++;
            LONG* plLength = pFX->m_prs->GetFieldLength(pFX);
            DynaRfxDefault(pFX, pFX->m_prs, plLength, (UINT)value.GetSize());
        }
        return;
    }
}

void AFXAPI Dyna_RFX_Date(CFieldExchange* pFX, const char *szName,
    CTime& value)
{
    ASSERT(AfxIsValidAddress(pFX, sizeof(CFieldExchange)));

    switch (pFX->m_nOperation)
    {
    default:
        RFX_Date(pFX, szName, value);
        return;

    case BIND_FIELD_FOR_UPDATE:
        {
            if(pFX->m_nFieldType == CFieldExchange::param)
                return;
    
            pFX->m_nFields++;

            if (pFX->m_prs->m_pvFieldProxy[pFX->m_nFields] != NULL)
            {
                // Fill buffer (expected by SQLSetPos) with new field data
                TIMESTAMP_STRUCT* pts;
                pts = (TIMESTAMP_STRUCT *)pFX->m_prs->m_pvFieldProxy[pFX->m_nFields];
                pts->year = (SWORD)value.GetYear();
                pts->month = (UWORD)value.GetMonth();
                pts->day = (UWORD)value.GetDay();
                pts->hour = (UWORD)value.GetHour();
                pts->minute = (UWORD)value.GetMinute();
                pts->second = (UWORD)value.GetSecond();
                pts->fraction = 0;
    
            }

            LONG* plLength = pFX->m_prs->GetFieldLength(pFX);
            DynaRfxDefault(pFX, pFX->m_prs, plLength, sizeof(TIMESTAMP_STRUCT));
        }
        return;

    case UNBIND_FIELD_FOR_UPDATE:
        if(pFX->m_nFieldType == CFieldExchange::param)
            return;

        {
            pFX->m_nFields++;
            LONG* plLength = pFX->m_prs->GetFieldLength(pFX);
            DynaRfxDefault(pFX, pFX->m_prs, plLength, sizeof(TIMESTAMP_STRUCT));
        }
        return;
    }

}

void AFXAPI Dyna_RFX_LongBinary(CFieldExchange* pFX, const char *szName,
    CLongBinary& value)
{
    ASSERT(AfxIsValidAddress(pFX, sizeof(CFieldExchange)));
    ASSERT(pFX->m_nFieldType != CFieldExchange::param);
    
    RETCODE nRetCode;
    long* plLength;                            
                                
    UINT nOp=pFX->m_nOperation;
    if (nOp==BIND_FIELD_FOR_UPDATE||nOp==UNBIND_FIELD_FOR_UPDATE|| 
        nOp==CFieldExchange::BindFieldToColumn || nOp==CFieldExchange::SetFieldNull)
    {   
        // m_nFields gets incremented in RFX_LongBinary for other operations 
        pFX->m_nFields++;
        plLength = pFX->m_prs->GetFieldLength(pFX);
    }
    
    switch (pFX->m_nOperation)
    {  
    case CFieldExchange::Name:
        ((CDynaRecordset*)pFX->m_prs)->m_bLongBinaryColumns=TRUE;
        // fall through to default
        
    default:
        RFX_LongBinary(pFX, szName, value);
        return;
          
    case BIND_FIELD_FOR_UPDATE:
        if (pFX->m_prs->IsFieldFlagDirty(pFX->m_nFields, pFX->m_nFieldType))
        {
            // If user marked column NULL, reflect this in length
            if (pFX->m_prs->IsFieldFlagNull(pFX->m_nFields, pFX->m_nFieldType))
                *plLength = SQL_NULL_DATA;
            else
            {
                // Length is signed value, it's limited by LONG_MAX
                if (value.m_dwDataLength >
                    (ULONG)(LONG_MAX - labs(SQL_LEN_DATA_AT_EXEC_OFFSET)))
                {
                    ASSERT(FALSE);
                    *plLength = LONG_MAX - labs(SQL_LEN_DATA_AT_EXEC_OFFSET);
                }
                else
                    *plLength = value.m_dwDataLength;

                *plLength = SQL_LEN_DATA_AT_EXEC(*plLength);
            }
        }
        else
            *plLength = SQL_IGNORE;

        return;

    case UNBIND_FIELD_FOR_UPDATE:
        *plLength = value.m_dwDataLength;
        return;
    
    case CFieldExchange::BindFieldToColumn:
        if (!((CDynaRecordset*)pFX->m_prs)->m_bUseUpdateSQL && pFX->m_prs->CanUpdate())
        {
            // Bind for updates with cb=0 now. Driver may not support post Execute or ExtendedFetch binding
            AFX_SQL_SYNC(::SQLBindCol(pFX->m_prs->m_hstmt, (UWORD)pFX->m_nFields, SQL_C_DEFAULT,
                &value, 0, plLength));
            if (!pFX->m_prs->Check(nRetCode))
                pFX->m_prs->ThrowDBException(nRetCode);
        }
        return;
        
    case CFieldExchange::SetFieldNull:
        if (pFX->m_pvField == NULL || pFX->m_pvField == &value)
        {
            if (pFX->m_bField)
            {
                // Mark fields null
                pFX->m_prs->SetFieldFlags(pFX->m_nFields,
                    AFX_SQL_FIELD_FLAG_NULL, pFX->m_nFieldType);
                value.m_dwDataLength = 0;
                *plLength = SQL_NULL_DATA;
            }
            else
            {
                pFX->m_prs->ClearFieldFlags(pFX->m_nFields,
                    AFX_SQL_FIELD_FLAG_NULL, pFX->m_nFieldType);

                // Length is signed value, it's limited by LONG_MAX
                if (value.m_dwDataLength >
                    (ULONG)(LONG_MAX - labs(SQL_LEN_DATA_AT_EXEC_OFFSET)))
                {
                    ASSERT(FALSE);
                    *plLength = LONG_MAX - labs(SQL_LEN_DATA_AT_EXEC_OFFSET);
                }
                else
                    *plLength = value.m_dwDataLength;

                *plLength = SQL_LEN_DATA_AT_EXEC(*plLength);
            }
#ifdef _DEBUG
            pFX->m_bFieldFound = TRUE;
#endif
        }
        return;
    }
}
