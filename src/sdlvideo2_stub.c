
#include <stdio.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/bigarray.h>
#include <caml/custom.h>

#include <SDL.h>

#include "config.h"
#include "common.h"
#include "sdlvideo2_stub.h"

#ifndef HAVE_INLINE
extern SDL_Surface *SDL_SURFACE(value v)
{
  struct ml_sdl_surf_data *cb_data;
  cb_data = (Tag_val(v) == 0) ? 
    Data_custom_val(Field(v, 0)) : Data_custom_val(v);
  return cb_data->s;
}
#endif


/* ************************************************** */
/* memory management : custom blocks & co. */
/* ************************************************** */
static void ml_SDL_FreeSurface(value s)
{
  struct ml_sdl_surf_data *cb_data;
  cb_data = (Tag_val(s) == 0) ? 
    Data_custom_val(Field(s, 0)) : Data_custom_val(s);
  if(cb_data->freeable)
    SDL_FreeSurface(cb_data->s);
}

static int ml_SDL_surf_compare(value v1, value v2)
{
  SDL_Surface *s1 = SDL_SURFACE(v1);
  SDL_Surface *s2 = SDL_SURFACE(v2);
  if(s1 == s2) return 0;
  if(s1 < s2) return -1; 
  else return 1;
}

static struct custom_operations sdl_surface_ops = {
  "sdlsurface",
  &ml_SDL_FreeSurface,
  &ml_SDL_surf_compare,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default 
};

extern value Val_SDLSurface(SDL_Surface *surf, int freeable, value barr)
{
  CAMLparam1(barr);
  CAMLlocal2(s, v);
  int used = surf->w * surf->h;
  struct ml_sdl_surf_data *cb_data;
  s = alloc_custom(&sdl_surface_ops, 
		   sizeof (*cb_data),
		   used, 1000000);
  cb_data = Data_custom_val(s);
  cb_data->s = surf;
  cb_data->freeable = freeable;
  if(barr == Val_unit)
    CAMLreturn(s);
  else {
    v = alloc_small(2, 0);
    Field(v, 0) = s;
    Field(v, 1) = barr;
    CAMLreturn(v);
  }
}



/*
 * Error handling
 */
static void sdlvideo_raise_exception (char *msg)
{
  static value *video_exn = NULL;
  if(! video_exn) {
    video_exn = caml_named_value("SDLvideo2_exception");
    if(! video_exn){
      fprintf(stderr, "exception not registered.");
      abort();
    }
  }
  raise_with_string(*video_exn, msg);
}

/*
 * some static conversion functions
 */
static inline void SDLColor_of_value(SDL_Color *c, value v)
{
  c->r = Int_val(Field(v, 0));
  c->g = Int_val(Field(v, 1));
  c->b = Int_val(Field(v, 2));
}

static value value_of_Rect(SDL_Rect r)
{
  value v = alloc_small(4, 0);
  Field(v, 0) = Val_int(r.x);
  Field(v, 1) = Val_int(r.y);
  Field(v, 2) = Val_int(r.w);
  Field(v, 3) = Val_int(r.h);
  return v;
}

static inline void SDLRect_of_value(SDL_Rect *r, value v)
{
  r->x = Int_val(Field(v, 0));
  r->y = Int_val(Field(v, 1));
  r->w = Int_val(Field(v, 2));
  r->h = Int_val(Field(v, 3));
}

static inline void update_value_from_SDLRect(value vr, SDL_Rect *r)
{
  CAMLparam1(vr);
  Store_field(vr, 0, Val_int(r->x));
  Store_field(vr, 1, Val_int(r->y));
  Store_field(vr, 2, Val_int(r->w));
  Store_field(vr, 3, Val_int(r->h));
  CAMLreturn0;
}

