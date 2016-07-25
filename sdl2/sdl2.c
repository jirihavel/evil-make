#include <SDL.h>

#include <stdio.h>
#include <stdlib.h>

#undef main

int main()
{
    printf("SDL2_FOUND:=$(true)\n");

    SDL_version version;

    SDL_VERSION(&version);
    printf("SDL2_VERSION:=%d.%d.%d\n", version.major, version.minor, version.patch);

    SDL_GetVersion(&version);
    printf("SDL2_LIB_VERSION:=%d.%d.%d\n", version.major, version.minor, version.patch);

    printf("SDL2_REVISION:=%s\n", SDL_GetRevision());

    printf("SDL2_REVISION_NUMBER:=%d\n", SDL_GetRevisionNumber());

    return EXIT_SUCCESS;
}
