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

/* $Id: sdl_stub.c,v 1.1.1.1 2000/01/02 01:32:25 fbrunel Exp $ */

#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/mlvalues.h>
#include <SDL.h>

/*
 * OCaml/C conversion functions
 */

value
sdl_init (void)
{
  if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_CDROM | SDL_INIT_TIMER) != 0) {
    raise_with_string(*caml_named_value("SDL_init_exception"), SDL_GetError());
  }
    
  return Val_unit;
}

value
sdl_init_with_auto_clean (void)
{
  sdl_init();
  atexit(SDL_Quit);
  
  return Val_unit;
}

value
sdl_quit (void)
{
  SDL_Quit();
  
  return Val_unit;
}
