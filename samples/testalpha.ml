open Bigarray

let debug = ref false
let dbug_msg msg = 
  if !debug
  then prerr_endline msg

let add_to_updates l x = 
  l := (Sdlvideo2.copy_rect x) :: !l

let frame_ticks = 1000 / 30
let flashes   = ref 0
let flashtime = ref 0

let create_light radius =
  (* Create a 32 (8/8/8/8) bpp square with a full 8-bit alpha channel *)
  let alphamask = 0x000000FF in
  let light = Sdlvideo2.create_RGB_surface
      [ `SWSURFACE ] (2*radius) (2*radius) 32
      (Int32.shift_left (Int32.of_int 0xFF) 24)
      (Int32.of_int 0x00FF0000)
      (Int32.of_int 0x0000FF00)
      (Int32.of_int alphamask) in

  let { Sdlvideo2.pitch = pitch ;
	Sdlvideo2.w = w ; 
	Sdlvideo2.h = h } as info = Sdlvideo2.surface_info light in

  (* Fill with a light yellow-orange color *)
  let pixels = Sdlvideo2.pixel_data_32 light in

  for y=0 to pred h do
    for x=0 to pred w do
      (* Calculate alpha values for the surface. *)
      let alpha =
	(* Slow distance formula (from center of light) *)
	let xdist = float (x - w/2) in
	let ydist = float (y - h/2) in
	let range = int_of_float (sqrt (xdist *. xdist +. ydist *. ydist)) in
	if range > radius
	then 0
	else
	  (* Increasing transparency with distance *)
	  let trans' = 
	    ((range * alphamask) / radius) + 
	      (alphamask + 1) /8 in
	  if trans' > alphamask
	  then 0
	  else alphamask - trans'
      in
      (* Set the pixel *)
      let pixel = Sdlvideo2.map_RGB light ~alpha (0xFF, 0xDD, 0x88) in
      pixels.{y * pitch / 4 + x} <- pixel
    done
  done ;

  (* Enable RLE acceleration of this alpha surface *)
  Sdlvideo2.set_alpha light ~rle:true 0 ;
  light




let flashlight ~screen ~light ~x ~y =
  let { Sdlvideo2.w = w ; 
	Sdlvideo2.h = h } as info = Sdlvideo2.surface_info light in
  let px = x - w / 2 in
  let py = y - h / 2 in
  let rect = Sdlvideo2.rect px py w h in

  let ticks1 = Sdltimer.get_ticks () in
  Sdlvideo2.blit_surface ~src:light ~dst:screen ~dst_rect:rect () ; 
  let ticks2 = Sdltimer.get_ticks () in

  Sdlvideo2.update_rect ~rect screen ;

  incr flashes ;
  flashtime := !flashtime + (ticks2 - ticks1)

let sprite_visible = ref false
let x_vel = ref 0
let y_vel = ref 0
let alpha_vel = ref 0
let position = { Sdlvideo2.r_x = 0; Sdlvideo2.r_y = 0;
		 Sdlvideo2.r_w = 0; Sdlvideo2.r_h = 0; }

let load_sprite ~screen filename = 
  (* Load the sprite image *)
  let sprite = Sdlvideo2.load_BMP filename in
  
  (* Set transparent pixel as the pixel at (0,0) *)
  if Sdlvideo2.use_palette sprite
  then begin
    let pixels = Sdlvideo2.pixel_data_8 sprite in
    dbug_msg (Printf.sprintf "## setting color key : %x" pixels.{0}) ;
    Sdlvideo2.set_color_key sprite (Int32.of_int pixels.{0}) ;
  end ;

  (* Convert sprite to video format *)
  dbug_msg "## converting to display format" ;
  let sprite' = Sdlvideo2.display_format sprite in
  Sdlvideo2.free_surface sprite ;

  (* Create the background *)
  let { Sdlvideo2.w = w ; Sdlvideo2.h = h } =
    Sdlvideo2.surface_info sprite' in
  let backing = Sdlvideo2.create_RGB_surface 
      [ `SWSURFACE ] w h 8 
      Int32.zero Int32.zero Int32.zero Int32.zero in

  (* Convert background to video format *)
  let backing' = Sdlvideo2.display_format backing in
  Sdlvideo2.free_surface backing ;

  let { Sdlvideo2.w = scr_w ; Sdlvideo2.h = scr_h } =
    Sdlvideo2.surface_info screen in
  
  position.Sdlvideo2.r_x <- (scr_w - w) / 2 ;
  position.Sdlvideo2.r_y <- (scr_h - h) / 2 ;
  position.Sdlvideo2.r_w <- w ;
  position.Sdlvideo2.r_h <- h ;
  x_vel := 0 ;
  y_vel := 0 ;
  alpha_vel := 1 ;

  (sprite', backing')

let attract_sprite x y = 
  x_vel := (x - position.Sdlvideo2.r_x) / 10 ;
  y_vel := (y - position.Sdlvideo2.r_y) / 10

