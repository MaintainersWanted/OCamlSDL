(* $Id: ocamlsdl_logo2.ml,v 1.1 2002/08/28 15:17:17 oliv__a Exp $ *)


let create_fade_surface w h =
  let bpp = Sdlvideo2.surface_bpps (Sdlvideo2.get_video_surface ()) in
  let dest = Sdlvideo2.create_RGB_surface [ `SWSURFACE; `SRCALPHA ] 
      ~w ~h ~bpp 
      ~rmask:(Int32.zero) ~bmask:(Int32.zero) 
      ~gmask:(Int32.zero) ~amask:(Int32.zero)
  in
  Sdlvideo2.fill_rect dest 
    (Sdlvideo2.map_RGB dest (0, 0, 0)) ;
  dest

let fade_in tgt =
  (* I want a 4 seconds fade in 50 steps *)
  let total_time = 4000 in
  let nb_steps = 50 in
  let delay_time = total_time / nb_steps in
  let alpha i = 255 * i / (nb_steps - 1) in
  let s = Sdlvideo2.get_video_surface () in
  for i=0 to pred nb_steps do
    Sdlvideo2.set_alpha tgt (alpha i) ;
    Sdlvideo2.blit_surface ~src:tgt ~dst:s () ;
    Sdlvideo2.flip s ;
    Sdltimer.delay delay_time ;
  done

let main () =
  Sdl.init ~auto_clean:true [ `VIDEO ] ;
  let logo = Sdlloader2.load_image "../images/ocamlsdl.png" in 
  let (w, h, _) = Sdlvideo2.surface_dims logo in
  let bpp = Sdlvideo2.video_mode_ok ~w ~h ~bpp:16 [] in
  Printf.printf "using %d bpp surfaces\n" bpp ; flush stdout ;
  let screen = 
    Sdlvideo2.set_video_mode ~w ~h ~bpp [] in
  let logo' = Sdlvideo2.display_format logo in

  (* wm_set_caption "OCamlSDL logo" "OCamlSDL icon";*)
  Sdlvideo2.blit_surface ~src:logo' ~dst:screen () ;
  Sdlvideo2.flip screen;
  Sdltimer.delay 1000 ;
  fade_in (create_fade_surface w h) ; 
  fade_in logo' ;
  Sdl.quit()

let _ = 
  try main ()
  with exn -> Sdl.quit () ; raise exn



