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

/* $Id: stub_shared.h,v 1.2 2002/04/24 15:13:06 xtrm Exp $ */

#ifndef __STUB_SHARED_H__
#define __STUB_SHARED_H__

#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <SDL.h>

/*
 * Convertion Macros
 */

/* Simple surfaces (not finalized) */
#define ML_SURFACE(surface) (value)surface
#define SDL_SURFACE(surface) ((SDL_Surface *)surface)

#endif /* __STUB_SHARED_H__ */
