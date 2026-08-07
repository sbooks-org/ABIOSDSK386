/****************************************************************************

    PROGRAM: Sortdemo.c

    PURPOSE: Demonstrates several sorting algorithms in a Windows-hosted
             application.

    FUNCTIONS:

    WinMain() - calls initialization function, processes message loop
    InitApplication() - initializes window data and registers window
    InitInstance() - saves instance handle and creates main window
    MainWndProc() - processes messages
    InitStats() -  initializes statistics for Stats dialog box
    InitPrevRandom() - initializes array and display to last randomized values
    InitSort() - initializes sort and statistics and gets a device content
    EndSort() - releases the device context and sets the cursor to an arrow
    SetNewColors() - sets a new color that's different from the previous bar
    DrawBar() -  erases a bar and draws a new bar in its place
    DrawTime() - paints the statistics on the window during the sort
    Swaps() -  exchanges two bar structures
    SwapBars() - draws the two swapped bars and the statistics
    Sleep() - pauses for a specified number of microseconds
    Beep() - sounds the speaker at a frequency for a duration
    InitBars() - initializes a random set of bars
    InsertionSort() - performs an insertion sort on abarWork
    BubbleSort() - performs a bubble sort on abarWork
    HeapSort() - performs a heap sort on abarWork
    PercolateUp() - converts elements into a reverse heap
    PercolateDown() - converts reverse heap into a sorted heap
    ExchangeSort() - performs an exchange sort on abarWork
    ShellSort() - performs a shell sort on abarWork
    QuickSort() -  performs a quick sort on abarWork
    About() - processes messages for "About" dialog box
    Stats() - processes messages for the "Statistics" dialog box
    Pause() - processes messages for the "Pause" dialog box


****************************************************************************/

#include "windows.h"
#include <time.h>
#include <string.h>
#include <conio.h>
#include <math.h>
#include <malloc.h>
#include <stdlib.h>
#include <stdio.h>

#include "sortdemo.h"
#include "resource.h"

///////////////////////////////////////////////////////////////////////
// Global variables
///////////////////

short cxClient, cyClient;
int fTallest;
BOOL sound = FALSE;
BOOL NewRandom = TRUE;
clock_t clStart, clFinish;
clock_t clPause = 30L; //  determines speed of swaps
float fTime;
HCURSOR hCross, hArrow, hHour;
HDC TempDC = NULL;
int nBar=NUMBARS, iSwaps, iCompares, nCurrentColor;
BAR abarWork[NUMBARS], abarPerm[NUMBARS], abarTemp[NUMBARS];

TIMESTRUCT Insertion = { (float)0.0, 0, 0, FALSE };
TIMESTRUCT Bubble = { (float)0.0, 0, 0, FALSE };
TIMESTRUCT Heap = { (float)0.0, 0, 0, FALSE };
TIMESTRUCT Exchange = { (float)0.0, 0, 0, FALSE };
TIMESTRUCT Shell = { (float)0.0 , 0, 0, FALSE };
TIMESTRUCT Quick = { (float)0.0, 0, 0, FALSE };
RECT rectPage = {0, 1000, 1000, 0};
RECT rectData = {50, 50, 950, 850};

HANDLE hInst;

/****************************************************************************

    FUNCTION: WinMain(HANDLE, HANDLE, LPSTR, int)

    PURPOSE: calls initialization function, processes message loop

****************************************************************************/

int PASCAL WinMain(HANDLE hInstance, HANDLE hPrevInstance, 
                    LPSTR lpCmdLine, int nCmdShow)

{
    MSG msg;

    if (!hPrevInstance)
    if (!InitApplication(hInstance))
        return (FALSE);

    if (!InitInstance(hInstance, nCmdShow))
        return (FALSE);

    while (GetMessage(&msg, NULL, NULL, NULL)) {
    TranslateMessage(&msg);
    DispatchMessage(&msg);
    }
    return (msg.wParam);
}


/****************************************************************************

    FUNCTION: InitApplication(HANDLE)

    PURPOSE: Initializes window data and registers window class

****************************************************************************/

BOOL InitApplication(HANDLE hInstance)

{
    WNDCLASS  wc;

    wc.style = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc = MainWndProc;
    wc.cbClsExtra = 0;
    wc.cbWndExtra = 0;
    wc.hInstance = hInstance;
    wc.hIcon = LoadIcon(hInstance, "sort");
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = GetStockObject(WHITE_BRUSH);
    wc.lpszMenuName =  "MainMenu";
    wc.lpszClassName = "SortDemoClass";

    return (RegisterClass(&wc));
}


