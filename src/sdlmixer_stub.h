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

/* $Id: sdlmixer_stub.h,v 1.2 2002/07/17 13:35:04 oliv__a Exp $ */

#ifndef __SDLMIXER_STUB_H__
#define __SDLMIXER_STUB_H__

/* Init the stub internal datas */
extern void sdlmixer_stub_init (void);

/* Clean the stub internal datas */
extern void sdlmixer_stub_kill (void);

/*
 * Convertion Macros
 */

/* Simple surfaces (not finalized) */
#ifdef __GNUC__ /* typechecked macro */
#define ML_CHUNK(chunk)  ( { Mix_Chunk *_mlsdl__c=chunk; \
                             abstract_ptr(_mlsdl__c); } )
#else
#define ML_CHUNK(chunk)  abstract_ptr(chunk);
#endif
#define SDL_CHUNK(chunk) ((Mix_Chunk *)Field((chunk), 0))


#ifdef __GNUC__ /* typechecked macro */
#define ML_MUS(music)  ( { Mix_Music *_mlsdl__m=music; \
                           abstract_ptr(_mlsdl__m); } )
#else
#define ML_MUS(music)  abstract_ptr(music);
#endif
#define SDL_MUS(music) ((Mix_Music *)Field((music), 0))


#endif /* __SDLMIXER_STUB_H__ */

