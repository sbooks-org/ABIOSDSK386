//    QWGDEMO.CPP opens multiple Graphics Child Windows using:
//
//	  _wgopen  _wgclose  _wggetactive  _wgsetactive
//
//	  and demonstrates pausing in a Graphics Child Window using:
//	  _inchar
//
//
//    This program creates 3 windows, pausing after each to allow you to
//    examine the window before continuing. Try using the scroll
//    bars and arrow keys, switching the GCWs to Full Screen or Size To
//    Fit mode, and resizing the windows.
//

#include <iostream.h>
#include <graph.h>

void main()
{

      int    status, handle, color;
      char   ch;
      long   bgd, prvbgd;
      char   name[] = "SMILEY";
      char   name2[] = "HELLO";

//  Send a message to the text window (stdin/stderr/stdout)
     cout <<  "QuickWin Graphics Demo Program.\n" ;

//  Pause before continuing
      cout << "\nThis is a text window. Press Enter to continue.\n" ;
      cin.get(ch);               
      
     

//  Close the default "Graphic1" GCW (we'll name our own)
      status = _setvideomode( _MAXRESMODE ); 
      handle = _wggetactive( );              
      status = _wgclose( handle );           

//  Open a GCW named "SMILEY" in which to draw a smiley face
      handle = _wgopen( name );              
      status = _wgsetactive( handle );       
      status = _setvideomode( _MAXRESMODE ); 

//  Draw Smiley's head
      color = 13;
      status = _setcolor( color );
      status = _ellipse( _GFILLINTERIOR, 40, 20, 240, 140 );

//  Draw Smiley's eyes, nose, and mouth
      status = _setcolor( color + 1 );
      status = _ellipse( _GFILLINTERIOR, 80, 40, 100, 60 );
      status = _ellipse( _GFILLINTERIOR, 180, 40, 200, 60 );
      status = _ellipse( _GBORDER, 130, 70, 150, 90 );
      status = _arc( 90, 80, 190, 120, 115, 100, 165, 100 );


//  Pause before continuing
      _settextposition( 1, 6 );
      _outtext("Press any key to continue.");
      status = _inchar( );

//  Open a new GCW called "HELLO" and set it for text output
      handle = _wgopen( name2 );
      status = _wgsetactive( handle );
      status = _setvideomode( _TEXTC80 );

//  Set background and text colors for the message
      bgd = 1;
      prvbgd = _setbkcolor( bgd );
      status = _settextcolor( color );

//  Display a text message in a GCW
      _settextposition( 6, 25 );
      _outtext( "HELLO, WORLD!" );

//  Return to default text color & background color
      bgd = _setbkcolor( prvbgd );
      status = _settextcolor( 15 );

//  Pause before continuing
      _settextposition( 1, 6 );
      _outtext("Press any key to continue.");
      status = _inchar( );

//  Leave the cursor at the start of the line below the message
      _settextposition( 7, 1 );

}