/****************************************************************************

    FUNCTION:  InitInstance(HANDLE, int)

    PURPOSE:  Saves instance handle and creates main window

****************************************************************************/

BOOL InitInstance(HANDLE hInstance, int nCmdShow)

{
    HWND            hWnd;

    hInst = hInstance;

    hWnd = CreateWindow(
        "SortDemoClass",
        "SortDemo Sample Application",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        NULL,
        NULL,
        hInstance,
        NULL
    );

    if (!hWnd)
        return (FALSE);

    ShowWindow(hWnd, nCmdShow);
    UpdateWindow(hWnd);
    return (TRUE);

}

/****************************************************************************

    FUNCTION: MainWndProc(HWND, UINT, UINT, LONG)

    PURPOSE:  Processes messages

    MESSAGES:

    WM_COMMAND    - application menu
    WM_CREATE     - create window and objects
    WM_PAINT      - update window, draw objects
    WM_DESTROY    - destroy window


****************************************************************************/

long FAR PASCAL __export MainWndProc(HWND hWnd,UINT message, UINT wParam, 
                                                    LONG lParam)

{
    FARPROC lpProcAbout;
    FARPROC lpProcStats;
    FARPROC lpProcPause;
    HMENU menu;

    switch (message) {
    case WM_COMMAND: {
        switch(wParam) {

            case IDM_EXIT:
                DestroyWindow(hWnd);
                return 0;

            case IDM_INSERT:
                InitSort(hWnd);
                InsertionSort();
                EndSort(hWnd);
                InitStats(&Insertion);
                return 0;

            case IDM_BUBBLE:
                InitSort(hWnd);
                BubbleSort();
                EndSort(hWnd);
                InitStats(&Bubble);
                return 0;

            case IDM_HEAP:
                InitSort(hWnd);
                HeapSort();
                EndSort(hWnd);
                InitStats(&Heap);
                return 0;

            case IDM_EXCHANGE:
                InitSort(hWnd);
                ExchangeSort();
                EndSort(hWnd);
                InitStats(&Exchange);
                return 0;

            case IDM_SHELL:
                InitSort(hWnd);
                ShellSort();
                EndSort(hWnd);
                InitStats(&Shell);
                return 0;

            case IDM_QUICK:
                InitSort(hWnd);
                QuickSort(0, nBar-1);
                EndSort(hWnd);
                InitStats(&Quick);
                return 0;

            case IDM_RAND: // initialize random numbers into abarPerm array
                InitBars();
                Insertion.done=FALSE;
                Bubble.done = FALSE;
                Heap.done = FALSE;
                Exchange.done = FALSE;
                Shell.done = FALSE;
                Quick.done = FALSE;
                NewRandom = TRUE;   // set new random flag so first sort after randomize
                                    // will use new random data

                InvalidateRect(hWnd, NULL, TRUE);
                return 0;

            case IDM_SOUND:
                sound = !sound;
                // check or uncheck menu
                menu = GetMenu(hWnd);
                sound?   CheckMenuItem(menu, IDM_SOUND, MF_CHECKED)
                        :CheckMenuItem(menu, IDM_SOUND, MF_UNCHECKED);
                return 0;

            case IDM_STATS:
                lpProcStats = MakeProcInstance(Stats, hInst);
                DialogBox(hInst,"Stats", hWnd, lpProcStats);
                FreeProcInstance(lpProcStats);
                return 0;

            case IDM_PAUSE:
                lpProcPause = MakeProcInstance(Pause, hInst);
                DialogBox(hInst,"Pause", hWnd,lpProcPause);
                FreeProcInstance(lpProcStats);
                return 0;

            case IDM_ABOUT:
                lpProcAbout = MakeProcInstance(About, hInst);
                DialogBox(hInst, "AboutBox", hWnd, lpProcAbout);
                FreeProcInstance(lpProcAbout);
                return 0;

            default:
                return (DefWindowProc(hWnd, message, wParam, lParam));
        } //switch wParam
    } // Case WM_COMMAND
    case WM_CREATE:
        hArrow = LoadCursor(NULL, IDC_ARROW);
        hHour = LoadCursor(NULL, IDC_WAIT);
        InitBars();
        return 0;

    case WM_PAINT:{
        RenderBars(hWnd);
        return 0;
    }

    case WM_DESTROY:
        PostQuitMessage(0);
        return 0;

    default:
        return (DefWindowProc(hWnd, message, wParam, lParam));
    }
    return 0;
}

