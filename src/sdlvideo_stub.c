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

/* $Id: sdlvideo_stub.c,v 1.10 2000/03/05 15:21:52 fbrunel Exp $ */

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <stdio.h>
#include <SDL.h>
#include "stub_shared.h"
#include "sdlvideo_stub.h"

/*
 * Conversion macros
 */

#define MLRECT_TO_SDLRECT(ml_rect, sdl_rect)		\
	sdl_rect.x = Int_val(Field(ml_rect, 0));	\
	sdl_rect.y = Int_val(Field(ml_rect, 1));	\
	sdl_rect.w = Int_val(Field(ml_rect, 2));	\
	sdl_rect.h = Int_val(Field(ml_rect, 3));

#define MLRECT_IS_MAX(ml_rect) (Int_val(ml_rect) == 0)

/*
 * Convert a color from the ML side into three integers between 0 and 255
 */

static void
convert_color (value color, unsigned char *r, unsigned char *g,
	       unsigned char *b)
{
  /* Maybe there is a more general method to identify the right
     type constructor ? */
  if (Is_long(Field(color, 0))) {
    *r = (unsigned char)Int_val(Field(color, 0));
    *g = (unsigned char)Int_val(Field(color, 1));
    *b = (unsigned char)Int_val(Field(color, 2));
  }
  else {
    *r = (unsigned char)(Double_val(Field(color, 0)) * 255);
    *g = (unsigned char)(Double_val(Field(color, 1)) * 255);
    *b = (unsigned char)(Double_val(Field(color, 2)) * 255);
  }
}

/*
 * Make a SDL color matching the surface pixel format
 */

static int
map_rgb_color (value surface, value color)
{
  unsigned char r, g, b;

  convert_color(color, &r, &g, &b);
  return SDL_MapRGB(SDL_SURFACE(surface)->format, r, g, b);
}

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

  CAMLreturn(result);
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
    sdlvideo_raise_exception("Bit depth not implemented!");
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

  if (MLRECT_IS_MAX(rect)) {
    SDL_UpdateRect(surf, 0, 0, 0, 0);
  }
  else {
    MLRECT_TO_SDLRECT(rect, sdl_rect);
    SDL_UpdateRects(surf, 1, &sdl_rect);
  }
  
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
  SDL_PixelFormat format;
  SDL_Surface *converted; 
  SDL_Surface *surf = SDL_LoadBMP(String_val(path));

  if (surf == NULL) {
    sdlvideo_raise_exception(SDL_GetError());
  }

  memset(&format, 0, sizeof(format)); 
  format.BytesPerPixel = 3;
  format.BitsPerPixel = 24;
  format.Rmask = 0x000000ff;
  format.Gmask = 0x0000ff00;
  format.Bmask = 0x00ff0000;
  
  converted = SDL_ConvertSurface(surf, &format, SDL_SWSURFACE);
  if (converted == NULL) {
    sdlvideo_raise_exception(SDL_GetError());
  }
  SDL_FreeSurface(surf);
  
  return ML_SURFACE(converted);
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
sdlvideo_surface_fill_rect (value surface, value rect, value color)
{
  SDL_Rect sdl_rect;
  int res;
  
  if (MLRECT_IS_MAX(rect)) {
    res = SDL_FillRect(SDL_SURFACE(surface), NULL,
		       map_rgb_color(surface, color));
  }
  else {
    MLRECT_TO_SDLRECT(rect, sdl_rect);
    res = SDL_FillRect(SDL_SURFACE(surface), &sdl_rect,
		       map_rgb_color(surface, color));
  }
    
  if (res < 0) {
    sdlvideo_raise_exception(SDL_GetError());
  }

  return ML_SURFACE(surface);
}

