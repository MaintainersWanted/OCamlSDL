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

/* $Id: sdlvideo_stub.c,v 1.33 2002/07/31 18:57:50 smkl Exp $ */

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/bigarray.h>


#include <stdio.h>
#include <string.h>

#include <SDL.h>


#include "common.h"
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
  if (Tag_val(color) == 0) { /* 3 ints */
    *r = (unsigned char)Int_val(Field(color, 0));
    *g = (unsigned char)Int_val(Field(color, 1));
    *b = (unsigned char)Int_val(Field(color, 2));
  }
  else { /* 3 floats */
    *r = (unsigned char)(Double_val(Field(color, 0)) * 255);
    *g = (unsigned char)(Double_val(Field(color, 1)) * 255);
    *b = (unsigned char)(Double_val(Field(color, 2)) * 255);
  }
}

/*
 * Raise an OCaml exception with a message
 */

static void
sdlvideo_raise_exception (char *msg)
{
  static value *video_exn = NULL;
  if(! video_exn)
    video_exn = caml_named_value("SDLvideo_exception");
  raise_with_string(*video_exn, msg);
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
  const SDL_VideoInfo *info = SDL_GetVideoInfo();

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
			  SDL_HWSURFACE | SDL_DOUBLEBUF | SDL_FULLSCREEN);

  if (surf == NULL) {
    sdlvideo_raise_exception(SDL_GetError());
  }

  return ML_SURFACE(surf);
}

/* video flags */
#include "sdlvideo_flag.h"
#include "sdlvideo_flag.c"

int 
video_flag_val(value flag_list)
{
  int flag = 0;
  value l = flag_list;

  while (is_not_nil(l))
    {
      flag |= Video_flag_val(hd(l));
      l = tl(l);
    }
  return flag;
}

value 
val_video_flag(int flags)
{
  value l = nil();
  lookup_info *table = ml_table_video_flag;
  int i;
  for (i = table[0].data; i > 0; i--)
    if (flags & table[i].data) 
      l = cons(table[i].key, l);
  return l;
}

value 
sdlvideo_video_mode_ok(value width, value height, value vbpp, value vf) 
{
  int w = Int_val(width);
  int h = Int_val(height);
  int bpp = Int_val(vbpp);
  int flags = video_flag_val(vf);

  return Val_bool(SDL_VideoModeOK(w,h,bpp,flags));
}

value 
sdlvideo_set_video_mode(value width, value height, value vbpp, value vf) 
{
  int w = Int_val(width);
  int h = Int_val(height);
  int bpp = Int_val(vbpp);
  int flags = video_flag_val(vf);
  SDL_Surface* s;
  
  if ((s = SDL_SetVideoMode(w,h,bpp,flags)) == NULL)
    sdlvideo_raise_exception(SDL_GetError());

  return ML_SURFACE(s);
}

value 
sdlvideo_create_rgb_surface(value flags, value width, value height, 
			    value bpp, value rmask, value gmask, 
			    value bmask, value amask) 
{
  SDL_Surface* s;
  
  s = SDL_CreateRGBSurface(Int_val(flags), Int_val(width),Int_val(height),
			   Int_val(bpp), Int_val(rmask), Int_val(gmask), 
			   Int_val(bmask), Int_val(amask));
  if (s == NULL) 
    sdlvideo_raise_exception(SDL_GetError());

  return ML_SURFACE(s);
}

value
sdlvideo_create_rgb_surface_bc(value *argv, int argc)
{
  return sdlvideo_create_rgb_surface(argv[0], argv[1], argv[2],
				     argv[3], argv[4], argv[5],
				     argv[6], argv[7]);
}

value
sdlvideo_set_opengl_mode (value width, value height, value bpp)
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
			  SDL_OPENGL);

  if (surf == NULL) {
    sdlvideo_raise_exception(SDL_GetError());
  }

  return ML_SURFACE(surf);
}
/*
 * Make a SDL color matching the surface pixel format
 */

