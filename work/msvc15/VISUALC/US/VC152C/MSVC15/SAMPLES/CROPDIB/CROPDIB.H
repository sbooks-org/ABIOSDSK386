/* CropDIB.h
 */
#include "resource.h"


/* macros */
#define MB_ERROR        (MB_ICONEXCLAMATION | MB_OK)
#define Error(hwnd, idsFmt)                                     \
        ( ErrMsg(hwnd, (idsFmt)), FALSE )
#define Error1(hwnd, idsFmt, arg1)                              \
        ( ErrMsg(hwnd, (idsFmt), (arg1)), FALSE )
#define Error2(hwnd, idsFmt, arg1, arg2)                        \
        ( ErrMsg(hwnd, (idsFmt), (arg1), (arg2)), FALSE )