static value value_of_PixelFormat(SDL_PixelFormat *fmt)
{
  CAMLparam0();
  CAMLlocal1(v);
  if( !fmt)
    abort();
  v = alloc(17, 0);
  Store_field(v, 0, fmt->palette ? Val_true : Val_false);
  Store_field(v, 1, Val_int(fmt->BitsPerPixel));
  Store_field(v, 2, Val_int(fmt->BytesPerPixel));
  Store_field(v, 3, copy_int32(fmt->Rmask));
  Store_field(v, 4, copy_int32(fmt->Gmask));
  Store_field(v, 5, copy_int32(fmt->Bmask));
  Store_field(v, 6, copy_int32(fmt->Amask));
  Store_field(v, 7, Val_int(fmt->Rshift));
  Store_field(v, 8, Val_int(fmt->Gshift));
  Store_field(v, 9, Val_int(fmt->Bshift));
  Store_field(v,10, Val_int(fmt->Ashift));
  Store_field(v,11, Val_int(fmt->Rloss));
  Store_field(v,12, Val_int(fmt->Gloss));
  Store_field(v,13, Val_int(fmt->Bloss));
  Store_field(v,14, Val_int(fmt->Aloss));
  Store_field(v,15, copy_int32(fmt->colorkey));
  Store_field(v,16, Val_int(fmt->alpha));
  CAMLreturn(v);
}

/* video flags */
#include "sdlvideo_flag.h"
/*  #include "sdlvideo_flag.c" */

static Uint32 video_flag_val(value flag_list)
{
  Uint32 flag = 0;
  value l = flag_list;

  while (is_not_nil(l)) {
      flag |= Video_flag_val(hd(l));
      l = tl(l); }
  return flag;
}

static value val_video_flag(Uint32 flags)
{
  value l = nil();
  lookup_info *table = ml_table_video_flag;
  int i;
  for (i = table[0].data; i > 0; i--)
    if (flags & table[i].data) 
      l = cons(table[i].key, l);
  return l;
}


/*
 * Palette stuff
 */
value ml_sdl_surface_use_palette(value s)
{
  SDL_Surface *surf = SDL_SURFACE(s);
  return Val_bool(surf->format->palette != NULL);
}

value ml_sdl_palette_ncolors(value surf)
{
  SDL_Surface *s = SDL_SURFACE(surf);
  SDL_Palette *p = s->format->palette;
  if(! p)
    invalid_argument("surface not palettized");
  return Val_int(p->ncolors);
}

value ml_sdl_palette_get_color(value surf, value n)
{
  SDL_Surface *s = SDL_SURFACE(surf);
  SDL_Palette *p = s->format->palette;
  SDL_Color c;
  int c_n = Int_val(n);
  value v;
  if(! p)
    invalid_argument("surface not palettized");
  if(c_n < 0 || c_n >= p->ncolors)
    invalid_argument("out of bounds palette access");
  c = p->colors[c_n];
  v = alloc_small(3, 0);
  Field(v, 0) = Val_int(c.r);
  Field(v, 1) = Val_int(c.g);
  Field(v, 2) = Val_int(c.b);
  return v;
}

value ml_SDL_SetPalette(value surf, value flags, 
			value ofirstcolor, value c_arr)
{
  SDL_Surface *s = SDL_SURFACE(surf);
  SDL_Palette *p = s->format->palette;
  int firstcolor = Opt_arg(ofirstcolor, Int_val, 0);
  int c_flags;
  int n = Wosize_val(c_arr);
  int i, status;
#ifdef __GNUC__
  SDL_Color color[n];
#else
  SDL_Color *color = calloc(sizeof(SDL_Color), n);
#endif

  if(! p) {
#ifndef __GNUC__
    free(color);
#endif
    invalid_argument("surface not palettized");
  }
  if(firstcolor + n > p->ncolors || firstcolor < 0) {
#ifndef __GNUC__
    free(color);
#endif
    invalid_argument("out of bounds palette access");
  }

  for(i=0; i< n; i++)
    SDLColor_of_value(&color[i], Field(c_arr, i));
  if(flags == Val_none)
    c_flags = SDL_LOGPAL | SDL_PHYSPAL ;
  else
    c_flags = Int_val(Unopt(flags)) +1 ;

  status = SDL_SetPalette(s, c_flags, color, ofirstcolor, n);
#ifndef __GNUC__
  free(color);
#endif
  return Val_bool(status);
}
  

/*
 * Video modes-related functions
 */

value ml_SDL_GetVideoInfo(value unit)
{
  value result;
  const SDL_VideoInfo *info = SDL_GetVideoInfo();
  result = alloc_small(10, 0);
  Field(result, 0) = Val_bool(info->hw_available);
  Field(result, 1) = Val_bool(info->wm_available);
  Field(result, 2) = Val_bool(info->blit_hw);
  Field(result, 3) = Val_bool(info->blit_hw_CC);
  Field(result, 4) = Val_bool(info->blit_hw_A);
  Field(result, 5) = Val_bool(info->blit_sw);
  Field(result, 6) = Val_bool(info->blit_sw_CC);
  Field(result, 7) = Val_bool(info->blit_sw_A);
  Field(result, 8) = Val_bool(info->blit_fill);
  Field(result, 9) = Val_int(info->video_mem);
  return result;
}

