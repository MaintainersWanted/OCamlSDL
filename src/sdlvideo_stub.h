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

/* $Id: sdlvideo_stub.h,v 1.3 2002/08/09 15:39:22 oliv__a Exp $ */

#ifndef __SDLVIDEO_STUB_H__
#define __SDLVIDEO_STUB_H__

#include "common.h"

/* Init the stub internal datas */
extern void sdlvideo_stub_init (void);

/* Clean the stub internal datas */
extern void sdlvideo_stub_kill (void);


/*
 * Convertion Macros
 */

/* Simple surfaces (not finalized) */
#ifdef __GNUC__ /* typechecked macro */
#define ML_SURFACE(surface)  ( { SDL_Surface *_mlsdl__s=surface; \
                                 abstract_ptr(_mlsdl__s); } )
#else
#define ML_SURFACE(surface)  abstract_ptr(surface);
#endif
#define SDL_SURFACE(surface) ((SDL_Surface *)Field((surface), 0))

#ifdef __GNUC__
#define SDL_COLOR_FROM_VALUE(ml_color, c_color) ( {\
value _mlsdl__val = ml_color; \
SDL_Color _mlsdl__color = c_color; \
_mlsdl__color.r = Int_val(Field(_mlsdl__val,0));\
_mlsdl__color.g = Int_val(Field(_mlsdl__val,1));\
_mlsdl__color.b = Int_val(Field(_mlsdl__val,2)); } )
#else
#define SDL_COLOR_FROM_VALUE(ml_color, c_color)\
(&(c_color))->r = Int_val(Field((ml_color),0));\
(&(c_color))->g = Int_val(Field((ml_color),1));\
(&(c_color))->b = Int_val(Field((ml_color),2));
#endif

#endif /* __SDLVIDEO_STUB_H__ */
