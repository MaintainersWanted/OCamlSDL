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

/* $Id: sdlevent_stub.c,v 1.9 2000/05/05 09:45:56 xtrm Exp $ */

#include <assert.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <stdio.h>
#include <SDL/SDL.h>
#include "sdlevent_stub.h"

/*
 * Constants
 */

#define MAX_FUNC_ARGS 4
#define MAX_KEY_SYMS 229

/*
 * Local variables
 */

/* This flag indicates the end of the event loop */
static char must_exit_loop;

/* OCaml event callbacks */
static value keyboard_event_func;
static value mouse_event_func;
static value mousemotion_event_func;
static value idle_event_func;

/* This array is used for passing arguments to OCaml callbacks */
static value func_args[MAX_FUNC_ARGS];

/* This array map the ML key values to the SDL ones */
static SDLKey sdl_key_syms[MAX_KEY_SYMS] = {
  SDLK_BACKSPACE,
  SDLK_TAB,
  SDLK_CLEAR,
  SDLK_RETURN,
  SDLK_PAUSE,
  SDLK_ESCAPE,
  SDLK_SPACE,
  SDLK_EXCLAIM,
  SDLK_QUOTEDBL,
  SDLK_HASH,
  SDLK_DOLLAR,
  SDLK_AMPERSAND,
  SDLK_QUOTE,
  SDLK_LEFTPAREN,
  SDLK_RIGHTPAREN,
  SDLK_ASTERISK,
  SDLK_PLUS,
  SDLK_COMMA,
  SDLK_MINUS,
  SDLK_PERIOD,
  SDLK_SLASH,
  SDLK_0,
  SDLK_1,
  SDLK_2,
  SDLK_3,
  SDLK_4,
  SDLK_5,
  SDLK_6,
  SDLK_7,
  SDLK_8,
  SDLK_9,
  SDLK_COLON,
  SDLK_SEMICOLON,
  SDLK_LESS,
  SDLK_EQUALS,
  SDLK_GREATER,
  SDLK_QUESTION,
  SDLK_AT,
  /* 
     Skip uppercase letters
  */
  SDLK_LEFTBRACKET,
  SDLK_BACKSLASH,
  SDLK_RIGHTBRACKET,
  SDLK_CARET,
  SDLK_UNDERSCORE,
  SDLK_BACKQUOTE,
  SDLK_a,
  SDLK_b,
  SDLK_c,
  SDLK_d,
  SDLK_e,
  SDLK_f,
  SDLK_g,
  SDLK_h,
  SDLK_i,
  SDLK_j,
  SDLK_k,
  SDLK_l,
  SDLK_m,
  SDLK_n,
  SDLK_o,
  SDLK_p,
  SDLK_q,
  SDLK_r,
  SDLK_s,
  SDLK_t,
  SDLK_u,
  SDLK_v,
  SDLK_w,
  SDLK_x,
  SDLK_y,
  SDLK_z,
  SDLK_DELETE,
  /* End of ASCII mapped keysyms */

  /* International keyboard syms */
  SDLK_WORLD_0,		/* 0xA0 */
  SDLK_WORLD_1,
  SDLK_WORLD_2,
  SDLK_WORLD_3,
  SDLK_WORLD_4,
  SDLK_WORLD_5,
  SDLK_WORLD_6,
  SDLK_WORLD_7,
  SDLK_WORLD_8,
  SDLK_WORLD_9,
  SDLK_WORLD_10,
  SDLK_WORLD_11,
  SDLK_WORLD_12,
  SDLK_WORLD_13,
  SDLK_WORLD_14,
  SDLK_WORLD_15,
  SDLK_WORLD_16,
  SDLK_WORLD_17,
  SDLK_WORLD_18,
  SDLK_WORLD_19,
  SDLK_WORLD_20,
  SDLK_WORLD_21,
  SDLK_WORLD_22,
  SDLK_WORLD_23,
  SDLK_WORLD_24,
  SDLK_WORLD_25,
  SDLK_WORLD_26,
  SDLK_WORLD_27,
  SDLK_WORLD_28,
  SDLK_WORLD_29,
  SDLK_WORLD_30,
  SDLK_WORLD_31,
  SDLK_WORLD_32,
  SDLK_WORLD_33,
  SDLK_WORLD_34,
  SDLK_WORLD_35,
  SDLK_WORLD_36,
  SDLK_WORLD_37,
  SDLK_WORLD_38,
  SDLK_WORLD_39,
  SDLK_WORLD_40,
  SDLK_WORLD_41,
  SDLK_WORLD_42,
  SDLK_WORLD_43,
  SDLK_WORLD_44,
  SDLK_WORLD_45,
  SDLK_WORLD_46,
  SDLK_WORLD_47,
  SDLK_WORLD_48,
  SDLK_WORLD_49,
  SDLK_WORLD_50,
  SDLK_WORLD_51,
  SDLK_WORLD_52,
  SDLK_WORLD_53,
  SDLK_WORLD_54,
  SDLK_WORLD_55,
  SDLK_WORLD_56,
  SDLK_WORLD_57,
  SDLK_WORLD_58,
  SDLK_WORLD_59,
  SDLK_WORLD_60,
  SDLK_WORLD_61,
  SDLK_WORLD_62,
  SDLK_WORLD_63,
  SDLK_WORLD_64,
  SDLK_WORLD_65,
  SDLK_WORLD_66,
  SDLK_WORLD_67,
  SDLK_WORLD_68,
  SDLK_WORLD_69,
  SDLK_WORLD_70,
  SDLK_WORLD_71,
  SDLK_WORLD_72,
  SDLK_WORLD_73,
  SDLK_WORLD_74,
  SDLK_WORLD_75,
  SDLK_WORLD_76,
  SDLK_WORLD_77,
  SDLK_WORLD_78,
  SDLK_WORLD_79,
  SDLK_WORLD_80,
  SDLK_WORLD_81,
  SDLK_WORLD_82,
  SDLK_WORLD_83,
  SDLK_WORLD_84,
  SDLK_WORLD_85,
  SDLK_WORLD_86,
  SDLK_WORLD_87,
  SDLK_WORLD_88,
  SDLK_WORLD_89,
  SDLK_WORLD_90,
  SDLK_WORLD_91,
  SDLK_WORLD_92,
  SDLK_WORLD_93,
  SDLK_WORLD_94,
  SDLK_WORLD_95,		/* 0xFF */

  /* Numeric keypad */
  SDLK_KP0,
  SDLK_KP1,
  SDLK_KP2,
  SDLK_KP3,
  SDLK_KP4,
  SDLK_KP5,
  SDLK_KP6,
  SDLK_KP7,
  SDLK_KP8,
  SDLK_KP9,
  SDLK_KP_PERIOD,
  SDLK_KP_DIVIDE,
  SDLK_KP_MULTIPLY,
  SDLK_KP_MINUS,
  SDLK_KP_PLUS,
  SDLK_KP_ENTER,
  SDLK_KP_EQUALS,

  /* Arrows + Home/End pad */
  SDLK_UP,
  SDLK_DOWN,
  SDLK_RIGHT,
  SDLK_LEFT,
  SDLK_INSERT,
  SDLK_HOME,
  SDLK_END,
  SDLK_PAGEUP,
  SDLK_PAGEDOWN,

  /* Function keys */
  SDLK_F1,
  SDLK_F2,
  SDLK_F3,
  SDLK_F4,
  SDLK_F5,
  SDLK_F6,
  SDLK_F7,
  SDLK_F8,
  SDLK_F9,
  SDLK_F10,
  SDLK_F11,
  SDLK_F12,
  SDLK_F13,
  SDLK_F14,
  SDLK_F15,

  /* Key state modifier keys */
  SDLK_NUMLOCK,
  SDLK_CAPSLOCK,
  SDLK_SCROLLOCK,
  SDLK_RSHIFT,
  SDLK_LSHIFT,
  SDLK_RCTRL,
  SDLK_LCTRL,
  SDLK_RALT,
  SDLK_LALT,
  SDLK_RMETA,
  SDLK_LMETA,
  SDLK_LSUPER,		/* Left "Windows" key */
  SDLK_RSUPER,		/* Right "Windows" key */
  SDLK_MODE,		/* "Alt Gr" key */

  /* Miscellaneous function keys */
  SDLK_HELP,
  SDLK_PRINT,
  SDLK_SYSREQ,
  SDLK_BREAK,
  SDLK_MENU,
  SDLK_POWER,		/* Power Macintosh power key */
  SDLK_EURO		/* Some european keyboards */
};

