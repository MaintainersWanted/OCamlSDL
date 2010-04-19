module CD = Sdlcdrom

let _ =
  Sdl.init ~auto_clean:true [`CDROM] ;
  let numbers_of_drives = CD.get_num_drives () in
  Printf.printf "Drives available: %d\n" numbers_of_drives ;
  for id = 0 to (numbers_of_drives - 1 ) do
    Printf.printf "Drive %d:  \"%s\"\n" id (CD.drive_name id) ;
    let cdrom = CD.cd_open id in  
    let cdrom_state = CD.cd_status cdrom in 
    let flag_track = ref false in 
    let s = 
      match cdrom_state with 
      | CD.CD_TRAYEMPTY -> 
	  "tray empty" 
      | CD.CD_STOPPED -> 
	  "stopped"
      | CD.CD_PLAYING -> 
	  flag_track := true ;
	  "playing"
      | CD.CD_PAUSED -> 
	  flag_track := true ;
	  "paused"
    in
    Printf.printf "Drive %d status: %s\n" id s ;
    if !flag_track then begin
      let info = CD.cd_info cdrom in
      let (m, s, _) = CD.msf_of_frames info.CD.curr_frame in
      Printf.printf "Currently playing track %d, %02d:%02d\n" 
	(info.CD.curr_track + 1) m s ;
      CD.cd_close cdrom 
    end
  done 