//RenderBars: paints the randomized sort bars on the window
void RenderBars(HWND hWnd)
{
    HDC hDC;                          /* display-context variable  */
    PAINTSTRUCT ps;                   /* paint structure           */
    float flFraction;
    short nWidth, i, nCurrentHeight, nNewHeight;
    COLOR Color;
    RECT rectBar;
    HPEN hWhitePen, hOldPen;
    HBRUSH hNewBrush, hOldBrush,hNewBarBrush, hOldBarBrush ;

    InvalidateRect(hWnd, NULL, TRUE); //invalidate entire window
    hDC = BeginPaint(hWnd, &ps);
    cxClient = ps.rcPaint.right - ps.rcPaint.left;
    cyClient = ps.rcPaint.bottom - ps.rcPaint.top;

    SetMapMode(hDC, MM_ANISOTROPIC);
    SetWindowExt(hDC, rectPage.right, rectPage.top);
    SetViewportExt(hDC, cxClient, -cyClient); // Set up Window
    SetViewportOrg (hDC, 0, cyClient);

    // A rectangle around the chart.
    //
    hWhitePen = CreatePen(PS_SOLID, 1, RGB(255, 255, 255));
    hOldPen = SelectObject(hDC, hWhitePen);
    Rectangle(hDC, rectData.left,rectData.top, rectData.right, rectData.bottom );

    // Create and select the brush to draw the chart data itself
    //
    hNewBrush = CreateSolidBrush(RGB(0, 0, 0));
    hOldBrush = SelectObject(hDC, hNewBrush);

    SelectObject(hDC, hOldPen);
    DeleteObject(hWhitePen);

    flFraction = ((rectData.right - rectData.left) / nBar);
    nWidth = (short) flFraction;

    for (i = 0; i < nBar; i++)
    {
        nNewHeight = abarWork[i].len;
        Color = abarWork[i].clr;

        // Calculate the size of the bar.
        //
        flFraction = (float) nNewHeight / (float) fTallest;
        nCurrentHeight = (short) (flFraction * (rectData.bottom - rectData.top));

        rectBar.left = rectData.left + (nWidth * i);
        rectBar.top = nCurrentHeight + rectData.top;
        rectBar.right = rectData.left + nWidth * (i+1);
        rectBar.bottom = rectBar.top - nCurrentHeight;

        hNewBarBrush = CreateSolidBrush(RGB(Color.nRed, Color.nGreen, Color.nBlue));
        hOldBarBrush =  SelectObject(hDC, hNewBarBrush);

        Rectangle(hDC, rectBar.left,rectBar.top,rectBar.right,rectBar.bottom);

        // Delete the brush, after selecting the old one back into the DC.
        SelectObject(hDC, hOldBarBrush);
        DeleteObject(hNewBarBrush);
    }

    // Delete the brush, after selecting the old one back in the DC.
    //
    SelectObject(hDC, hOldBrush);
    DeleteObject(hNewBrush);
    EndPaint (hWnd, &ps);
}


// InitStats: initializes statistics for Stats dialog box
void InitStats(TIMESTRUCT *tm)
{
    tm->time = fTime;
    tm->swaps = iSwaps;
    tm->compares = iCompares;
    tm->done = TRUE;
}


// InitPrevRandom: initializes abarWork to previous random values and
// repaints random display
void InitPrevRandom(HWND hWnd)
{
    int iRow;
    for( iRow = 0; iRow < nBar; iRow++ )
    {
        abarWork[iRow] = abarPerm[iRow];
        abarTemp[iRow] = abarPerm[iRow];
    }
    RenderBars(hWnd);
}


//InitSort: Initializes everything for a new sort and gets a device context
//
void InitSort(HWND hWnd)
{
    if (NewRandom)              // if randomize just occurred
        NewRandom = FALSE;      // make sure next sorts use new data
    else                        // if first sort has already been done
        InitPrevRandom(hWnd);   // restore last randomized bars

    TempDC = GetDC(hWnd);
    SetMapMode(TempDC, MM_ANISOTROPIC);
    SetWindowExt(TempDC, rectPage.right, rectPage.top);
    SetViewportExt(TempDC, cxClient, -cyClient); // Set up Window
    SetViewportOrg (TempDC, 0, cyClient);
    SetCursor(hHour);

    clStart = clock();
    clFinish = 0;
    iSwaps = 0;
    iCompares = 0;
}

// EndSort: Releases the device context and sets cursor back to an arrow
//
void EndSort(HWND hWnd)
{
    DrawTime();
    ReleaseDC(hWnd, TempDC);
    TempDC = NULL;
    SetCursor(hArrow);
}

// SetNewColors: Sets a new color that's different from the previous bar.
COLOR SetNewColors()
{
    COLOR newColor;
    nCurrentColor++;
    nCurrentColor %= NUMBARS;
    newColor.nBlue = (nCurrentColor & 1) ? 255 : 0;
    newColor.nGreen = (nCurrentColor & 2) ? 255 : 0;
    newColor.nRed = (nCurrentColor & 4) ? 255 : 0;
    return newColor;
}