/*
 * Find the ML key index by the SDL key symbol
 */

static int
find_key_index (SDLKey key)
{
  int a = 0;
  int b = MAX_KEY_SYMS;
  int c;
  int prev_c = -1;

  /* Do a dichotomical search to find the key symbol in the array. It
     is better than a simple search, but a hashtable would be
     faster. Maybe the next time! ;-) */
  
  while (1) {
    c = (a + b) / 2;

    if (prev_c == c) {
      /* FATAL: SHOULD NOT HAPPEN! The key symbol is UNKNOWN! */
      assert(0);
    }
    prev_c = c;

    if (key == sdl_key_syms[c]) {
      return c;
    }
    else if (key > sdl_key_syms[c]) {
      a = c;
    }
    else {
      b = c;
    }
  }

  /* Never reached! */
  return -1;
}

/*
 * Local functions for converting SDL events to OCamlSDL events callbacks
 */

static void
treat_keyboard_event (SDL_KeyboardEvent *event)
{
  if (keyboard_event_func != Val_unit) {
    int mouse_x;
    int mouse_y;

/*    printf("%d", event->keysym.sym); */
    
    /* Get the mouse position */
    SDL_GetMouseState(&mouse_x, &mouse_y);

    /* Fill the arguments array */
    func_args[0] = Val_int(find_key_index(event->keysym.sym));
    func_args[1] = (event->state == SDL_PRESSED) ? Val_int(0) : Val_int(1);
    func_args[2] = Val_int(mouse_x);
    func_args[3] = Val_int(mouse_y);

    /* Call the OCaml closure */
    callbackN(keyboard_event_func, 4, func_args);
  }
}

