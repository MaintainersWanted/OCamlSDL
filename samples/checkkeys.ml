
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


let print_key { Sdlevent.ke_state = state; 
		Sdlevent.keysym = key ;
		Sdlevent.keymod = kmod ;
		Sdlevent.keycode = kcode } =
  let c = 
    try Sdlkey.char_of_key key
    with Invalid_argument _ -> '?' in
  Printf.printf "Key %s: %c [%s] (%03d) - %s -"
    ( match state with
    | Sdlevent.PRESSED ->  "pressed "
    | Sdlevent.RELEASED -> "released" )
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

  let screen = Sdlvideo.set_video_mode 640 480 [ `SWSURFACE ] in

  let mask = 
    Sdlevent.keyboard_event_mask lor
    Sdlevent.mousebuttonup_mask lor
    Sdlevent.quit_mask in
  Sdlevent.disable_events Sdlevent.all_events_mask ;
  Sdlevent.enable_events mask ;
  Sdlkey.enable_unicode true ;

  try while true do
    Sdlevent.pump () ;
    match Sdlevent.get ~mask 1 with
    | [] -> Sdltimer.delay 10
	  
    | evt :: _ ->
	match evt with
	| Sdlevent.QUIT 
	| Sdlevent.MOUSEBUTTONUP _
	| Sdlevent.KEYUP 
	    { Sdlevent.keysym = Sdlkey.KEY_ESCAPE } ->
	      raise Exit

	| Sdlevent.KEYDOWN ke
	| Sdlevent.KEYUP ke ->
	    print_key ke

	| _ -> 
	    prerr_endline "another event"
  done
  with Exit -> ()

let _ = 
  try main ()
  with exn -> Sdl.quit () ; raise exn
