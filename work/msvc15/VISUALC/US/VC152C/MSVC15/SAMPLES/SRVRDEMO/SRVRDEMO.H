/*
  OLE SERVER DEMO
  SrvrDemo.h

  This file contains typedefs, defines, global variable declarations, and
  function prototypes.

  (c) Copyright Microsoft Corp. 1990 - 1992 All Rights Reserved
*/


/*
   Explanation of Function Comments.

   Every function has a comment preceding it which gives the following
   information:

   1) Function name.
   2) A description of what the function does.
   3) A list of parameters, each with its type and a short description.
   4) A list of return values, each with an explanation of the condition that
      will cause the function to return that value.
   5) A customization section giving tips on how to customize this function
      for your OLE application.
      If the customization section says "None" then you may find the function
      usable as is.
      If the customization section says "Re-implement" then the function
      should still serve the same purpose and do what is indicated in the
      function comment, but will probably need to be re-implemented for
      your particular application.  Any Server Demo code relating to OLE
      will be useful as a guide in your re-implementation.
      If the customization section says "Server Demo specific" then the
      function will probably have no counterpart in your application.
*/
#include "resource.h"


#define OBJECT_WIDTH        120
#define OBJECT_HEIGHT       60

// number HIMETRIC units per inch
#define  HIMETRIC_PER_INCH  2540

/* Types */

// Document type

typedef enum
{
    doctypeNew,      // The document is untitled.
    doctypeFromFile, // The document exists in a file and may be linked.
    doctypeEmbedded, // The document is an embedded document.
} DOCTYPE;


// Device context type, passed to DrawObj.

typedef enum
{
   dctypeScreen,
   dctypeBitmap,
   dctypeMetafile
} DCTYPE ;


// Version

typedef int VERSION;


// Verb

typedef enum
{
   verbPlay = OLEVERB_PRIMARY,
   verbEdit
} VERB;


// Server structure

typedef struct
{
    OLESERVER     olesrvr;        // This must be the first field so that
                                  //   an LPOLESERVER can be cast to a SRVR*.
    LHSERVER      lhsrvr;         // Registration handle
} SRVR ;


// How many objects (distinct numbers) will we allow?
#define cfObjNums 20

// How many distinct clients can be associated with the object?
#define clpoleclient 20


// Document structure

typedef struct
{
    OLESERVERDOC oledoc;      // This must be the first field so that an
                              //   LPOLESERVERDOC can be cast to an DOC*.
    LHSERVERDOC  lhdoc;       // Registration handle
    DOCTYPE      doctype;     // Document type
    ATOM         aName;       // Document name
    HPALETTE     hpal;        // Handle to a logical color palette
    BYTE         rgfObjNums[cfObjNums+1]; // What object numbers have been used
} DOC, FAR *DOCPTR ;


// Native data structure

typedef struct
{
    int         idmColor;
    int         nWidth;
    int         nHeight;
    int         nX;
    int         nY;
    int         nHiMetricWidth;  // Used by an object handler.  These two fields
    int         nHiMetricHeight; // always correspond to nWidth and nHeight.
    VERSION     version;
    char        szName[10];      // "Object nn"
} NATIVE, FAR *LPNATIVE;


// Object structure

/* Ordinarily, an OBJ structure would not contain native data.  Rather, it
   would contain a pointer (or some other reference) to the native data.
   This method would allow multiple objects containing the same native data.
   Each OBJ structure would be created on the fly when some portion of the
   document was to be made into an object.  Each OBJ structure would have
   only one LPOLECLIENT, which would be passed in to DocGetObject.
*/

typedef struct
{
    OLEOBJECT   oleobject;   // This must be the first field so that an
                             //   LPOLEOBJECT can be cast to a LPOBJ.
    HANDLE      hObj;        // A circular handle to this structure,
                             //   used to delete this structure.
    LPOLECLIENT lpoleclient[clpoleclient];
                             // Clients associated with the object.
                             //   The array is NULL terminated.
    HWND        hwnd;        // The object's own window
    ATOM        aName;       // Unique identifier for each object within a doc
    HPALETTE    hpal;        // Logical palette to use in drawing object
    NATIVE      native;      // Object data in native format
} OBJ, FAR *LPOBJ ;



