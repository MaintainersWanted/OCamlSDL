
let print_mod kmod =
  if kmod land Sdlkey.kmod_ctrl <> 0
  then Printf.printf " CTRL" ;
  if kmod land Sdlkey.kmod_shift <> 0
  then Printf.printf " SHIFT" ;
  if kmod land Sdlkey.kmod_alt <> 0
  then Printf.printf " ALT" ;
  if kmod land Sdlkey.kmod_meta <> 0
  then Printf.printf " META" ;
  print_newline ()


let print_key { Sdlevent2.ke_state = state; 
		Sdlevent2.keysym = key ;
		Sdlevent2.keymod = kmod ;
		Sdlevent2.keycode = kcode } =
  let c = 
    try Sdlkey.char_of_key key
    with Invalid_argument _ -> '?' in
  Printf.printf "Key %s: %c [%s] (%03d) - %s -"
    ( match state with
    | Sdlevent2.PRESSED ->  "pressed "
    | Sdlevent2.RELEASED -> "released" )
    c 
    (if kcode = '\000' 
    then ""
    else if Char.code kcode < 32
    then "^" ^ String.make 1 (Char.chr (Char.code kcode + Char.code '@'))
    else String.make 1 kcode)
    (Sdlkey.int_of_key key) (Sdlkey.name key) ;
  print_mod kmod ;
  flush stdout

let main () = 
  Sdl.init ~auto_clean:true [ `VIDEO ] ;

  let screen = Sdlvideo.set_video_mode 640 480 16 [ `SWSURFACE ] in

  let mask = 
    Sdlevent2.keyboard_event_mask lor
    Sdlevent2.mousebuttonup_mask lor
    Sdlevent2.quit_mask in
  Sdlevent2.disable_events Sdlevent2.all_events_mask ;
  Sdlevent2.enable_events mask ;
  Sdlkey.enable_unicode true ;

  try while true do
    Sdlevent2.pump () ;
    match Sdlevent2.get ~mask 1 with
    | [] -> Sdltimer.delay 10
	  
    | evt :: _ ->
	match evt with
	| Sdlevent2.QUIT 
	| Sdlevent2.MOUSEBUTTONUP _
	| Sdlevent2.KEYUP 
	    { Sdlevent2.keysym = Sdlkey.KEY_ESCAPE } ->
	      raise Exit

	| Sdlevent2.KEYDOWN ke
	| Sdlevent2.KEYUP ke ->
	    print_key ke

	| _ -> 
	    prerr_endline "another event"
  done
  with Exit -> ()

let _ = 
  try main ()
  with exn -> Sdl.quit () ; raise exn