// DrawBar: Erases a bar and draws a new bar in its place
//
void DrawBar( int Bar )
{
    RECT rectBar;
    HPEN hWhitePen, hOldPen;
    HBRUSH hWhiteBrush, hOldBrush, hBarBrush;
    float flFraction;
    short nCurrentHeight, nWidth;

    flFraction = ((rectData.right  - rectData.left) / nBar);
    nWidth = (short) flFraction;

    // draw white rectangle over old bar
    flFraction = (float) abarTemp[Bar].len / (float) fTallest;
    nCurrentHeight = (short) (flFraction * (rectData.bottom - rectData.top));

    rectBar.left = rectData.left + (nWidth * Bar);
    rectBar.top = nCurrentHeight + rectData.top;
    rectBar.right = rectData.left + nWidth * (Bar+1);
    rectBar.bottom = rectBar.top - nCurrentHeight;

    hWhitePen = CreatePen(PS_SOLID, 1, RGB(255, 255, 255));
    hOldPen = SelectObject(TempDC, hWhitePen);

    hWhiteBrush = CreateSolidBrush(RGB(255, 255, 255));
    hOldBrush = SelectObject(TempDC, hWhiteBrush);
    Rectangle(TempDC, rectBar.left, rectBar.top, rectBar.right, rectBar.bottom);
    SelectObject(TempDC, hOldPen);
    DeleteObject(hWhitePen);
    SelectObject(TempDC, hOldBrush);
    DeleteObject(hWhiteBrush);

    // draw new colored rectangle
    flFraction = (float) abarWork[Bar].len / (float) fTallest;
    nCurrentHeight = (short) (flFraction * (rectData.bottom - rectData.top));


    rectBar.left = rectData.left + (nWidth * Bar);
    rectBar.top = nCurrentHeight + rectData.top;
    rectBar.right = rectData.left + nWidth * (Bar+1);
    rectBar.bottom = rectBar.top - nCurrentHeight;



    hBarBrush = CreateSolidBrush(RGB(   abarWork[Bar].clr.nRed,
                                        abarWork[Bar].clr.nGreen,
                                        abarWork[Bar].clr.nBlue));
    hOldBrush = SelectObject(TempDC, hBarBrush);

    Rectangle(TempDC,rectBar.left,rectBar.top,rectBar.right, rectBar.bottom);
    // Delete the brush, after selecting the old one back into the DC.
    //
    SelectObject(TempDC, hOldBrush);
    DeleteObject(hBarBrush);

    abarTemp[Bar] = abarWork[Bar];

    if( sound == TRUE)
    {
        Beep( 60 * Bar, 75 );   // Play note
        Sleep( clPause - 75L );  // Pause adjusted for note duration
    }
    else
    Sleep( clPause );        // Pause

}

//DrawTime: Paints the statistics on the window during the sort
//
void DrawTime()
{
    char szTime[30], szSwaps[20], szCompares[20];

    clFinish = clock();

    fTime =  (float)(clFinish - clStart) / CLOCKS_PER_SEC ;

    sprintf(szTime, "Seconds: %5.2f",fTime);
    sprintf(szSwaps, "Swaps: %4.i", iSwaps);
    sprintf(szCompares, "Compares: %4.i", iCompares);


    // Print the number of seconds elapsed
    TextOut(TempDC, 50, 975, szTime, strlen(szTime));
    TextOut(TempDC, 425, 975, szSwaps, strlen(szSwaps));
    TextOut(TempDC, 750, 975, szCompares, strlen(szCompares));

}


// Swaps: Exchanges two bar structures.
//
void Swaps( BAR *bar1, BAR *bar2 )
{
    BAR barTmp;

    ++iSwaps;
    barTmp = *bar1;
    *bar1  = *bar2;
    *bar2  = barTmp;
}


// SwapBars - Calls DrawBar twice to switch the two bars in iRow1 and
// iRow2, then calls DrawTime to update the time.
//
void SwapBars( int iRow1, int iRow2 )
{
    DrawBar( iRow1 );
    DrawBar( iRow2 );
    DrawTime();
}

// Sleep: Pauses for a specified number of microseconds.
//
void Sleep( clock_t wait )
{
    clock_t goal;

    goal = wait + clock();
    while( goal >= clock() );
}


