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

/* $Id: sdlttf_stub.h,v 1.2 2002/07/13 17:13:07 oliv__a Exp $ */

#ifndef __SDLTTF_STUB_H__
#define __SDLTTF_STUB_H__

#include "common.h"

/* Init the stub internal datas */
extern void sdlttf_stub_init (void);

/* Clean the stub internal datas */
extern void sdlttf_stub_kill (void);

/*
 * Convertion Macros
 */
#ifdef __GNUC__ /* typechecked macro */
#define ML_FONT(f)  ( { TTF_Font *_mlsdl__f=f; abstract_ptr(_mlsdl__f); } )
#else
#define ML_FONT(f)  abstract_ptr(f);
#endif
#define SDL_FONT(f) ((TTF_Font *)Field((f), 0))

#endif /* __SDLTTF_STUB_H__ */

