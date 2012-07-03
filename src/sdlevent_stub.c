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

/* $Id: sdlevent_stub.c,v 1.27 2012/07/03 19:11:45 oliv__a Exp $ */

#include <SDL.h>

#include "common.h"
#include "sdlmouse_stub.h"

ML_0(SDL_PumpEvents, Unit)

static void raise_event_exn(char *msg) Noreturn;
static void raise_event_exn(char *msg)
{
  static value *exn = NULL;
  if(! exn){
    exn = caml_named_value("sdlevent_exn");
    if(! exn) {
      fprintf(stderr, "exception not registered.");
      abort();
    }
  }
  raise_with_string(*exn, msg);
}

static value value_of_active_state(Uint8 state)
{
  value v = nil();
  if(state & SDL_APPMOUSEFOCUS)
    v = mlsdl_cons(Val_int(0), v);
  if(state & SDL_APPINPUTFOCUS)
    v = mlsdl_cons(Val_int(1), v);
  if(state & SDL_APPACTIVE)
    v = mlsdl_cons(Val_int(2), v);
  return v;
}

CAMLprim value mlsdlevent_get_app_state(value unit)
{
  return value_of_active_state( SDL_GetAppState() );
}

static Uint8 state_of_value(value l)
{
  Uint8 state = 0;
  while(is_not_nil(l)){
    if (Is_long(hd(l)))
      state |= 1 << Int_val(hd(l));
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

static value value_of_keyevent(SDL_KeyboardEvent keyevt)
{
  CAMLparam0();
  CAMLlocal2(v, r);
  Uint8 char_code = 0;
  tag_t tag;
  r = alloc_small(6, 0);
  Field(r, 0) = Val_int(keyevt.which) ;
  Field(r, 1) = keyevt.state == SDL_RELEASED ? Val_int(0) : Val_int(1);
  Field(r, 2) = find_mlsdl_keysym(keyevt.keysym.sym) ;
  Field(r, 3) = Val_int(keyevt.keysym.mod) ;
  if (keyevt.keysym.unicode <= 0x7F)
    char_code = keyevt.keysym.unicode;
  Field(r, 4) = Val_int(char_code);
  Field(r, 5) = Val_long(keyevt.keysym.unicode);
  tag = keyevt.state == SDL_PRESSED ? 1 : 2 ;
  v = alloc_small(1, tag);
  Field(v, 0) = r;
  CAMLreturn(v);
} 

static value value_of_mouse_button(Uint8 b)
{
  value r;
  if (SDL_BUTTON_LEFT <= b && b <= SDL_BUTTON_WHEELDOWN)
    r = Val_int(b - 1);
  else {
    r = caml_alloc_small(1, 0);
    Field(r, 0) = Val_int(b);
  }
  return r;
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
    v = value_of_keyevent(evt.key);
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
    t = value_of_mouse_button(evt.button.button);
    r = alloc_small(5, 0);
    Field(r, 0) = Val_int(evt.button.which);
    Field(r, 1) = t;
    Field(r, 2) = evt.button.state == SDL_RELEASED ? Val_int(0) : Val_int(1);
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
    Field(r, 2) = Val_int(evt.jball.xrel);
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
    Field(r, 2) = evt.jbutton.state == SDL_RELEASED ? Val_int(0) : Val_int(1);
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
    v = alloc_small(2, 11);
    Field(v, 0) = Val_int(evt.resize.w);
    Field(v, 1) = Val_int(evt.resize.h);
    break;
  case SDL_VIDEOEXPOSE :
    v = Val_int(2);
    break;
  case SDL_USEREVENT :
    v = alloc_small(1, 12);
    Field(v, 0) = Val_int(evt.user.code);
    break;
  default : 
    /* unknown event ? -> raise an exception */
    raise_event_exn("unknown event");
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
      evt.type = SDL_VIDEOEXPOSE; break;
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
      break;
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
      evt.button.button = Is_long(Field(r, 1)) ? Int_val(Field(r, 1)) : Int_val(Field(Field(r, 1), 0));
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
      evt.resize.w = Int_val(Field(e, 0));
      evt.resize.h = Int_val(Field(e, 1));
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

CAMLprim value mlsdlevent_peek(value omask, value num)
{
  int n = Int_val(num);
  int m;
  LOCALARRAY(SDL_Event, evt, n);
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
      v = mlsdl_cons(e, v);
    }
    CAMLreturn(v);
  }
}

CAMLprim value mlsdlevent_get(value omask, value num)
{
  int n = Int_val(num);
  int m;
  LOCALARRAY(SDL_Event, evt, n);
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
      v = mlsdl_cons(e, v);
    }
    CAMLreturn(v);
  }
}