value ml_SDL_GetVideoInfo_format(value unit)
{
  const SDL_VideoInfo *info = SDL_GetVideoInfo();
  return value_of_PixelFormat(info->vfmt);
}

value ml_SDL_VideoDriverName(value unit)
{
  char buff[64];
  if(! SDL_VideoDriverName(buff, 64))
    sdlvideo_raise_exception(SDL_GetError());
  return copy_string(buff);
}

value ml_SDL_ListModes(value obpp, value flag_list)
{
  Uint8 bpp = Opt_arg(obpp, Int_val, 0);
  SDL_Rect **modes;
  SDL_PixelFormat fmt;
  if(bpp){
    fmt.BitsPerPixel = bpp;
    modes = SDL_ListModes(&fmt, video_flag_val(flag_list));
  }
  else
    modes = SDL_ListModes(NULL, video_flag_val(flag_list));
  if(modes == (SDL_Rect **)0)
    return Val_int(0);
  if(modes == (SDL_Rect **)-1)
    return Val_int(1);
  {
    CAMLparam0();
    CAMLlocal3(v, l, r);
    register int i;
    l = nil();
    for(i=0; modes[i]; i++){
      r = alloc_small(2, 0);
      Field(r, 0) = Val_int(modes[i]->w);
      Field(r, 1) = Val_int(modes[i]->h);
      l = cons(r, l);
    }
    v = alloc_small(1, 0);
    Field(v, 0) = l;
    CAMLreturn(v);
  }
}

value ml_SDL_VideoModeOK(value w, value h, value bpp, value flags)
{
  return Val_int(SDL_VideoModeOK(Int_val(w), Int_val(h), 
				 Int_val(bpp), video_flag_val(flags)));
}

value ml_sdl_surface_info(value s)
{
  CAMLparam0();
  CAMLlocal3(f, r, v);
  SDL_Surface *surf = SDL_SURFACE(s);
  if(! surf)
    sdlvideo_raise_exception("dead surface");
  f = val_video_flag(surf->flags);
  r = value_of_Rect(surf->clip_rect);
  v = alloc_small(6, 0);
  Field(v, 0) = f;
  Field(v, 1) = Val_int(surf->w);
  Field(v, 2) = Val_int(surf->h);
  Field(v, 3) = Val_int(surf->pitch);
  Field(v, 4) = r;
  Field(v, 5) = Val_int(surf->refcount);
  CAMLreturn(v);
}

value ml_sdl_surface_info_format(value s)
{
  SDL_Surface *surf = SDL_SURFACE(s);
  return value_of_PixelFormat(surf->format);
}

value ml_SDL_GetVideoSurface(value unit)
{
  SDL_Surface *s = SDL_GetVideoSurface();
  if( !s)
    sdlvideo_raise_exception(SDL_GetError());

  return Val_SDLSurface(s, 0, Val_unit);
}

value ml_SDL_SetVideoMode(value w, value h, value obpp, value flags)
{
  int bpp = Opt_arg(obpp, Int_val, 0);
  SDL_Surface *s = SDL_SetVideoMode(Int_val(w), Int_val(h), 
				    bpp, video_flag_val(flags));
  if( !s)
    sdlvideo_raise_exception(SDL_GetError());

  return Val_SDLSurface(s, 0, Val_unit);
}



value ml_SDL_UpdateRect(value orect, value screen)
{
  SDL_Rect r = {0, 0, 0, 0};
  if(orect != Val_none)
    SDLRect_of_value(&r, Unopt(orect));
  SDL_UpdateRect(SDL_SURFACE(screen), r.x, r.y, r.w, r.h);
  return Val_unit;
}

value ml_SDL_UpdateRects(value rectl, value screen)
{
  int len = list_length(rectl);
  register int i;
#ifdef __GNUC__
  SDL_Rect r[len];
#else
  SDL_Rect *r = calloc(sizeof(SDL_Rect), len);
#endif
  for(i=0; i<len; i++){
    SDLRect_of_value(&r[i], hd(rectl));
    rectl = tl(rectl);
  }
  SDL_UpdateRects(SDL_SURFACE(screen), len, r);
#ifndef __GNUC__
  free(r);
#endif
  return Val_unit;
}

