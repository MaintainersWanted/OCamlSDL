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

/* $Id: sdlttf_stub.c,v 1.6 2001/05/16 16:03:24 smkl Exp $ */

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <stdio.h>

#include <SDL/SDL.h>
#include <SDL/SDL_ttf.h>

/*
 * Raise an OCaml exception with a message
 */

static void
sdlttf_raise_exception (char *msg)
{
   raise_with_string(*caml_named_value("SDLttf_exception"), msg);
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
   TTF_Font *font = TTF_OpenFont(&Byte(file,0), Int_val(ptsize));
   if (font == NULL) {
      sdlttf_raise_exception(SDL_GetError());
   }
   return (value)font;
}

value
sdlttf_font_height(value font)
{
   return Val_int(TTF_FontHeight((TTF_Font *)font));
}

value
sdlttf_close_font(value font)
{
   TTF_CloseFont((TTF_Font *)font);
   return Val_unit;
}

value
sdlttf_render_text(value font, value text, value fg, value bg)
{
   SDL_Color sfg;
   SDL_Color sbg;
   SDL_Surface *surf;
   sfg.r = Int_val(Field(fg,0));
   sfg.g = Int_val(Field(fg,1));
   sfg.b = Int_val(Field(fg,2));
   sbg.r = Int_val(Field(bg,0));
   sbg.g = Int_val(Field(bg,1));
   sbg.b = Int_val(Field(bg,2));
   surf = TTF_RenderText_Solid((TTF_Font *)font,&Byte(text,0), sfg);
   SDL_SetColorKey(surf, SDL_SRCCOLORKEY|SDL_RLEACCEL, 0);
   if (surf == NULL) {
      sdlttf_raise_exception(SDL_GetError());
   }
   return (value)surf;
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
   TTF_Font *font = (TTF_Font *)fnt;
   TTF_GlyphMetrics(font, c, &minx, &maxx, &miny, &maxy, &advance);
   result = alloc(4, 0);
   Store_field(result, 0, Val_int(minx));
   Store_field(result, 0, Val_int(maxx));
   Store_field(result, 0, Val_int(miny));
   Store_field(result, 0, Val_int(maxy));
   return result;
}