CAMLprim value mlsdlevent_add(value elist)
{
  int len = mlsdl_list_length(elist);
  LOCALARRAY(SDL_Event, evt, len);
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

CAMLprim value mlsdlevent_has_event(value unit)
{
  return Val_bool(SDL_PollEvent(NULL));
}

CAMLprim value mlsdlevent_poll(value unit)
{
  SDL_Event evt;
  value v = Val_none;
  if(SDL_PollEvent(&evt) == 1)
    v = Val_some( value_of_SDLEvent(evt) );
  return v;
}


CAMLprim value mlsdlevent_wait(value unit)
{
  int status;
  enter_blocking_section();
  status = SDL_WaitEvent(NULL);
  leave_blocking_section();
  if(! status)
    raise_event_exn(SDL_GetError());
  return Val_unit;
}

CAMLprim value mlsdlevent_wait_event(value unit)
{
  SDL_Event evt;
  int status;
  enter_blocking_section();
  status = SDL_WaitEvent(&evt);
  leave_blocking_section();
  if(! status)
    raise_event_exn(SDL_GetError());
  return value_of_SDLEvent(evt);
}

static const Uint8 evt_type_of_val [] = {
  SDL_ACTIVEEVENT, SDL_KEYDOWN, SDL_KEYUP, 
  SDL_MOUSEMOTION, SDL_MOUSEBUTTONDOWN, SDL_MOUSEBUTTONUP,
  SDL_JOYAXISMOTION, SDL_JOYBALLMOTION, SDL_JOYHATMOTION, 
  SDL_JOYBUTTONDOWN, SDL_JOYBUTTONUP, SDL_QUIT, SDL_SYSWMEVENT,
  SDL_VIDEORESIZE, SDL_VIDEOEXPOSE, SDL_USEREVENT, } ;

CAMLprim value mlsdlevent_get_state(value evt_v)
{
  return Val_bool( SDL_EventState( evt_type_of_val[ Int_val(evt_v) ], 
				   SDL_QUERY) );
}

CAMLprim value mlsdlevent_set_state(value state, value evt_v)
{
  int c_state = ( state == Val_true ? SDL_ENABLE : SDL_DISABLE ) ;
  SDL_EventState( evt_type_of_val[ Int_val(evt_v) ], c_state);
  return Val_unit;
}

CAMLprim value mlsdlevent_set_state_by_mask(value mask, value state)
{
  int c_state = ( state == Val_true ? SDL_ENABLE : SDL_DISABLE ) ;
  Uint32 c_mask = Int_val(mask);
  int i;
  for(i=0; i<SDL_TABLESIZE(evt_type_of_val); i++) {
    Uint8 type = evt_type_of_val[i];
    if(SDL_EVENTMASK(type) & c_mask)
      SDL_EventState(type, c_state);
  }
  return Val_unit;
}

CAMLprim value mlsdlevent_get_enabled(value unit)
{
  Uint32 mask = 0;
  register int i;
  for(i=0; i<SDL_TABLESIZE(evt_type_of_val); i++) {
    Uint8 type = evt_type_of_val[i];
    if(SDL_EventState(type, SDL_QUERY))
      mask |= SDL_EVENTMASK(type);
  }
  return Val_int(mask);
}
