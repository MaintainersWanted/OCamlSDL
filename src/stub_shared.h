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

/* $Id: stub_shared.h,v 1.1 2000/03/05 15:20:41 fbrunel Exp $ */

#ifndef __STUB_SHARED_H__
#define __STUB_SHARED_H__

#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <SDL.h>

/* The finalization function prototype */
typedef void *FINAL_FUN (value);

/*
 * Macros
 */

/* This macro allocate a finalized block of 1 word wide for containing
   a pointer to a malloc'ed memory block. The finalization function
   (final_fun) is called when the block is about to be reclaimed.
   The CAMLparam, CAMLlocal and CAMLreturn macros must be used in the
   function which call this macro. cf. O'Caml doc. */
#define ALLOC_FINAL_PTR(ptr, final_fun, result)		\
	{ result = alloc_final(2, final_fun, 1, 1);	\
	  ((long *)result)[1] = (long)ptr; }

/* This macro give access to the pointer stored in a finalized block */
#define GET_FINAL_PTR(final_block) ((long *)final_block)[1]

/*
 * Convertion Macros
 */

/* Convert an SDL surface to an ML finalized surface */
#define ML_FINAL_SURFACE(surface, result) \
	ALLOC_FINAL_PTR(surface, finalize_surface, result)

/* Convert an ML finalized surface to an SDL surface */
#define SDL_FINAL_SURFACE(surface) (SDL_Surface *)GET_FINAL_PTR(surface)

/* Simple surfaces (not finalized) */
#define ML_SURFACE(surface) (value)surface
#define SDL_SURFACE(surface) ((SDL_Surface *)surface)

/*
 * Finalization functions
 */

extern void finalize_surface (value final_surface);

#endif /* __STUB_SHARED_H__ */
