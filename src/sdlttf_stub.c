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

/* $Id: sdlttf_stub.c,v 1.26 2004/02/04 12:00:22 oliv__a Exp $ */

#include <SDL_ttf.h>

#include "common.h"
#include "sdlvideo_stub.h"

/*
 * Convertion Macros
 */
#define SDL_FONT(f) (*(TTF_Font **)Data_custom_val(f))

static void ml_TTF_CloseFont(value v)
{
  TTF_CloseFont(SDL_FONT(v));
}
  
static int ml_TTF_compare(value v1, value v2)
{
  TTF_Font *f1 = SDL_FONT(v1);
  TTF_Font *f2 = SDL_FONT(v2);
  if(f1 == f2) return 0;
  if(f1 < f2) return -1;
  else return 1;
}

static struct custom_operations sdl_ttf_ops = {
  "sdlsurface",
  &ml_TTF_CloseFont,
  &ml_TTF_compare,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default 
};

static value ML_FONT(TTF_Font *f)
{
  value v;
  TTF_Font **b;
  v = alloc_custom(&sdl_ttf_ops, sizeof(*b), 0, 1);
  b = Data_custom_val(v);
  *b = f;
  return v;
}

/*
 * Raise an OCaml exception with a message
 */

static void
sdlttf_raise_exception (char *msg) Noreturn;
static void
sdlttf_raise_exception (char *msg)
{
  static value *ttf_exn = NULL;
  if(! ttf_exn)
    ttf_exn = caml_named_value("SDLttf_exception");
  raise_with_string(*ttf_exn, msg);
}

/*
 * SDL_ttf initialization
 */

CAMLprim value
sdlttf_init(value unit)
{
   int error;
   error = TTF_Init();
   if (error) {
      sdlttf_raise_exception(TTF_GetError());
   }
   return Val_unit;
}

/*
 * SDL_ttf shutdown
 */

CAMLprim value
sdlttf_kill(value unit)
{
   TTF_Quit();
   return Val_unit;
}

/*
 * OCaml/C conversion functions
 */

CAMLprim value
sdlttf_open_font(value file, value index, value ptsize)
{
  int c_index = Opt_arg(index, Int_val, 0);
  TTF_Font *font=NULL;

#if (TTF_RELEASE >= 204)
  font = TTF_OpenFontIndex(String_val(file), Int_val(ptsize), c_index);
#else  /* try to keep compatibility with SDL_ttf v1 */
  font = TTF_OpenFont(String_val(file), Int_val(ptsize));
#endif

  if (font == NULL) {
    sdlttf_raise_exception(TTF_GetError());
  }
  return ML_FONT(font);
}

CAMLprim value
sdlttf_get_font_style(value font)
{
  int style = TTF_GetFontStyle(SDL_FONT(font));
  if (style == TTF_STYLE_NORMAL)
    return cons(Val_int(0), Val_emptylist);
  else {
    int i;
    const int font_style_table [] = {
      TTF_STYLE_BOLD, TTF_STYLE_ITALIC, TTF_STYLE_UNDERLINE } ;
    value v_style = Val_emptylist;
    for(i=0; i < 3 ; i++)
      if(font_style_table[i] & style) 
	v_style = cons(Val_int(i+1), v_style);
    return v_style;
  }
}

CAMLprim value
sdlttf_set_font_style(value font, value style)
{
  const int font_style_table [] = {
    TTF_STYLE_NORMAL, TTF_STYLE_BOLD, 
    TTF_STYLE_ITALIC, TTF_STYLE_UNDERLINE } ;
  int c_style = 0;
  while (is_not_nil(style)) {
    c_style |= font_style_table[ Int_val( hd(style) ) ];
    style = tl(style);
  }
  TTF_SetFontStyle(SDL_FONT(font), c_style);
  return Val_unit;
}

CAMLprim value
sdlttf_font_height(value font)
{
   return Val_int(TTF_FontHeight(SDL_FONT(font)));
}

CAMLprim value
sdlttf_font_ascent(value font)
{
   return Val_int(TTF_FontAscent(SDL_FONT(font)));
}

CAMLprim value
sdlttf_font_descent(value font)
{
   return Val_int(TTF_FontDescent(SDL_FONT(font)));
}

