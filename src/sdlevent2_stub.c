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

/* $Id: sdlevent2_stub.c,v 1.2 2002/08/26 16:07:59 xtrm Exp $ */

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>

#include <error.h>

#include <SDL.h>

#include "common.h"
#include "sdlmouse_stub.h"

ML_0(SDL_PumpEvents, Unit)

static void raise_event_exn(char *msg)
{
  static value *exn = NULL;
  if(! exn){
    exn = caml_named_value("sdlevent_exn");
    if(! exn)
      error(-1, 0, "exception not registered.");
  }
  raise_with_string(*exn, msg);
}

static value value_of_active_state(Uint8 state)
{
  value v = nil();
  if(state & SDL_APPMOUSEFOCUS)
    v = cons(Val_int(0), v);
  if(state & SDL_APPINPUTFOCUS)
    v = cons(Val_int(1), v);
  if(state & SDL_APPACTIVE)
    v = cons(Val_int(2), v);
  return v;
}

value mlsdlevent_get_app_state(value unit)
{
  return value_of_active_state( SDL_GetAppState() );
}

static Uint8 state_of_value(value l)
{
  Uint8 state = 0;
  while(is_not_nil(l)){
    state |= Int_val(hd(l));
    l = tl(l);
  }
  return state;
}

static value find_mlsdl_keysym(SDLKey key)
{
  static value *table = NULL;
  if(! table){
    table = caml_named_value("rev_keycode_table");
    if(! table)
      raise_event_exn("keysyms lookup table not registered !");
  }
  return Field(*table, key);
}

static SDLKey find_sdl_keysym(value mlkey)
{
  static value *table = NULL;
  if(! table){
    table = caml_named_value("keycode_table");
    if(! table)
      raise_event_exn("keysyms lookup table not registered !");
  }
  return Int_val(Field(*table, Int_val(mlkey)));
}

static value value_of_SDLEvent(SDL_Event evt)
{
  CAMLparam0();
  CAMLlocal3(v, r, t);
  tag_t tag;
  switch(evt.type){
  case SDL_ACTIVEEVENT :
    t = value_of_active_state(evt.active.state);
    r = alloc_small(2, 0);
    Field(r, 0) = Val_bool(evt.active.gain);
    Field(r, 1) = t;
    v = alloc_small(1, 0);
    Field(v, 0) = r;
    break ;
  case SDL_KEYDOWN :
  case SDL_KEYUP :
    r = alloc_small(3, 0);
    Field(r, 0) = Val_int(evt.key.which) ;
    Field(r, 1) = Val_int(evt.key.state) ; 
    /* SDL_PRESSED = 0x01, SDL_RELEASED = 0x00 */
    Field(r, 2) = find_mlsdl_keysym(evt.key.keysym.sym) ;
    Field(r, 3) = Val_int(evt.key.keysym.mod) ;
    tag = evt.key.state == SDL_PRESSED ? 1 : 2 ;
    v = alloc_small(1, tag);
    Field(v, 0) = r ;
    break ;
  case SDL_MOUSEMOTION :
    t = value_of_mousebutton_state(evt.motion.state);
    r = alloc_small(6, 0);
    Field(r, 0) = Val_int(evt.motion.which);
    Field(r, 1) = t;
    Field(r, 2) = Val_int(evt.motion.x);
    Field(r, 3) = Val_int(evt.motion.y);
    Field(r, 4) = Val_int(evt.motion.xrel);
    Field(r, 5) = Val_int(evt.motion.yrel);
    v = alloc_small(1, 3);
    Field(v, 0) = r;
    break ;
  case SDL_MOUSEBUTTONDOWN :
  case SDL_MOUSEBUTTONUP :
    r = alloc_small(5, 0);
    Field(r, 0) = Val_int(evt.button.which);
    Field(r, 1) = Val_int(evt.button.button - 1);
    Field(r, 2) = Val_int(evt.button.state);
    Field(r, 3) = Val_int(evt.button.x);
    Field(r, 4) = Val_int(evt.button.y);
    tag = evt.button.state == SDL_PRESSED ? 4 : 5;
    v = alloc_small(1, tag);
    Field(v, 0) = r ;
    break ;
  case SDL_JOYAXISMOTION :
    r = alloc_small(3, 0);
    Field(r, 0) = Val_int(evt.jaxis.which);
    Field(r, 1) = Val_int(evt.jaxis.axis);
    Field(r, 2) = Val_int(evt.jaxis.value);
    v = alloc_small(1, 6);
    Field(v, 0) = r;
    break ;
  case SDL_JOYBALLMOTION :
    r = alloc_small(4, 0);
    Field(r, 0) = Val_int(evt.jball.which);
    Field(r, 1) = Val_int(evt.jball.ball);
    Field(r, 3) = Val_int(evt.jball.xrel);
    Field(r, 3) = Val_int(evt.jball.yrel);
    v = alloc_small(1, 7);
    Field(v, 0) = r;
    break ;
  case SDL_JOYHATMOTION :
    r = alloc_small(3, 0);
    Field(r, 0) = Val_int(evt.jhat.which);
    Field(r, 1) = Val_int(evt.jhat.hat);
    Field(r, 2) = Val_int(evt.jhat.value);
    v = alloc_small(1, 8);
    Field(v, 0) = r;
    break ;
  case SDL_JOYBUTTONDOWN :
  case SDL_JOYBUTTONUP :
    r = alloc_small(3, 0);
    Field(r, 0) = Val_int(evt.jbutton.which);
    Field(r, 1) = Val_int(evt.jbutton.button);
    Field(r, 2) = Val_int(evt.jbutton.state);
    tag = evt.jbutton.state == SDL_PRESSED ? 9 : 10 ;
    v = alloc_small(1, tag);
    Field(v, 0) = r;
    break ;
  case SDL_QUIT :
    v = Val_int(0);
    break;
  case SDL_SYSWMEVENT :
    v = Val_int(1);
    break;
  case SDL_VIDEORESIZE :
    r = alloc_small(2, 0);
    Field(r, 0) = Val_int(evt.resize.w);
    Field(r, 1) = Val_int(evt.resize.h);
    v = alloc_small(1, 11);
    Field(v, 0) = r;
    break;
  case SDL_VIDEOEXPOSE :
    v = Val_int(2);
    break;
  case SDL_USEREVENT :
    v = alloc_small(1, 12);
    Field(v, 0) = Val_int(evt.user.code);
    break;
  }
  CAMLreturn(v);
}