value ml_SDL_Flip(value screen)
{
  if(SDL_Flip(SDL_SURFACE(screen)) < 0)
    sdlvideo_raise_exception(SDL_GetError());
  return Val_unit;
}

value ml_SDL_SetGamma(value rg, value gg, value bg)
{
  if(SDL_SetGamma(Double_val(rg), Double_val(gg), Double_val(bg)) < 0)
    sdlvideo_raise_exception(SDL_GetError());
  return Val_unit;
}

/* SDL_SetGammaRamp */
/* SDL_GetGammaRamp */

/*
 * Pixels conversions
 */
value ml_SDL_MapRGB(value surf, value alpha, value color)
{
  Uint32 p;
  SDL_Color c;
  SDL_Surface *s = SDL_SURFACE(surf);
  SDLColor_of_value(&c, color);
  if(alpha == Val_none)
    p = SDL_MapRGB(s->format, c.r, c.g, c.b);
  else
    p = SDL_MapRGBA(s->format, c.r, c.g, c.b, Int_val(Unopt(alpha)) );
  return copy_int32(p);
}

value ml_SDL_GetRGB(value surf, value pixel)
{
  Uint32 p = Int32_val(pixel);
  SDL_Surface *s = SDL_SURFACE(surf);
  Uint8 r,g,b;
  value v;
  SDL_GetRGB(p, s->format, &r, &g, &b);
  v = alloc_small(3, 0);
  Field(v, 0) = Val_int(r);
  Field(v, 1) = Val_int(g);
  Field(v, 2) = Val_int(b);
  return v;
}

value ml_SDL_GetRGBA(value surf, value pixel)
{
  Uint32 p = Int32_val(pixel);
  SDL_Surface *s = SDL_SURFACE(surf);
  Uint8 r,g,b,a;
  SDL_GetRGBA(p, s->format, &r, &g, &b, &a);
  {
    CAMLparam0();
    CAMLlocal2(c, v);
    c = alloc_small(3, 0);
    Field(c, 0) = Val_int(r);
    Field(c, 1) = Val_int(g);
    Field(c, 2) = Val_int(b);
    v = alloc_small(2, 0);
    Field(v, 0) = c;
    Field(v, 1) = Val_int(a);
    CAMLreturn(v);
  }
}


/*
 * Surface-related functions
 */
value ml_SDL_CreateRGBSurface(value videoflags, value w, value h,
			      value depth, value rmask, value gmask,
			      value bmask, value amask)
{
  SDL_Surface *s = SDL_CreateRGBSurface(video_flag_val(videoflags), 
					Int_val(w), Int_val(h), 
					Int_val(depth),
					Int32_val(rmask), Int32_val(gmask), 
					Int32_val(bmask), Int32_val(amask));
  if(! s)
    sdlvideo_raise_exception(SDL_GetError());
  return ML_SURFACE(s);
}

value ml_SDL_CreateRGBSurface_bc(value *argv, int argc)
{
  return ml_SDL_CreateRGBSurface(argv[0], argv[1], argv[2], argv[3],
				 argv[4], argv[5], argv[6], argv[7]);
}

value ml_SDL_CreateRGBSurface_format(value surf, value videoflags, 
				     value w, value h)
{
  SDL_PixelFormat *fmt = SDL_SURFACE(surf)->format;
  SDL_Surface *s = SDL_CreateRGBSurface(video_flag_val(videoflags), 
					Int_val(w), Int_val(h), 
					fmt->BitsPerPixel,
					fmt->Rmask, fmt->Gmask,
					fmt->Bmask, fmt->Amask);
  if(! s)
    sdlvideo_raise_exception(SDL_GetError());
  return ML_SURFACE(s);
}

value ml_SDL_CreateRGBSurfaceFrom(value pixels, value w, value h,
				  value depth, value pitch,
				  value rmask, value gmask,
				  value bmask, value amask)
{
  struct caml_bigarray *barr = Bigarray_val(pixels);
  SDL_Surface *s = SDL_CreateRGBSurfaceFrom(barr->data, Int_val(w),
					    Int_val(h), Int_val(depth),
					    Int_val(pitch),
					    Int32_val(rmask), Int32_val(gmask),
					    Int32_val(bmask), Int32_val(amask)) ;
  return Val_SDLSurface(s, 1, pixels);
}

