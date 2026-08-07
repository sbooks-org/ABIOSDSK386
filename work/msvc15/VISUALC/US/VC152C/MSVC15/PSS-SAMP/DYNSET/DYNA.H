// dyna.h
//
//////////////////////////////////////////////////////////////////////////////

#ifndef _DYNA_H
#define _DYNA_H

// RFX operation types
#define BIND_FIELD_FOR_UPDATE   0xFE    // Value not likely to conflict
#define UNBIND_FIELD_FOR_UPDATE 0xFF    // Value not likely to conflict

// New error for SQLSetPos update failures
#define SQL_ERROR_UPDATE_DELETE_FAILED AFX_SQL_ERROR_MAX + 1

/////////////////////////////////////////////////////////////////////////////
// CDynaRecordView

class CDynaRecordView : public CRecordView
{
    DECLARE_DYNAMIC(CDynaRecordView)
// Construction
protected:  // must derive your own class
    CDynaRecordView(LPCSTR lpszTemplateName);
    CDynaRecordView(UINT nIDTemplate);

// Attributes
public:

// Operations
public:
    virtual void OnInitialUpdate();
    virtual BOOL OnMove(UINT nIDMoveCommand);

// Implementation
public:
};
/////////////////////////////////////////////////////////////////////////////
// DynaRecordset Field Exchange routines

void DynaRfxDefault(CFieldExchange* pFX, CRecordset* prs,
    LONG* plLength, UINT cbValue);

// text data
void AFXAPI Dyna_RFX_Text(CFieldExchange* pFX, const char *szName,
    CString& value, int nMaxLength = 255, int nColumnType = SQL_VARCHAR);

// boolean data
void AFXAPI Dyna_RFX_Bool(CFieldExchange* pFX, const char *szName,
    BOOL& value);

// integer data
void AFXAPI Dyna_RFX_Long(CFieldExchange* pFX, const char *szName,
    long& value);
void AFXAPI Dyna_RFX_Int(CFieldExchange* pFX, const char *szName,
    int& value);
void AFXAPI Dyna_RFX_Single(CFieldExchange* pFX, const char *szName,
    float& value);
void AFXAPI Dyna_RFX_Double(CFieldExchange* pFX, const char *szName,
    double& value);

// date and time
void AFXAPI Dyna_RFX_Date(CFieldExchange* pFX, const char *szName,
    CTime& value);

// Binary data
void AFXAPI Dyna_RFX_Binary(CFieldExchange* pFX, const char *szName,
    CByteArray& value, int nMaxLength = 255);
void AFXAPI Dyna_RFX_Byte(CFieldExchange* pFX, const char *szName,
    BYTE& value);
void AFXAPI Dyna_RFX_LongBinary(CFieldExchange* pFX, const char *szName,
    CLongBinary& value);

//////////////////////////////////////////////////////////////////////////////
// CDynaDatabase

class CDynaDatabase : public CDatabase
{
    DECLARE_DYNAMIC(CDynaDatabase)

// Constructors
public:
    CDynaDatabase();

// Overridables
public: 
    virtual BOOL Open(LPCSTR lpszDSN, BOOL bExclusive = FALSE,
        BOOL bReadonly = FALSE, LPCSTR lpszConnect = "ODBC;",
        BOOL bUseCursorLib = TRUE);
};

class CDynaRecordset : public CRecordset
{
DECLARE_DYNAMIC(CDynaRecordset)

// Constructors
public:
    CDynaRecordset(CDatabase* pDatabase = NULL);

// Overridables
public:
    virtual BOOL Open(UINT nOpenType = snapshot, LPCSTR lpszSQL = NULL,
        DWORD dwOptions = none);

    virtual void OnSetOptions(HSTMT hstmt);
    virtual void Move(long lRows);
    virtual void Delete();
    virtual BOOL Update();
    virtual BOOL Requery();
    
// Attributes
public:
    BOOL m_bUseUpdateSQL;
    BOOL m_bLongBinaryColumns;        
    DWORD m_dwDriverPositionedStatements;
    DWORD m_dwDriverConcurrency;
    DWORD m_dwConcurrency;
    
    WORD m_wRowStatus;
    
// Implementation
public:
    void InitRecordMoveFirst();
    BOOL SetPosUpdateInsertDelete();
    void BindFieldsForUpdate();
    void UnbindFieldsForUpdate();
    void ExecuteSetPosUpdate();
    void SendLongBinaryData(HSTMT hstmt);

    int GetEditMode();
    
    enum EditMode
    {
        noMode,
        edit,
        addnew
    };
};

#endif  // _DYNA_H
