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

/* $Id: sdl_stub.c,v 1.17 2003/02/24 22:55:10 oliv__a Exp $ */

#include <string.h>

#include <caml/callback.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/mlvalues.h>


#include <SDL.h>


#include "config.h"
#include "common.h"


/*
 * Local functions
 */

/* Shut down the SDL with all stubs */
static void sdl_internal_quit (void)
{
  /* Shut down SDL */
  SDL_Quit();
}

/*

  conversion between OCAMLSDL flags and C SDL flags

*/
#include "sdlinit_flag.h"
#include "sdlinit_flag.c"

static int init_flag_val(value flag_list)
{
  int flag = 0;
  value l = flag_list;

  while (is_not_nil(l)){
    flag |= Init_flag_val(hd(l)); 
    l = tl(l);
  }
  return flag;
}


/*
 * OCaml/C conversion functions
 */

CAMLprim value 
sdl_init(value auto_clean, value vf) 
{
  int flags = init_flag_val(vf);
  int clean = Opt_arg(auto_clean, Bool_val, 0);

  if (SDL_Init(flags) < 0) 
    raise_with_string(*caml_named_value("SDL_init_exception"),
		      SDL_GetError());

  if(clean)
    atexit(sdl_internal_quit);

  return Val_unit;
}

CAMLprim value
sdl_quit (value unit)
{
  sdl_internal_quit();
  return Val_unit;
}

CAMLprim value
sdl_init_subsystem (value vf)
{
  int flags = init_flag_val(vf);
  if (SDL_Init(flags) < 0) 
    raise_with_string(*caml_named_value("SDL_init_exception"),
		      SDL_GetError());
  return Val_unit;
}

CAMLprim value
sdl_quit_subsystem (value vf)
{
  int flags = init_flag_val(vf);
  SDL_QuitSubSystem(flags);
  return Val_unit;
}

CAMLprim value
sdl_was_init (value unit)
{
  Uint32 flags = SDL_WasInit(0);
  value l = nil();
  lookup_info *table = ml_table_init_flag;
  int i;
  for (i = table[0].data; i > 0; i--)
    if (flags & table[i].data && table[i].data != SDL_INIT_EVERYTHING) 
      l = cons(table[i].key, l);
  return l;
}

CAMLprim value
sdl_version (value unit)
{
  const SDL_version *v;
  value r;
  v = SDL_Linked_Version();
  r = alloc_small(3, 0);
  Field(r, 0) = Val_int(v->major);
  Field(r, 1) = Val_int(v->minor);
  Field(r, 2) = Val_int(v->patch);
  return r;
}

/* a shameless cut-and-paste from putenv.c in the caml Unix module
   sources ... */
CAMLprim value sdl_putenv(value name, value val)
{
  mlsize_t namelen = string_length(name);
  mlsize_t vallen = string_length(val);
  char * s = stat_alloc(namelen + 1 + vallen + 1);

  memmove (s, String_val(name), namelen);
  if(vallen > 0) {
    s[namelen] = '=';
    memmove (s + namelen + 1, String_val(val), vallen);
    s[namelen + 1 + vallen] = 0;
  }
  else
    s[namelen] = 0;
  if (putenv(s) == -1) raise_out_of_memory();
  return Val_unit;
}
