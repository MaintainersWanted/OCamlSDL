
let main () =
  Sdl.init ~auto_clean:true [ `VIDEO ] ;
  let logo = Sdlloader.load_image "ocamlsdl.png" in 
  let (w, h, _) = Sdlvideo.surface_dims logo in
  let screen = Sdlvideo.set_video_mode ~w ~h [] in
  let logo' = Sdlvideo.display_format logo in

  Sdlwm.set_caption "OCamlSDL logo" "OCamlSDL icon" ;
  for i = 0 to 99 do 
    let logo'' = Sdlgfx.rotozoomSurface logo' (float i /. 100.0 *. 360.) (float i /.100.0) true in
    Sdlvideo.fill_rect screen (Sdlvideo.map_RGB logo' Sdlvideo.white) ;
    Sdlvideo.blit_surface ~src:logo'' ~dst:screen () ;
    Sdlvideo.flip screen ;
    Sdltimer.delay 30
  done ;
  
  Sdlvideo.blit_surface ~src:logo' ~dst:screen () ;
  Sdlvideo.flip screen ;
  Sdltimer.delay 1000 ;
  Sdl.quit()

let _ = 
  try main ()
  with exn -> Sdl.quit () ; raise exn
