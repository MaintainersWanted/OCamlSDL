let width = 640
let height = 480

let proc_ev = function
  | Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }
  | Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_q } -> exit 0
  | _ -> ()

let () =
  Random.self_init ();
  Sdl.init [`VIDEO];
  Sdlttf.init ();
  at_exit (fun () -> Sdl.quit (); Sdlttf.quit ());
  let screen = Sdlvideo.set_video_mode ~w:width ~h:height ~bpp:0
    [`HWSURFACE; `DOUBLEBUF] in
  let font = Sdlttf.open_font "./vera-small.ttf" 48 in
  let txt = Sdlttf.render_text_solid font "Hello, SDL_ttf" (255, 160, 32) in
  while true do
    begin match Sdlevent.poll () with
    | None -> ()
    | Some ev -> proc_ev ev
    end;
    Sdlvideo.blit_surface ~src:txt ~dst:screen ();
    Sdlvideo.flip screen;
    Sdltimer.delay 10;
  done
