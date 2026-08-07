# This is a part of the Microsoft Foundation Classes C++ library.
# Copyright (C) 1992-1993 Microsoft Corporation
# All rights reserved.
#
# This source code is only intended as a supplement to the
# Microsoft Foundation Classes Reference and Microsoft
# QuickHelp documentation provided with the library.
# See these sources for detailed information regarding the
# Microsoft Foundation Classes product.
#
# This file defines OBJ groups for OLE controls runtime.
# They are defined separate from the makefile, so that
# this file can be included in both the local makefile,
# as well as the runtime makefile.


AFXLIB_OBJ=$D\objcore.obj $D\except.obj\
	$D\afxver.obj $D\validadd.obj $D\dumpcont.obj\
	$D\dumpflt.obj $D\arccore.obj $D\arcobj.obj\
	$D\arcex.obj $D\filecore.obj $D\filetxt.obj\
	$D\filemem.obj $D\filex.obj $D\filest.obj\
	$D\array_b.obj $D\array_d.obj $D\array_p.obj\
	$D\array_o.obj $D\array_s.obj $D\array_u.obj\
	$D\array_w.obj $D\list_o.obj  $D\list_p.obj\
	$D\list_s.obj $D\map_pp.obj $D\map_pw.obj\
	$D\map_so.obj $D\map_sp.obj $D\map_ss.obj\
	$D\map_wo.obj $D\map_wp.obj $D\plex.obj\
	$D\strcore1.obj $D\strcore2.obj $D\strex.obj\
	$D\timecore.obj $D\wincore.obj $D\winfrm.obj\
	$D\winfrmx.obj $D\winhand.obj $D\barcore.obj $D\bartool.obj\
	$D\bardlg.obj $D\dcprev.obj $D\dcmeta.obj\
	$D\trckrect.obj $D\fileshrd.obj $D\dlgcore.obj\
	$D\dlgdata.obj $D\dlgfloat.obj $D\winctrl.obj\
	$D\winbtn.obj  $D\penctrl.obj $D\dlgfile.obj\
	$D\dlgprnt.obj $D\dlgclr.obj $D\dlgfnt.obj\
	$D\dlgfr.obj $D\wingdi.obj $D\wingdix.obj\
	$D\winstr.obj $D\winmenu.obj $D\auxdata.obj\
	$D\afxtrace.obj $D\winutil.obj $D\cmdtarg.obj\
	$D\doccore.obj $D\doctempl.obj\
	$D\viewcore.obj $D\viewprnt.obj\
	$D\winsplit.obj $D\viewscrl.obj $D\viewform.obj\
	$D\viewedit.obj $D\viewprev.obj $D\appcore.obj\
	$D\appinit.obj $D\appterm.obj $D\appui.obj\
	$D\appui2.obj $D\appgray.obj $D\appdlg.obj\
	$D\appprnt.obj $D\apphelp.obj $D\apphelpx.obj\
	$D\appdata.obj $D\olelock1.obj $D\olelock2.obj\
	$D\oledata.obj $D\ctlstate.obj $D\afxmem.obj
# not $D\winmdi.obj $D\docmulti.obj $D\docsingl.obj

AFXOLE_OBJ= $D\oleinit.obj $D\olebar.obj $D\oledobj1.obj $D\oledobj2.obj\
	$D\oledisp1.obj $D\oledisp2.obj $D\oledrop1.obj $D\oledrop2.obj\
	$D\oleenum.obj $D\olefact.obj $D\olemisc.obj $D\olestrm.obj\
	$D\oleunk.obj
# not $D\olereg.obj $D\oletsvr.obj

# NonShared diagnostics and other hooks (see OBJDIAG in MAKEFILE)
DIAG_OBJ=$D\dumpinit.obj $D\afxasert.obj $D\dumpout.obj $D\oledll.obj\
	$D\afxabort.obj

# get explicitly-compiled inline functions only if debug build

!if "$(DEBUG)" == "1"
INLINES=$D\afxinl1.obj $D\afxinl2.obj $D\afxinl3.obj
!else
INLINES=
!endif

# OLEASM is defined in MAKEFILE, it contains the dependency for OLECALLF.OBJ

AFXCONTROL_OBJ=$(AFXLIB_OBJ) $(AFXOLE_OBJ) $(OLEASM) $(INLINES)\
	$(DIAG_OBJ) $D\dllctl.obj
