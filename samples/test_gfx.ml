let width = 640
let height = 480

let proc_ev = function
  | Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }
  | Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_q } -> exit 0
  | _ -> ()

let rand_color () =
  let r = Random.int 256
  and g = Random.int 256
  and b = Random.int 256 in
  (r, g, b)

let rand_pos () =
  let x = Random.int width
  and y = Random.int height in
  (x, y)

let draw_pixel screen =
  let x, y = rand_pos () in
  let color = rand_color () in
  Sdlgfx.pixelRGBA screen x y color 255

let draw_line screen =
  let p1 = rand_pos () in
  let p2 = rand_pos () in
  let color = rand_color () in
  Sdlgfx.lineRGBA screen p1 p2 color 255

let draw_aaline screen =
  let p1 = rand_pos () in
  let p2 = rand_pos () in
  let color = rand_color () in
  Sdlgfx.aalineRGBA screen p1 p2 color 255

let draw_circle screen =
  let center = rand_pos () in
  let radius = Random.int 80 in
  let color = rand_color () in
  Sdlgfx.circleRGBA screen center radius color 255

let draw_arc screen =
  let center = rand_pos () in
  let radius = Random.int 80 in
  let start = Random.int 360 in
  let end_ = Random.int 360 in
  let color = rand_color () in
  Sdlgfx.arcRGBA screen center radius start end_ color 255

let draw_filledCircle screen =
  let center = rand_pos () in
  let radius = Random.int 80 in
  let color = rand_color () in
  Sdlgfx.filledCircleRGBA screen center radius color 255

let draw_box screen =
  let p1 = rand_pos () in
  let p2 = rand_pos () in
  let color = rand_color () in
  Sdlgfx.boxRGBA screen p1 p2 color 255

let draw_rectangle screen =
  let p1 = rand_pos () in
  let p2 = rand_pos () in
  let color = rand_color () in
  Sdlgfx.rectangleRGBA screen p1 p2 color 255

let draw_roundedRectangle screen =
  let p1 = rand_pos () in
  let p2 = rand_pos () in
  let radius = Random.int 24 in
  let color = rand_color () in
  Sdlgfx.roundedRectangleRGBA screen p1 p2 radius color 255

let draw_roundedBox screen =
  let p1 = rand_pos () in
  let p2 = rand_pos () in
  let radius = 1 + Random.int 24 in
  let color = rand_color () in
  Sdlgfx.roundedBoxRGBA screen p1 p2 radius color 255

let draw_thickLine screen =
  let p1 = rand_pos () in
  let p2 = rand_pos () in
  let width = 1 + Random.int 8 in
  let color = rand_color () in
  Sdlgfx.thickLineRGBA screen p1 p2 width color 255

let draw_funcs = [
  ("-draw-pixel",             draw_pixel);
  ("-draw-line",              draw_line);
  ("-draw-aaline",            draw_aaline);
  ("-draw-circle",            draw_circle);
  ("-draw-arc",               draw_arc);
  ("-draw-filledCircle",      draw_filledCircle);
  ("-draw-box",               draw_box);
  ("-draw-rectangle",         draw_rectangle);
  ("-draw-roundedRectangle",  draw_roundedRectangle);
  ("-draw-roundedBox",        draw_roundedBox);
  ("-draw-thickLine",         draw_thickLine);
]

let () =
  Random.self_init ();
  let args = List.tl (Array.to_list Sys.argv) in
  if args = [] then begin
    print_endline "Available primitives:";
    List.iter (fun (arg, _) -> Printf.printf " %s\n%!" arg) draw_funcs
  end;
  let draw = List.map (fun a -> List.assoc a draw_funcs) args in
  Sdl.init [`VIDEO];
  at_exit Sdl.quit;
  let screen = Sdlvideo.set_video_mode ~w:width ~h:height ~bpp:0
    [`HWSURFACE; `DOUBLEBUF] in
  while true do
    begin match Sdlevent.poll () with
    | None -> ()
    | Some ev -> proc_ev ev
    end;
    Sdlgfx.boxRGBA screen (0,0) (width, height) (0,0,0) 8;
    List.iter (fun f -> f screen) draw;
    Sdlvideo.flip screen;
    Sdltimer.delay 10;
  done
