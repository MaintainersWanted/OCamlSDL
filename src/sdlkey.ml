type key =       
  | KEY_UNKNOWN  
  | KEY_BACKSPACE
  | KEY_TAB      
  | KEY_CLEAR    
  | KEY_RETURN   
  | KEY_PAUSE    
  | KEY_ESCAPE   
  | KEY_SPACE    
  | KEY_EXCLAIM
  | KEY_QUOTEDBL
  | KEY_HASH
  | KEY_DOLLAR
  | KEY_AMPERSAND
  | KEY_QUOTE
  | KEY_LEFTPAREN
  | KEY_RIGHTPAREN
  | KEY_ASTERISK
  | KEY_PLUS
  | KEY_COMMA
  | KEY_MINUS
  | KEY_PERIOD
  | KEY_SLASH
  | KEY_0
  | KEY_1
  | KEY_2
  | KEY_3
  | KEY_4
  | KEY_5
  | KEY_6
  | KEY_7
  | KEY_8
  | KEY_9
  | KEY_COLON
  | KEY_SEMICOLON
  | KEY_LESS
  | KEY_EQUALS
  | KEY_GREATER
  | KEY_QUESTION
  | KEY_AT

  (* Skip uppercase letters *)
  
  | KEY_LEFTBRACKET
  | KEY_BACKSLASH
  | KEY_RIGHTBRACKET
  | KEY_CARET
  | KEY_UNDERSCORE
  | KEY_BACKQUOTE
  | KEY_a
  | KEY_b
  | KEY_c
  | KEY_d
  | KEY_e
  | KEY_f
  | KEY_g
  | KEY_h
  | KEY_i
  | KEY_j
  | KEY_k
  | KEY_l
  | KEY_m
  | KEY_n
  | KEY_o
  | KEY_p
  | KEY_q
  | KEY_r
  | KEY_s
  | KEY_t
  | KEY_u
  | KEY_v
  | KEY_w
  | KEY_x
  | KEY_y
  | KEY_z
  | KEY_DELETE
  (* End of ASCII mapped keysyms *)

  (* International keyboard syms *)
  | KEY_WORLD_0
  | KEY_WORLD_1
  | KEY_WORLD_2
  | KEY_WORLD_3
  | KEY_WORLD_4
  | KEY_WORLD_5
  | KEY_WORLD_6
  | KEY_WORLD_7
  | KEY_WORLD_8
  | KEY_WORLD_9
  | KEY_WORLD_10
  | KEY_WORLD_11
  | KEY_WORLD_12
  | KEY_WORLD_13
  | KEY_WORLD_14
  | KEY_WORLD_15
  | KEY_WORLD_16
  | KEY_WORLD_17
  | KEY_WORLD_18
  | KEY_WORLD_19
  | KEY_WORLD_20
  | KEY_WORLD_21
  | KEY_WORLD_22
  | KEY_WORLD_23
  | KEY_WORLD_24
  | KEY_WORLD_25
  | KEY_WORLD_26
  | KEY_WORLD_27
  | KEY_WORLD_28
  | KEY_WORLD_29
  | KEY_WORLD_30
  | KEY_WORLD_31
  | KEY_WORLD_32
  | KEY_WORLD_33
  | KEY_WORLD_34
  | KEY_WORLD_35
  | KEY_WORLD_36
  | KEY_WORLD_37
  | KEY_WORLD_38
  | KEY_WORLD_39
  | KEY_WORLD_40
  | KEY_WORLD_41
  | KEY_WORLD_42
  | KEY_WORLD_43
  | KEY_WORLD_44
  | KEY_WORLD_45
  | KEY_WORLD_46
  | KEY_WORLD_47
  | KEY_WORLD_48
  | KEY_WORLD_49
  | KEY_WORLD_50
  | KEY_WORLD_51
  | KEY_WORLD_52
  | KEY_WORLD_53
  | KEY_WORLD_54
  | KEY_WORLD_55
  | KEY_WORLD_56
  | KEY_WORLD_57
  | KEY_WORLD_58
  | KEY_WORLD_59
  | KEY_WORLD_60
  | KEY_WORLD_61
  | KEY_WORLD_62
  | KEY_WORLD_63
  | KEY_WORLD_64
  | KEY_WORLD_65
  | KEY_WORLD_66
  | KEY_WORLD_67
  | KEY_WORLD_68
  | KEY_WORLD_69
  | KEY_WORLD_70
  | KEY_WORLD_71
  | KEY_WORLD_72
  | KEY_WORLD_73
  | KEY_WORLD_74
  | KEY_WORLD_75
  | KEY_WORLD_76
  | KEY_WORLD_77
  | KEY_WORLD_78
  | KEY_WORLD_79
  | KEY_WORLD_80
  | KEY_WORLD_81
  | KEY_WORLD_82
  | KEY_WORLD_83
  | KEY_WORLD_84
  | KEY_WORLD_85
  | KEY_WORLD_86
  | KEY_WORLD_87
  | KEY_WORLD_88
  | KEY_WORLD_89
  | KEY_WORLD_90
  | KEY_WORLD_91
  | KEY_WORLD_92
  | KEY_WORLD_93
  | KEY_WORLD_94
  | KEY_WORLD_95

  (* Numeric keypad *)
  | KEY_KP0
  | KEY_KP1
  | KEY_KP2
  | KEY_KP3
  | KEY_KP4
  | KEY_KP5
  | KEY_KP6
  | KEY_KP7
  | KEY_KP8
  | KEY_KP9
  | KEY_KP_PERIOD
  | KEY_KP_DIVIDE
  | KEY_KP_MULTIPLY
  | KEY_KP_MINUS
  | KEY_KP_PLUS
  | KEY_KP_ENTER
  | KEY_KP_EQUALS

  (* Arrows + Home/End pad *)
  | KEY_UP
  | KEY_DOWN
  | KEY_RIGHT
  | KEY_LEFT
  | KEY_INSERT
  | KEY_HOME
  | KEY_END
  | KEY_PAGEUP
  | KEY_PAGEDOWN

  (* Function keys *)
  | KEY_F1
  | KEY_F2
  | KEY_F3
  | KEY_F4
  | KEY_F5
  | KEY_F6
  | KEY_F7
  | KEY_F8
  | KEY_F9
  | KEY_F10
  | KEY_F11
  | KEY_F12
  | KEY_F13
  | KEY_F14
  | KEY_F15
      
  (* Key state modifier keys *)
  | KEY_NUMLOCK
  | KEY_CAPSLOCK
  | KEY_SCROLLOCK
  | KEY_RSHIFT
  | KEY_LSHIFT
  | KEY_RCTRL
  | KEY_LCTRL
  | KEY_RALT
  | KEY_LALT
  | KEY_RMETA
  | KEY_LMETA
  | KEY_LSUPER		(* Left "Windows" key *)
  | KEY_RSUPER		(* Right "Windows" key *)
  | KEY_MODE		(* "Alt Gr" key *)
  | KEY_COMPOSE         (* Multi-key compose key *)

   (* Miscellaneous function keys *)
  | KEY_HELP
  | KEY_PRINT
  | KEY_SYSREQ
  | KEY_BREAK
  | KEY_MENU
  | KEY_POWER		(* Power Macintosh power key *)
  | KEY_EURO		(* Some european keyboards *)
  | KEY_UNDO	        (* Atari keyboard has Undo *)


