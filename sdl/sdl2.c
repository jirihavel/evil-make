#include <SDL2/SDL.h>

#include <stdlib.h>

#undef main

int main()
{
    SDL_Init(SDL_INIT_EVERYTHING);
    return EXIT_SUCCESS;
}