// Beep: Sounds the speaker for a time specified in microseconds by
// duration at a pitch specified in hertz by frequency.
//
void Beep( int frequency, int duration )
{

    int control;

    // If frequency is 0, Beep doesn't try to make a sound. It
    // just sleeps for the duration.

    if( frequency )
    {
        // 75 is about the shortest reliable duration of a sound.
        if( duration < 75 )
            duration = 75;

        // Prepare timer by sending 10111100 to port 43.
        _outp( 0x43, 0xb6 );

        // Divide input frequency by timer ticks per second and
        // write (byte by byte) to timer.

        frequency = (unsigned)(1193180L / frequency);
        _outp( 0x42, (char)frequency );
        _outp( 0x42, (char)(frequency >> 8) );

        // Save speaker control byte.
        control = _inp( 0x61 );

        // Turn on the speaker (with bits 0 and 1).
        _outp( 0x61, control | 0x3 );
    }

    Sleep( (clock_t)duration );

    // Turn speaker back on if necessary.
    if( frequency )
        _outp( 0x61, control );

}


// InitBars: Initializes a random set of bars
//
void InitBars()
{
    int aTemp[NUMBARS], iRow, iRowMax, iRand, iLength;
    float flFraction;
    short nWidth;

    // Seed the random-number generator.
    srand( (unsigned)time( NULL ) );


    // Randomize an array of rows.
    for( iRow = 0; iRow < nBar; iRow++ )
           aTemp[iRow] = iRow + 1;
    iRowMax = nBar - 1;

    flFraction = ((rectData.right - rectData.left) / nBar);
    nWidth = (short) flFraction;


    nCurrentColor = 0;
    fTallest = 0;
    for( iRow = 0; iRow < nBar; iRow++ )
    {
        // Find a random element in aTemp between 0 and iRowMax,
        // then assign the value in that element to iLength.

        iRand = GetRandom( 0, iRowMax );
        iLength = aTemp[iRand];

        // Overwrite the value in aTemp[iRand] with the value in
        // aTemp[iRowMax] so the value in aTemp[iRand] is
        // chosen only once.
        //
        aTemp[iRand] = aTemp[iRowMax];

        // Decrease the value of iRowMax so that aTemp[iRowMax] can't
        // be chosen on the next pass through the loop.
        //
        --iRowMax;
        abarPerm[iRow].len = iLength;
        if (iLength > fTallest) fTallest = iLength;
        abarPerm[iRow].clr = SetNewColors();
    }

    // Assign permanent sort values to temporary and draw unsorted bars.

    for( iRow = 0; iRow < nBar; iRow++ )
    {
        abarWork[iRow] = abarPerm[iRow];
        abarTemp[iRow] = abarPerm[iRow];
    }
}

// InsertionSort: InsertionSort compares the length of each element
// with the lengths of all the preceding elements. When the appropriate
// place for the new element is found, the element is inserted and
// all the other elements are moved down one place.
//
void InsertionSort()
{
    BAR barTemp;
    int iRow, iRowTmp, iLength;

    // Start at the top.
    for( iRow = 0; iRow < nBar; iRow++ )
    {
        barTemp = abarWork[iRow];
        iLength = barTemp.len;

        // As long as the length of the temporary element is greater than
        // the length of the original, keep shifting the elements down.
        //
        for( iRowTmp = iRow; iRowTmp; iRowTmp-- )
        {
            iCompares++;
            if( abarWork[iRowTmp - 1].len > iLength )
            {
                ++iSwaps;
                abarWork[iRowTmp] = abarWork[iRowTmp - 1];
                DrawBar( iRowTmp );         // Print the new bar
                DrawTime();        // Print the elapsed time
            }
            else                              // Otherwise, exit
                break;
        }

        // Insert the original bar in the temporary position.
        abarWork[iRowTmp] = barTemp;
        DrawBar( iRowTmp );
        DrawTime();
    }
}


// BubbleSort: BubbleSort cycles through the elements, comparing
// adjacent elements and swapping pairs that are out of order. It
// continues to do this until no out-of-order pairs are found.
//
void BubbleSort()
{
    int iRow, iSwitch, iLimit = nBar-1;

    // Move the longest bar down to the bottom until all are in order.
    do
    {
        iSwitch = 0;
        for( iRow = 0; iRow < iLimit; iRow++ )
        {
            // If two adjacent elements are out of order, swap their values
            // and redraw those two bars.
            //
            iCompares++;
            if( abarWork[iRow].len > abarWork[iRow + 1].len )
            {
                Swaps( &abarWork[iRow], &abarWork[iRow + 1] );
                SwapBars( iRow, iRow + 1 );
                iSwitch = iRow;
            }
        }

        // Sort on next pass only to where the last switch was made.
        iLimit = iSwitch;
    } while( iSwitch );
}


