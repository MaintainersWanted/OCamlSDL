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

/* $Id: sdlttf_stub.c,v 1.14 2002/07/13 17:13:07 oliv__a Exp $ */

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <stdio.h>

#include <SDL_ttf.h>

#include "sdlvideo_stub.h"
#include "sdlttf_stub.h"

/*
 * Raise an OCaml exception with a message
 */

static void
sdlttf_raise_exception (char *msg)
{
  static value *ttf_exn = NULL;
  if(! ttf_exn)
    ttf_exn = caml_named_value("SDLttf_exception");
  raise_with_string(*ttf_exn, msg);
}

/*
 * Stub initialization
 */

void
sdlttf_stub_init(void)
{
   int error;
   error = TTF_Init();
   if (error) {
      sdlttf_raise_exception(SDL_GetError());
   }
}

/*
 * Stub shutdown
 */

void
sdlttf_stub_kill(void)
{
   TTF_Quit();
}

/*
 * OCaml/C conversion functions
 */

value
sdlttf_open_font(value file, value ptsize)
{
   TTF_Font *font = TTF_OpenFont(String_val(file), Int_val(ptsize));
   if (font == NULL) {
      sdlttf_raise_exception(SDL_GetError());
   }
   return ML_FONT(font);
}

value
sdlttf_font_height(value font)
{
   return Val_int(TTF_FontHeight(SDL_FONT(font)));
}

value
sdlttf_font_ascent(value font)
{
   return Val_int(TTF_FontAscent(SDL_FONT(font)));
}

value
sdlttf_font_descent(value font)
{
   return Val_int(TTF_FontDescent(SDL_FONT(font)));
}

value
sdlttf_close_font(value font)
{
   TTF_CloseFont(SDL_FONT(font));
   return Val_unit;
}

value
sdlttf_render_text_solid(value font, value text, value fg) 
{
   SDL_Color sfg;
   SDL_Surface *surf;

   SDL_COLOR_FROM_VALUE(fg,sfg)

   surf = TTF_RenderText_Solid(SDL_FONT(font),String_val(text), sfg);
   SDL_SetColorKey(surf, SDL_SRCCOLORKEY|SDL_RLEACCEL, 0);
   if (surf == NULL) {
      sdlttf_raise_exception(SDL_GetError());
   }
   return ML_SURFACE(surf);

}
value
sdlttf_render_text_shaded(value font, value text, value fg, value bg) 
{
   SDL_Color sfg;
   SDL_Color sbg;
   SDL_Surface *surf;

   SDL_COLOR_FROM_VALUE(fg,sfg)
   SDL_COLOR_FROM_VALUE(bg,sbg)

   surf = TTF_RenderText_Shaded(SDL_FONT(font),String_val(text), sfg, sbg);
   SDL_SetColorKey(surf, SDL_SRCCOLORKEY|SDL_RLEACCEL, 0);
   if (surf == NULL) {
      sdlttf_raise_exception(SDL_GetError());
   }
   return ML_SURFACE(surf);

}
value
sdlttf_render_text_blended(value font, value text, value fg) 
{
   SDL_Color sfg;
   SDL_Surface *surf;

   SDL_COLOR_FROM_VALUE(fg,sfg)

   surf = TTF_RenderText_Blended(SDL_FONT(font),String_val(text), sfg);
   SDL_SetColorKey(surf, SDL_SRCCOLORKEY|SDL_RLEACCEL, 0);
   if (surf == NULL) {
      sdlttf_raise_exception(SDL_GetError());
   }
   return ML_SURFACE(surf);
}


value
sdlttf_render_text(value font, value text, value fg, value bg)
{
   SDL_Color sfg;
   SDL_Color sbg;
   SDL_Surface *surf;

   SDL_COLOR_FROM_VALUE(fg,sfg)
   SDL_COLOR_FROM_VALUE(bg,sbg)

   surf = TTF_RenderText_Shaded(SDL_FONT(font),String_val(text), sfg, sbg);
   SDL_SetColorKey(surf, SDL_SRCCOLORKEY|SDL_RLEACCEL, 0);
   if (surf == NULL) {
      sdlttf_raise_exception(SDL_GetError());
   }
   return ML_SURFACE(surf);
}

value
sdlttf_font_metrics(value fnt, value chr)
{
   int minx;
   int miny;
   int maxx;
   int maxy;
   int advance;
   int c = Int_val(chr);
   value result;
   TTF_Font *font = SDL_FONT(fnt);
   TTF_GlyphMetrics(font, c, &minx, &maxx, &miny, &maxy, &advance);
   result = alloc(4, 0);
   Store_field(result, 0, Val_int(minx));
   Store_field(result, 1, Val_int(maxx));
   Store_field(result, 2, Val_int(miny));
   Store_field(result, 3, Val_int(maxy));
   return result;
}
