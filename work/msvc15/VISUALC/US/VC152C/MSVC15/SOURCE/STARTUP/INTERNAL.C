/***
*internal.h - contains declarations of internal routines and variables
*
*	Copyright (c) 1985-1992, Microsoft Corporation. All rights reserved.
*
*Purpose:
*	Declares routines and variables used internally by the C run-time.
*	These variables are declared "near" for efficiency.
*	[Internal]
*
****/

#ifdef __cplusplus
extern "C" {
#endif

/* no _FAR_ in internal builds */		/* _FAR_DEFINED */
#undef _FAR_					/* _FAR_DEFINED */
#define _FAR_					/* _FAR_DEFINED */

#define _LOAD_DS		/* _LOAD_DGROUP */
				/* _LOAD_DGROUP */
#define _NEAR_ __near
#define _PASCAL_ __pascal

#if (_MSC_VER <= 600)
#define __cdecl     _cdecl
#define __far       _far
#define __near      _near
#define __pascal    _pascal
#endif

/* conditionally define macro for Windows DLL libs */
#ifdef	_WINDLL
#define _WINSTATIC	static
#else
#define _WINSTATIC
#endif

extern char __near _commode;	/* default file commit mode */

extern int __near _nfile;	/* # of OS file handles */
#ifdef _QWIN
extern int __near _wfile;	/* # of QWIN file handles */
extern int __near _wnfile;	/* total # of file handles */
#endif

extern char __near _osfile[];

extern char __near __dnames[];
extern char __near __mnames[];

extern int __near _days[];
extern int __near _lpdays[];

#ifdef _QWIN
extern int __near _qwinused;	  /* QWIN system in use flag */
#endif

/*
#ifdef	_WINDOWS
#ifdef _WINDLL
extern unsigned int _hModule;
extern unsigned int _wDataSeg;
extern unsigned int _wHeapSize;
extern char __far * _lpszCmdLine;
#else
extern unsigned int _hInstance;
extern unsigned int _hPrevInstance;
extern char __far * _lpszCmdLine;
extern int _cmdShow;
#endif
#endif
*/

#ifndef _TIME_T_DEFINED
typedef long	time_t;		/* time value */
#define _TIME_T_DEFINED 	/* avoid multiple def's of time_t */
#endif

extern time_t _dostotime_t(int, int, int, int, int, int);

#ifdef _TM_DEFINED
extern int _isindst(struct tm *);
#endif

extern void __tzset(void);

/**
** This variable is in the C start-up; the length must be kept synchronized