value ml_SDL_CreateRGBSurfaceFrom_bc(value *argv, int argc)
{
  return ml_SDL_CreateRGBSurfaceFrom(argv[0], argv[1], argv[2], 
				     argv[3], argv[4], argv[5], 
				     argv[6], argv[7], argv[8]);
}

value ml_SDL_MustLock(value s)
{
  return Val_bool(SDL_MUSTLOCK(SDL_SURFACE(s)));
}

value ml_SDL_LockSurface(value s)
{
  if(SDL_LockSurface(SDL_SURFACE(s)) < 0)
    sdlvideo_raise_exception(SDL_GetError());
  return Val_unit;
}

ML_1(SDL_UnlockSurface, SDL_SURFACE, Unit)

/*
 * BMP images loader
 */
value ml_SDL_LoadBMP(value fname)
{
  SDL_Surface *s = SDL_LoadBMP(String_val(fname));
  if(! s)
    sdlvideo_raise_exception(SDL_GetError());
  return ML_SURFACE(s);
}

value ml_SDL_SaveBMP(value surf, value fname)
{
  if(SDL_SaveBMP(SDL_SURFACE(surf), String_val(fname)) < 0)
    sdlvideo_raise_exception(SDL_GetError());
  return Val_unit;
}


/*
 * colorkey / alpha / cliprect
 */
value ml_SDL_unset_color_key(value surf)
{
  if(SDL_SetColorKey(SDL_SURFACE(surf), 0, 0) < 0)
    sdlvideo_raise_exception(SDL_GetError());
  return Val_unit;
}

value ml_SDL_SetColorKey(value surf, value orle, value key)
{
  Uint32 flags = SDL_SRCCOLORKEY;
  int rle = Opt_arg(orle, Bool_val, 0);
  if(rle)
    flags |= SDL_RLEACCEL;
  if(SDL_SetColorKey(SDL_SURFACE(surf), flags, Int32_val(key)) < 0)
    sdlvideo_raise_exception(SDL_GetError());
  return Val_unit;
}

value ml_SDL_get_color_key(value s)
{
  SDL_Surface *surf = SDL_SURFACE(s);
  return copy_int32(surf->format->colorkey);
}

value ml_SDL_unset_alpha(value surf)
{
  if(SDL_SetAlpha(SDL_SURFACE(surf), 0, 0) < 0)
    sdlvideo_raise_exception(SDL_GetError());
  return Val_unit;
}

value ml_SDL_SetAlpha(value surf, value orle, value alpha)
{
  Uint32 flags = SDL_SRCALPHA;
  int rle = Opt_arg(orle, Bool_val, 0);
  if(rle)
    flags |= SDL_RLEACCEL;
  if(SDL_SetAlpha(SDL_SURFACE(surf), flags, Int_val(alpha)) < 0)
    sdlvideo_raise_exception(SDL_GetError());
  return Val_unit;
}

value ml_SDL_get_alpha(value s)
{
  SDL_Surface *surf = SDL_SURFACE(s);
  return Val_int(surf->format->alpha);
}

value ml_SDL_UnsetClipRect(value surf)
{
  SDL_SetClipRect(SDL_SURFACE(surf), NULL);
  return Val_unit;
}

value ml_SDL_SetClipRect(value surf, value r)
{
  SDL_Rect rect;
  SDLRect_of_value(&rect, r);
  return Val_bool(SDL_SetClipRect(SDL_SURFACE(surf), &rect));
}

value ml_SDL_GetClipRect(value s)
{
  SDL_Rect r;
  SDL_GetClipRect(SDL_SURFACE(s), &r);
  return value_of_Rect(r);
}


/* 
 * surface blittinf and conversion
 */

value ml_SDL_BlitSurface(value src_s, value osrc_r, 
			 value dst_s, value odst_r, value unit)
{
  SDL_Rect tmp_src_r, tmp_dst_r, *src_r, *dst_r;
  if(osrc_r == Val_none)
    src_r = NULL;
  else {
    SDLRect_of_value(&tmp_src_r, Unopt(osrc_r));
    src_r = &tmp_src_r;
  }
  if(odst_r == Val_none)
    dst_r = NULL;
  else {
    SDLRect_of_value(&tmp_dst_r, Unopt(odst_r));
    dst_r = &tmp_dst_r;
  }

  if( SDL_BlitSurface(SDL_SURFACE(src_s), src_r, 
		      SDL_SURFACE(dst_s), dst_r) < 0)
    sdlvideo_raise_exception(SDL_GetError());

  if(osrc_r != Val_none)
    update_value_from_SDLRect(Unopt(osrc_r), src_r);
  if(odst_r != Val_none)
    update_value_from_SDLRect(Unopt(odst_r), dst_r);
  return Val_unit;
}

