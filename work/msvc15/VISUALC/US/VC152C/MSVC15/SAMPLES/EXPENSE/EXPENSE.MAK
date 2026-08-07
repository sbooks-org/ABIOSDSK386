# Microsoft Visual C++ generated build script - Do not modify

PROJ = EXPENSE
DEBUG = 1
PROGTYPE = 0
CALLER = 
ARGS = 
DLLS = 
D_RCDEFINES = 
R_RCDEFINES = 
ORIGIN = MSVC
ORIGIN_VER =1.00
PROJPATH =UNKNOWN
USEMFC = 0
CC = cl
CPP = cl
CXX = cl
CCREATEPCHFLAG = 
CPPCREATEPCHFLAG = 
CUSEPCHFLAG = 
CPPUSEPCHFLAG = 
FIRSTC = EXPENSE.C   
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /Zp1 /W3 /AM /Od /D "_DEBUG" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /Zp1 /W3 /AM /Ox /D "NDEBUG" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO  /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE /CO 
LFLAGS_R_WEXE =/NOLOGO  /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE 
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew libw 
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew libw 
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  /t 
RUNFLAGS = 
DEFFILE = EXPENSE.DEF
OBJS_EXT = 
LIBS_EXT = CUSTDICT.LIB 
!if "$(DEBUG)" == "1"
CFLAGS = $(CFLAGS_D_WEXE)
LFLAGS = $(LFLAGS_D_WEXE)
LIBS = $(LIBS_D_WEXE)
MAPFILE = nul
RCDEFINES = $(D_RCDEFINES)
!else
CFLAGS = $(CFLAGS_R_WEXE)
LFLAGS = $(LFLAGS_R_WEXE)
LIBS = $(LIBS_R_WEXE)
MAPFILE = nul
RCDEFINES = $(R_RCDEFINES)
!endif
!if [if exist MSVC.BND del MSVC.BND]
!endif
SBRS = EXPENSE.SBR


CUSTDICT_DEP = 

EXPENSE_DEP = expres.h \
	expense.h


EXPENSE_RCDEP = expres.h \
	expense.ico


all:	$(PROJ).EXE $(PROJ).BSC

EXPENSE.OBJ:	EXPENSE.C $(EXPENSE_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c EXPENSE.C

EXPENSE.RES:	EXPENSE.RC $(EXPENSE_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r EXPENSE.RC


$(PROJ).EXE::	EXPENSE.RES

$(PROJ).EXE::	EXPENSE.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
EXPENSE.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
CUSTDICT.LIB+
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) EXPENSE.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	EXPENSE.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) EXPENSE.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
