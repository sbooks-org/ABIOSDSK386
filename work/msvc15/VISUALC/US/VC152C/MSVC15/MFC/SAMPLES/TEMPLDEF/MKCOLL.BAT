echo "Building all collection shapes"

rem - copy prefix files
copy afxcoll1.h newcoll.h
copy afxcoll1.inl newcoll.inl

REM ////////////////////////////////////////////////////////////////////////
REM -- Arrays

templdef "CArray<BYTE,BYTE,1,0> CByteArray" array.ctt temp.h temp.inl array_b.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

templdef "CArray<WORD,WORD,1,0> CWordArray" array.ctt temp.h temp.inl array_w.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

templdef "CArray<DWORD,DWORD,1,0> CDWordArray" array.ctt temp.h temp.inl array_d.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

templdef "CArray<UINT,UINT,0,0> CUIntArray" array.ctt temp.h temp.inl array_u.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

templdef "CArray<void*,void*,0,0> CPtrArray" array.ctt temp.h temp.inl array_p.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

templdef "CArray<CObject*,CObject*,1,0> CObArray" array.ctt temp.h temp.inl array_o.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

REM -- String Arrays require special support
templdef "CArray<CString,const char*,1,1> CStringArray" array.ctt temp.h temp.inl array_s.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

REM ////////////////////////////////////////////////////////////////////////
REM -- Lists
templdef "CList<void*,void*,0,0> CPtrList" list.ctt temp.h temp.inl list_p.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

templdef "CList<CObject*,CObject*,1,0> CObList" list.ctt temp.h temp.inl list_o.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

REM -- String Lists require special support
templdef "CList<CString,const char*,1,1> CStringList" list.ctt temp.h temp.inl list_s.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

REM ////////////////////////////////////////////////////////////////////////
REM -- Maps

templdef "CMap<WORD,WORD,void*,void*,0,0> CMapWordToPtr" map.ctt temp.h temp.inl map_wp.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

templdef "CMap<void*,void*,WORD,WORD,0,0> CMapPtrToWord" map.ctt temp.h temp.inl map_pw.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

templdef "CMap<void*,void*,void*,void*,0,0> CMapPtrToPtr" map.ctt temp.h temp.inl map_pp.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

templdef "CMap<WORD,WORD,CObject*,CObject*,1,0> CMapWordToOb" map.ctt temp.h temp.inl map_wo.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

REM ////////////////////////////////////////////////////////////////////////
REM -- Maps from Strings
templdef "CMapStringTo<void*,void*,0,0> CMapStringToPtr" map_s.ctt temp.h temp.inl map_sp.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

templdef "CMapStringTo<CObject*,CObject*,1,0> CMapStringToOb" map_s.ctt temp.h temp.inl map_so.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

templdef "CMapStringTo<CString,const char*,1,1> CMapStringToString" map_s.ctt temp.h temp.inl map_ss.cpp
copy newcoll.h+temp.h newcoll.h
copy newcoll.inl+temp.inl newcoll.inl

REM ////////////////////////////////////////////////////////////////////////
REM - Wrap up/Clean up

rem - append suffix files
copy newcoll.h+afxcoll2.h newcoll.h
copy newcoll.inl+afxcoll2.inl newcoll.inl

erase temp.h
erase temp.inl