let cnt = ref 0

let move_sprite ~screen ~olight ~backing ~sprite = 
  let updates = ref [] in
  let { Sdlvideo2.w = scr_w ; Sdlvideo2.h = scr_h } =
    Sdlvideo2.surface_info screen in

  (* Erase the sprite if it was visible *)
  begin 
    add_to_updates updates position ;
    let up = List.hd !updates in
    if !sprite_visible
    then Sdlvideo2.blit_surface ~src:backing ~dst:screen ~dst_rect:up ()
    else begin
      up.Sdlvideo2.r_x <- 0; up.Sdlvideo2.r_y <- 0; 
      up.Sdlvideo2.r_w <- 0; up.Sdlvideo2.r_h <- 0; 
      sprite_visible := true ;
    end
  end ;

  (* Since the sprite is off the screen, we can do other drawing *)
  (* without being overwritten by the saved area behind the sprite. *)
  begin match olight with
  | Some light ->
      let (x, y , _) = Sdlmouse.get_state () in
      flashlight ~screen ~light ~x ~y 
  | None-> ()
  end ;

  (* Move the sprite, bounce at the wall *)
  position.Sdlvideo2.r_x <- position.Sdlvideo2.r_x + !x_vel ;
  if position.Sdlvideo2.r_x < 0 || position.Sdlvideo2.r_x >= scr_w
  then begin
    x_vel := - !x_vel ;
    position.Sdlvideo2.r_x <- position.Sdlvideo2.r_x + !x_vel 
  end ;
  position.Sdlvideo2.r_y <- position.Sdlvideo2.r_y + !y_vel ;
  if position.Sdlvideo2.r_y < 0 || position.Sdlvideo2.r_y >= scr_h
  then begin
    y_vel := - !y_vel ;
    position.Sdlvideo2.r_y <- position.Sdlvideo2.r_y + !y_vel 
  end ;

  (* Update transparency (fade in and out) *)
  let alpha = Sdlvideo2.get_alpha sprite in
  let alpha' = alpha + !alpha_vel in
  if alpha' < 64 || alpha' > 255
  then alpha_vel := - !alpha_vel ;
  Sdlvideo2.set_alpha sprite (alpha + !alpha_vel) ;
  
  (* Save the area behind the sprite *)
  Sdlvideo2.blit_surface 
    ~src_rect:(Sdlvideo2.copy_rect position) ~src:screen ~dst:backing () ;

  (* Blit the sprite onto the screen *)
  add_to_updates updates position ;
  Sdlvideo2.blit_surface 
    ~src:sprite ~dst:screen ~dst_rect:(List.hd !updates) ();

  (* Make it so! *)
  Sdlvideo2.update_rects !updates screen 

(* let warp_sprite ~screen ~backing ~sprite x y = *)
(*   let { Sdlvideo2.w = w ; Sdlvideo2.h = h } = *)
(*     Sdlvideo2.surface_info sprite in *)
(*   let updates = Array.make 2 position in *)

(*   updates.(0) <- Sdlvideo2.copy_rect position ; *)
(*   Sdlvideo2.blit_surface backing ~dst_rect:updates.(0) screen ; *)

(*   position.Sdlvideo2.r_x <- x - w /2 ; *)
(*   position.Sdlvideo2.r_y <- y - h /2 ; *)
(*   updates.(1) <- Sdlvideo2.copy_rect position ; *)
(*   Sdlvideo2.blit_surface ~src_rect:updates.(1) screen backing ; *)
(*   updates.(1) <- Sdlvideo2.copy_rect position ; *)
(*   Sdlvideo2.blit_surface sprite screen ~dst_rect:updates.(1) ; *)
(*   Sdlvideo2.update_rects (Array.to_list updates) screen *)
    

let process_cli ini_bpp = 
  let videoflags = ref [ `SWSURFACE ] in
  let bpp = ref ini_bpp in
  let add_to_flags fl = fun () ->
    videoflags := fl :: !videoflags in
  let cli_args = [
    ( "-d", Arg.Set debug, "debugging" ) ;
    ( "-bpp", Arg.Int ((:=) bpp), "bpp for video mode" ) ;
    ( "-hw", Arg.Unit (add_to_flags `HWSURFACE) , "hardware surface" ) ;
    ( "-warp", Arg.Unit (add_to_flags`HWPALETTE), "hardware palette" ) ;
    ( "-fs", Arg.Unit (add_to_flags `FULLSCREEN), "fullscreen" ) ;
  ] in
  let usg_msg = Printf.sprintf "usage: %s [options]"
      (Filename.basename Sys.argv.(0)) in
  Arg.parse cli_args ignore usg_msg ;
  (!videoflags, !bpp)

exception Continue

