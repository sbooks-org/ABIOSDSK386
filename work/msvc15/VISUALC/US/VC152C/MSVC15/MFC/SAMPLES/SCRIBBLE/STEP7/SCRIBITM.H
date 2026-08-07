// scribitm.h : Prototypes for the CScribItem class.
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

/////////////////////////////////////////////////////////////////////////////
// CScribbleEmbeddedItem

class CScribItem : public COleServerItem
{
	DECLARE_DYNAMIC(CScribItem)

// Constructors
public:
	CScribItem(CScribDoc* pContainerDoc);

// Attributes
	CScribDoc* GetDocument() const
		{ return (CScribDoc*)COleServerItem::GetDocument(); }

// Implementation
public:
	~CScribItem();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif
   virtual BOOL OnDraw(CDC* pDC, CSize& rSize);
	virtual BOOL OnGetExtent(DVASPECT dwDrawAspect, CSize& rSize);

protected:
	virtual void Serialize(CArchive& ar);   // overridden for document i/o
};
