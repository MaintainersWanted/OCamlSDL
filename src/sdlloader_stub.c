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

/* $Id: sdlloader_stub.c,v 1.9 2002/09/10 12:01:18 oliv__a Exp $ */

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <stdio.h>
#include <string.h>
#include <SDL.h>
#include <SDL_image.h>

#include "sdlvideo_stub.h"

static void
sdlloader_raise_exception (char *msg)
{
  static value *loader_exn = NULL;
  if(! loader_exn)
    loader_exn = caml_named_value("SDLloader_exception");
  raise_with_string(*loader_exn, msg);
}

value
sdlloader_load_image(value file)
{
   SDL_PixelFormat format;
   SDL_Surface *converted;
   SDL_Surface *surf;
   surf = IMG_Load_RW(SDL_RWFromFile(&Byte(file,0), "rb"), 1);
   if (surf == NULL) sdlloader_raise_exception(SDL_GetError());
     memset(&format, 0, sizeof(format));
   format.BytesPerPixel = 3;
   format.BitsPerPixel = 24;
   format.Rmask = 0x000000ff;
   format.Gmask = 0x0000ff00;
   format.Bmask = 0x00ff0000;
   converted = SDL_ConvertSurface(surf, &format, SDL_SWSURFACE);
   if (converted == NULL) {
      sdlloader_raise_exception(SDL_GetError());
   }
   SDL_FreeSurface(surf);
   return ML_SURFACE(converted);
}

#ifdef FOOFOO

#include <png.h>

value
sdlloader_load_png(value file_name)
{
   SDL_Surface *surf;
   png_structp png_ptr;
   png_infop info_ptr;
   png_uint_32 width, height;
   int bit_depth, color_type, interlace_type;
   FILE *fp;
   png_bytep *row_pointers;
   int row;
   
   /* open the file and initialize libpng */
   
   if ((fp = fopen(String_val(file_name), "rb")) == NULL)
     sdlloader_raise_exception("Can't open file");
   
   png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

   if (png_ptr == NULL) {
     fclose(fp);
     sdlloader_raise_exception("Cannot initialize libpng reader");
   }
   
   info_ptr = png_create_info_struct(png_ptr);
   if (info_ptr == NULL) {
     fclose(fp);
     png_destroy_read_struct(&png_ptr, (png_infopp)NULL, (png_infopp)NULL);
     sdlloader_raise_exception("Cannot initialize libpng info");
   }
   
   /* this is not working */
   if (setjmp(png_ptr->jmpbuf)) {
     sdlloader_raise_exception("libpng died");
   }
   
   png_init_io(png_ptr, fp);
   png_read_info(png_ptr, info_ptr);
   png_get_IHDR(png_ptr, info_ptr, &width, &height, &bit_depth, &color_type,
                &interlace_type, NULL, NULL);
   
   /* expand everything to RGB */
   png_set_packing(png_ptr);
   png_set_strip_16(png_ptr);
/*   png_set_palette_to_rgb(png_ptr);
   png_set_gray_1_2_4_to_8(png_ptr);
   png_set_tRNS_to_alpha(png_ptr); */
   png_set_expand(png_ptr);
   png_set_expand(png_ptr);
   png_set_expand(png_ptr);
   png_read_update_info(png_ptr, info_ptr);

   /* finally read it */
   row_pointers = malloc(height*sizeof(png_bytep));
   for (row = 0; row < height; row++) {
     row_pointers[row] = malloc(png_get_rowbytes(png_ptr, info_ptr));
   }
   
   png_read_image(png_ptr, row_pointers);
   png_read_end(png_ptr, info_ptr);
   png_destroy_read_struct(&png_ptr, &info_ptr, (png_infopp)NULL);
   fclose(fp);
   
   /* then convert to SDL surface */
   surf = SDL_CreateRGBSurface(SDL_SWSURFACE, width, height, 24,
			       0x000000ff, 0x0000ff00, 0x00ff0000, 0x0);
   if (surf == NULL) sdlloader_raise_exception(SDL_GetError());
   {
     char *src, *dest;
     int i;
     dest = surf->pixels;
     for (i = 0; i < height; i++) {
       src = row_pointers[i];
       memcpy(dest, src, width * 3);
       dest += surf->pitch;
     }
   }
   
   for (row = 0; row < height; row++)
     free(row_pointers[row]);
   free(row_pointers);
   
   return ML_SURFACE(surf);
}

value
sdlloader_load_png_with_alpha(value file_name)
{
   SDL_Surface *surf;
   png_structp png_ptr;
   png_infop info_ptr;
   png_uint_32 width, height;
   int bit_depth, color_type, interlace_type;
   FILE *fp;
   png_bytep *row_pointers;
   int row;
   
   /* open the file and initialize libpng */
   if ((fp = fopen(&Byte(file_name, 0), "rb")) == NULL)
     sdlloader_raise_exception("Can't open file");
   
   png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
   if (png_ptr == NULL) {
     fclose(fp);
     sdlloader_raise_exception("Cannot initialize libpng reader");
   }
   
   info_ptr = png_create_info_struct(png_ptr);
   if (info_ptr == NULL) {
     fclose(fp);
     png_destroy_read_struct(&png_ptr, (png_infopp)NULL, (png_infopp)NULL);
     sdlloader_raise_exception("Cannot initialize libpng info");
   }
   
   if (setjmp(png_ptr->jmpbuf)) {
     png_destroy_read_struct(&png_ptr, &info_ptr, (png_infopp)NULL);
     fclose(fp);
     sdlloader_raise_exception("libpng failed");
   }
   
   png_init_io(png_ptr, fp);
   png_read_info(png_ptr, info_ptr);
   png_get_IHDR(png_ptr, info_ptr, &width, &height, &bit_depth, &color_type,
                &interlace_type, NULL, NULL);
   /* expand everything to RGBA */
   png_set_packing(png_ptr);
   png_set_strip_16(png_ptr);
/* these should work on a new version of libpng ?
   png_set_palette_to_rgb(png_ptr);
   png_set_gray_1_2_4_to_8(png_ptr);
   png_set_tRNS_to_alpha(png_ptr); */
   png_set_expand(png_ptr);
   png_set_expand(png_ptr);
   png_set_expand(png_ptr);
   png_set_filler(png_ptr, 0xff, PNG_FILLER_AFTER);
   png_read_update_info(png_ptr, info_ptr);
   /* finally read it */
   row_pointers = malloc(height*sizeof(png_bytep));

   for (row = 0; row < height; row++) {
     row_pointers[row] = malloc(png_get_rowbytes(png_ptr, info_ptr));
   }
   
   png_read_image(png_ptr, row_pointers);
   png_read_end(png_ptr, info_ptr);
   png_destroy_read_struct(&png_ptr, &info_ptr, (png_infopp)NULL);
   fclose(fp);
   
   /* then convert to SDL surface */
   surf = SDL_CreateRGBSurface(SDL_SWSURFACE, width, height, 32,
			       0x000000ff, 0x0000ff00, 0x00ff0000,
			       0xff000000);
   if (surf == NULL) sdlloader_raise_exception(SDL_GetError());
   {
     void *src, *dest;
     int i;
     dest = surf->pixels;
     
     for (i = 0; i < height; i++) {
       src = row_pointers[i];
       memcpy(dest,src,width*4);
       dest += surf->pitch;
     }
   }
   
   for (row = 0; row < height; row++)
     free(row_pointers[row]);
   free(row_pointers);
   
   return ML_SURFACE(surf);
}

#endif