let main () =
  (* Initialize SDL *)
  Sdl.init ~auto_clean:true [ `VIDEO ] ;
  
  (* Alpha blending doesn't work well at 8-bit color *)
  let video_bpp = 
    let info_fmt = 
      Sdlvideo2.pixel_format_info
	(Sdlvideo2.get_video_info ()).Sdlvideo2.vi_fmt in
    if info_fmt.Sdlvideo2.bits_pp > 8
    then info_fmt.Sdlvideo2.bits_pp
    else 16
  in

  let (video_flags, bpp) = process_cli video_bpp in
  
  (* Set 640x480 video mode *)
  dbug_msg "## setting video mode" ;
  let screen = Sdlvideo2.set_video_mode ~w:640 ~h:480 ~bpp video_flags in
  
  (* Set the surface pixels and refresh! *)
  dbug_msg "## setting surface" ;
  let { Sdlvideo2.pitch = pitch ;
	Sdlvideo2.w = w ;
	Sdlvideo2.h = h ; } = Sdlvideo2.surface_info screen in
  Sdlvideo2.lock screen ;
  let pixels = Sdlvideo2.pixel_data screen in
  for i=0 to pred h do
    let sub = Array1.sub pixels (i * pitch) pitch in
    Array1.fill sub (i * 255 / h) ;
  done ;
  Sdlvideo2.unlock screen ;
  Sdlvideo2.update_rect screen ;

  (* Create the light *)
  dbug_msg "## creating light" ;
  let light = create_light 82 in
  
  (* Load the sprite *)
  dbug_msg "## loading sprite" ;
  let (sprite, backing) = load_sprite ~screen "../images/icon.bmp" in

  (* Set a clipping rectangle to clip the outside edge of the screen *)
  begin
    dbug_msg "## setting clip rect" ;
    let clip = {
      Sdlvideo2.r_x = 32 ; Sdlvideo2.r_y = 32 ;
      Sdlvideo2.r_w = w - (2*32) ;
      Sdlvideo2.r_h = h - (2*32) ; } in
    Sdlvideo2.set_clip_rect screen clip
  end ;

  (* wait for a keystroke *)
  let lastticks = ref (Sdltimer.get_ticks ()) in
  let mouse_pressed = ref false in

  dbug_msg "## entering event loop" ;
  begin try while true do

    (* Update the frame -- move the sprite *)
    begin
      let olight = 
	if !mouse_pressed
	then Some light
	else None
      in
      move_sprite ~screen ~olight ~backing ~sprite ;
      mouse_pressed := false 
    end ;
    
    (* Slow down the loop to 30 frames/second *)
    let ticks = Sdltimer.get_ticks () in
    if ticks - !lastticks < frame_ticks
    then Sdltimer.delay (frame_ticks - (ticks - !lastticks)) ;
    lastticks := ticks ;
    
    try while true do
      (* Check for events *)
      match Sdlevent2.poll () with
      | None -> raise Continue
      | Some evt ->
	  match evt with

	    (* Attract sprite while mouse is held down *)
	  | Sdlevent2.MOUSEMOTION 
	      { Sdlevent2.mme_x = x ; 
		Sdlevent2.mme_y = y ;
		Sdlevent2.mme_state = button_list } 
	    when button_list <> [] ->
	      dbug_msg "## mouse motion -> attract_sprite" ;
	      attract_sprite x y

	  | Sdlevent2.MOUSEBUTTONDOWN
	      { Sdlevent2.mbe_x = x ; 
		Sdlevent2.mbe_y = y ;
		Sdlevent2.mbe_button = Sdlmouse.BUTTON_LEFT } ->
		  dbug_msg "## button down -> attract_sprite" ;
		  attract_sprite x y ;
		  mouse_pressed := true

	  | Sdlevent2.MOUSEBUTTONDOWN 
	      { Sdlevent2.mbe_x = x ; Sdlevent2.mbe_y = y } ->
		dbug_msg "## blitting a dark rect" ;
		let rect = Sdlvideo2.rect (x-16) (y-16) 32 32 in
		Sdlvideo2.fill_rect ~rect screen (Int32.zero) ;
		Sdlvideo2.update_rect ~rect screen 

	  | Sdlevent2.KEYDOWN _ 
	      (* Any keypress quits the app... *)
	  | Sdlevent2.QUIT ->
	      dbug_msg "## exiting ..." ;
	      raise Exit
	  | _ -> ()
    done
    with Continue -> ()
  done
  with Exit -> () 
  end ;
  
  dbug_msg "## freeing surfaces" ;
  Sdlvideo2.free_surface light ;
  Sdlvideo2.free_surface sprite ;
  Sdlvideo2.free_surface backing ;

  if !flashes > 0
  then
    Printf.printf "%d alpha blits, ~%4.4f ms per blit\n"
      !flashes 
      ((float !flashtime) /. (float !flashes))
    

let _ = 
  try main ()
  with exn -> Sdl.quit () ; raise exn

    
