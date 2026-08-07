// dynacore.cpp
//

#include "stdafx.h"
#include "dyna.h"

#ifndef _AfxAnsiNext
#define _AfxAnsiNext(psz)   ((char*)_AfxGetPtrFromFarPtr(AnsiNext((LPCSTR)psz)))
#endif

/////////////////////////////////////////////////////////////////////////////
// CDynaDatabase implementation

IMPLEMENT_DYNAMIC(CDynaDatabase, CDatabase)

CDynaDatabase::CDynaDatabase()
    : CDatabase()
{   
}

static char BASED_CODE lpszODBC[] = "ODBC;";
BOOL CDynaDatabase::Open(LPCSTR lpszDSN, BOOL bExclusive /* = FALSE */,
        BOOL bReadonly /* = FALSE */, LPCSTR lpszConnect /* = "ODBC;" */,
        BOOL bUseCursorLib /* = TRUE */)
{
    char szConnectOutput[MAX_CONNECT_LEN];
    int cbConnStrOut;

    ASSERT_VALID(this);
    ASSERT(lpszDSN == NULL || AfxIsValidString(lpszDSN));
    ASSERT(lpszConnect == NULL || AfxIsValidString(lpszConnect));

    // Exclusive access not supported.
    ASSERT(!bExclusive);
    m_bUpdatable = !bReadonly;

    CString strTemp;
    TRY
    {
        if (lpszConnect != NULL)
            m_strConnect = lpszConnect;

        // For VB/Access compatibility, require "ODBC;" (or "odbc;")
        // prefix to the connect string
        strTemp = m_strConnect.Left(sizeof(lpszODBC)-1);
        if (lstrcmpi(strTemp, lpszODBC) != 0)
        {
#ifdef _DEBUG
            TRACE0("Error: Missing \"ODBC;\" prefix on connect string\n");
#endif // _DEBUG
            return FALSE;
        }

        // Strip "ODBC;"
        m_strConnect = m_strConnect.Right(m_strConnect.GetLength()
            - (sizeof(lpszODBC)-1));

        if (lpszDSN != NULL && lstrlen(lpszDSN) != 0)
        {
            // Append "DSN=" lpszDSN
            static char BASED_CODE lpszDSNEqual[] = ";DSN=";
            m_strConnect += lpszDSNEqual;
            m_strConnect += lpszDSN;
        }

        AllocConnect();

        RETCODE nRetCode;

        if(bUseCursorLib)
        {
            // Turn on cursor lib support
            AFX_SQL_SYNC(::SQLSetConnectOption(m_hdbc,
                SQL_ODBC_CURSORS, SQL_CUR_USE_ODBC));
        }

        int cbResult;
        
        HWND hwndOwner;
        CWnd* pParent = AfxGetMainWnd();
        
        if (pParent == NULL || pParent->m_hWnd == NULL)
            hwndOwner = NULL;
        else
        {
            ASSERT_VALID(pParent);
            hwndOwner = ::GetLastActivePopup(pParent->GetTopLevelParent()->m_hWnd);
        }

        AFX_SQL_SYNC(::SQLDriverConnect(m_hdbc,
            hwndOwner,
            (UCHAR FAR*)(const char *)m_strConnect, SQL_NTS,
            (UCHAR FAR*)szConnectOutput, sizeof(szConnectOutput),
            (short FAR*)&cbConnStrOut, SQL_DRIVER_COMPLETE));

        // If user hit 'Cancel'
        if (nRetCode == SQL_NO_DATA_FOUND)
        {
            Free();
            return FALSE;
        }

        if (!Check(nRetCode))
        {
#ifdef _DEBUG
            if ((AfxGetApp()->m_pMainWnd)->GetSafeHwnd() == NULL)
                TRACE0("Error: No default window (AfxGetApp()->m_pMainWnd) for SQLDriverConnect\n");
#endif // _DEBUG
            ThrowDBException(nRetCode);
        }

        // Connect strings must have "ODBC;"
        m_strConnect = lpszODBC;
        // Save connect string returned from ODBC
        m_strConnect += szConnectOutput;

        UINT nAPIConformance;
        AFX_SQL_SYNC(::SQLGetInfo(m_hdbc, SQL_ODBC_API_CONFORMANCE,
            &nAPIConformance, sizeof(nAPIConformance),
            (short FAR*)&cbResult));
        if (!Check(nRetCode))
            ThrowDBException(nRetCode);

        if (nAPIConformance < SQL_OAC_LEVEL1)
            ThrowDBException(AFX_SQL_ERROR_API_CONFORMANCE);

        UINT nSQLConformance;
        AFX_SQL_SYNC(::SQLGetInfo(m_hdbc, SQL_ODBC_SQL_CONFORMANCE,
            &nSQLConformance, sizeof(nSQLConformance),
            (short FAR*)&cbResult));
        if (!Check(nRetCode))
            ThrowDBException(nRetCode);

        if (nSQLConformance < SQL_OSC_MINIMUM)
            ThrowDBException(AFX_SQL_ERROR_SQL_CONFORMANCE);

        UINT nCursorBehavior;
        AFX_SQL_SYNC(::SQLGetInfo(m_hdbc, SQL_CURSOR_COMMIT_BEHAVIOR,
            &nCursorBehavior, sizeof(nCursorBehavior),
            (short FAR*)&cbResult));
        if (Check(nRetCode))
        {
            if (nCursorBehavior == SQL_CR_PRESERVE)
            {
                AFX_SQL_SYNC(::SQLGetInfo(m_hdbc,
                    SQL_CURSOR_ROLLBACK_BEHAVIOR, &nCursorBehavior,
                    sizeof(nCursorBehavior), (short FAR*)&cbResult));
                if (Check(nRetCode) && nCursorBehavior == SQL_CR_PRESERVE)
                    m_bTransactions = TRUE;
            }
        }

        if (m_bUpdatable)
        {
            // Make sure data source is Updatable
            char szReadOnly[10];
            AFX_SQL_SYNC(::SQLGetInfo(m_hdbc, SQL_DATA_SOURCE_READ_ONLY,
                szReadOnly, sizeof(szReadOnly), (short FAR*)&cbResult));
            if (Check(nRetCode) && cbResult == 1)
                m_bUpdatable = !(lstrcmp(szReadOnly, "Y") == 0);
            else
                m_bUpdatable = FALSE;
#ifdef _DEBUG
            if (!m_bUpdatable && (afxTraceFlags & 0x20))
                TRACE0("Warning: data source is readonly\n");
#endif // _DEBUG
        }
        else
        {
            // Make data source is !Updatable
            AFX_SQL_SYNC(::SQLSetConnectOption(m_hdbc,
                SQL_ACCESS_MODE, SQL_MODE_READ_ONLY));
        }

        char szIDQuoteChar[2];
        AFX_SQL_SYNC(::SQLGetInfo(m_hdbc, SQL_IDENTIFIER_QUOTE_CHAR,
            szIDQuoteChar, sizeof(szIDQuoteChar), (short FAR*)&cbResult));
        if (Check(nRetCode) && cbResult == 1)
            m_chIDQuoteChar = szIDQuoteChar[0];
        else
            m_chIDQuoteChar = ' ';


        char szDriverName[32];
        AFX_SQL_SYNC(::SQLGetInfo(m_hdbc, SQL_DRIVER_NAME,
            szDriverName, sizeof(szDriverName), (short FAR*)&cbResult));
        if (lstrcmpi(szDriverName, "simba.dll") == 0)
        {
            m_bStripTrailingSpaces = TRUE;
        }


#ifdef _DEBUG
        if (afxTraceFlags & 0x20)
        {
            int cbResult;
            char szInfo[64];
            AFX_SQL_SYNC(::SQLGetInfo(m_hdbc, SQL_DBMS_NAME,
                szInfo, sizeof(szInfo), (short FAR*)&cbResult));
            if (Check(nRetCode))
            {
                TRACE1("DBMS: %s", szInfo);

                AFX_SQL_SYNC(::SQLGetInfo(m_hdbc, SQL_DBMS_VER,
                    szInfo, sizeof(szInfo), (short FAR*)&cbResult));
                if (Check(nRetCode))
                    TRACE1(", Version: %s\n", szInfo);
            }
        }
#endif // _DEBUG
    }
    CATCH_ALL(e)
    {
        strTemp.Empty();
        Free();
        THROW_LAST();
    }
    END_CATCH_ALL

    return TRUE;
}
         

