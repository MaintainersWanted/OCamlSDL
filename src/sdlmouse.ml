open Bigarray

type button = 
  | BUTTON_LEFT
  | BUTTON_MIDDLE
  | BUTTON_RIGHT
  | BUTTON_WHEELUP
  | BUTTON_WHEELDOWN

external get_state : ?relative:bool -> unit -> int * int * button list
    = "mlsdlevent_get_mouse_state"

external warp : int -> int -> unit
    = "ml_SDL_WarpMouse"

type cursor
type cursor_data = {
    data  : (int, int8_unsigned_elt, c_layout) Array2.t ;
    mask  : (int, int8_unsigned_elt, c_layout) Array2.t ;
    w     : int ;
    h     : int ;
    hot_x : int ;
    hot_y : int ;
  } 

external make_cursor : 
  data:(int, int8_unsigned_elt, c_layout) Array2.t ->
  mask:(int, int8_unsigned_elt, c_layout) Array2.t ->
  hot_x:int -> hot_y:int -> cursor
    = "ml_SDL_CreateCursor"

external free_cursor : cursor -> unit
    = "ml_SDL_FreeCursor"

external set_cursor : cursor -> unit
    = "ml_SDL_SetCursor"

external cursor_visible : unit -> bool
    = "ml_SDL_ShowCursor_query"

external show_cursor : bool -> unit
    = "ml_SDL_ShowCursor"

external get_cursor : unit -> cursor
    = "ml_SDL_GetCursor"

external cursor_data : cursor -> cursor_data
    = "ml_SDL_Cursor_data"

let string_of_bits x =
  let s = String.make 8 ' ' in
  for i=0 to 7 do
    if x land (1 lsl i) <> 0
    then s.[7-i] <- '@'
  done ;
  s

let pprint_cursor c =
  let { data = data ; mask = mask } = cursor_data c in
  let h = Array2.dim1 data in
  let w = Array2.dim2 data in
  print_endline "data :" ;
  for i=0 to pred h do
    for j=0 to pred w do
      print_string (string_of_bits data.{i, j})
    done ;
    print_newline ()
  done ;
  print_newline () ;
  print_endline "mask :" ;
  for i=0 to pred h do
    for j=0 to pred w do
      print_string (string_of_bits mask.{i, j})
    done ;
    print_newline ()
  done

let convert_to_cursor ~data ~mask ~w ~h ~hot_x ~hot_y =
  if Array.length data <> Array.length mask ||
  w mod 8 <> 0 ||
  Array.length data <> h * w / 8
  then invalid_arg "Sdlmouse.convert_to_cursor" ;
  let w' = w / 8 in
  let b_data = Array2.create int8_unsigned c_layout h w' in
  let b_mask = Array2.create int8_unsigned c_layout h w' in
  for i=0 to pred h do
    for j=0 to pred w' do
      b_data.{i, j} <- data.( w' * i + j) ;
      b_mask.{i, j} <- mask.( w' * i + j)
    done 
  done ;
  make_cursor ~data:b_data ~mask:b_mask ~hot_x ~hot_y

