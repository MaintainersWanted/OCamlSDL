#include "config.h"

extern value Val_SDLSurface(SDL_Surface *s, int freeable, value barr);
#define ML_SURFACE(s) Val_SDLSurface((s), 1, Val_unit)

struct ml_sdl_surf_data {
  SDL_Surface *s ;
  int freeable;
};


#ifndef HAVE_INLINE
extern SDL_Surface *SDL_SURFACE(value v);
#else
static inline SDL_Surface *SDL_SURFACE(value v)
{
  struct ml_sdl_surf_data *cb_data;
  cb_data = (Tag_val(v) == 0) ? 
    Data_custom_val(Field(v, 0)) : Data_custom_val(v);
  return cb_data->s;
}
#endif

#ifndef HAVE_INLINE
static void SDLColor_of_value(SDL_Color *c, value v);
#else
static inline void SDLColor_of_value(SDL_Color *c, value v)
{
  c->r = Int_val(Field(v, 0));
  c->g = Int_val(Field(v, 1));
  c->b = Int_val(Field(v, 2));
}
#endif
