
module J = Sdljoystick
module E = Sdlevent
module V = Sdlvideo

let scr_width  = 640
let scr_height = 480

let clip (v : int) a b = 
  min (max v a) b

let watch_joystick joystick =
  (* Set a video mode to display joystick axis position *)
  let screen = Sdlvideo.set_video_mode 
      ~w:scr_width ~h:scr_height ~bpp:16 [] in

  (* define some colors *)
  let white = V.map_RGB screen (255, 255, 255) in
  let black = V.map_RGB screen (0, 0, 0) in

  (* Print info about the joystick we are watching *)
  let name = J.name (J.index joystick) in
  Printf.printf "Watching joystick %d: (%s)\n" 
    (J.index joystick) name ;
  Printf.printf "Joystick has %d axes, %d hats, %d balls, and %d buttons\n"
    (J.num_axes joystick) (J.num_hats joystick) 
    (J.num_balls joystick) (J.num_buttons joystick) ;
  flush stdout ;

  (* Initialize drawing rectangles *)
  let axis_area = Array.init 2 (fun _ -> V.rect 0 0 0 0) in
  let buttons_area = V.rect 
      ~x:0 ~y:(scr_height - 34) 
      ~w:(34 * (J.num_buttons joystick)) ~h:32 in
  let draw = ref 0 in
  
  let mask = E.joystick_event_mask lor E.quit_mask lor E.keydown_mask in
  E.disable_events E.all_events_mask ;
  E.enable_events mask ;

  (* Loop, getting joystick events! *)
  try while true do
    begin match Sdlevent.wait_event () with
    | E.JOYAXISMOTION jae ->
	Printf.printf "Joystick %d axis %d value: %d\n"
	  jae.E.jae_which jae.E.jae_axis jae.E.jae_value
    | E.JOYHATMOTION jhe ->
	Printf.printf "Joystick %d hat %d\n"
	  jhe.E.jhe_which jhe.E.jhe_hat
    | E.JOYBALLMOTION jle ->
	Printf.printf "Joystick %d ball %d\n"
	  jle.E.jle_which jle.E.jle_ball
    | E.JOYBUTTONDOWN jb 
    | E.JOYBUTTONUP jb ->
	Printf.printf "Joystick %d button %d %s\n"
	  jb.E.jbe_which jb.E.jbe_button
	  (if jb.E.jbe_state = E.PRESSED
	  then "down"
	  else "up")
    | E.KEYDOWN { E.keysym = Sdlkey.KEY_ESCAPE }
    | E.QUIT ->
	raise Exit
    | E.KEYDOWN _ ->
	()
    | _ ->
	failwith "should not happen"
    end ;
    
    (* Update visual joystick state *)
    for i=0 to pred (J.num_buttons joystick) do
      let rect = V.rect
	  ~x:(i * 34) ~y:(scr_height - 34)
	  ~w:32 ~h:32 in
      V.fill_rect ~rect screen 
	(if J.get_button joystick i
	then white 
	else black) ;
    done ;

    (* Erase previous axes *)
    V.fill_rect ~rect:axis_area.(!draw) screen black ;

    (* Draw the X/Y axis *)
    draw := (succ !draw) mod 2 ;
    let x = 
      ((J.get_axis joystick 0) + (1 lsl 15)) * scr_width / (1 lsl 16) in
    let x' = clip x 0 (scr_width - 16) in
    let y = 
      ((J.get_axis joystick 1) + (1 lsl 15)) * scr_height / (1 lsl 16) in
    let y' = clip y 0 (scr_height - 16) in
    axis_area.(!draw).V.r_x <- x' ;
    axis_area.(!draw).V.r_y <- y' ;
    axis_area.(!draw).V.r_w <- 16 ;
    axis_area.(!draw).V.r_h <- 16 ;
    V.fill_rect ~rect:axis_area.(!draw) screen white ;
    
    V.update_rects (buttons_area :: (Array.to_list axis_area)) screen ;
    flush stdout
  done 
  with Exit -> ()

let main () = 
  (* Initialize SDL (Note: video is required to start event loop) *)
  Sdl.init [ `VIDEO ; `JOYSTICK ] ;

  (* Print information about the joysticks *)
  let n = J.num_joysticks () in
  Printf.printf "There are %d joysticks attached\n" n ;
  
  for i=0 to pred n do
    let name = J.name i in
    Printf.printf "Joystick %d: %s\n" i name
  done ;
  flush stdout ;

  if Array.length Sys.argv > 1
  then begin
    let i = int_of_string Sys.argv.(1) in
    let j = J.open_joystick i in
    watch_joystick j ;
    J.close j 
  end ;

  Sdl.quit ()


let _ = 
  try main ()
  with exn -> Sdl.quit () ; raise exn