static SDL_Event SDLEvent_of_value(value e)
{
  SDL_Event evt;
  if(Is_long(e))
    switch(Int_val(e)){
    case 0 :
      evt.type = SDL_QUIT; break;
    case 1:
      goto invalid;
    case 2:
      evt.type = SDL_VIDEOEXPOSE; break ;
    default:
      abort();
    }
  else {
    value r = Field(e, 0);
    switch(Tag_val(e)){
    case 0 :
      evt.type = SDL_ACTIVEEVENT;
      evt.active.gain  = Bool_val(Field(r, 0));
      evt.active.state = state_of_value(Field(r, 1));
      break ;
    case 1:
    case 2:
      evt.type = Tag_val(e) == 1 ? SDL_KEYDOWN : SDL_KEYUP ;
      evt.key.which = Int_val(Field(r, 0));
      evt.key.state = Int_val(Field(r, 1));
      evt.key.keysym.scancode = 0;
      evt.key.keysym.sym = find_sdl_keysym(Field(r, 2)) ;
      evt.key.keysym.mod = Int_val(Field(r, 3));
      evt.key.keysym.unicode = 0;
    case 3:
      evt.type = SDL_MOUSEMOTION;
      evt.motion.which = Int_val(Field(r, 0));
      evt.motion.state = state_of_value(Field(r, 1));
      evt.motion.x = Int_val(Field(r, 2));
      evt.motion.y = Int_val(Field(r, 3));
      evt.motion.xrel = Int_val(Field(r, 4));
      evt.motion.yrel = Int_val(Field(r, 5));
      break;
    case 4:
    case 5:
      evt.type = Tag_val(e) == 4 ? SDL_MOUSEBUTTONDOWN : SDL_MOUSEBUTTONUP ;
      evt.button.which  = Int_val(Field(r, 0));
      evt.button.button = Int_val(Field(r, 1));
      evt.button.state  = Int_val(Field(r, 2));
      evt.button.x      = Int_val(Field(r, 3));
      evt.button.y      = Int_val(Field(r, 4));
      break;
    case 6:
      evt.type = SDL_JOYAXISMOTION;
      evt.jaxis.which = Int_val(Field(r, 0));
      evt.jaxis.axis  = Int_val(Field(r, 1));
      evt.jaxis.value = Int_val(Field(r, 2));
      break ;
    case 7:
      evt.type = SDL_JOYBALLMOTION;
      evt.jball.which = Int_val(Field(r, 0));
      evt.jball.ball  = Int_val(Field(r, 1));
      evt.jball.xrel  = Int_val(Field(r, 2));
      evt.jball.yrel  = Int_val(Field(r, 3));
      break;
    case 8:
      evt.type = SDL_JOYHATMOTION;
      evt.jhat.which = Int_val(Field(r, 0));
      evt.jhat.hat   = Int_val(Field(r, 1));
      evt.jhat.value = Int_val(Field(r, 2));
      break;
    case 9:
    case 10:
      evt.type = Tag_val(e) == 0 ? SDL_JOYBUTTONDOWN : SDL_JOYBUTTONUP ;
      evt.jbutton.which  = Int_val(Field(r, 0));
      evt.jbutton.button = Int_val(Field(r, 1));
      evt.jbutton.state  = Int_val(Field(r, 2));
      break;
    case 11:
      evt.type = SDL_VIDEORESIZE ;
      evt.resize.w = Int_val(Field(r, 0));
      evt.resize.h = Int_val(Field(r, 1));
      break;
    case 12:
      evt.type = SDL_USEREVENT ;
      evt.user.code = Int_val(Field(e, 0));
      evt.user.data1 = NULL;
      evt.user.data2 = NULL;
      break;
    default:
      abort();
    }
  }
  return evt;

 invalid:
  invalid_argument("SDLEvent_of_value"); 

  return evt;  /* silence compiler */
}

