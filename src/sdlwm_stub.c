#include <caml/memory.h>
#include <caml/alloc.h>

#include <SDL.h>

#include "common.h"
#include "sdlvideo2_stub.h"

#if ( __STDC_VERSION__ != 199901L )

static SDL_Surface *SDL_SURFACE(value v)
{
        struct ml_sdl_surf_data *cb_data;
        cb_data = (Tag_val(v) == 0) ?
     Data_custom_val(Field(v, 0)) : Data_custom_val(v);
        return cb_data->s;
}
    
#endif


ML_2(SDL_WM_SetCaption, String_val, String_val, Unit)


  
value ml_SDL_WM_GetCaption(value unit)
{
  CAMLparam0();
  CAMLlocal3(v, s1, s2);
  char *title, *icon;
  SDL_WM_GetCaption(&title, &icon);
  if(! title) title = "";
  if(! icon) icon = "" ;
  s1 = copy_string(title);
  s2 = copy_string(icon);
  v = alloc_small(2, 0);
  Field(v, 0) = s1;
  Field(v, 1) = s2;
  CAMLreturn(v);
}

value ml_SDL_WM_SetIcon(value surf)
{
  SDL_WM_SetIcon(SDL_SURFACE(surf), NULL);
  return Val_unit;
}

ML_0(SDL_WM_IconifyWindow, Val_bool)

value ml_SDL_WM_ToggleFullScreen(value unit)
{
  return Val_bool(SDL_WM_ToggleFullScreen(SDL_GetVideoSurface()));
}

value ml_SDL_WM_GrabInput(value grabmode)
{
  SDL_GrabMode mode = Bool_val(grabmode) ? SDL_GRAB_ON : SDL_GRAB_OFF ;
  SDL_WM_GrabInput(mode);
  return Val_unit;
}

value ml_SDL_WM_GetGrabInput(value unit)
{
  return Val_bool(SDL_WM_GrabInput(SDL_GRAB_QUERY));
}
