
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>

#include <SDL.h>

#include "common.h"
#include "sdlvideo_stub.h"

/*
 * GL interaction functions
 */

ML_0(SDL_GL_SwapBuffers, Unit)

static const SDL_GLattr GL_attr_map[13] = {
  SDL_GL_RED_SIZE, SDL_GL_GREEN_SIZE,
  SDL_GL_BLUE_SIZE, SDL_GL_ALPHA_SIZE,
  SDL_GL_BUFFER_SIZE, SDL_GL_DOUBLEBUFFER,
  SDL_GL_DEPTH_SIZE, SDL_GL_STENCIL_SIZE,
  SDL_GL_ACCUM_RED_SIZE, SDL_GL_ACCUM_GREEN_SIZE,
  SDL_GL_ACCUM_BLUE_SIZE, SDL_GL_ACCUM_ALPHA_SIZE, 
  SDL_GL_STEREO };

CAMLprim value ml_SDL_GL_SetAttribute(value attrl)
{
  while( is_not_nil(attrl) ){
    value attr = hd(attrl);
    SDL_GL_SetAttribute( GL_attr_map[ Tag_val(attr) ], 
			 Int_val(Field(attr, 0)) );
    attrl = tl(attrl);
  }
  return Val_unit;
}

CAMLprim value ml_SDL_GL_GetAttribute(value unit)
{
  CAMLparam0();
  CAMLlocal2(v, a);
  int i, val;
  v = Val_emptylist;
  for(i=12; i>=0; i--){
    if( SDL_GL_GetAttribute( GL_attr_map[i], &val) < 0)
      CAMLreturn( ( sdlvideo_raise_exception(SDL_GetError()) ,
		   Val_unit ) ) ;
    a = alloc_small(1, i);
    Field(a, 0) = Val_int(val);
    v = cons(a, v);
  }
  CAMLreturn(v);
}

/* LablGL interaction : the following defines come from LablGL 0.98 */
#define MLTAG_ubyte	Val_int(520420861)
#define SIZE_RAW 5
#define Kind_raw(raw) (Field(raw,0))
#define Base_raw(raw) (Field(raw,1))
#define Offset_raw(raw) (Field(raw,2))
#define Size_raw(raw) (Field(raw,3))
#define Static_raw(raw) (Field(raw,4))

CAMLprim value ml_SDL_GL_to_raw(value s)
{
  SDL_Surface *surf = SDL_SURFACE(s);
  void *pixels = surf->pixels;
  size_t size  = surf->h * surf->pitch;
  value raw;
  raw = alloc_small (SIZE_RAW+1, 0);
  Kind_raw(raw) = MLTAG_ubyte;
  Size_raw(raw) = Val_int(size);
  Base_raw(raw) = Val_bp(pixels);
  Offset_raw(raw) = Val_int(0);
  Static_raw(raw) = Val_false;
  /* we extend the record with a field containing the
     SDL surface to keep it live */
  Field(raw, SIZE_RAW) = s;
  return raw;
}
