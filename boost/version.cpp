#include <boost/version.hpp>

#include <cstdio>
#include <cstdlib>

int main()
{
    printf("BOOST_FOUND:=1\n");
    printf("BOOST_LIB_VERSION:=%s\n", BOOST_LIB_VERSION);
    return EXIT_SUCCESS;
}