/////////////////////////////////////////////////////////////////////////////
// CDynaRecordset implementation

IMPLEMENT_DYNAMIC(CDynaRecordset, CRecordset)

CDynaRecordset::CDynaRecordset(CDatabase* pdb)
    : CRecordset(pdb)
{ 
    BOOL m_bLongBinaryColumns = FALSE;
}         

static char BASED_CODE szWhere[] = " WHERE ";
static char BASED_CODE szOrderBy[] = " ORDER BY ";
static char BASED_CODE szSelect[] = "SELECT ";
static char BASED_CODE szFrom[] = " FROM ";
static char BASED_CODE szForUpdateOf[] = " FOR UPDATE OF ";
static char szDriverNotCapable[] = "State:S1C00";
BOOL CDynaRecordset::Open(UINT nOpenType /* = snapshot */,
    LPCSTR lpszSQL /* = NULL */, DWORD dwOptions /* = none */)
{
    ASSERT_VALID(this);
    ASSERT(lpszSQL == NULL || AfxIsValidString(lpszSQL));
    ASSERT(nOpenType == dynaset || nOpenType == snapshot ||
        nOpenType == forwardOnly);
    ASSERT(dwOptions == 0 || (dwOptions & appendOnly) ||
        (dwOptions & readOnly));

    m_nOpenType = nOpenType;
    m_bAppendable = (dwOptions & CRecordset::appendOnly) != 0 ||
        (dwOptions & CRecordset::readOnly) == 0;
    m_bUpdatable = (dwOptions & CRecordset::readOnly) == 0 &&
        (dwOptions & CRecordset::appendOnly) == 0;

    // Can't update forward only cursor
    ASSERT(!((nOpenType == forwardOnly) && m_bUpdatable));

    RETCODE nRetCode;
    if (m_hstmt == SQL_NULL_HSTMT)
    {
        CString strDefaultConnect;
        TRY
        {
            if (m_pDatabase == NULL)
            {
              //  m_pDatabase = (CDatabase*)new CDynaDatabase();
                m_pDatabase= new CDynaDatabase;
                m_bRecordsetDb = TRUE;
            }

            strDefaultConnect = GetDefaultConnect();           
            
            // don't load the cursor library if using a dynaset
            BOOL bCursorLib=(m_nOpenType==dynaset)?FALSE:TRUE;
            
            if (!m_pDatabase->IsOpen() &&
                !((CDynaDatabase*)m_pDatabase)->Open("", FALSE, FALSE,
                strDefaultConnect, bCursorLib))
                       return FALSE;
            
            AFX_SQL_SYNC(::SQLAllocStmt(m_pDatabase->m_hdbc, &m_hstmt));
            if (!Check(nRetCode))
                ThrowDBException(SQL_INVALID_HANDLE);
        }
        CATCH_ALL(e)
        {
#ifdef _DEBUG
            if (afxTraceFlags & 0x20)
                TRACE0("Error: CDatabase create for CRecordset failed\n");
#endif // _DEBUG
            strDefaultConnect.Empty();
            if (m_bRecordsetDb)
            {
                delete m_pDatabase;
                m_pDatabase = NULL;
            }
            ASSERT(m_hstmt == SQL_NULL_HSTMT);
            THROW_LAST();
        }
        END_CATCH_ALL
    }

    // Musn't open new recordset till any pending async ops have completed
    ASSERT(!m_pDatabase->InWaitForDataSource());

    CString strName;
    TRY
    {
        // Allocate flag and length arrays if not already
        if ((m_nFields != 0 && m_pbFieldFlags == NULL) ||
            (m_nParams != 0 && m_pbParamFlags == NULL))
            AllocFlags();

        OnSetOptions(m_hstmt);

        if (lpszSQL == NULL)
            m_strSQL = GetDefaultSQL();
        else
            m_strSQL = lpszSQL;

        // Set any supplied params
        if (m_nParams != 0)
        {
            UINT nParams = BindParams(m_hstmt);
            ASSERT(nParams == m_nParams);
        }

        // Check for SELECT keyword
        strName = m_strSQL.Left(sizeof(szSelect)-1);
        if (lstrcmpi(strName, szSelect) == 0)
        {
            // Find table name
            strName = m_strSQL;
            strName.MakeUpper();
            CString strFrom = szFrom;
            int nFrom = strName.Find(strFrom);
            LPCSTR lpsz = nFrom < 0 ? NULL : (LPCSTR)strName + nFrom;
            if (lpsz == NULL)
            {
                m_bAppendable = m_bUpdatable = FALSE;

#ifdef _DEBUG
                if (afxTraceFlags & 0x20)
                    TRACE0("Warning: Missing 'FROM', recordset not updatable\n");
#endif // _DEBUG
            }
            else
            {
                // remove chars upto and including " FROM "
                strName = m_strSQL.Right(m_strSQL.GetLength() -
                    (lpsz - (LPCSTR)strName + sizeof(szFrom)-1));

                // Search for table name
                for (char *pchName = strName.GetBuffer(0);
                    *pchName > 0xD && *pchName != ',' && *pchName != ' ';
                    pchName = _AfxAnsiNext(pchName))
                    ;

                // If list of names, we can't update
                if (*pchName == ',')
                {
                    m_bAppendable = m_bUpdatable = FALSE;
#ifdef _DEBUG
                    if (afxTraceFlags & 0x20)
                        TRACE0("Warning: multi-table recordset not updatable\n");
#endif // _DEBUG
                }
                else
                {
                    *pchName = '\0';
                    // get table name
                    m_strTableName = m_pDatabase->QuoteName(strName);
                }
                strName.ReleaseBuffer();
            }
        }
        else
        {
            // Parse for query procedure call keyword
            static char BASED_CODE szCall[] = "{call ";
            strName = m_strSQL.Left(sizeof(szCall)-1);
            if (lstrcmpi(strName, szCall) != 0)
            {
                for (char *pchName = m_strSQL.GetBuffer(0);
                    *pchName > 0xD && *pchName != ',' && *pchName != ' ';
                    pchName = _AfxAnsiNext(pchName))
                    ;

                // If list of names, we can't update
                if (*pchName == ',')
                {
                    m_bAppendable = m_bUpdatable = FALSE;
                    m_strTableName = m_strSQL;
#ifdef _DEBUG
                    if (afxTraceFlags & 0x20)
                        TRACE0("Warning: multi-table recordset not updatable\n");
#endif // _DEBUG
                }
                else
                {
                    // Assume m_strSQL is a table name
                    m_strTableName = m_pDatabase->QuoteName(m_strSQL);
                }

                m_strSQL.ReleaseBuffer();

                if (m_nFields == 0)
                {
                    // no fields to bind to
#ifdef _DEBUG
                    if (afxTraceFlags & 0x20)
                        TRACE0("Warning: No output fields defined for recordset\n");
#endif // _DEBUG
                    m_strSQL.Empty();
                    m_bAppendable = m_bUpdatable = FALSE;
                    m_bAppendable = FALSE;
                    return TRUE;
                }
                else
                {
                    // build query to retrieve table data
                    BuildTableQuery();
                }
            }
        }
        strName.Empty();

        if (!m_strFilter.IsEmpty())
        {
            m_strSQL += szWhere;
            m_strSQL += m_strFilter;
        }

        if (!m_strSort.IsEmpty())
        {
            m_strSQL += szOrderBy;
            m_strSQL += m_strSort;
        }

        if (m_bUpdatable && m_bUseUpdateSQL &&
            (m_dwDriverPositionedStatements & SQL_PS_SELECT_FOR_UPDATE))
            m_strSQL += szForUpdateOf;

        BOOL bConcurrency = FALSE;
        while(!bConcurrency)
        {
            AFX_SQL_ASYNC(this, ::SQLPrepare(m_hstmt,
                (UCHAR FAR*)(const char *)m_strSQL, SQL_NTS));
            if(Check(nRetCode))
                bConcurrency = TRUE;
            else
            {
                // If "Driver Not Capable" error, assume cursor type doesn't
                // support requested concurrency and try alternate concurrency.
                CDBException e(nRetCode);
                e.BuildErrorString(m_pDatabase, m_hstmt);
                if (m_dwConcurrency != SQL_CONCUR_READ_ONLY &&
                    e.m_strStateNativeOrigin.Find(szDriverNotCapable) >0 )
                {
#ifdef _DEBUG
                    if (afxTraceFlags & 0x20)
                        TRACE0("Warning: Driver does not support requested concurrency.\n");
#endif

                    // ODBC will automatically attempt to set alternate concurrency if
                    // request fails, but it won't try LOCK even if driver supports it.
                    if ((m_dwDriverConcurrency & SQL_SCCO_LOCK) &&
                        (m_dwConcurrency == SQL_CONCUR_ROWVER ||
                        m_dwConcurrency == SQL_CONCUR_VALUES))
                    {
                        m_dwConcurrency = SQL_CONCUR_LOCK;
                    }
                    else
                    {
                        m_dwConcurrency = SQL_CONCUR_READ_ONLY;
                        m_bUpdatable = m_bAppendable = FALSE;
#ifdef _DEBUG
                        if (afxTraceFlags & 0x20)
                            TRACE0("Warning: Setting recordset read only.\n");
#endif
                    }

                    // Attempt to reset the concurrency model.
                    AFX_SQL_SYNC(::SQLSetStmtOption(m_hstmt, SQL_CONCURRENCY,
                        m_dwConcurrency));
                    if (!Check(nRetCode))
                    {
                        TRACE0("Error: ODBC failure setting recordset concurrency.\n");
                        ThrowDBException(nRetCode);
                    }
                }
                else
                {
                    TRACE0("Error: ODBC failure on SQLPrepare.\n");
                    ThrowDBException(nRetCode);
                }
            }
        }

        // now try to execute the SQL Query
        AFX_SQL_ASYNC(this, ::SQLExecute(m_hstmt));
        if (!Check(nRetCode))
            ThrowDBException(nRetCode);

        // Give derived classes a call before binding
        PreBindFields();

        MoveFirst();
    }
    CATCH_ALL(e)
    {
        strName.Empty();
        Close();
        THROW_LAST();
    }
    END_CATCH_ALL

    return TRUE;
}

