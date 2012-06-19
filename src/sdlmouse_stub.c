
#include <SDL_mouse.h>

#include "common.h"
#include "sdlmouse_stub.h"

/*
 * Mouse state
 */

value value_of_mousebutton_state(Uint8 state)
{
  value v = Val_emptylist;
  int i;
  const int buttons[] = {
    SDL_BUTTON_LEFT, 
    SDL_BUTTON_MIDDLE,
    SDL_BUTTON_RIGHT, 
  };

  for(i=SDL_TABLESIZE(buttons)-1; i>=0; i--)
    if(state & SDL_BUTTON(buttons[i]))
      v = mlsdl_cons(Val_int(i), v);
  return v;
}

CAMLprim value mlsdlevent_get_mouse_state(value orelative, value unit)
{
  CAMLparam0();
  CAMLlocal2(s, v);
  int x,y;
  int relative = Opt_arg(orelative, Bool_val, 0);
  Uint8 state;
  if(relative)
    state = SDL_GetRelativeMouseState(&x, &y);
  else
    state = SDL_GetMouseState(&x, &y);
  s = value_of_mousebutton_state(state);
  v = alloc_small(3, 0);
  Field(v, 0) = Val_int(x);
  Field(v, 1) = Val_int(y);
  Field(v, 2) = s ;
  CAMLreturn(v);
}

ML_2(SDL_WarpMouse, Int_val, Int_val, Unit)


/*
 * Cursors
 */

CAMLprim value ml_SDL_CreateCursor(value data, value mask, value hot_x, value hot_y)
{
  struct caml_bigarray *b_data = Bigarray_val(data);
  struct caml_bigarray *b_mask = Bigarray_val(mask);
  SDL_Cursor *c;
  int h = b_data->dim[0];
  int w = b_data->dim[1];
  if(b_mask->dim[0] != h ||
     b_mask->dim[1] != w)
    invalid_argument("Sdl_mouse.create_cursor: wrong data/mask format");
  
  c = SDL_CreateCursor((Uint8 *)b_data->data, (Uint8 *)b_mask->data, 
		       w*8, h, Int_val(hot_x), Int_val(hot_y));
  {
    CAMLparam2(data, mask);
    CAMLlocal2(v, r);
    v = abstract_ptr(c);
    r = alloc_small(3, 0);
    Field(r, 0) = v;
    Field(r, 1) = data;
    Field(r, 2) = mask;
    CAMLreturn(r);
  }
}

#define MLSDL_CURSOR(v) ((SDL_Cursor *)Field(Field((v), 0), 0))

CAMLprim value ml_SDL_FreeCursor(value c)
{
  SDL_FreeCursor( MLSDL_CURSOR(c) );
  nullify_abstract (Field(c, 0));
  Store_field(c, 1, Val_unit);
  Store_field(c, 2, Val_unit);
  return Val_unit;
}

ML_1(SDL_SetCursor, MLSDL_CURSOR, Unit)
ML_1(SDL_ShowCursor, Bool_val, Unit)

CAMLprim value ml_SDL_ShowCursor_query(value unit)
{
  return Val_bool(SDL_ShowCursor(-1));
}

CAMLprim value ml_SDL_GetCursor(value unit)
{
  CAMLparam0();
  CAMLlocal2(v, r);  
  SDL_Cursor *c = SDL_GetCursor();
  v = abstract_ptr(c);
  r = alloc_small(3, 0);
  Field(r, 0) = v;
  Field(r, 1) = Val_unit;
  Field(r, 2) = Val_unit;
  CAMLreturn(r);
}

CAMLprim value ml_SDL_Cursor_data(value cursor)
{
  CAMLparam0();
  CAMLlocal3(v, b_data, b_mask);
  SDL_Cursor *c = MLSDL_CURSOR(cursor);
  
  if(Field(cursor, 1) != Val_unit) {
    b_data = Field(cursor, 1);
    b_mask = Field(cursor, 2);
  }
  else {
    b_data = alloc_bigarray_dims(BIGARRAY_UINT8 | 
				 BIGARRAY_C_LAYOUT | 
				 BIGARRAY_EXTERNAL, 
				 2, c->data, 
				 c->area.h,
				 c->area.w / 8);
    b_mask = alloc_bigarray_dims(BIGARRAY_UINT8 |
				 BIGARRAY_C_LAYOUT | 
				 BIGARRAY_EXTERNAL, 
				 2, c->mask, 
				 c->area.h,
				 c->area.w / 8);
  }
  v = alloc_small(6, 0);
  Field(v, 0) = b_data;
  Field(v, 1) = b_mask;
  Field(v, 2) = Val_int(c->area.w);
  Field(v, 3) = Val_int(c->area.h);
  Field(v, 4) = Val_int(c->hot_x);
  Field(v, 5) = Val_int(c->hot_y);
  CAMLreturn(v);
}
