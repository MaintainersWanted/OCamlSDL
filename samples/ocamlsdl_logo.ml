(* $Id: ocamlsdl_logo.ml,v 1.1 2002/08/28 13:37:08 xtrm Exp $ *)

open Sdl;;
open Sdlvideo;;


init [`VIDEO];;

let create_fade_surface src =
  let dest = create_rgb_surface [`SWSURFACE;`SRCALPHA] 
	       ~width:(surface_width src) 
	       ~height:(surface_height src) 
	       ~bpp:16 ~rmask:0 ~bmask:0 ~gmask:0 ~amask:0
  in
    surface_fill_rect dest RectMax (IntColor(0,0,0));;

let fade_in tgt =
  let old_time = ref(Sdltimer.get_ticks()) in
  let cur_time = ref(!old_time) in
  let step = ref 0.0 in
  let alpha = ref 0.01 in
  let s = get_display_surface() in
    try 
      while true 
      do
	let _ = surface_set_alpha tgt !alpha in 
	  step := !step +. ((float_of_int(!cur_time - !old_time)) /. 1500.);
	  surface_blit tgt RectMax s RectMax;
	  flip s;
	  Sdltimer.delay 100;
	  alpha := !alpha +. 0.01;
	  old_time := !cur_time;
	  cur_time := Sdltimer.get_ticks();
	  if !step /. 2.55 >= 1.
	then raise Exit
      done;
    with Exit -> ();;

let _ =
  let logo = Sdlloader.load_image "../images/ocamlsdl.png" in 
  let screen = set_video_mode (surface_width logo) (surface_height logo) 
		 16 [`HWSURFACE] in

      wm_set_caption "OCamlSDL logo" "OCamlSDL icon";
      surface_blit logo RectMax screen RectMax;
      flip screen;
      Sdltimer.delay 1000 ;
      fade_in (create_fade_surface logo); 
      fade_in logo;
      quit();;



