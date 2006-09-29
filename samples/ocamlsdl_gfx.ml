
let main () =
  Sdl.init ~auto_clean:true [ `VIDEO ] ;
  let logo = Sdlloader.load_image "../images/ocamlsdl.png" in 
  let (w, h, _) = Sdlvideo.surface_dims logo in
  let screen = Sdlvideo.set_video_mode ~w ~h [] in
  let logo' = Sdlvideo.display_format logo in

  Sdlwm.set_caption "OCamlSDL logo" "OCamlSDL icon" ;
    let i=ref 0 in
      while !i<100 do
	let logo''=Sdlgfx.rotozoomSurface logo' (float_of_int !i/.100.0 *. 360.) (float_of_int !i/.100.0) true in
	  Sdlvideo.fill_rect screen (Sdlvideo.map_RGB logo' Sdlvideo.white);
	  Sdlvideo.blit_surface ~src:logo'' ~dst:screen () ;
	  Sdlvideo.flip screen;
	  Sdltimer.delay 30 ;
	  i:= !i+1;
      done;

      Sdlvideo.blit_surface ~src:logo' ~dst:screen () ;
      Sdlvideo.flip screen;
      Sdltimer.delay 1000 ;
  Sdl.quit()

let _ = 
  try main ()
  with exn -> Sdl.quit () ; raise exn