static char szInfoRange[] = "State:S1096";
void CDynaRecordset::OnSetOptions(HSTMT hstmt)
{
    ASSERT_VALID(this);
    ASSERT(hstmt != SQL_NULL_HSTMT);

    // Inherit options settings from CDatabase
    m_pDatabase->OnSetOptions(hstmt);

    // ODBC "cursor" is forwardOnly by default
    if (m_nOpenType == forwardOnly)
    {
        ASSERT(!m_bUpdatable);
        return;
    }

    RETCODE nRetCode;
    UWORD wDriverScrollSupport;
    // If SQLExtendedFetch not supported open forwardOnly (uses SQLFetch)
    AFX_SQL_SYNC(::SQLGetFunctions(m_pDatabase->m_hdbc,
        SQL_API_SQLEXTENDEDFETCH, &wDriverScrollSupport));
    if (!Check(nRetCode))
    {
        TRACE0("Error: ODBC failure determining whether recordset is scrollable.\n");
        ThrowDBException(nRetCode);
    }
    m_bScrollable = wDriverScrollSupport;
    if (!m_bScrollable)
    {
#ifdef _DEBUG
        if (afxTraceFlags & 0x20)
            TRACE0("Warning: SQLExtendedFetch not supported by driver\n");
            TRACE0("and/or cursor library not loaded. Opening forwardOnly.\n");
#endif // _DEBUG
        m_bUpdatable = FALSE;
        return;
    }

    char szResult[30];
    SWORD nResult;
    // Snapshots and dynasets require ODBC v2.0 or higher
    AFX_SQL_SYNC(::SQLGetInfo(m_pDatabase->m_hdbc, SQL_ODBC_VER,
        szResult, sizeof(szResult), &nResult));
    if (!Check(nRetCode))
    {
        TRACE0("Error: ODBC failure checking for driver capabilities.\n");
        ThrowDBException(nRetCode);
    }
    if (szResult[0] == '0' && szResult[1] < '2')
        ThrowDBException(AFX_SQL_ERROR_ODBC_V2_REQUIRED);

    // Determine scroll options supported by driver
    UDWORD dwDriverScrollOptions;
    AFX_SQL_SYNC(::SQLGetInfo(m_pDatabase->m_hdbc, SQL_SCROLL_OPTIONS,
        &dwDriverScrollOptions, sizeof(dwDriverScrollOptions), &nResult));

    UDWORD dwScrollOptions = SQL_CURSOR_FORWARD_ONLY;
    if (m_nOpenType == dynaset)
    {
        // Dnaset support requires ODBC's keyset driven model
        if (!(dwDriverScrollOptions & SQL_SO_KEYSET_DRIVEN))
            ThrowDBException(AFX_SQL_ERROR_DYNASET_NOT_SUPPORTED);
        dwScrollOptions = SQL_CURSOR_KEYSET_DRIVEN;
    }
    else
    {
        // Snapshot support requires ODBC's static cursor model
        if (!(dwDriverScrollOptions & SQL_SO_STATIC))
            ThrowDBException(AFX_SQL_ERROR_SNAPSHOT_NOT_SUPPORTED);
        dwScrollOptions = SQL_CURSOR_STATIC;
    }

    UDWORD dwDriverPosOperations;
    AFX_SQL_SYNC(::SQLGetInfo(m_pDatabase->m_hdbc, SQL_POS_OPERATIONS,
        &dwDriverPosOperations, sizeof(dwDriverPosOperations), &nResult));
    if (!Check(nRetCode))
    {
        TRACE0("Error: ODBC failure checking for driver capabilities.\n");
        ThrowDBException(nRetCode);
    }

    if ((dwDriverPosOperations & SQL_POS_UPDATE) &&
        (dwDriverPosOperations & SQL_POS_DELETE) &&
        (dwDriverPosOperations & SQL_POS_ADD))
        // SQLSetPos fully supported
        m_bUseUpdateSQL = FALSE;
    else
    {
        // SQLSetPos not supported, check for positioned update SQL statements
        AFX_SQL_SYNC(::SQLGetInfo(m_pDatabase->m_hdbc, SQL_POSITIONED_STATEMENTS,
            &m_dwDriverPositionedStatements, sizeof(m_dwDriverPositionedStatements),
            &nResult));
        if (nRetCode != SQL_SUCCESS)
        {
            CDBException e(nRetCode);
            e.BuildErrorString(m_pDatabase, m_hstmt);
            if (e.m_strStateNativeOrigin.Find(szInfoRange) >= 0)
                // Driver doesn't support SQL_POSITIONED_STATEMENTS info option
                m_bUpdatable = FALSE;
            else
            {
                e.Empty();
                TRACE0("Error: determining if POSITIONED UPDATES supported.\n");
                ThrowDBException(nRetCode);
            }
        }
        else if (!((m_dwDriverPositionedStatements & SQL_PS_POSITIONED_DELETE) &&
            (m_dwDriverPositionedStatements & SQL_PS_POSITIONED_UPDATE)))
            m_bUpdatable = FALSE;
        else
            m_bUseUpdateSQL = TRUE;
    }

    UDWORD dwConcurrency = SQL_CONCUR_READ_ONLY;
    if (m_bUpdatable && m_pDatabase->CanUpdate())
    {
        UDWORD dwDriverConcurrencyOptions;
        AFX_SQL_SYNC(::SQLGetInfo(m_pDatabase->m_hdbc, SQL_SCROLL_CONCURRENCY,
            &dwDriverConcurrencyOptions, sizeof(dwDriverConcurrencyOptions), &nResult));
        if (!Check(nRetCode))
        {
            TRACE0("Error: ODBC failure checking recordset updatability.\n");
            ThrowDBException(nRetCode);
        }

        if (m_nLockMode == pessimistic)
        {
            if (dwDriverConcurrencyOptions & SQL_SCCO_LOCK)
                dwConcurrency = SQL_CONCUR_LOCK;
#ifdef _DEBUG
            else
            {
                if (afxTraceFlags & 0x20)
                    TRACE0("Warning: locking not supported, setting recordset read only.\n");
            }
#endif // _DEBUG
        }
        else
        {
            // Use cheapest, most concur. model
            if (dwDriverConcurrencyOptions & SQL_SCCO_OPT_TIMESTAMP)
                dwConcurrency = SQL_CONCUR_TIMESTAMP;
            else if (dwDriverConcurrencyOptions & SQL_SCCO_OPT_VALUES)
                dwConcurrency = SQL_CONCUR_VALUES;
            else if (dwDriverConcurrencyOptions & SQL_SCCO_LOCK)
                dwConcurrency = SQL_CONCUR_LOCK;
        }
    }

    // Set cursor type (Let rowset size default to 1).
    AFX_SQL_SYNC(::SQLSetStmtOption(hstmt, SQL_CURSOR_TYPE, dwScrollOptions));
    if (!Check(nRetCode))
    {
        TRACE0("Error: ODBC failure setting recordset cursor type.\n");
        ThrowDBException(nRetCode);
    }

    // Set the concurrency model.
    AFX_SQL_SYNC(::SQLSetStmtOption(hstmt, SQL_CONCURRENCY, dwConcurrency));
    if (!Check(nRetCode))
    {
        TRACE0("Error: ODBC failure setting recordset concurrency.\n");
        ThrowDBException(nRetCode);
    }
}