/* HeapSort:  HeapSort (also called TreeSort) works by calling
   PercolateUp and PercolateDown. PercolateUp organizes the elements
   into a "heap" or "tree," which has the properties shown below:

                              element[1]
                            /            \
                 element[2]                element[3]
                /          \              /          \
          element[4]     element[5]   element[6]    element[7]
          /        \     /        \   /        \    /        \
         ...      ...   ...      ... ...      ...  ...      ...

*/
//  Each "parent node" is greater than each of its "child nodes"; for
//  example, element[1] is greater than element[2] or element[3];
//  element[4] is greater than element[5] or element[6], and so forth.
//  Therefore, once the first loop in HeapSort is finished, the
//  largest element is in element[1].
//
//  The second loop rebuilds the heap (with PercolateDown), but starts
//  at the top and works down, moving the largest elements to the bottom.
//  This has the effect of moving the smallest elements to the top and
//  sorting the heap.

void HeapSort()
{
    int i;

    for( i = 1; i < nBar; i++ )
        PercolateUp( i );

    for( i = nBar - 1; i > 0; i-- )
    {
        Swaps( &abarWork[0], &abarWork[i] );
        SwapBars( 0, i );
        PercolateDown( i - 1 );
    }
}


// PercolateUp: Converts elements into a "heap" with the largest
// element at the top (see the diagram above).

void PercolateUp( int iMaxLevel )
{
    int i = iMaxLevel, iParent;

    // Move the value in abarWork[iMaxLevel] up the heap until it has
    // reached its proper node (that is, until it is greater than either
    // of its child nodes, or until it has reached 1, the top of the heap).

    while( i )
    {
        iParent = i / 2;    // Get the subscript for the parent node
        iCompares++;
        if( abarWork[i].len > abarWork[iParent].len )
        {
            // The value at the current node is bigger than the value at
            // its parent node, so swap these two array elements.
            //
            Swaps( &abarWork[iParent], &abarWork[i] );
            SwapBars( iParent, i );
            i = iParent;
        }
        else
            // Otherwise, the element has reached its proper place in the
            // heap, so exit this procedure.

            break;
    }
}


// PercolateDown: Converts elements to a "heap" with the largest elements
// at the bottom. When this is done to a reversed heap (largest elements
// at top), it has the effect of sorting the elements.
//
void PercolateDown( int iMaxLevel )
{
    int iChild, i = 0;

    // Move the value in abarWork[0] down the heap until it has reached
    // its proper node (that is, until it is less than its parent node
    // or until it has reached iMaxLevel, the bottom of the current heap).

    while( TRUE )
    {
        // Get the subscript for the child node.
        iChild = 2 * i;

        // Reached the bottom of the heap, so exit this procedure.
        if( iChild > iMaxLevel )
            break;

        // If there are two child nodes, find out which one is bigger.
        if( iChild + 1 <= iMaxLevel )
        {
            iCompares++;
            if( abarWork[iChild + 1].len > abarWork[iChild].len )
                iChild++;
        }

        iCompares++;
        if( abarWork[i].len < abarWork[iChild].len )
        {
            // Move the value down since it is still not bigger than
            // either one of its children.

            Swaps( &abarWork[i], &abarWork[iChild] );
            SwapBars( i, iChild );
            i = iChild;
        }
        else
            // Otherwise, abarWork has been restored to a heap from 1 to
            // iMaxLevel, so exit.

            break;
    }
}


// ExchangeSort: The ExchangeSort compares each element--starting with
// the first--with every following element. If any of the following
// elements is smaller than the current element, it is exchanged with
// the current element and the process is repeated for the next element.
//
void ExchangeSort()
{
    int iRowCur, iRowMin, iRowNext;

    for( iRowCur = 0; iRowCur < nBar; iRowCur++ )
    {
        iRowMin = iRowCur;
        for( iRowNext = iRowCur; iRowNext < nBar; iRowNext++ ){
            iCompares++;
            if( abarWork[iRowNext].len < abarWork[iRowMin].len ){
                iRowMin = iRowNext;
                DrawTime();
            }
        }

        // If a row is shorter than the current row, swap those two
        // array elements.

        if( iRowMin > iRowCur ){
            Swaps( &abarWork[iRowCur], &abarWork[iRowMin] );
            SwapBars( iRowCur, iRowMin );
        }
    }
}


