/*
 * OCamlSDL - An ML interface to the SDL library
 * Copyright (C) 1999  Frederic Brunel
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/* $Id: sdlloader_stub.c,v 1.15 2004/02/04 12:00:22 oliv__a Exp $ */

#include <string.h>

#include <SDL.h>
#include <SDL_image.h>

#include "common.h"
#include "sdlvideo_stub.h"
#include "sdlrwops_stub.h"

static void
sdlloader_raise_exception (char *msg) Noreturn;
static void
sdlloader_raise_exception (char *msg)
{
  static value *loader_exn = NULL;
  if(! loader_exn){
    loader_exn = caml_named_value("SDLloader_exception");
    if(! loader_exn) {
      fprintf(stderr, "exception not registered.");
      abort();
    }
  }
  raise_with_string(*loader_exn, msg);
}

CAMLprim value ml_IMG_Load(value file)
{
  SDL_Surface *s = IMG_Load(String_val(file));
  if(! s)
    sdlloader_raise_exception(IMG_GetError());
  return ML_SURFACE(s);
}

CAMLprim value ml_IMG_Load_RW(value o_autoclose, value rwops)
{
  int autoclose = Opt_arg(o_autoclose, Bool_val, SDL_TRUE);
  SDL_Surface *s = IMG_Load_RW(SDLRWops_val(rwops), autoclose);
  if(! s)
    sdlloader_raise_exception(IMG_GetError());
  return ML_SURFACE(s);
}

#if (SDL_IMAGE_VERSION >= 121)
CAMLprim value ml_IMG_ReadXPMFromArray(value string_arr)
{
  int len = Wosize_val(string_arr);
  LOCALARRAY(char *, xpm, len+1);
  SDL_Surface *s;
  memcpy(xpm, Bp_val(string_arr), Bsize_wsize(len));
  xpm[len] = NULL;
  s = IMG_ReadXPMFromArray(xpm);
  if(! s)
    sdlloader_raise_exception(IMG_GetError());
  return ML_SURFACE(s);
}
#else
Unsupported (IMG_ReadXPMFromArray)
#endif