let keycodes =
  [ (0, 0); (8, 9); (12, 13); (19, 19); (27, 27); 
    (32, 36); (38, 64);
    (91, 122); (127, 127); 
    (160, 296); (300, 322); ]

let num_keys =
  (Obj.magic KEY_UNDO) + 1

let keycode_table =
  let table = Array.make num_keys 0 in
  let rec proc i = function
    | (a, b) :: l ->
	for j=0 to b-a do
	  table.(i+j) <- a+j
	done ;
	proc (i + b-a+1) l
    | [] -> ()
  in
  proc 0 keycodes ;
  Callback.register "keycode_table" table ;
  table
  
let max_code = 
  keycode_table.( num_keys-1 )

let int_of_key (key : key) =
  keycode_table.(Obj.magic key)
  
let char_of_key key =
  let code = int_of_key key in
  if code < 256
  then Char.chr code
  else invalid_arg "Sdlkey.char_of_key"

let rev_keycode_table = 
  let table = Array.make (max_code +1) (-1) in
  for i=0 to pred num_keys do
    table.( keycode_table.(i) ) <- i
  done ;
  Callback.register "rev_keycode_table" table ;
  table

let key_of_int n =
  if n < 0 || n > max_code
  then invalid_arg "Sdlkey.key_of_int" ;
  let k = rev_keycode_table.(n) in
  if k < 0
  then invalid_arg "Sdlkey.key_of_int" 
  else (Obj.magic k : key)

external _name : int -> string 
  = "ml_SDL_GetKeyName"
let name key = 
  _name (int_of_key key)

external disable_key_repeat : unit -> unit
    = "ml_SDL_DisableKeyRepeat"
external enable_key_repeat : ?delay:int -> ?interval:int -> unit -> unit
    = "ml_SDL_EnableKeyRepeat"

open Bigarray
external get_key_state : unit -> (int, int8_unsigned_elt, c_layout) Array1.t
    = "ml_SDL_GetKeyState"

external _is_key_pressed : int -> bool
    = "ml_sdl_key_pressed"
let is_key_pressed key = 
  _is_key_pressed (int_of_key key)

type mod_state = int
let kmod_none  = 0x0000
let kmod_lshift= 0x0001
let kmod_rshift= 0x0002
let kmod_lctrl = 0x0040
let kmod_rctrl = 0x0080
let kmod_lalt  = 0x0100
let kmod_ralt  = 0x0200
let kmod_lmeta = 0x0400
let kmod_rmeta = 0x0800
let kmod_num   = 0x1000
let kmod_caps  = 0x2000
let kmod_mode  = 0x4000

let kmod_ctrl  = 0x00C0
let kmod_shift = 0x0003
let kmod_alt   = 0x0300
let kmod_meta  = 0x0C00

external get_mod_state : unit -> mod_state
    = "ml_SDL_GetModState"
external set_mod_state : mod_state -> unit
    = "ml_SDL_SetModState"

let link_me = ()
