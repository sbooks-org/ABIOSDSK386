/* 
MEMTEST2.CPP
*/

#include <stdlib.h>
#include <iostream.h>
#include <new.h>
#include <string.h>

class msg {
public:
    msg()   { cout << "hello from " << __FILE__ << "\n" ; }
    ~msg()  { cout << "bye\n" ; }
    } ;

static msg banner;  // test C++ static constructors, destructors

static unsigned long bytes = 0;
static unsigned long allocs = 0;
static unsigned blk_size = 10240;

int new_fail(size_t )
{
    if (blk_size)
        blk_size >>= 1;  // try to allocate a smaller block
    else
    {   // memory exhausted
        cout << "Allocated " << bytes << " bytes\n" ;
        exit(1);
    }
    return 1;
}

void
main(void)
{
    char *p;

    _set_new_handler(new_fail);   // called when new fails

    for (;;)
    {
       p = new char[blk_size];   // allocate memory
       memset(p, 0, blk_size);   // touch every byte
       *p = 'x';                 // do something, anything with
       p[blk_size-1] = 'y';      //   the allocated memory
           
       bytes += blk_size;
       allocs++;
       if ((allocs % 25) == 0)   // odometer
            cout << "Allocated " << bytes << " bytes\r";
    }
}