static void
treat_mouse_event (SDL_MouseButtonEvent *event)
{
  if (mouse_event_func != Val_unit) {
    /* Fill the arguments array */
    func_args[0] = Val_int(event->button - 1);
    func_args[1] = (event->state == SDL_PRESSED) ? Val_int(0) : Val_int(1);
    func_args[2] = Val_int(event->x);
    func_args[3] = Val_int(event->y);

    /* Call the OCaml closure */
    callbackN(mouse_event_func, 4, func_args);
  }
}

static void
treat_mousemotion_event (SDL_MouseMotionEvent *event)
{
  if (mousemotion_event_func != Val_unit) {
    callback2(mousemotion_event_func, Val_int(event->x), Val_int(event->y));
  }
}

static void treat_idle_event (void)
{
  if (idle_event_func != Val_unit) {
    callback(idle_event_func, Val_unit);
  }
}

/*
 * Raise an OCaml exception with a message
 */

static void
sdlevent_raise_exception (char *msg)
{
  raise_with_string(*caml_named_value("SDLevent_exception"), msg);
}

/*
 * Stub initialization
 */

void
sdlevent_stub_init (void)
{
  int i;
  
  /* Register the global variables with the garbage collector */
  register_global_root(&keyboard_event_func);
  register_global_root(&mouse_event_func);
  register_global_root(&mousemotion_event_func);
  register_global_root(&idle_event_func);
  
  for(i = 0; i < MAX_FUNC_ARGS; i++) {
    register_global_root(func_args + i);
  }
  
  /* Set this variables to unit */
  keyboard_event_func = Val_unit;
  mouse_event_func = Val_unit;
  mousemotion_event_func = Val_unit;
  idle_event_func = Val_unit;

  /* Ignore unhandled events */
  SDL_EventState(SDL_ACTIVEEVENT, SDL_IGNORE);
#if SDL_MAJOR_VERSION == 1 && SDL_MINOR_VERSION == 1
  SDL_EventState(SDL_JOYAXISMOTION, SDL_IGNORE);
#else
  SDL_EventState(SDL_JOYMOTION, SDL_IGNORE);
#endif
  SDL_EventState(SDL_JOYBUTTONUP, SDL_IGNORE);
  SDL_EventState(SDL_JOYBUTTONDOWN, SDL_IGNORE);
  SDL_EventState(SDL_QUIT, SDL_IGNORE);
  SDL_EventState(SDL_SYSWMEVENT, SDL_IGNORE);
}

