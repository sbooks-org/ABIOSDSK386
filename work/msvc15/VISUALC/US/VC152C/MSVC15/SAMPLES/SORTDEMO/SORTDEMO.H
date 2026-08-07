// sortdemo.h : Declares the class interfaces for the Sort Demo frame window.
//

#ifndef __SORTDEMO_H__
#define __SORTDEMO_H__

#define NUMBARS 45

typedef struct _COLOR
{
    short nBlue;
    short nGreen;
    short nRed;
} COLOR;

typedef struct _BAR
{
    char len;
    COLOR clr;
} BAR;

typedef struct _TIMESTRUCT
{   float   time;
    int swaps;
    int compares;
    BOOL    done;
}TIMESTRUCT;


/////////////////////////////////////////////////////////////////////////////
// function prototypes

int PASCAL WinMain(HANDLE, HANDLE, LPSTR, int);
BOOL InitApplication(HANDLE);
BOOL InitInstance(HANDLE, int);
long FAR PASCAL __export MainWndProc(HWND, UINT, UINT, LONG);
BOOL FAR PASCAL __export About(HWND, unsigned, WORD, LONG);
BOOL FAR PASCAL __export Stats(HWND, unsigned, WORD, LONG);
BOOL FAR PASCAL __export Pause(HWND, unsigned, WORD, LONG);

void RenderBars(HWND hWnd);
void DrawBarChart();
void DrawTime();
void Sleep( clock_t wait );
void Beep( int frequency, int duration );
void DrawBar( int Row );
void InitBars( void  );             // Bar functions
void Swaps( BAR *one, BAR *two );
void SwapBars( int iRow1, int iRow2 );
void InsertionSort( void );
void BubbleSort( void  );
void HeapSort( void  );
void PercolateUp( int iMaxLevel );
void PercolateDown( int iMaxLevel );
void ExchangeSort( void  );
void ShellSort( void  );
void QuickSort( int iLow, int iHigh );
COLOR SetNewColors();
void InitStats(TIMESTRUCT *tm);
void InitPrevRandom(HWND hWnd);
void InitSort(HWND hWnd);
void EndSort(HWND hWnd);


#define GetRandom( min, max ) ((rand() % (int)(((max) + 1) - (min))) + (min))

/////////////////////////////////////////////////////////////////////////////

#endif // __SORTDEMO_H__
