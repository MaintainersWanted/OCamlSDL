open Printf ;;
open Sdl ;;
open Sdlcdrom ;;

(* init the SDL library *)
let _ =
  init ~auto_clean:true [`CDROM];; 

(* Get the number of cdrom drives *)
let numbers_of_drives = get_num_drives ();;

let _ =
  printf "Drives available: %d\n" numbers_of_drives ;

  for id = 0 to (numbers_of_drives - 1 ) do

    printf "Drive %d:  \"%s\"\n" id (drive_name id);
    let cdrom = cd_open id in  
    let cdrom_state = cd_status cdrom in 
    let flag_track = ref 0 in 
    let s = 
      match cdrom_state with 
	CD_TRAYEMPTY -> 
	  "tray empty" 
      | CD_STOPPED -> 
	  "stopped"
      | CD_PLAYING -> 
	  flag_track := 1 ;
	  "playing"
      | CD_PAUSED -> 
	  flag_track := 1 ;
	  "paused"
    in
    printf "Drive %d status: %s\n" id s ;
    if !flag_track = 1
    then
      let info = cd_info cdrom in
      let (m, s, _) = msf_of_frames info.curr_frame in
      printf "Currently playing track %d, %02d:%02d\n" 
	(info.curr_track+1) m s ;
      cd_close cdrom 
  done 