/* Defines */

// The name of the application, used in message boxes and title bars.
#define szAppName        "Server Demo"

// THe class name in the registration database.
#define szClassName      "ServerDemo"

// Used to check for "-Embedding" on command line.
#define szEmbeddingFlag  "Embedding"

// Maximum length of a fully-qualified pathname.
#define cchFilenameMax   256

// Maximum number of HBRUSHes.
#define chbrMax          9

// Number of extra bytes in the window structure for an object
#define cbWindExtra 4

// Offset (in the extra space) of the pointer to the object
#define ibLpobj          0



/* Global variable declarations.  (See SrvrDemo.c for descriptions.) */

extern HANDLE           hInst;
extern HWND             hwndMain;
extern SRVR             srvrMain;
extern DOC              docMain;
extern BOOL             fDocChanged;
extern BOOL             fEmbedding;
extern BOOL             fRevokeSrvrOnSrvrRelease;
extern BOOL             fWaitingForDocRelease;
extern BOOL             fWaitingForSrvrRelease;
extern BOOL             fUnblock;
extern char             szClient[];
extern char             szClientDoc[];
extern HBRUSH           hbrColor[chbrMax];
extern VERSION          version;
extern OLECLIPFORMAT    cfObjectLink;
extern OLECLIPFORMAT    cfOwnerLink;
extern OLECLIPFORMAT    cfNative;
extern OLESERVERDOCVTBL docvtbl;
extern OLEOBJECTVTBL    objvtbl;
extern OLESERVERVTBL    srvrvtbl;



/* Function Prototypes */

// Various functions

BOOL  CreateDocFromFile (LPSTR lpszDoc, LHSERVERDOC lhdoc, DOCTYPE doctype);
BOOL  CreateNewDoc (LONG lhdoc, LPSTR lpszDoc, DOCTYPE doctype);
LPOBJ CreateNewObj (BOOL fDoc_Changed);
void  CutOrCopyObj (BOOL fOpIsCopy);
void  DestroyDoc (void);
void  DestroyObj (HWND hwnd);
void  DeviceToHiMetric (HWND hwnd, LPPOINT lppt);
void  EmbeddingModeOff (void) ;
void  EmbeddingModeOn (void);
void  UpdateFileMenu (int);
void  ErrorBox (char *jwf);
void  FreeVTbls (void);
BOOL  GetFileOpenFilename (LPSTR lpszFilename);
BOOL  GetFileSaveFilename (LPSTR lpszFilename);
void  HiMetricToDevice (HWND hwnd, LPPOINT lppt);
LPOBJ HwndToLpobj (HWND hwndObj);
BOOL  InitServer (HWND hwnd, HANDLE hInst);
void  InitVTbls (void);
BOOL  OpenDoc (void);
void  PaintObj (HWND hwnd);
OLESTATUS RevokeDoc (void);
void  RevokeObj (LPOBJ lpobj);
int   SaveChangesOption (BOOL *pfUpdateLater);
BOOL  SaveDoc (void);
BOOL  SaveDocAs (void);
void  SavedServerDoc (void);
LPOBJ SelectedObject (void);
HWND  SelectedObjectWindow (void);
void  SendDocMsg (WORD wMessage );
void  SendObjMsg (LPOBJ lpobj, WORD wMessage);
void  SetTitle (LPSTR lpszDoc, BOOL bEmbedded);
void  SetHiMetricFields (LPOBJ lpobj);
void  SizeClientArea (HWND hwndMain, RECT rectReq, BOOL fFrame);
void  SizeObj (HWND hwnd, RECT rect, BOOL fMove);
OLESTATUS StartRevokingServer (void);
void  Wait (BOOL *pf);
LPSTR Abbrev (LPSTR lpsz);
BOOL FAR PASCAL __export fnFailedUpdate (HWND, WORD, WORD, DWORD);
int PASCAL WinMain
   (HANDLE  hInstance, HANDLE hPrevInstance, LPSTR lpCmdLine, int nCmdShow);