value
sdlvideo_surface_blit (value surface_src, value rect_src,
		       value surface_dst, value rect_dst)
{
  SDL_Surface *src;
  SDL_Surface *dst;
  SDL_Rect src_conv_rect;
  SDL_Rect dst_conv_rect;
  SDL_Rect *src_sdl_rect = NULL;
  SDL_Rect *dst_sdl_rect = NULL;
  
  src = SDL_SURFACE(surface_src);
  dst = SDL_SURFACE(surface_dst);

  if (!MLRECT_IS_MAX(rect_src)) {
    MLRECT_TO_SDLRECT(rect_src, src_conv_rect);
    src_sdl_rect = &src_conv_rect;
  }

  if (!MLRECT_IS_MAX(rect_dst)) {
    MLRECT_TO_SDLRECT(rect_dst, dst_conv_rect);
    dst_sdl_rect = &dst_conv_rect;
  }

  if (SDL_BlitSurface(src, src_sdl_rect, dst, dst_sdl_rect) < 0) {
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
sdlvideo_wm_available (void)
{
  return Val_bool(SDL_GetVideoInfo()->wm_available);
}

value
sdlvideo_surface_set_colorkey(value surface, value key)
{
   int res;
   
   if (key == Val_unit) {
     res = SDL_SetColorKey(SDL_SURFACE(surface), 0, 0);
   }
   else {
     res = SDL_SetColorKey(SDL_SURFACE(surface),
			   SDL_SRCCOLORKEY | SDL_RLEACCEL,
			   map_rgb_color(surface, Field(key, 0)));
   }
   
   if (res < 0) {
     sdlvideo_raise_exception(SDL_GetError());
   }
   
   return Val_unit;
}

value
sdlvideo_surface_display_format(value surface)
{
   SDL_Surface *res = SDL_DisplayFormat(SDL_SURFACE(surface));

   if (res == NULL)
     sdlvideo_raise_exception(SDL_GetError());
   
   return ML_SURFACE(res);
}

value
sdlvideo_empty_surface(value width, value height)
{
   SDL_Surface *surf;
   int w, h;
   w = Int_val(width);
   h = Int_val(height);

   surf = SDL_CreateRGBSurface(SDL_SWSURFACE, w, h, 24,
			       0x0000000ff, 0x0000ff00, 0x00ff0000, 0);

   if (surf == NULL)
     sdlvideo_raise_exception(SDL_GetError());

   return ML_SURFACE(surf);
}

value
sdlvideo_surface_from_rawrgb(value raw, value width, value height)
{
   SDL_Surface *surf;
   void *dest, *src;
   int w, h, i;
   w = Int_val(width);
   h = Int_val(height);

   surf = SDL_CreateRGBSurface(SDL_SWSURFACE, w, h, 24,
			       0x0000000ff, 0x0000ff00, 0x00ff0000, 0);
   
   if (surf == NULL)
     sdlvideo_raise_exception(SDL_GetError());
   
   dest = surf->pixels;
   src = &Byte(raw, 0);
   
   for (i = 0; i < h; i++) {
     memcpy(dest,src, w * 3);
     src += w * 3;
     dest += surf->pitch;
   }
   
   return ML_SURFACE(surf);
}

value
sdlvideo_surface_from_rawrgba(value raw, value width, value height)
{
   SDL_Surface *surf;
   void *dest, *src;
   int w, h, i;
   w = Int_val(width);
   h = Int_val(height);

   surf = SDL_CreateRGBSurface(SDL_SWSURFACE, w, h, 32,
			       0x000000ff, 0x0000ff00, 0x00ff0000,
			       0xff000000);
   if (surf == NULL)
     sdlvideo_raise_exception(SDL_GetError());

   dest = surf->pixels;
   src = &Byte(raw, 0);
   
   for (i = 0; i < h; i++) {
     memcpy(dest, src, w * 4);
     src += w * 4;
     dest += surf->pitch;
   }

   return ML_SURFACE(surf);
}

value
sdlvideo_surface_set_pixel(value ml_surf, value x, value y,
			   value color)
{
   char *location;
   unsigned char r, g, b;
   SDL_Surface *surf = SDL_SURFACE(ml_surf);

   convert_color(color, &r, &g, &b);
   
   location = surf->pixels +
              surf->pitch * Int_val(y) +
              surf->format->BytesPerPixel * Int_val(x);
   location[0] = r;
   location[1] = g;
   location[2] = b;

   return Val_unit;
}

value
sdlvideo_surface_get_pixel(value ml_surf, value x, value y)
{
   CAMLparam3(ml_surf, x, y);
   CAMLlocal1(ret);
   char *location;
   SDL_Surface *surf = SDL_SURFACE(ml_surf);

   ret = alloc_tuple(3);
   location = surf->pixels +
              surf->pitch * Int_val(y) +
              surf->format->BytesPerPixel * Int_val(x);
   Field(ret, 0) = Val_int(location[0]);
   Field(ret, 1) = Val_int(location[1]);
   Field(ret, 2) = Val_int(location[2]);

   CAMLreturn(ret);
}

value
sdlvideo_surface_set_pixel_bytecode(value *argv, int argn)
{
  return sdlvideo_surface_set_pixel(argv[0], argv[1], argv[2],
				    argv[3]);
}

value
sdlvideo_blit_raw_buffer(value screen, value buffer, value size)
{
   int ret;
   SDL_Surface *scr = SDL_SURFACE(screen);
   ret = SDL_LockSurface(scr);
   if (ret < 0) sdlvideo_raise_exception(SDL_GetError());
   memcpy(scr->pixels, &Byte(buffer,0), Int_val(size));
   SDL_UnlockSurface(scr);
   return Val_unit;
}

/* EXPERIMENTAL */

value
sdlvideo_surface_final(void)
{
  CAMLparam0();
  CAMLlocal1(ret);
  static int i = 0;

  ALLOC_FINAL_PTR((long)i, finalize_surface, ret);

  printf("Allocated final: %p %d\n", ret, i++);
  CAMLreturn(ret);
}
