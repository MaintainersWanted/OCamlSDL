(* $Id: ocamlsdl_logo.ml,v 1.2 2002/11/06 23:02:56 oliv__a Exp $ *)


let create_fade_surface w h =
  let screen = Sdlvideo.get_video_surface () in
  let dest = Sdlvideo.create_RGB_surface_format 
      screen 
      [ `SWSURFACE; `SRCALPHA ] ~w ~h in
  Sdlvideo.fill_rect dest 
    (Sdlvideo.map_RGB dest (0, 0, 0)) ;
  dest

let fade_in tgt =
  (* I want a 4 seconds fade in 50 steps *)
  let total_time = 4000 in
  let nb_steps = 50 in
  let delay_time = total_time / nb_steps in
  let alpha i = 255 * i / (nb_steps - 1) in
  let s = Sdlvideo.get_video_surface () in
  for i=0 to pred nb_steps do
    Sdlvideo.set_alpha tgt (alpha i) ;
    Sdlvideo.blit_surface ~src:tgt ~dst:s () ;
    Sdlvideo.flip s ;
    Sdltimer.delay delay_time ;
  done

let main () =
  Sdl.init ~auto_clean:true [ `VIDEO ] ;
  let logo = Sdlloader.load_image "../images/ocamlsdl.png" in 
  let (w, h, _) = Sdlvideo.surface_dims logo in
  let screen = Sdlvideo.set_video_mode ~w ~h [] in
  let logo' = Sdlvideo.display_format logo in

  Sdlwm.set_caption "OCamlSDL logo" "OCamlSDL icon" ;
  Sdlvideo.blit_surface ~src:logo' ~dst:screen () ;
  Sdlvideo.flip screen;
  Sdltimer.delay 1000 ;
  fade_in (create_fade_surface w h) ; 
  fade_in logo' ;
  Sdl.quit()

let _ = 
  try main ()
  with exn -> Sdl.quit () ; raise exn



