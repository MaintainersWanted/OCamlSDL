open Printf ;;
open Sdl ;;
open Sdlcdrom ;;

(* init the SDL library *)
init [`CDROM];; (*  init_with_auto_clean();; *)

(* Get the number of cdrom drives *)
let numbers_of_drives = get_num_drives ();;

printf "Drives available: %d\n" numbers_of_drives ;;

for id = 0 to (numbers_of_drives - 1 ) do

  printf "Drive %d:  \"%s\"\n" id (drive_name id);
  let cdrom = cd_open id
  in  
  let cdrom_state = cd_status cdrom
  in 
  let flag_track = ref 0
  in let s = 
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
	| _ -> 
	    "error state" 
  in
      printf "Drive %d status: %s\n" id s ;
    if (!flag_track == 1) 
    then
      let current_track = (cd_current_track cdrom)
      and (m,s) = (cd_track_current_time cdrom)
      in
	printf "Currently playing track %d, %2d:%2d\n" 
	  (track_get_number current_track) m s;
    cd_close cdrom 
done 

