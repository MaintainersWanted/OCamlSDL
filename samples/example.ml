(* $Id: example.ml,v 1.1 2000/01/06 23:00:42 fbrunel Exp $ *)

open Sdl;;
open Sdlvideo;;

init_with_auto_clean();;

let screen = set_display_mode 320 200 32;;
let clouds = surface_loadBMP "images/clouds.bmp";;
let icon = surface_loadBMP "images/icon.bmp";;
let black = make_rgb_color (surface_pixel_format screen) 0.0 0.0 0.0;;

let screen_fill () = 
  surface_blit clouds (surface_rect screen) screen (surface_rect screen);;

let screen_clear () = 
  surface_fill_rect screen (surface_rect screen) black;;

let random_placement src dst =
  let y_max = (surface_height dst) - (surface_height src)
  and x_max = (surface_width dst) - (surface_width src)
  in
  surface_blit src (surface_rect src) dst (Rect(Random.int x_max, 
						Random.int y_max,
						surface_width src,
						surface_height src));;
						
let place_max_icons max = 
  for i = 0 to max do
    random_placement icon screen;
    flip screen;
  done;;
