#include <SDL_image.h>

#include <stdio.h>
#include <stdlib.h>

#undef main

int main()
{
    printf("SDL2_IMAGE_FOUND:=$(true)\n");

    SDL_version version;

    SDL_IMAGE_VERSION(&version);
    printf("SDL2_IMAGE_VERSION:=%d.%d.%d\n", version.major, version.minor, version.patch);

    version = *IMG_Linked_Version();
    printf("SDL2_IMAGE_LIB_VERSION:=%d.%d.%d\n", version.major, version.minor, version.patch);
    
    return EXIT_SUCCESS;
}
