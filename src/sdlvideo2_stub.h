
extern value Val_SDLSurface(SDL_Surface *s, int freeable, value barr);
#define ML_SURFACE(s) Val_SDLSurface((s), 1, Val_unit)

struct ml_sdl_surf_data {
  SDL_Surface *s ;
  int freeable;
};

static inline SDL_Surface *SDL_SURFACE(value v)
{
  struct ml_sdl_surf_data *cb_data;
  cb_data = (Tag_val(v) == 0) ? 
    Data_custom_val(Field(v, 0)) : Data_custom_val(v);
  return cb_data->s;
}