// Window handlers

BOOL FAR PASCAL __export About       (HWND, unsigned, WORD, LONG);
long FAR PASCAL __export MainWndProc (HWND, UINT, WPARAM, LPARAM);
long FAR PASCAL __export ObjWndProc  (HWND, UINT, WPARAM, LPARAM);


// Server methods

OLESTATUS FAR PASCAL __export SrvrCreate (LPOLESERVER, LHSERVERDOC, LPSTR, LPSTR, LPOLESERVERDOC FAR *);
OLESTATUS FAR PASCAL __export SrvrCreateFromTemplate (LPOLESERVER, LHSERVERDOC, LPSTR, LPSTR, LPSTR, LPOLESERVERDOC FAR *);
OLESTATUS FAR PASCAL __export SrvrEdit (LPOLESERVER, LHSERVERDOC, LPSTR, LPSTR, LPOLESERVERDOC FAR * );
OLESTATUS FAR PASCAL __export SrvrExecute (LPOLESERVER, HANDLE);
OLESTATUS FAR PASCAL __export SrvrExit (LPOLESERVER);
OLESTATUS FAR PASCAL __export SrvrOpen (LPOLESERVER, LHSERVERDOC, LPSTR, LPOLESERVERDOC FAR *);
OLESTATUS FAR PASCAL __export SrvrRelease (LPOLESERVER);

// Document methods

OLESTATUS FAR PASCAL __export DocClose (LPOLESERVERDOC);
OLESTATUS FAR PASCAL __export DocExecute (LPOLESERVERDOC, HANDLE);
OLESTATUS FAR PASCAL __export DocGetObject (LPOLESERVERDOC, LPSTR, LPOLEOBJECT FAR *, LPOLECLIENT);
OLESTATUS FAR PASCAL __export DocRelease (LPOLESERVERDOC);
OLESTATUS FAR PASCAL __export DocSave (LPOLESERVERDOC);
OLESTATUS FAR PASCAL __export DocSetColorScheme (LPOLESERVERDOC, LPLOGPALETTE);
OLESTATUS FAR PASCAL __export DocSetDocDimensions (LPOLESERVERDOC, LPRECT);
OLESTATUS FAR PASCAL __export DocSetHostNames (LPOLESERVERDOC, LPSTR, LPSTR);

// Object methods

OLESTATUS FAR PASCAL __export ObjDoVerb (LPOLEOBJECT, WORD, BOOL, BOOL);
OLESTATUS FAR PASCAL __export ObjGetData (LPOLEOBJECT, OLECLIPFORMAT, LPHANDLE);
LPVOID    FAR PASCAL __export ObjQueryProtocol (LPOLEOBJECT, LPSTR);
OLESTATUS FAR PASCAL __export ObjRelease (LPOLEOBJECT);
OLESTATUS FAR PASCAL __export ObjSetBounds (LPOLEOBJECT, LPRECT);
OLESTATUS FAR PASCAL __export ObjSetColorScheme (LPOLEOBJECT, LPLOGPALETTE);
OLESTATUS FAR PASCAL __export ObjSetData (LPOLEOBJECT, OLECLIPFORMAT, HANDLE);
OLESTATUS FAR PASCAL __export ObjSetTargetDevice (LPOLEOBJECT, HANDLE);
OLESTATUS FAR PASCAL __export ObjShow (LPOLEOBJECT, BOOL);
OLECLIPFORMAT FAR PASCAL __export ObjEnumFormats (LPOLEOBJECT, OLECLIPFORMAT);
