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

/* $Id: stub_shared.c,v 1.1 2000/03/05 15:20:28 fbrunel Exp $ */

#include <stdio.h>
#include "stub_shared.h"

void
finalize_surface (value final_surface)
{
#ifdef __DEBUG__
  fprintf(stderr, "Freeing surface: %p\n",
	  SDL_FINAL_SURFACE(final_surface));
#endif __DEBUG__  
}

