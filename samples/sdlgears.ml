(*
 * 3-D gear wheels.  This program is in the public domain.
 *
 * Brian Paul
 *
 * GLUT version by Mark J. Kilgard
 * SDL version by Sam Lantinga
 * LablGL version by Jacques Garrigue
 * OCamlSDL version by Eric Cooper
 *)

let pi = acos (-1.)

(**

  Draw a gear wheel.  You'll probably want to call this function when
  building a display list since we do a lot of trig here.

  Input:  inner_radius - radius of hole at center
	  outer_radius - radius at center of teeth
	  width - width of gear
	  teeth - number of teeth
	  tooth_depth - depth of tooth

 **)

let gear ~inner_radius ~outer_radius ~width ~teeth ~tooth_depth =
  let r0 = inner_radius
  and r1 = outer_radius -. tooth_depth /. 2.0
  and r2 = outer_radius +. tooth_depth /. 2.0 in

  let ta = 2.0 *. pi /. float teeth in
  let da = ta /. 4.0 in

  GlDraw.shade_model `flat;

  GlDraw.normal ~z:1.0 ();

  let vertex ~r ~z ?(s=0) i =
    let angle = float i *. ta +. float s *. da in
    GlDraw.vertex ~x:(r *. cos angle) ~y:(r *. sin angle) ~z ()
  in

  (* draw front face *)
  let z = width *. 0.5 in
  GlDraw.begins `quad_strip;
  for i=0 to teeth do
    vertex i ~r:r0 ~z;
    vertex i ~r:r1 ~z;
    vertex i ~r:r0 ~z;
    vertex i ~r:r1 ~z ~s:3;
  done;
  GlDraw.ends ();

  (* draw front sides of teeth *)
  GlDraw.begins `quads;
  for i=0 to teeth - 1 do
    vertex i ~r:r1 ~z;
    vertex i ~r:r2 ~s:1 ~z;
    vertex i ~r:r2 ~s:2 ~z;
    vertex i ~r:r1 ~s:3 ~z;
  done;
  GlDraw.ends ();

  GlDraw.normal ~z:(-1.0) ();

  (* draw back face *)
  let z = -. width *. 0.5 in
  GlDraw.begins `quad_strip;
  for i=0 to teeth do
    vertex i ~r:r1 ~z;
    vertex i ~r:r0 ~z;
    vertex i ~r:r1 ~s:3 ~z;
    vertex i ~r:r0 ~z;
  done;
  GlDraw.ends ();

  (* draw back sides of teeth *)
  GlDraw.begins `quads;
  for i=0 to teeth - 1 do
    vertex i ~r:r1 ~s:3 ~z;
    vertex i ~r:r2 ~s:2 ~z;
    vertex i ~r:r2 ~s:1 ~z;
    vertex i ~r:r1 ~z;
  done;
  GlDraw.ends ();

  (* draw outward faces of teeth *)
  let z = width *. 0.5 and z' = width *. (-0.5) in
  GlDraw.begins `quad_strip;
  for i=0 to teeth - 1 do
    let angle = float i *. ta in
    vertex i ~r:r1 ~z;
    vertex i ~r:r1 ~z:z';
    let u = r2 *. cos(angle+.da) -. r1 *. cos(angle)
    and v = r2 *. sin(angle+.da) -. r1 *. sin(angle) in
    GlDraw.normal ~x:v ~y:(-.u) ();
    vertex i ~r:r2 ~s:1 ~z;
    vertex i ~r:r2 ~s:1 ~z:z';
    GlDraw.normal ~x:(cos angle) ~y:(sin angle) ();
    vertex i ~r:r2 ~s:2 ~z;
    vertex i ~r:r2 ~s:2 ~z:z';
    let u = r1 *. cos(angle +. 3. *. da) -. r2 *. cos(angle +. 2. *. da)
    and v = r1 *. sin(angle +. 3. *. da) -. r2 *. sin(angle +. 2. *. da) in
    GlDraw.normal ~x:v ~y:(-.u) ();
    vertex i ~r:r1 ~s:3 ~z;
    vertex i ~r:r1 ~s:3 ~z:z';
    GlDraw.normal ~x:(cos angle) ~y:(sin angle) ();
  done;
  vertex 0 ~r:r1 ~z;
  vertex 0 ~r:r1 ~z:z';
  GlDraw.ends ();

  GlDraw.shade_model `smooth;

  (* draw inside radius cylinder *)
  GlDraw.begins `quad_strip;
  for i=0 to teeth do
    let angle = float i *. ta in
    GlDraw.normal ~x:(-. cos angle) ~y:(-. sin angle) ();
    vertex i ~r:r0 ~z:z';
    vertex i ~r:r0 ~z;
  done;
  GlDraw.ends ()

let view_rotx = ref 20.0
let view_roty = ref 30.0
let view_rotz = ref 0.0
let angle = ref 0.0

let increase ?(by=5.0) r = r := !r +. by
let decrease ?(by=5.0) r = r := !r -. by

let t0 = ref 0
let frames = ref 0

