/*
 * OCamlSDL - An ML interface to the SDL library
 * Copyright (C) 2002 plusieurs personnes
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

/* $Id: sdljoystick_stub.c,v 1.5 2003/11/16 14:40:28 oliv__a Exp $ */

#include <SDL.h>

#include "common.h"

#ifdef __GNUC__ /* typechecked macro */
#define Val_SDLJoystick(p)  ( { SDL_Joystick *_mlsdl__j = p; \
                                abstract_ptr(_mlsdl__j); } )
#else
#define Val_SDLJoystick(p)  abstract_ptr(p);
#endif
#define SDLJoystick_val(v)  ((SDL_Joystick *)(Field(v, 0)))

static void mlsdljoystick_raise_exception (char *msg) Noreturn;
static void mlsdljoystick_raise_exception (char *msg)
{
  static value *joystick_exn = NULL;
  if(! joystick_exn)
    joystick_exn = caml_named_value("SDLjoystick_exception");
  raise_with_string(*joystick_exn, msg);
}

ML_0(SDL_NumJoysticks, Val_int)
ML_1(SDL_JoystickName, Int_val, copy_string)

CAMLprim value
ml_SDL_JoystickOpen(value index)
{
  SDL_Joystick *j = SDL_JoystickOpen(Int_val(index));
  if(! j)
    mlsdljoystick_raise_exception(SDL_GetError());
  return Val_SDLJoystick(j);
}

ML_1(SDL_JoystickOpened, Int_val, Val_bool)
ML_1(SDL_JoystickIndex, SDLJoystick_val, Val_int)
ML_1(SDL_JoystickNumAxes, SDLJoystick_val, Val_int)
ML_1(SDL_JoystickNumBalls, SDLJoystick_val, Val_int)
ML_1(SDL_JoystickNumHats, SDLJoystick_val, Val_int)
ML_1(SDL_JoystickNumButtons, SDLJoystick_val, Val_int)

ML_0(SDL_JoystickUpdate, Unit)

ML_1_name(ml_SDL_JoystickSetEventState, SDL_JoystickEventState, Bool_val, Unit)
CAMLprim value ml_SDL_JoystickGetEventState(value unit)
{
  return Val_bool(SDL_JoystickEventState(SDL_QUERY));
}

ML_2(SDL_JoystickGetAxis,   SDLJoystick_val, Int_val, Val_int)
ML_2(SDL_JoystickGetHat,    SDLJoystick_val, Int_val, Val_int);
ML_2(SDL_JoystickGetButton, SDLJoystick_val, Int_val, Val_bool);

CAMLprim value ml_SDL_JoystickGetBall(value j, value ball)
{
  int dx, dy;
  value v;
  SDL_JoystickGetBall(SDLJoystick_val(j), Int_val(ball), &dx, &dy);
  v = alloc_small(2, 0);
  Field(v, 0) = Val_int(dx);
  Field(v, 1) = Val_int(dy);
  return v;
}

ML_1(SDL_JoystickClose, SDLJoystick_val, Unit)
