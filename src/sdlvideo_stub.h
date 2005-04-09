#include "config.h"

typedef void (*sdl_finalizer)(void *);

extern value Val_SDLSurface(SDL_Surface *s, int freeable, value barr, 
			    sdl_finalizer finalizer, void* finalizer_data);
#define ML_SURFACE(s) Val_SDLSurface((s), 1, Val_unit, NULL, NULL)

struct ml_sdl_surf_data {
  SDL_Surface *s ;
  int freeable;
  sdl_finalizer finalizer;
  void *finalizer_data;
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
extern void SDLColor_of_value(SDL_Color *c, value v);
#else
static inline void SDLColor_of_value(SDL_Color *c, value v)
{
  c->r = Int_val(Field(v, 0));
  c->g = Int_val(Field(v, 1));
  c->b = Int_val(Field(v, 2));
}
#endif

#ifndef HAVE_INLINE
extern void SDLRect_of_value(SDL_Rect *r, value v);
#else
static inline void SDLRect_of_value(SDL_Rect *r, value v)
{
  r->x = Int_val(Field(v, 0));
  r->y = Int_val(Field(v, 1));
  r->w = Int_val(Field(v, 2));
  r->h = Int_val(Field(v, 3));
}
#endif

void sdlvideo_raise_exception (char *) Noreturn;
