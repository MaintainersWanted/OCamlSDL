(* $Id: example.ml,v 1.12 2002/08/25 12:50:47 oliv__a Exp $ *)

open Sdl;;
open Sdlvideo;;

init [`EVERYTHING];; (* init_with_auto_clean();; *)

let screen = set_video_mode 640 480 16 [`HWSURFACE];;
let s = "OCamlSDL" ;;
wm_set_caption s s;;

let clouds = surface_loadBMP "../images/clouds.bmp";;
let icon = surface_loadBMP "../images/icon.bmp";;
let logo = Sdlloader.load_image "../images/ocamlsdl.png";; 

let black = color_of_int(0,0,0) ;;
let white = color_of_int(255,255,255) ;;

let screen_fill img = 
  let screen = get_display_surface()
  in
    surface_blit img (surface_rect screen) screen (surface_rect screen);
    flip screen;;

let fill_with bg = 
  flip (surface_fill_rect screen (surface_rect screen) bg);;

let random_placement src dst =
  let h = surface_height src
  and w = surface_width src
  in
  let y_max = (surface_height dst) - h
  and x_max = (surface_width dst) - w
  in
  let r_smiley = (Rect(Random.int x_max, 
		       Random.int y_max,
		       w,h))
  and r_src = (surface_rect src)
    
  in
    surface_blit src r_src dst r_smiley;
    update_rect dst r_smiley;;
    
let place_max_icons max delay = 
  surface_set_colorkey icon (Some (Sdlvideo.IntColor(255, 255, 255)));
  for i = 0 to max do
    surface_set_alpha icon (Random.float 1.0);
    random_placement icon screen;
    Sdltimer.delay delay; 
  done;;

let display_text f s bg fg =
  let s_text = Sdlttf.render_text_shaded f s
	       ~bg ~fg
  in
  random_placement s_text screen ;;

let f = Sdlttf.open_font "../fonts/Arial.ttf" 20;;


 fill_with white;;
 display_text f "Wait 2 seconds..." black white ;;
 Sdltimer.delay 2000 ;;
 
 fill_with black;;
 display_text f "Going in the sky in 2 seconds and let's the pacmen" white black;;
 Sdltimer.delay 2000 ;;
 
 screen_fill clouds;;
 flip screen ;;
 (* display_text f "Let's the pacmen !!" white black;; *)
 place_max_icons 100 1;;
 Sdltimer.delay 2000 ;;
 
 fill_with white;;
 screen_fill logo ;;
 flip screen;;
 display_text f ("Made with "^s)  black white;;
 Sdltimer.delay 5000 ;;
 
 Sdlttf.close_font f ;;

 quit();;


