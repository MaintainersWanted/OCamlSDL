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

/* $Id: sdl_stub.c,v 1.4 2000/05/05 09:45:56 xtrm Exp $ */

#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/mlvalues.h>
#include <SDL/SDL.h>
#include "sdlcdrom_stub.h"
#include "sdlevent_stub.h"
#include "sdltimer_stub.h"
#include "sdlvideo_stub.h"
#include "sdlttf_stub.h"
#include "sdlmixer_stub.h"

/*
 * Local functions
 */

/* Shut down the SDL with all stubs */
static void sdl_internal_quit (void)
{
  /* Shut down SDL */
  SDL_Quit();

  /* Shut down all stubs */
  sdlcdrom_stub_kill();
  sdlevent_stub_kill();
  sdltimer_stub_kill();
  sdlvideo_stub_kill();
  sdlttf_stub_kill();
  sdlmixer_stub_kill();
}

/*
 * OCaml/C conversion functions
 */

value
sdl_init (void)
{
  /* SDL initialization */
  if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_CDROM | SDL_INIT_TIMER) != 0) {
    raise_with_string(*caml_named_value("SDL_init_exception"), SDL_GetError());
  }

  /* Initialize all stubs */
  sdlcdrom_stub_init();
  sdlevent_stub_init();
  sdltimer_stub_init();
  sdlvideo_stub_init();
  sdlttf_stub_init();
  sdlmixer_stub_init();
  
  return Val_unit;
}

value
sdl_init_with_auto_clean (void)
{
  sdl_init();
  atexit(sdl_internal_quit);
  
  return Val_unit;
}

value
sdl_quit (void)
{
  sdl_internal_quit();
  return Val_unit;
}
