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

/* $Id: sdlvideo_stub.c,v 1.2 2000/01/12 00:51:52 fbrunel Exp $ */

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <stdio.h>
#include <SDL.h>
#include "sdlvideo_stub.h"

/*
 * Conversion macros
 */

#define ML_SURFACE(surface) (value)surface
#define SDL_SURFACE(surface) ((SDL_Surface *)surface)

#define ML_PIXELFORMAT(pixel_format) (value)pixel_format
#define SDL_PIXELFORMAT(pixel_format) ((SDL_PixelFormat *)pixel_format)

#define ML_COLOR(color) Val_int(color)

#define MLRECT_TO_SDLRECT(ml_rect, sdl_rect)		\
	sdl_rect.x = Int_val(Field(ml_rect, 0));	\
	sdl_rect.y = Int_val(Field(ml_rect, 1));	\
	sdl_rect.w = Int_val(Field(ml_rect, 2));	\
	sdl_rect.h = Int_val(Field(ml_rect, 3));

/*
 * Raise an OCaml exception with a message
 */

static void
sdlvideo_raise_exception (char *msg)
{
  raise_with_string(*caml_named_value("SDLvideo_exception"), msg);
}

/*
 * Stub initialization
 */

void
sdlvideo_stub_init (void)
{
  return;
}

/*
 * Stub shut down
 */

void
sdlvideo_stub_kill (void)
{
  return;
}

/*
 * OCaml/C conversion functions
 */

value
sdlvideo_get_video_info (void)
{
  CAMLparam0();
  CAMLlocal1(result);
  SDL_VideoInfo *info = SDL_GetVideoInfo();

  result = alloc(10, 0);
  Store_field(result, 0, Val_bool(info->hw_available));
  Store_field(result, 1, Val_bool(info->wm_available));
  Store_field(result, 2, Val_bool(info->blit_hw));
  Store_field(result, 3, Val_bool(info->blit_hw_CC));
  Store_field(result, 4, Val_bool(info->blit_hw_A));
  Store_field(result, 5, Val_bool(info->blit_sw));
  Store_field(result, 6, Val_bool(info->blit_sw_CC));
  Store_field(result, 7, Val_bool(info->blit_sw_A));
  Store_field(result, 8, Val_bool(info->blit_fill));
  Store_field(result, 9, Val_int(info->video_mem));

  CAMLreturn result;
}

value
sdlvideo_get_display_surface (void)
{
  return ML_SURFACE(SDL_GetVideoSurface());
}

value
sdlvideo_set_display_mode (value width, value height, value bpp)
{
  SDL_Surface *surf;
  int depth = Int_val(bpp);
  
  /* Modes not implemented */
  if (depth != 0 && depth < 15) {
    sdlvideo_raise_exception("Bit depth not implemented");
  }

  surf = SDL_SetVideoMode(Int_val(width),
			  Int_val(height),
			  Int_val(bpp),
			  SDL_HWSURFACE | SDL_DOUBLEBUF);
  
  if (surf == NULL) {
    sdlvideo_raise_exception(SDL_GetError());
  }

  return ML_SURFACE(surf);
}

value
sdlvideo_flip (value surface)
{
  if (SDL_Flip(SDL_SURFACE(surface)) < 0) {
    sdlvideo_raise_exception(SDL_GetError());
  }

  return Val_unit;
}

value
sdlvideo_update_rect (value surface, value rect)
{
  SDL_Surface *surf = SDL_SURFACE(surface);
  SDL_Rect sdl_rect;

  MLRECT_TO_SDLRECT(rect, sdl_rect);
  SDL_UpdateRects(surf, 1, &sdl_rect);
  
  return Val_unit;
}

value
sdlvideo_surface_free (value surface)
{
  SDL_FreeSurface(SDL_SURFACE(surface));
  return Val_unit;
}

value
sdlvideo_surface_loadBMP (value path)
{
  SDL_Surface *surf = SDL_LoadBMP(String_val(path));

  if (surf == NULL) {
    sdlvideo_raise_exception(SDL_GetError());
  }

  return ML_SURFACE(surf);
}

value
sdlvideo_surface_saveBMP (value surface, value path)
{
  if (SDL_SaveBMP(SDL_SURFACE(surface), String_val(path)) < 0) {
    sdlvideo_raise_exception(SDL_GetError());
  }

  return Val_unit;
}

value
sdlvideo_surface_width (value surface)
{
  return Val_int(SDL_SURFACE(surface)->w);
}

value
sdlvideo_surface_height (value surface)
{
  return Val_int(SDL_SURFACE(surface)->h);
}

value
sdlvideo_surface_pixel_format (value surface)
{
  return ML_PIXELFORMAT(SDL_SURFACE(surface)->format);
}

value
sdlvideo_surface_fill_rect (value surface, value rect, value color)
{
  SDL_Rect sdl_rect;

  MLRECT_TO_SDLRECT(rect, sdl_rect);

  if (SDL_FillRect(SDL_SURFACE(surface), &sdl_rect, Int_val(color)) < 0) {
    sdlvideo_raise_exception(SDL_GetError());
  }

  return ML_SURFACE(surface);
}

value
sdlvideo_surface_blit (value surface_src, value rect_src,
		       value surface_dst, value rect_dst)
{
  SDL_Surface *src;
  SDL_Rect srcrect;
  SDL_Surface *dst;
  SDL_Rect dstrect;

  src = SDL_SURFACE(surface_src);
  MLRECT_TO_SDLRECT(rect_src, srcrect);
  dst = SDL_SURFACE(surface_dst);
  MLRECT_TO_SDLRECT(rect_dst, dstrect);

  if (SDL_BlitSurface(src, &srcrect, dst, &dstrect) < 0) {
    sdlvideo_raise_exception(SDL_GetError());
  }
  
  return Val_unit;
}

value
sdlvideo_surface_set_alpha (value surface, value alpha)
{
  float a = (float)Double_val(alpha);
  
  if (a != 0.0f) {
    SDL_SetAlpha(SDL_SURFACE(surface), SDL_SRCALPHA,
		 (char)(a * 255));
  }
  else {
    SDL_SetAlpha(SDL_SURFACE(surface), 0, 0);
  }
  
  return surface;
}

value
sdlvideo_make_rgb_color (value pixel_format, value red, value green, value blue)
{
  float r = (float)Double_val(red);
  float g = (float)Double_val(green);
  float b = (float)Double_val(blue);
  
  return ML_COLOR(SDL_MapRGB(SDL_PIXELFORMAT(pixel_format),
			     (char)(r * 255),
			     (char)(g * 255),
			     (char)(b * 255)));
}

value
sdlvideo_wm_available (void)
{
  return Val_bool(SDL_GetVideoInfo()->wm_available);
}
