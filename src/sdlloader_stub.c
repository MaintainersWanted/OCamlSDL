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

/* $Id: sdlloader_stub.c,v 1.10 2002/11/06 23:05:36 oliv__a Exp $ */

#include <string.h>

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>

#include <SDL.h>
#include <SDL_image.h>

#include "common.h"
#include "sdlvideo_stub.h"

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

value ml_IMG_Load(value file)
{
  SDL_Surface *s = IMG_Load(String_val(file));
  if(! s)
    sdlloader_raise_exception(IMG_GetError());
  return ML_SURFACE(s);
}


value ml_IMG_ReadXPMFromArray(value string_arr)
{
#if (IMAGE_RELEASE == 2)
  int len = Bosize_val(string_arr);
#ifdef __GNUC__
  char *xpm[len+1];
#else
  char *xpm = stat_alloc(len+1);
#endif
  SDL_Surface *s;
  memcpy(xpm, Bp_val(string_arr), len);
  xpm[len] = NULL;
  s = IMG_ReadXPMFromArray(xpm);
#ifndef __GNUC__
    stat_free(xpm);
#endif
  if(! s)
    sdlloader_raise_exception(IMG_GetError());
  return ML_SURFACE(s);
#else
  sdlloader_raise_exception("not supported");
  return Val_unit;
#endif
}