ML_1(TTF_FontLineSkip, SDL_FONT, Val_int)
#if (SDL_TTF_VERSION >= 204)
ML_1(TTF_FontFaces, SDL_FONT, Val_int)
ML_1(TTF_FontFaceIsFixedWidth, SDL_FONT, Val_bool)
ML_1(TTF_FontFaceFamilyName, SDL_FONT, copy_string)
ML_1(TTF_FontFaceStyleName, SDL_FONT, copy_string)
#else
Unsupported (TTF_FontFaces)
Unsupported (TTF_FontFaceIsFixedWidth)
Unsupported (TTF_FontFaceFamilyName)
Unsupported (TTF_FontFaceStyleName)
#endif /* SDL_TTF_VERSION */

CAMLprim value
sdlttf_size_text(value font, value text)
{
  int w, h;
  value v;
  if(TTF_SizeText(SDL_FONT(font), String_val(text), &w, &h))
    sdlttf_raise_exception(TTF_GetError());
  v = alloc_small(2, 0);
  Field(v, 0) = Val_int(w);
  Field(v, 1) = Val_int(h);
  return v;
}

CAMLprim value
sdlttf_render_text_solid(value font, value text, value fg) 
{
   SDL_Color sfg;
   SDL_Surface *surf;

   SDLColor_of_value(&sfg, fg);

   surf = TTF_RenderText_Solid(SDL_FONT(font),String_val(text), sfg);
   SDL_SetColorKey(surf, SDL_SRCCOLORKEY|SDL_RLEACCEL, 0);
   if (surf == NULL) {
      sdlttf_raise_exception(TTF_GetError());
   }
   return ML_SURFACE(surf);
}

CAMLprim value
sdlttf_render_glyph_solid(value font, value ch, value fg) 
{
   SDL_Color sfg;
   SDL_Surface *surf;

   SDLColor_of_value(&sfg, fg);

   surf = TTF_RenderGlyph_Solid(SDL_FONT(font),Int_val(ch), sfg);
   SDL_SetColorKey(surf, SDL_SRCCOLORKEY|SDL_RLEACCEL, 0);
   if (surf == NULL) {
      sdlttf_raise_exception(TTF_GetError());
   }
   return ML_SURFACE(surf);

}

CAMLprim value
sdlttf_render_text_shaded(value font, value text, value fg, value bg) 
{
   SDL_Color sfg;
   SDL_Color sbg;
   SDL_Surface *surf;

   SDLColor_of_value(&sfg, fg);
   SDLColor_of_value(&sbg, bg);

   surf = TTF_RenderText_Shaded(SDL_FONT(font),String_val(text), sfg, sbg);
   SDL_SetColorKey(surf, SDL_SRCCOLORKEY|SDL_RLEACCEL, 0);
   if (surf == NULL) {
      sdlttf_raise_exception(TTF_GetError());
   }
   return ML_SURFACE(surf);
}

CAMLprim value
sdlttf_render_glyph_shaded(value font, value ch, value fg, value bg) 
{
   SDL_Color sfg;
   SDL_Color sbg;
   SDL_Surface *surf;

   SDLColor_of_value(&sfg, fg);
   SDLColor_of_value(&sbg, bg);

   surf = TTF_RenderGlyph_Shaded(SDL_FONT(font),Int_val(ch), sfg, sbg);
   SDL_SetColorKey(surf, SDL_SRCCOLORKEY|SDL_RLEACCEL, 0);
   if (surf == NULL) {
      sdlttf_raise_exception(TTF_GetError());
   }
   return ML_SURFACE(surf);
}

CAMLprim value
sdlttf_render_text_blended(value font, value text, value fg) 
{
   SDL_Color sfg;
   SDL_Surface *surf;

   SDLColor_of_value(&sfg, fg);

   surf = TTF_RenderText_Blended(SDL_FONT(font),String_val(text), sfg);
   SDL_SetColorKey(surf, SDL_SRCCOLORKEY|SDL_RLEACCEL, 0);
   if (surf == NULL) {
      sdlttf_raise_exception(TTF_GetError());
   }
   return ML_SURFACE(surf);
}

CAMLprim value
sdlttf_render_glyph_blended(value font, value ch, value fg) 
{
   SDL_Color sfg;
   SDL_Surface *surf;

   SDLColor_of_value(&sfg, fg);

   surf = TTF_RenderGlyph_Blended(SDL_FONT(font),Int_val(ch), sfg);
   SDL_SetColorKey(surf, SDL_SRCCOLORKEY|SDL_RLEACCEL, 0);
   if (surf == NULL) {
      sdlttf_raise_exception(TTF_GetError());
   }
   return ML_SURFACE(surf);
}

CAMLprim value
sdlttf_glyph_metrics(value fnt, value chr)
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