static char szDataTruncated[] = "State:01004";
static char szRowFetch[] = "State:01S01";
void CDynaRecordset::Move(long lRows)
{
    RETCODE nRetCode;
    ASSERT_VALID(m_pDatabase);
    ASSERT(m_hstmt != SQL_NULL_HSTMT);

    // First call - fields haven't been bound
    if (m_nFieldsBound == 0)
    {
        InitRecordMoveFirst();

        // First move completed
        return;
    }

    if (m_nFieldsBound > 0)
    {
        // Reset field flags - mark all clean, all non-null
        memset(m_pbFieldFlags, 0, m_nFields);
    }

    // Clear any edit mode that was set
    ReleaseCopyBuffer();

    if (lRows == 0)
        // Do nothing
        return;

    BOOL bForward = lRows > 0;
    if (!m_bScrollable && lRows != AFX_MOVE_NEXT)
        ThrowDBException(AFX_SQL_ERROR_RECORDSET_FORWARD_ONLY);

    WORD wFetchType;
    if (lRows == AFX_MOVE_FIRST)
    {
        wFetchType = SQL_FETCH_FIRST;
        lRows = 1;
    }
    else
    {
        if (lRows == AFX_MOVE_LAST)
        {
            wFetchType = SQL_FETCH_LAST;
            lRows = 1;
        }
        else
        {
            if (bForward)
            {
                // if already at EOF, throw an exception
                if (m_bEOF)
                    ThrowDBException(AFX_SQL_ERROR_NO_DATA_FOUND);

                wFetchType = SQL_FETCH_NEXT;
            }
            else
            {
                // if already at BOF, throw an exception
                if (m_bBOF)
                    ThrowDBException(AFX_SQL_ERROR_NO_DATA_FOUND);

                lRows = -lRows;
                wFetchType = SQL_FETCH_PREV;
            }
        }
    }

    DWORD dwRowsMoved = 1;
    m_wRowStatus = SQL_ROW_SUCCESS;
    WORD wFetchNext = wFetchType;
    nRetCode = SQL_SUCCESS;
    // Skip deleted rows
    while (Check(nRetCode) && nRetCode != SQL_NO_DATA_FOUND && lRows != 0)
    {
        if (!m_bScrollable)
        {
            AFX_SQL_ASYNC(this, ::SQLFetch(m_hstmt));
        }
        else
        {
            AFX_SQL_ASYNC(this, ::SQLExtendedFetch(m_hstmt, wFetchNext, 0L,
                &dwRowsMoved, &m_wRowStatus));
        }

        if (wFetchType == SQL_FETCH_FIRST || wFetchType == SQL_FETCH_LAST)
        {
            // If doing MoveFirst/Last and first/last record is deleted, must do MoveNext/Prev
            wFetchNext = (WORD)((bForward)? SQL_FETCH_PREV: SQL_FETCH_NEXT);
        }

        m_bDeleted = (m_wRowStatus == SQL_ROW_DELETED);
        if (!m_bDeleted)
        {
            lRows--;
            if (nRetCode != SQL_NO_DATA_FOUND)
            {
                if (wFetchType == SQL_FETCH_FIRST)
                {
                    m_lCurrentRecord = 0;
                }
                else if (wFetchType == SQL_FETCH_LAST)
                {
                    if (m_bEOFSeen)
                        m_lCurrentRecord = m_lRecordCount-1;
                    else
                        m_lRecordCount = m_lCurrentRecord = AFX_CURRENT_RECORD_UNDEFINED;
                }
                else if (m_lCurrentRecord != AFX_CURRENT_RECORD_UNDEFINED)
                {
                    if (bForward)
                        m_lCurrentRecord++;
                    else
                    {
                        // If on deleted record or past end, current record already decremented
                        if (!m_bDeleted && !m_bEOF)
                            m_lCurrentRecord--;
                    }
                }
            }
        }
    }

    if (nRetCode == SQL_SUCCESS_WITH_INFO)
    {
        CDBException e(nRetCode);
        // Build the error string but don't send nuisance output to TRACE window
        e.BuildErrorString(m_pDatabase, m_hstmt);

        if (e.m_strStateNativeOrigin.Find(szDataTruncated) >= 0)
        {
            // Ignore data truncated warning if binding long binary columns
            // (may mask non-long binary truncation warnings or other warnings)
            if (m_bUseUpdateSQL || !m_bLongBinaryColumns || !m_bUpdatable)
            {
                e.Empty();
                TRACE0("Error: field data truncated during Open or Requery.\n");
                ThrowDBException(AFX_SQL_ERROR_DATA_TRUNCATED);
            }
        }
        else if (e.m_strStateNativeOrigin.Find(szRowFetch) >= 0)
        {
            e.Empty();
            TRACE0("Error: fetching row from server during Open or Requery.\n");
            ThrowDBException(AFX_SQL_ERROR_ROW_FETCH);
        }
    }
    else
    {
        if (!Check(nRetCode))
        {
            TRACE0("Error: Move operation failed.\n");
            ThrowDBException(nRetCode);
        }
    }

    if (nRetCode != SQL_NO_DATA_FOUND)
    {
        ASSERT(m_wRowStatus != SQL_ROW_NOROW && dwRowsMoved == 1);
        if (m_lCurrentRecord+1 > m_lRecordCount)
            m_lRecordCount = m_lCurrentRecord+1;
        Fixups();
        m_bBOF = FALSE;
        m_bEOF = FALSE;
        return;
    }

    // Only deleted records are left in set
    if (m_bDeleted)
    {
        m_bEOF = m_bBOF = m_bEOFSeen = TRUE;
        return;
    }

    // SQL_NO_DATA_FOUND
    if (bForward)
    {
        // hit end of set
        m_bEOF = TRUE;

        // If current record is known
        if (m_lCurrentRecord != AFX_CURRENT_RECORD_UNDEFINED)
        {
            m_bEOFSeen = TRUE;
            m_lRecordCount = m_lCurrentRecord+1;
        }
    }
    else
    {
        m_bBOF = TRUE;
        m_lCurrentRecord = AFX_CURRENT_RECORD_BOF;
    }
}