let draw (gear1, gear2, gear3) =
  GlClear.clear [`color;`depth];

  GlMat.push ();
  GlMat.rotate ~angle:!view_rotx ~x:1.0 ();
  GlMat.rotate ~angle:!view_roty ~y:1.0 ();
  GlMat.rotate ~angle:!view_rotz ~z:1.0 ();

  GlMat.push ();
  GlMat.translate ~x:(-3.0) ~y:(-2.0) ();
  GlMat.rotate ~angle:!angle ~z:1.0 ();
  GlList.call gear1;
  GlMat.pop ();

  GlMat.push ();
  GlMat.translate ~x:3.1 ~y:(-2.0) ();
  GlMat.rotate ~angle:(-2.0 *. !angle -. 9.0) ~z:1.0 ();
  GlList.call gear2;
  GlMat.pop ();

  GlMat.push ();
  GlMat.translate ~x:(-3.1) ~y:4.2 ();
  GlMat.rotate ~angle:(-2.0 *. !angle -. 25.0) ~z:1.0 ();
  GlList.call gear3;
  GlMat.pop ();

  GlMat.pop ();

  Sdlgl.swap_buffers ();

  incr frames;
  let t = Sdltimer.get_ticks () in
  if t - !t0 >= 5000 then
    let seconds = float (t - !t0) /. 1000.0 in
    let fps = float !frames /. seconds in
    Printf.printf "%d frames in %g seconds = %g FPS\n" !frames seconds fps;
    flush stdout;
    t0 := t;
    frames := 0

let idle delay_fun =
  increase angle ~by: 2.0 ;
  delay_fun ()

let reshape ~w ~h =
  ignore (Sdlvideo.set_video_mode ~w ~h [`OPENGL; `RESIZABLE]);
  GlDraw.viewport ~x:0 ~y:0 ~w ~h;
  GlMat.mode `projection;
  GlMat.load_identity ();
  begin
    if w > h then
      let r = float w /. float h in
      GlMat.frustum ~x:(-.r,r) ~y:(-1.0,1.0) ~z:(5.0,60.0)
    else
      let r = float h /. float w in
      GlMat.frustum ~x:(-1.0,1.0) ~y:(-.r,r) ~z:(5.0,60.0)
  end;
  GlMat.mode `modelview;
  GlMat.load_identity();
  GlMat.translate ~z:(-40.0) ();
  GlClear.clear [`color;`depth]

let init () =
  let pos = 5.0, 5.0, 10.0, 0.0
  and red = 0.8, 0.1, 0.0, 1.0
  and green = 0.0, 0.8, 0.2, 1.0
  and blue = 0.2, 0.2, 1.0, 1.0 in

  GlLight.light ~num:0 (`position pos);
  List.iter Gl.enable
    [`cull_face;`lighting;`light0;`depth_test;`normalize];

  (* make the gears *)
  let make_gear ~inner_radius ~outer_radius ~width ~teeth ~color =
    let list = GlList.create `compile in
    GlLight.material ~face:`front (`ambient_and_diffuse color);
    gear ~inner_radius ~outer_radius ~width ~teeth ~tooth_depth:0.7;
    GlList.ends ();
    list
  in
  let gear1 = make_gear
      ~inner_radius:1.0 ~outer_radius:4.0 ~width:1.0 ~teeth:20 ~color:red
  and gear2 = make_gear
      ~inner_radius:0.5 ~outer_radius:2.0 ~width:2.0 ~teeth:10 ~color:green
  and gear3 = make_gear
      ~inner_radius:1.3 ~outer_radius:2.0 ~width:0.5 ~teeth:10 ~color:blue
  in
  (gear1, gear2, gear3)

let finished () =
  Sdl.quit ();
  exit 0

open Sdlkey

let do_key = function
  | KEY_ESCAPE | KEY_q -> finished ()
  | KEY_UP -> increase view_rotx
  | KEY_DOWN -> decrease view_rotx
  | KEY_LEFT -> increase view_roty
  | KEY_RIGHT -> decrease view_roty
  | KEY_z ->
      if get_mod_state () land kmod_shift != 0 then
	decrease view_rotz
      else
	increase view_rotz
  | _ -> ()

open Sdlevent

let check_events () =
  while has_event () do
    match wait_event () with
    | VIDEORESIZE (w, h) -> reshape ~w ~h
    | KEYDOWN { keysym = key } -> do_key key
    | QUIT -> finished ()
    | _ -> ()
  done

let framerate target =
  let last_time = ref (Sdltimer.get_ticks ()) in
  let interv = int_of_float (1000. /. target) in
  fun () ->
    let t = Sdltimer.get_ticks () in
    let to_wait = !last_time + interv - t in
    if to_wait <= 0
    then last_time := t
    else begin
      last_time := !last_time + interv ;
      Sdltimer.delay to_wait
    end

let target_framerate = ref 75.

let _ =
  Arg.parse []
    (fun a ->
      try target_framerate := float_of_string a 
      with Failure _ -> ())
    (Printf.sprintf "usage: %s [framerate]" (Filename.basename Sys.executable_name))

let main () =
  Sdl.init [`VIDEO];
  Sdlwm.set_caption ~title: "OCamlSDL Gears" ~icon: "gears";
  reshape ~w: 300 ~h: 300;
  let delay = framerate !target_framerate in
  let gears = init() in
  enable_key_repeat ();
  while true do
    idle delay ;
    check_events ();
    draw gears
  done

let _ = main ()
