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

/* $Id: sdltimer_stub.c,v 1.8 2002/09/24 22:34:54 oliv__a Exp $ */

#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/mlvalues.h>
#include <SDL.h>

/*
 * OCaml/C conversion functions
 */

void enter_blocking_section(void);
void leave_blocking_section(void);

value
sdltimer_delay (value ms)
{
  enter_blocking_section();
  SDL_Delay(Int_val(ms));
  leave_blocking_section();
  return Val_unit;
}

value sdltimer_get_ticks(value u) 
{
  return Val_int(SDL_GetTicks());
}
