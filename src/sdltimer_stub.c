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

/* $Id: sdltimer_stub.c,v 1.11 2003/11/16 14:26:38 oliv__a Exp $ */

#include <SDL.h>

#include "common.h"

/*
 * OCaml/C conversion functions
 */

CAMLprim value
sdltimer_delay (value ms)
{
  enter_blocking_section();
  SDL_Delay(Int_val(ms));
  leave_blocking_section();
  return Val_unit;
}

CAMLprim value sdltimer_get_ticks(value u) 
{
  return Val_int(SDL_GetTicks());
}