/*
 * Stub shut down
 */

void
sdlevent_stub_kill (void)
{
  int i;

  /* Un-register the global variables from the garbage collector */
  remove_global_root(&keyboard_event_func);
  remove_global_root(&mouse_event_func);
  remove_global_root(&mousemotion_event_func);
  remove_global_root(&idle_event_func);

  for(i = 0; i < MAX_FUNC_ARGS; i++) {
    remove_global_root(func_args + i);
  }
}

/*
 * OCaml/C conversion functions
 */

value
sdlevent_set_keyboard_event_func (value func)
{
  keyboard_event_func = func;
  return Val_unit;
}

value
sdlevent_set_mouse_event_func (value func)
{
  mouse_event_func = func;
  return Val_unit;
}

value
sdlevent_set_mousemotion_event_func (value func)
{
  mousemotion_event_func = func;
  return Val_unit;
}

value
sdlevent_set_idle_event_func (value func)
{
  idle_event_func = func;
  return Val_unit;
}

value
sdlevent_is_key_pressed (value key)
{
  unsigned char *keystate = SDL_GetKeyState(NULL);
  return Val_bool(keystate[sdl_key_syms[Int_val(key)]]);
}

value
sdlevent_is_button_pressed (value button)
{
  int buttonstate = SDL_GetMouseState(NULL, NULL);
  return Val_bool(SDL_BUTTON(Int_val(button) + 1));
}

value
sdlevent_get_mouse_position (void)
{
  CAMLparam0();
  CAMLlocal1(result);
  int x;
  int y;

  SDL_GetMouseState(&x, &y);
  
  result = alloc_tuple(2);
  Store_field(result, 0, Val_int(x));
  Store_field(result, 1, Val_int(y));

  CAMLreturn (result);
}

value
sdlevent_set_mouse_position (value x, value y)
{
  SDL_WarpMouse(Int_val(x), Int_val(y));
  return Val_unit;
}

value
sdlevent_start_event_loop (void)
{
  SDL_Event event;
  
  /* Clear the exit flag */
  must_exit_loop = 0;

  /* Delete the currently pending events */
  while (SDL_PollEvent(&event))
    ;
  
  /* The event loop */
  while (!must_exit_loop) {
    if (SDL_PollEvent(&event)) {
      /* Proceed with the event */
      switch(event.type)
	{
	case SDL_KEYDOWN:
	case SDL_KEYUP:
	  treat_keyboard_event(&(event.key));
	  break;

	case SDL_MOUSEBUTTONDOWN:
	case SDL_MOUSEBUTTONUP:
	  treat_mouse_event(&(event.button));
	  break;

	case SDL_MOUSEMOTION:
	  treat_mousemotion_event(&(event.motion));
	  break;

	default:
	  break;
	}
    }
    else {
      /* Call the idle function */
      treat_idle_event();
    }
  }
  
  return Val_unit;
}

value
sdlevent_exit_event_loop (void)
{
  /* Set the exit flag */
  must_exit_loop = 1;
  return Val_unit;
}
