(** Keyboard handling and key symbols *)

(** {1 Keysyms } *)

(** Concrete type describing keyboard keys ("keysym") *)
type t = 
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
  | KEY_AT           (** Skip uppercase letters *)
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
  | KEY_DELETE     (** End of ASCII mapped keysyms *)
  | KEY_WORLD_0    (** International keyboard syms *)
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
  | KEY_KP0        (** Numeric keypad *)
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
  | KEY_UP         (** Arrows + Home/End pad *)
  | KEY_DOWN
  | KEY_RIGHT
  | KEY_LEFT
  | KEY_INSERT
  | KEY_HOME
  | KEY_END
  | KEY_PAGEUP
  | KEY_PAGEDOWN
  | KEY_F1         (** Function keys *)
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
  | KEY_NUMLOCK    (** Key state modifier keys *)
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
  | KEY_LSUPER		(** Left "Windows" key *)
  | KEY_RSUPER		(** Right "Windows" key *)
  | KEY_MODE		(** "Alt Gr" key *)
  | KEY_COMPOSE         (** Multi-key compose key *)
  | KEY_HELP       (** Miscellaneous function keys *)
  | KEY_PRINT
  | KEY_SYSREQ
  | KEY_BREAK
  | KEY_MENU
  | KEY_POWER		(** Power Macintosh power key *)
  | KEY_EURO		(** Some european keyboards *)
  | KEY_UNDO	        (** Atari keyboard has Undo *)

val int_of_key  : t -> int
(** get the SDL keysym of the key *)
val key_of_int  : int -> t
(** get the key corresponding to a SDL keysym
   @raise Invalid_arg if not a valid SDL keysym *)

val char_of_key : t -> char
(** Returns a (iso-8859-1) character corresponding to a key
   @raise Invalid_arg if corresponding SDL keysym is > 255 *)

val num_keys : int
(** number of keys in the Sdlkey.t variant type : should be [232] *)
val max_code : int
(** highest SDL keysym : should be [322] *)

val name : t -> string
(** @return a short string describing the key *)


(** {1 Keyboard handling } *)

external enable_unicode : bool -> unit
    = "ml_SDL_EnableUNICODE"
(** Enable unicode translation of keysyms for keyboard events *)
external query_unicode : unit -> bool
    = "ml_SDL_QueryUNICODE"


external disable_key_repeat : unit -> unit
    = "ml_SDL_DisableKeyRepeat"
(** Disable keyboard repeat *)
external enable_key_repeat : ?delay:int -> ?interval:int -> unit -> unit
    = "ml_SDL_EnableKeyRepeat"
(** Enable keyboard repeat
   @param delay initial delay in ms between the time when a key is
   pressed, and keyboard repeat begins
   @param interval the time in ms between keyboard repeat events
*)


open Bigarray
external get_key_state : unit -> (int, int8_unsigned_elt, c_layout) Array1.t
    = "ml_SDL_GetKeyState"
(** Get a snapshot of the current state of the keyboard.
   @return an array of keystates, indexed by the SDL keysyms 
   (cf {! Sdlkey.int_of_key}) *)

val is_key_pressed : t -> bool
(** Checks wether a key is currently pressed on the keyboard. *)


(** {1 Key modifiers } *)

type mod_state = int

(** The following values are flags. Use with [land], [lor], etc. *)

val kmod_none   : mod_state
val kmod_lshift : mod_state
val kmod_rshift : mod_state
val kmod_lctrl  : mod_state
val kmod_rctrl  : mod_state
val kmod_lalt   : mod_state
val kmod_ralt   : mod_state
val kmod_lmeta  : mod_state
val kmod_rmeta  : mod_state
val kmod_num    : mod_state
val kmod_caps   : mod_state
val kmod_mode   : mod_state

val kmod_ctrl   : mod_state
val kmod_shift  : mod_state
val kmod_alt    : mod_state
val kmod_meta   : mod_state

external get_mod_state : unit -> mod_state
    = "ml_SDL_GetModState"
(** Get the current key modifier state *)

external set_mod_state : mod_state -> unit
    = "ml_SDL_SetModState"
(** Set the current key modifier state
   This does not change the keyboard state, only the key modifier flags. *)

(**/**)
val link_me : unit
