/* 
 * GETTIME.C
 * Gets time efficiently from the system.
 */
 
#include <windows.h>
#include <ddeml.h> 
#include <string.h>
#include "wrapper.h" 
#include "ddemlclk.h"

#pragma warning(disable:4704)

void GetTime(TIME * pTime) {
	__asm { 
        mov     ax, 2c00h          		; get time
        int     21h
        mov     bx, pTime
        cmp     ch, 12                  ; if hour <12
        jl      lt12                    ; we're ok
        sub     ch,12                   ; else adjust it
lt12:
        xor     ax,ax
        mov     al,ch
        mov     [bx].hour, ax
        mov     al,cl
        mov     [bx].minute, ax
        mov     al,dh
        mov     [bx].second, ax 
        }
	}  
	
void SetTime(TIME * pTime ) {
	__asm {
        mov     bx, pTime
        mov     ax, [bx].hour
        mov     ch, al
        mov     ax, [bx].minute
        mov     cl, al
        mov     ax, [bx].second
        mov     dh, al
        mov     ax, 2d00h           ; set time
        mov     dl, al
        int     21h	      
        }
	}        