value ml_SDL_FillRect(value odst_r, value dst_s, value pixel)
{
  SDL_Rect tmp_r, *r;
  if(odst_r == Val_none) 
    r = NULL;
  else {
    SDLRect_of_value(&tmp_r, Unopt(odst_r));
    r = &tmp_r;
  }
  if( SDL_FillRect(SDL_SURFACE(dst_s), r, Int32_val(pixel)) < 0 )
    sdlvideo_raise_exception(SDL_GetError());
  if(odst_r != Val_none)
    update_value_from_SDLRect(Unopt(odst_r), r);
  return Val_unit;
}

value ml_SDL_DisplayFormat(value oalpha, value surf)
{
  SDL_Surface *s;
  int alpha = Opt_arg(oalpha, Bool_val, 0);
  if(! alpha)
    s = SDL_DisplayFormat(SDL_SURFACE(surf));
  else
    s = SDL_DisplayFormatAlpha(SDL_SURFACE(surf));
  if( !s)
    sdlvideo_raise_exception(SDL_GetError());
  return ML_SURFACE(s);
}

value ml_bigarray_pixels(value s, value mlBpp)
{
  SDL_Surface *surf = SDL_SURFACE(s);
  Uint8 Bpp = Int_val(mlBpp);
  int b_flag = 0;
  long dim = surf->h;
  if(Bpp != 0 && Bpp != surf->format->BytesPerPixel)
    invalid_argument("wrong pixel format");
  switch (Bpp) {
  case 0:
  case 1:  /* 8 bpp */
    dim *= surf->pitch;
    b_flag |= BIGARRAY_UINT8; break;
  case 2:  /* 16 bpp */
    dim *= surf->pitch / 2;
    b_flag |= BIGARRAY_UINT16; break;
  case 3:  /* 24 bpp */
    dim *= surf->pitch;
    b_flag |= BIGARRAY_UINT8; break;
  case 4:  /* 32 bpp */
    dim *= surf->pitch / 4;
    b_flag |= BIGARRAY_INT32; break;
  default:
    sdlvideo_raise_exception("unsupported");
  }
  b_flag |= BIGARRAY_C_LAYOUT | BIGARRAY_EXTERNAL ;
  return alloc_bigarray(b_flag, 1, surf->pixels, &dim);
}



/*
 * GL interaction functions
 */

ML_0(SDL_GL_SwapBuffers, Unit)

static const SDL_GLattr GL_attr_map[12] = {
  SDL_GL_RED_SIZE, SDL_GL_GREEN_SIZE,
  SDL_GL_BLUE_SIZE, SDL_GL_ALPHA_SIZE,
  SDL_GL_BUFFER_SIZE, SDL_GL_DOUBLEBUFFER,
  SDL_GL_DEPTH_SIZE, SDL_GL_STENCIL_SIZE,
  SDL_GL_ACCUM_RED_SIZE, SDL_GL_ACCUM_GREEN_SIZE,
  SDL_GL_ACCUM_BLUE_SIZE, SDL_GL_ACCUM_ALPHA_SIZE, };

value ml_SDL_GL_SetAttribute(value attrl)
{
  while( is_not_nil(attrl) ){
    value attr = hd(attrl);
    SDL_GL_SetAttribute( GL_attr_map[ Tag_val(attr) ], 
			 Int_val(Field(attr, 0)) );
    attrl = tl(attrl);
  }
  return Val_unit;
}

value ml_SDL_GL_GetAttribute(value unit)
{
  CAMLparam0();
  CAMLlocal2(v, a);
  int i, val;
  v = nil();
  for(i=11; i>=0; i--){
    if( SDL_GL_GetAttribute( GL_attr_map[i], &val) < 0)
      CAMLreturn( ( sdlvideo_raise_exception(SDL_GetError()) ,
		   Val_unit ) ) ;
    a = alloc_small(1, i);
    Field(a, 0) = Val_int(val);
    v = cons(a, v);
  }
  CAMLreturn(v);
}
