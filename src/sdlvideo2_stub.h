
extern value Val_SDLSurface(SDL_Surface *s, int freeable, value barr);
#define ML_SURFACE(s) Val_SDLSurface((s), 1, Val_unit)

static inline SDL_Surface *SDL_SURFACE(value v)
{
  if(Tag_val(v) == 0)
    return (SDL_Surface *)(Field(Field(v, 0), 0)) ;
  else
    return (SDL_Surface *)(Field(v, 0)) ;
}
