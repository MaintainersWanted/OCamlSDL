open Sdl;;
open Sdlvideo;;
open Sdlevent;;

init [`EVERYTHING];;

let screen = set_video_mode 640 480 16 [`HWSURFACE] ;; (*;`FULLSCREEN];;*)
let s = "Pathetic Sketch" ;;
wm_set_caption s s;;

let cur_x = ref 1;;

let display_surface surf x y = 
  let contain low value high =
    min high (max low value)
  in
  let h = surface_height surf
  and w = surface_width surf
  in
  let x_dest = contain 0 x ((surface_width screen) - w)
  and y_dest = contain 0 y ((surface_height screen) - h)
  in
  let r_dest = (Rect(x_dest,y_dest,w,h))
  and r_src = (surface_rect surf)
  in
    surface_blit surf r_src screen r_dest;
    update_rect screen r_dest;;
  

let display_text font string fg x y =
  let s_text = Sdlttf.render_text_solid font string ~fg
  in display_surface s_text x y;;


let screen_fill img = 
  let screen = get_display_surface()
  in
    surface_blit img (surface_rect screen) screen (surface_rect screen);
    flip screen;;

let fill_with bg = 
  flip (surface_fill_rect screen (surface_rect screen) bg);;


let f = Sdlttf.open_font "../fonts/Arial.ttf" 20;;

let black = color_of_int(0,0,0) ;;
let white = color_of_int(255,255,255) ;;

let white_dot = surface_from_pixels (RGBPixels([|[| white |]|]));;
let black_dot = surface_from_pixels (RGBPixels([|[| black |]|]));;
(* surface_set_pixel black_dot 0 0 black;; *)



type location = {
  mutable x : int;
  mutable y : int
};;

let loc = {x = 0; y = 0};;

let display_white = ref true;;

let target_filename = 
  (* grabbed in cdk *)
  let replace doc chr str =
    let res = Buffer.create (2 * (String.length doc)) in
    let pos = ref 0 in
    let rec aux () =
      let new_pos = String.index_from doc !pos chr in
	Buffer.add_substring res doc !pos (new_pos - !pos);
	Buffer.add_string res str;
	pos := new_pos + 1;
	aux () in
      (try
	 aux ()
       with
	 | Not_found -> Buffer.add_substring res doc !pos ((String.length doc) - !pos)
	 | Invalid_argument _ -> ());
      Buffer.contents res
  in 
    Filename.temp_file (replace s ' ' "") ".bmp";;




let idle_handler () = 
  begin 
    if !display_white then 
      begin 
	display_surface black_dot loc.x loc.y;
	Sdltimer.delay 10;
	display_surface white_dot loc.x loc.y;
      end
    else 
      begin
	display_surface white_dot loc.x loc.y;
	Sdltimer.delay 10;
	display_surface black_dot loc.x loc.y;
      end;

    if is_key_pressed KEY_UP then 
      loc.y <- loc.y - 1;
    if is_key_pressed KEY_DOWN then 
      loc.y <- loc.y + 1;
    if is_key_pressed KEY_LEFT then
      loc.x <- loc.x - 1;
    if is_key_pressed KEY_RIGHT then
      loc.x <- loc.x + 1;
    if is_key_pressed KEY_SPACE then
      fill_with black;

    if is_key_pressed KEY_s then
      begin
	surface_saveBMP screen target_filename; 
	(* "writing:" ^ target_filename in *)
	display_text f ("writing"^target_filename) white 0 0;
	print_string "writing\n";
	Sdltimer.delay 20;
	display_text f ("writing"^target_filename) black 0 0;
      end;
    if is_key_pressed KEY_ESCAPE then
      exit_event_loop ();
    display_surface white_dot loc.x loc.y;
    Sdltimer.delay 20;
  end;;

      
let keyboard_handler key (state:key_state) (x:int) (y:int) = match state with
  | KEY_STATE_PRESSED -> 
      (match key with 
	| KEY_LSHIFT | KEY_RSHIFT ->
	    display_white := false
	| _ -> ())
   | KEY_STATE_RELEASED -> 
       (match key with 
	| KEY_LSHIFT | KEY_RSHIFT ->
	    display_white := true
	| _ -> ());;

set_keyboard_event_func keyboard_handler;; 

set_idle_event_func idle_handler;;

display_text f 
  "Use arrow keys to move the white pixel and space for cleaning screen" 
  white 
  0 3000;;

start_event_loop ();;
quit();;