// ShellSort: ShellSort is similar to the BubbleSort. However, it
// begins by comparing elements that are far apart (separated by the
// value of the iOffset variable, which is initially half the distance
// between the first and last element), then comparing elements that
// are closer together. When iOffset is one, the last iteration is
// merely a bubble sort.
//
void ShellSort()
{
    int iOffset, iSwitch, iLimit, iRow;

    // Set comparison offset to half the number of bars.
    iOffset = nBar  / 2;

    while( iOffset )
    {
        // Loop until offset gets to zero.
        iLimit = nBar - iOffset - 1 ;
        do
        {
            iSwitch = FALSE;     // Assume no switches at this offset.

            // Compare elements and switch ones out of order.
            for( iRow = 0; iRow <= iLimit; iRow++ )
            {
                iCompares++;
                if( abarWork[iRow].len > abarWork[iRow + iOffset].len )
                {
                    Swaps( &abarWork[iRow], &abarWork[iRow + iOffset] );
                    SwapBars( iRow, iRow + iOffset );
                    iSwitch = iRow;
                }
            }

            // Sort on next pass only to where last switch was made.
            iLimit = iSwitch - iOffset;
        } while( iSwitch );

        // No switches at last offset, try one half as big.
        iOffset = iOffset / 2;
    }
}


// QuickSort: QuickSort works by picking a random "pivot" element,
// then moving every element that is bigger to one side of the pivot,
// and every element that is smaller to the other side. QuickSort is
// then called recursively with the two subdivisions created by the pivot.
// Once the number of elements in a subdivision reaches two, the recursive
// calls end and the array is sorted.
//
void QuickSort( int iLow, int iHigh )
{
    int iUp, iDown, iBreak;

    if( iLow < iHigh )
    {
        // Only two elements in this subdivision; swap them if they are
        // out of order, then end recursive calls.
        //
        if( (iHigh - iLow) == 1 )
        {
            iCompares++;
            if( abarWork[iLow].len > abarWork[iHigh].len )
            {
                Swaps( &abarWork[iLow], &abarWork[iHigh] );
                SwapBars( iLow, iHigh );
            }
        }
        else
        {
            iBreak = abarWork[iHigh].len;
            do
            {
                // Move in from both sides towards the pivot element.
                iUp = iLow;
                iDown = iHigh;
                iCompares++;
                while( (iUp < iDown) && (abarWork[iUp].len <= iBreak) )
                    iUp++;
                iCompares++;
                while( (iDown > iUp) && (abarWork[iDown].len >= iBreak) )
                    iDown--;
                // If we haven't reached the pivot, it means that two
                // elements on either side are out of order, so swap them.
                //
                if( iUp < iDown )
                {
                    Swaps( &abarWork[iUp], &abarWork[iDown] );
                    SwapBars( iUp, iDown );
                }
            } while ( iUp < iDown );

            // Move pivot element back to its proper place in the array.
            Swaps( &abarWork[iUp], &abarWork[iHigh] );
            SwapBars( iUp, iHigh );

            // Recursively call the QuickSort procedure (pass the smaller
            // subdivision first to use less stack space).
            //
            if( (iUp - iLow) < (iHigh - iUp) )
            {
                QuickSort( iLow, iUp - 1 );
                QuickSort( iUp + 1, iHigh );
            }
            else
            {
                QuickSort( iUp + 1, iHigh );
                QuickSort( iLow, iUp - 1 );
            }
        }
    }
}



/****************************************************************************

    FUNCTION: About(HWND, unsigned, WORD, LONG)

    PURPOSE:  Processes messages for "About" dialog box

    MESSAGES:

    WM_INITDIALOG - initialize dialog box
    WM_COMMAND    - Input received

****************************************************************************/

BOOL FAR PASCAL __export About(hDlg, message, wParam, lParam)
HWND hDlg;
unsigned message;
WORD wParam;
LONG lParam;
{
    switch (message) {
    case WM_INITDIALOG:
        return (TRUE);

    case WM_COMMAND:
        if (wParam == IDOK
                || wParam == IDCANCEL) {
        EndDialog(hDlg, TRUE);
        return (TRUE);
        }
        break;
    }
    return (FALSE);
}