void CDynaRecordset::Delete()
{
    ASSERT_VALID(this);
    ASSERT(m_hstmt != SQL_NULL_HSTMT);

    if (m_nEditMode != noMode)
        ThrowDBException(AFX_SQL_ERROR_ILLEGAL_MODE);
        
    if(m_bUseUpdateSQL)
        UpdateInsertDelete();
    else
        SetPosUpdateInsertDelete();
}
 
 
BOOL CDynaRecordset::Requery()
{
    RETCODE nRetCode;

    ASSERT_VALID(this);
    ASSERT(IsOpen());
    // Can't requery till all pending Async operations have completed
    ASSERT(!m_pDatabase->InWaitForDataSource());

    TRY
    {
        // Shutdown current query
        AFX_SQL_SYNC(::SQLFreeStmt(m_hstmt, SQL_CLOSE));

        // Rebind date/time parameters
        RebindDateParams(m_hstmt);

        // now attempt to reexecute the SQL Query
        AFX_SQL_ASYNC(this, ::SQLExecute(m_hstmt));
        if (!Check(nRetCode))
        {
            TRACE0("Error: Requery attempt failed.\n");
            ThrowDBException(nRetCode);
        }

        m_nFieldsBound = 0;
        InitRecordMoveFirst();
    }
    CATCH_ALL(e)
    {
        Close();
        THROW_LAST();
    }
    END_CATCH_ALL

    return TRUE;    // all set
}
 
