#include <caml/memory.h>
#include <caml/alloc.h>

#include <SDL.h>

#include "common.h"
#include "sdlvideo_stub.h"

ML_2(SDL_WM_SetCaption, String_val, String_val, Unit)
  
CAMLprim value ml_SDL_WM_GetCaption(value unit)
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

CAMLprim value ml_SDL_WM_SetIcon(value surf)
{
  SDL_WM_SetIcon(SDL_SURFACE(surf), NULL);
  return Val_unit;
}

ML_0(SDL_WM_IconifyWindow, Val_bool)

CAMLprim value ml_SDL_WM_ToggleFullScreen(value unit)
{
  return Val_bool(SDL_WM_ToggleFullScreen(SDL_GetVideoSurface()));
}

CAMLprim value ml_SDL_WM_GrabInput(value grabmode)
{
  SDL_GrabMode mode = Bool_val(grabmode) ? SDL_GRAB_ON : SDL_GRAB_OFF ;
  SDL_WM_GrabInput(mode);
  return Val_unit;
}

CAMLprim value ml_SDL_WM_GetGrabInput(value unit)
{
  return Val_bool(SDL_WM_GrabInput(SDL_GRAB_QUERY));
}
