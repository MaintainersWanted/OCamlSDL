open Sdl;;
open Sdlmixer;;


let usage() = 
  let basename = (Filename.basename Sys.argv.(0)) in
    Printf.printf "%s made with OCamlSDL\n\nUsage: %s <input file>\n\n" basename basename;
    flush stdout;;

if Array.length Sys.argv <= 1
then
  begin
    usage();
    exit 0
  end;;

init [`EVERYTHING];;

try 
  open_audio ~freq:44100 AUDIO_FORMAT_S16 STEREO;
  Printf.printf "audio device initialised\n";
  flush stdout;
with _ ->
  Printf.printf "%s\n" "could not initialized audio device\n";
  exit 255;;


(* exceptions must be caught *)
let check_file_and_play_it f =
  let queue = Queue.create() in
  let playing = ref true in
  let cb_music_finished () = 
    Printf.printf "Freeying Music\n";
    flush stdout;
    free_music (Queue.take queue);
    playing := false;
  in
    if (Sys.file_exists f) 
    then
      begin  
	Printf.printf "Loading music: %s\n" f;
	flush stdout;
	let m = load_music f in
	let _ = play_music m (Some 1) 
	in 
	  Queue.add m queue;
	  set_music_finished cb_music_finished;
	  playing := true;
	  while !playing
	  do
	    Sdltimer.delay 10;
	  done
      end;;

List.iter check_file_and_play_it (List.tl (Array.to_list Sys.argv));;
close_audio ();
Printf.printf "closing audio device\n";
flush stdout;
quit();;