BOOL CDynaRecordset::Update()
{
    ASSERT_VALID(this);
    ASSERT(m_hstmt != SQL_NULL_HSTMT);

    if (m_nEditMode != addnew && m_nEditMode != edit)
        ThrowDBException(AFX_SQL_ERROR_ILLEGAL_MODE);

    if(m_bUseUpdateSQL)
        // Old method of SQL-based updates
        return UpdateInsertDelete();
    else
        // Execute update
        return SetPosUpdateInsertDelete();
}

int CDynaRecordset::GetEditMode()
{
    return m_nEditMode;
}

// Bind fields (if not already bound), then retrieve 1st record
void CDynaRecordset::InitRecordMoveFirst()
{
    RETCODE nRetCode;

    // fields to bind
    if (m_nFields != 0)
    {
        m_nFieldsBound = BindFieldsToColumns();
        // m_nFields doesn't reflect number of
        // RFX_ output column calls in DoFieldExchange
        ASSERT(m_nFields == m_nFieldsBound);

        // Reset field flags - mark all clean, all non-null
        memset(m_pbFieldFlags, 0, m_nFields);
    }
    else
    {
        // No fields to bind, don't try to bind again
        m_nFieldsBound = -1;
    }

    ReleaseCopyBuffer();
    m_bEOFSeen = m_bBOF = m_bEOF = TRUE;
    m_bDeleted = FALSE;

    // prime the pump, retrieve first record
    if (!m_bScrollable)
    {
        AFX_SQL_ASYNC(this, ::SQLFetch(m_hstmt));
    }
    else
    {
        DWORD dwRowsMoved;

        AFX_SQL_ASYNC(this, ::SQLExtendedFetch(m_hstmt, SQL_FETCH_NEXT, 0L,
            &dwRowsMoved, &m_wRowStatus));
    }
    
    if (nRetCode == SQL_SUCCESS_WITH_INFO)
    {
        CDBException e(nRetCode);
        // Build the error string but don't send nuisance output to TRACE window
        e.BuildErrorString(m_pDatabase, m_hstmt);

        if (e.m_strStateNativeOrigin.Find(szDataTruncated) >= 0)
        {
            // Ignore data truncated warning if binding long binary columns
            // (may mask non-long binary truncation warnings or other warnings)
            if (m_bUseUpdateSQL || !m_bLongBinaryColumns || !m_bUpdatable)
            {
                e.Empty();
                TRACE0("Error: field data truncated during Open or Requery.\n");
                ThrowDBException(AFX_SQL_ERROR_DATA_TRUNCATED);
            }
        }
        else if (e.m_strStateNativeOrigin.Find(szRowFetch) >= 0)
        {
            e.Empty();
            TRACE0("Error: fetching row from server during Open or Requery.\n");
            ThrowDBException(AFX_SQL_ERROR_ROW_FETCH);
        }
    }
    else
    {
        if (!Check(nRetCode))
        {
            TRACE0("Error: Move operation failed.\n");
            ThrowDBException(nRetCode);
        }
    }
    
    // if data found, bound fields now filled with first record
    if (nRetCode != SQL_NO_DATA_FOUND)
    {
        Fixups();
        m_bEOFSeen = m_bBOF = m_bEOF = FALSE;
        m_lCurrentRecord = 0;
        m_lRecordCount = 1;
    }
    else
    {
        // If recordset empty, set all values to NULL
        SetFieldNull(NULL);
    }
}

