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

/* $Id: sdlevent_stub.c,v 1.3 2000/01/13 17:45:10 smkl Exp $ */

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <stdio.h>
#include <SDL.h>
#include "sdlevent_stub.h"

/*
 * Constants
 */

#define MAX_FUNC_ARGS 4

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

/*
 * Local functions for converting SDL events to OCamlSDL events callbacks
 */

static void
treat_keyboard_event (SDL_KeyboardEvent *event)
{
#ifdef __DEBUG_EVENT
  printf("Keyboard event (type = %d, state = %d, sym = %d)\n",
	 event->type, event->state, event->keysym.sym);
#endif

  if (keyboard_event_func != Val_unit) {
    int mouse_x;
    int mouse_y;

    printf("%d", event->keysym.sym);
    
    /* Get the mouse position */
    SDL_GetMouseState(&mouse_x, &mouse_y);

    /* Fill the arguments array */
    func_args[0] = Val_int(event->keysym.sym);
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
#ifdef __DEBUG_EVENT  
  printf("Mouse button event (type = %d, state = %d, button = %d, x = %d, y = %d)\n",
	 event->type, event->state, event->button, event->x,
	 event->y);
#endif
  
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
#ifdef __DEBUG_EVENT
  printf("Mouse motion event (type = %d, state = %d, x = %d, y = %d, xrel = %d, yrel = %d)\n",
	 event->type, event->state, event->x, event->y, event->xrel,
	 event->yrel);
#endif

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
  SDL_EventState(SDL_JOYMOTION, SDL_IGNORE);
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
