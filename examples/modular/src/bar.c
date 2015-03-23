#include <bar.h>
#include <foo.h>

#include <stdlib.h>

int main(int argc, char * argv[])
{
    foo_init();
    bar_init();
    return EXIT_SUCCESS;
}