BOOL CDynaRecordset::SetPosUpdateInsertDelete()
{
    ASSERT_VALID(this);
    ASSERT(m_hstmt != SQL_NULL_HSTMT);
    // Can't close till all pending Async operations have completed
    ASSERT(!m_pDatabase->InWaitForDataSource());

    long lRowsAffected = 0;

    // Delete mode
    if (m_nEditMode == addnew)
    {
        if (!m_bAppendable)
            ThrowDBException(AFX_SQL_ERROR_RECORDSET_READONLY);
    }
    else
    {
        if (!m_bUpdatable)
        {
            ThrowDBException(AFX_SQL_ERROR_RECORDSET_READONLY);
        }

        // Requires currency
        if (m_bEOF || m_bBOF || m_bDeleted)
        {
            ThrowDBException(AFX_SQL_ERROR_NO_CURRENT_RECORD);
        }
    }

    // Update or AddNew is NOP w/o at least 1 changed field
    if (m_nEditMode != noMode && !IsFieldDirty(NULL))
    {
        return FALSE;
    }

    ExecuteSetPosUpdate();

    TRY
    {
        // Delete
        switch (m_nEditMode)
        {
        case noMode:
            // Decrement record count
            if (m_lCurrentRecord > 0)
            {
                if (m_lRecordCount > 0)
                    m_lRecordCount--;
                m_lCurrentRecord--;
            }

            // indicate on a deleted record
            m_bDeleted = TRUE;
            // Set all fields to NULL
            SetFieldNull(NULL);
            break;

        case addnew:
            if (m_lCurrentRecord >= 0)
            {
                if (m_lRecordCount != -1)
                    m_lRecordCount++;
                m_lCurrentRecord++;
            }
            // Fall through

        case edit:
            // Update, AddNew
            ReleaseCopyBuffer();
            break;
        }
    }
    CATCH_ALL(e)
    {
        // Fall through - must return TRUE since record updated
    }
    END_CATCH_ALL

    return TRUE;
}

