/* $Id: sdlkey_stub.c,v 1.2 2002/08/23 09:52:23 xtrm Exp $ */

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