/****************************************************************************

    FUNCTION: Stats(HWND, unsigned, WORD, LONG)

    PURPOSE:  Processes messages for "Stats" dialog box

    MESSAGES:

    WM_INITDIALOG - initialize dialog box
    WM_COMMAND    - Input received

****************************************************************************/
BOOL FAR PASCAL __export Stats(hDlg, message, wParam, lParam)
HWND hDlg;
unsigned message;
WORD wParam;
LONG lParam;
{
    char temp[10];
    LPSTR farStr;

    switch (message) {
    case WM_INITDIALOG:
        farStr = (LPSTR) _fmalloc(10);
        if (Insertion.done) {
            sprintf(temp,"%2.2f",Insertion.time);
            _fstrcpy(farStr,(LPSTR)temp);
            SetDlgItemText(hDlg, ID_I_TIME, farStr);
            SetDlgItemInt(hDlg, ID_I_SWAP, Insertion.swaps, FALSE);
            SetDlgItemInt(hDlg, ID_I_COMPARE, Insertion.compares, FALSE);
        }

        if (Bubble.done) {
            sprintf(temp,"%2.2f",Bubble.time);
            _fstrcpy(farStr,(LPSTR)temp);
            SetDlgItemText(hDlg, ID_B_TIME, farStr);
            SetDlgItemInt(hDlg, ID_B_SWAP, Bubble.swaps, FALSE);
            SetDlgItemInt(hDlg, ID_B_COMPARE, Bubble.compares, FALSE);
        }

        if (Heap.done) {
            sprintf(temp,"%2.2f",Heap.time);
            _fstrcpy(farStr,(LPSTR)temp);
            SetDlgItemText(hDlg, ID_H_TIME, farStr);
            SetDlgItemInt(hDlg, ID_H_SWAP, Heap.swaps, FALSE);
            SetDlgItemInt(hDlg, ID_H_COMPARE, Heap.compares, FALSE);
        }

        if (Exchange.done) {
            sprintf(temp,"%2.2f",Exchange.time);
            _fstrcpy(farStr,(LPSTR)temp);
            SetDlgItemText(hDlg, ID_E_TIME, farStr);
            SetDlgItemInt(hDlg, ID_E_SWAP, Exchange.swaps, FALSE);
            SetDlgItemInt(hDlg, ID_E_COMPARE, Exchange.compares, FALSE);
        }


        if (Shell.done) {
            sprintf(temp,"%2.2f",Shell.time);
            _fstrcpy(farStr,(LPSTR)temp);
            SetDlgItemText(hDlg, ID_S_TIME, farStr);
            SetDlgItemInt(hDlg, ID_S_SWAP, Shell.swaps, FALSE);
            SetDlgItemInt(hDlg, ID_S_COMPARE, Shell.compares, FALSE);
        }

        if (Quick.done) {
            sprintf(temp,"%2.2f",Quick.time);
            _fstrcpy(farStr,(LPSTR)temp);
            SetDlgItemText(hDlg, ID_Q_TIME, farStr);
            SetDlgItemInt(hDlg, ID_Q_SWAP, Quick.swaps, FALSE);
            SetDlgItemInt(hDlg, ID_Q_COMPARE, Quick.compares, FALSE);
        }

        _ffree(farStr);

        return (TRUE);

    case WM_COMMAND:
        if (wParam == IDOK
                || wParam == IDCANCEL) {
        EndDialog(hDlg, TRUE);
        return (TRUE);
        }
        break;
    }
    return (FALSE);
}


/****************************************************************************

    FUNCTION: Pause (HWND, unsigned, WORD, LONG)

    PURPOSE:  Processes messages for "Pause" dialog box

    MESSAGES:

    WM_INITDIALOG - initialize dialog box
    WM_COMMAND    - Input received

****************************************************************************/
BOOL FAR PASCAL __export Pause(hDlg, message, wParam, lParam)
HWND hDlg;
unsigned message;
WORD wParam;
LONG lParam;
{
    char temp[10];
    LPSTR farStr;
    static clock_t tmpPause;

    switch (message) {
    case WM_INITDIALOG:
        tmpPause = clPause;
        farStr = (LPSTR) _fmalloc(10);
        sprintf(temp,"%3.3u", tmpPause/30);
        _fstrcpy(farStr,(LPSTR)temp);
        SetDlgItemText(hDlg, ID_PAUSE, farStr);
        _ffree(farStr);
        return (TRUE);

    case WM_COMMAND:
        switch (wParam) {
        case IDOK:
            clPause = tmpPause;
            EndDialog(hDlg, TRUE);
            return (TRUE);
            break;
        case IDCANCEL:
            EndDialog(hDlg, TRUE);
            return (TRUE);
            break;

        case ID_SLOWER:
            if( tmpPause <= 900L ){
                tmpPause += 30L;
                farStr = (LPSTR) _fmalloc(10);
                sprintf(temp,"%3.3u", tmpPause/30);
                _fstrcpy(farStr,(LPSTR)temp);
                SetDlgItemText(hDlg, ID_PAUSE, farStr);
                _ffree(farStr);
            }
            break;

        case ID_FASTER:
            if( tmpPause ){
                tmpPause -= 30L;
                farStr = (LPSTR) _fmalloc(10);
                sprintf(temp,"%3.3u", tmpPause/30);
                _fstrcpy(farStr,(LPSTR)temp);
                SetDlgItemText(hDlg, ID_PAUSE, farStr);
                _ffree(farStr);
            }
            break;
        }
    }
    return (FALSE);
}