// Execute the update (or delete) using SQLSetPos
void CDynaRecordset::ExecuteSetPosUpdate()
{
    UWORD wPosOption;

    if (m_nEditMode == noMode)
        wPosOption = SQL_DELETE;
    else
    {
        if (m_nEditMode == edit)
            wPosOption = SQL_UPDATE;
        else
            wPosOption = SQL_ADD;
    }

    BindFieldsForUpdate();

    RETCODE nRetCode;
    AFX_SQL_SYNC(::SQLSetPos(m_hstmt, 0, wPosOption, SQL_LOCK_NO_CHANGE));
    if (!Check(nRetCode))
    {
        TRACE0("Error: failure updating record.\n");
        AfxThrowDBException(nRetCode, m_pDatabase, m_hstmt);
    }

    // Only have data-at-execution columns for CLongBinary columns
    if (nRetCode == SQL_NEED_DATA)
        SendLongBinaryData(m_hstmt);
    
    // for positioned update only one row is expected to be affected    
    SDWORD lRowsAffected;
    AFX_SQL_SYNC(::SQLRowCount(m_hstmt, &lRowsAffected));
    if (Check(nRetCode) && lRowsAffected!=-1 && lRowsAffected!=1)
    {
#ifdef _DEBUG
            if (afxTraceFlags & 0x20)
            TRACE1("Warning: %u rows affected by update operation (expected 1).\n",
                    lRowsAffected);
#endif // _DEBUG
                ThrowDBException(lRowsAffected == 0?
                    AFX_SQL_ERROR_NO_ROWS_AFFECTED :
                    AFX_SQL_ERROR_MULTIPLE_ROWS_AFFECTED);
    }  
        
    UnbindFieldsForUpdate();
}

void CDynaRecordset::BindFieldsForUpdate()
{
    ASSERT_VALID(this);

    if (m_nEditMode == edit || m_nEditMode == addnew)
    {
        // Set a dummy operation to avoid an assert
        int nOperation = CFieldExchange::BindFieldToColumn;
        CFieldExchange fx(nOperation, this);
        
        // Now set it to "new" value
        fx.m_nOperation = BIND_FIELD_FOR_UPDATE;
        fx.m_hstmt = m_hstmt;
        DoFieldExchange(&fx);
    }
}

void CDynaRecordset::UnbindFieldsForUpdate()
{
    ASSERT_VALID(this);

    if (m_nEditMode == edit || m_nEditMode == addnew)
    {
        // Set a dummy operation to avoid an assert
        int nOperation = CFieldExchange::BindFieldToColumn;
        CFieldExchange fx(nOperation, this);

        // Now set it to "new" value
        fx.m_nOperation = UNBIND_FIELD_FOR_UPDATE;
        fx.m_hstmt = m_hstmt;
        DoFieldExchange(&fx);
    }
}

void CDynaRecordset::SendLongBinaryData(HSTMT hstmt)
{
    RETCODE nRetCode;
    void FAR* pv;
    AFX_SQL_ASYNC(this, ::SQLParamData(hstmt, &pv));
    if (!Check(nRetCode))
    {
        // cache away error
        CDBException* pException = new CDBException(nRetCode);
        pException->BuildErrorString(m_pDatabase, hstmt);

        // then cancel Execute operation
        Cancel();
        THROW(pException);
    }

    while (nRetCode == SQL_NEED_DATA)
    {
        CLongBinary* pLongBinary = (CLongBinary*)_AfxGetPtrFromFarPtr(pv);
        ASSERT_VALID(pLongBinary);

        const BYTE _huge* lpData = (const BYTE _huge*)::GlobalLock(pLongBinary->m_hData);
        ASSERT(lpData != NULL);

        DWORD dwDataLength = 0;
        while (dwDataLength != pLongBinary->m_dwDataLength)
        {
            DWORD dwSend = pLongBinary->m_dwDataLength-dwDataLength;
            if (dwSend > 0x8000)
                dwSend = 0x8000;
            AFX_SQL_ASYNC(this, ::SQLPutData(hstmt, (PTR)lpData, dwSend));
            if (!Check(nRetCode))
            {
                ::GlobalUnlock(pLongBinary->m_hData);
                // Cache away error
                CDBException* pException = new CDBException(nRetCode);
                pException->BuildErrorString(m_pDatabase, hstmt);
                // Then cancel Execute operation
                Cancel();
                THROW(pException);
            }
            lpData += dwSend;
            dwDataLength += dwSend;
        }

        // Check for another DATA_AT_EXEC
        AFX_SQL_ASYNC(this, ::SQLParamData(hstmt, &pv));
        if (!Check(nRetCode))
        {
            TRACE0("Error: failure handling long binary value during update.\n");
            ThrowDBException(nRetCode, hstmt);
        }
    }
}