value
sdlvideo_map_rgb(value surface, value color)
{
  unsigned char r, g, b;

  convert_color(color, &r, &g, &b);
  return copy_int32(SDL_MapRGB(SDL_SURFACE(surface)->format, r, g, b));
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
sdlvideo_surface_bpp(value surface) 
{
  return Val_int(SDL_SURFACE(surface)->format->BitsPerPixel);
}

value 
sdlvideo_surface_rmask(value surface) 
{
  return Val_int(SDL_SURFACE(surface)->format->Rmask);
}

value 
sdlvideo_surface_gmask(value surface) 
{
  return Val_int(SDL_SURFACE(surface)->format->Gmask);
}

value 
sdlvideo_surface_bmask(value surface) 
{
  return Val_int(SDL_SURFACE(surface)->format->Bmask);
}

value 
sdlvideo_surface_amask(value surface) 
{
  return Val_int(SDL_SURFACE(surface)->format->Amask);
}

value
sdlvideo_surface_fill_rect (value surface, value rect, value color)
{
  SDL_Rect sdl_rect;
  SDL_Rect *rectp;
  int res;
  
  if(MLRECT_IS_MAX(rect))
    rectp = NULL;
  else {
    rectp = &sdl_rect;
    MLRECT_TO_SDLRECT(rect, sdl_rect);
  } ;
  res = SDL_FillRect(SDL_SURFACE(surface), rectp,
		     Int32_val(sdlvideo_map_rgb(surface, color)));
    
  if (res < 0) {
    sdlvideo_raise_exception(SDL_GetError());
  }
  /* GNI? : why return the surface ? */
  return surface;
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
sdlvideo_wm_set_caption (value title, value icon)
{
  SDL_WM_SetCaption(String_val(title), String_val(icon));
  return Val_unit;
}
/* TODO:
 *  value
 *  sdlvideo_wm_get_caption (value title, value icon)
 *  {
 *    return Val_unit;
 *  } */
value
sdlvideo_wm_iconify_window (void)
{
  SDL_WM_IconifyWindow();
  return Val_unit;
}

/* TO FIX:
 *  value
 *  sdlvideo_wm_toggle_fullscreen (value surface)
 *  {
 *    SDL_Surface *s = SDL_SURFACE(surface);
 *  
 *    return Val_int(SDL_WM_ToggleFullScreen(s));
 *  } */

value
sdlvideo_surface_set_colorkey (value surface, value key)
{
   int res;
   
   if (Is_long(key)) {
     res = SDL_SetColorKey(SDL_SURFACE(surface), 0, 0);
   }
   else {
     res = SDL_SetColorKey(SDL_SURFACE(surface),
			   SDL_SRCCOLORKEY | SDL_RLEACCEL,
			   Int32_val(sdlvideo_map_rgb(surface, Field(key, 0))));
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
   unsigned char *location;
   unsigned char r, g, b;
   SDL_Surface *surf = SDL_SURFACE(ml_surf);

   convert_color(color, &r, &g, &b);
   
   location = surf->pixels +
              surf->pitch * Int_val(y) +
              surf->format->BytesPerPixel * Int_val(x);
   /* location[0] = r; */
   /* location[1] = g; */
   /* location[2] = b; */

   if(surf->format->BytesPerPixel > 2) {
     location[0] = r;
     location[1] = g;
     location[2] = b;
   } else {
     location[0] = (b>>3) | (((g>>2) & 0x7) << 5);
     location[1] = (g >> 5) | ((r>>3) << 3);
   }

   return Val_unit;
}

value
sdlvideo_surface_get_pixel(value ml_surf, value x, value y)
{
   CAMLparam3(ml_surf, x, y);
   CAMLlocal1(ret);
   unsigned char *location;
   SDL_Surface *surf = SDL_SURFACE(ml_surf);

   ret = alloc_tuple(3);
   location = surf->pixels +
              surf->pitch * Int_val(y) +
              surf->format->BytesPerPixel * Int_val(x);
   /* Field(ret, 0) = Val_int(location[0]); */
   /* Field(ret, 1) = Val_int(location[1]); */
   /* Field(ret, 2) = Val_int(location[2]); */

   if(surf->format->BytesPerPixel > 2) {
     Field(ret, 0) = Val_int(location[0]);
     Field(ret, 1) = Val_int(location[1]);
     Field(ret, 2) = Val_int(location[2]);
   } else {
     Field(ret, 0) = Val_int(location[1] & 0xf8);
     Field(ret, 1) = Val_int(
			     ((location[1] & 0x07)<<5)
			     |
			     (((location[0] & 0xe0))>>3)
			     );
     Field(ret, 2) = Val_int((location[0] & 0x1f)<<3);
   }

   CAMLreturn(ret);
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

value sdlvideo_show_cursor(value vtoggle)
{
  int toggle = Bool_val(vtoggle);

  SDL_ShowCursor(toggle);
  return Val_unit;
}
  

/* UNSTESTED */
value
sdlvideo_must_lock(value s)
{
   int b = SDL_MUSTLOCK(SDL_SURFACE(s));
   return Val_bool(b);
}

value sdlvideo_lock_surface(value s)
{
   if (SDL_LockSurface(SDL_SURFACE(s)) < 0)
     sdlvideo_raise_exception(SDL_GetError());
   	return Val_unit;
}

value sdlvideo_unlock_surface(value s)
{
  SDL_UnlockSurface(SDL_SURFACE(s));
  return Val_unit;
}


value
sdlvideo_surface_pixel_data(value surface)
{
   long dims[1];
   SDL_Surface *surf = SDL_SURFACE(surface);
   dims[0] = surf->h * surf->pitch;
   return alloc_bigarray(BIGARRAY_UINT8 | BIGARRAY_C_LAYOUT,
			 1, surf->pixels, dims);
}

value
sdlvideo_gl_swap_buffers(value unit)
{
   SDL_GL_SwapBuffers();
   return Val_unit;
}