value mlsdlevent_peek(value omask, value num)
{
  int n = Int_val(num);
  int m;
  SDL_Event evt[n];
  Uint32 mask = Opt_arg(omask, Int_val, SDL_ALLEVENTS);
  m = SDL_PeepEvents(evt, n, SDL_PEEKEVENT, mask);
  if(m < 0)
    raise_event_exn(SDL_GetError());
  {
    int i;
    CAMLparam0();
    CAMLlocal1(v);
    v = nil();
    for(i=m-1; i>=0; i--){
      value e = value_of_SDLEvent(evt[i]);
      v = cons(e, v);
    }
    CAMLreturn(v);
  }
}

value mlsdlevent_get(value omask, value num)
{
  int n = Int_val(num);
  int m;
  SDL_Event evt[n];
  Uint32 mask = Opt_arg(omask, Int_val, SDL_ALLEVENTS);
  m = SDL_PeepEvents(evt, n, SDL_GETEVENT, mask);
  if(m < 0)
    raise_event_exn(SDL_GetError());
  {
    int i;
    CAMLparam0();
    CAMLlocal1(v);
    v = nil();
    for(i=m-1; i>=0; i--){
      value e = value_of_SDLEvent(evt[i]);
      v = cons(e, v);
    }
    CAMLreturn(v);
  }
}

value mlsdlevent_add(value elist)
{
  int len = list_length(elist);
  SDL_Event evt[len];
  value l = elist;
  int i=0;
  while(is_not_nil(l)){
    evt[i] = SDLEvent_of_value(hd(l));
    l = tl(l);
    i++;
  }
  if(SDL_PeepEvents(evt, len, SDL_ADDEVENT, SDL_ALLEVENTS) < 0)
    raise_event_exn(SDL_GetError());
  return Val_unit;
}

value mlsdlevent_has_event(value unit)
{
  return Val_bool(SDL_PollEvent(NULL));
}

value mlsdlevent_poll(value unit)
{
  SDL_Event evt;
  value v = Val_none;
  if(SDL_PollEvent(&evt) == 1)
    v = Val_some( value_of_SDLEvent(evt) );
  return v;
}


value mlsdlevent_wait(value unit)
{
  if(! SDL_WaitEvent(NULL))
    raise_event_exn(SDL_GetError());
  return Val_unit;
}

value mlsdlevent_wait_event(value unit)
{
  SDL_Event evt;
  if(! SDL_WaitEvent(&evt))
    raise_event_exn(SDL_GetError());
  return value_of_SDLEvent(evt);
}

static const Uint8 evt_type_of_val [] = {
  SDL_ACTIVEEVENT, SDL_KEYDOWN, SDL_KEYUP, 
  SDL_MOUSEMOTION, SDL_MOUSEBUTTONDOWN, SDL_MOUSEBUTTONUP,
  SDL_JOYAXISMOTION, SDL_JOYBALLMOTION, SDL_JOYHATMOTION, 
  SDL_JOYBUTTONDOWN, SDL_JOYBUTTONUP, SDL_QUIT, SDL_SYSWMEVENT,
  SDL_VIDEORESIZE, SDL_VIDEOEXPOSE, SDL_USEREVENT, } ;

value mlsdlevent_get_state(value evt_v)
{
  return Val_bool( SDL_EventState( evt_type_of_val[ Int_val(evt_v) ], 
				   SDL_QUERY) );
}

value mlsdlevent_set_state(value state, value evt_v)
{
  int c_state = ( state == Val_true ? SDL_ENABLE : SDL_DISABLE ) ;
  SDL_EventState( evt_type_of_val[ Int_val(evt_v) ], c_state);
  return Val_unit;
}

value mlsdlevent_set_state_by_mask(value mask, value state)
{
  int c_state = ( state == Val_true ? SDL_ENABLE : SDL_DISABLE ) ;
  Uint32 c_mask = Int_val(mask);
  int i;
  for(i=SDL_NOEVENT + 1; i<SDL_NUMEVENTS; i++)
    if(SDL_EVENTMASK(i) & c_mask)
      SDL_EventState(i, c_state);
  return Val_unit;
}
