/* $Id: sdlkey_stub.c,v 1.3 2002/08/24 21:03:07 oliv__a Exp $ */

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/bigarray.h>

#include <SDL.h>

#include "common.h"

value ml_SDL_GetKeyName(value key)
{
  return copy_string(SDL_GetKeyName(Int_val(key)));
}

value ml_SDL_DisableKeyRepeat(value unit)
{
  SDL_EnableKeyRepeat(0, 0);
  return Val_unit;
}

value ml_SDL_EnableKeyRepeat(value odelay, value ointerval, value unit)
{
  int delay    = Opt_arg(odelay, Int_val, SDL_DEFAULT_REPEAT_DELAY);
  int interval = Opt_arg(ointerval, Int_val, SDL_DEFAULT_REPEAT_INTERVAL);
  SDL_EnableKeyRepeat(delay, interval);
  return Val_unit;
}

value ml_SDL_GetKeyState(value unit)
{
  int len;
  Uint8 *data = SDL_GetKeyState(&len);
  long llen = len;
  value v = alloc_bigarray(BIGARRAY_UINT8 | 
			   BIGARRAY_C_LAYOUT | 
			   BIGARRAY_EXTERNAL, 1, data, &llen);
  return v;
}

ML_0(SDL_GetModState, Val_int)
ML_1(SDL_SetModState, Int_val, Unit)

value ml_sdl_key_pressed(value ksym)
{
  int len;
  Uint8 *keystate = SDL_GetKeyState(&len);
  return Val_bool( keystate[ Int_val(ksym) ] );
}
