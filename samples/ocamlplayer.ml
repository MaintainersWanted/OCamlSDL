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

init [`AUDIO];;

try 
  open_audio ~freq:44100 () ;
  Printf.printf "audio device initialised\n";
  flush stdout;
with _ ->
  Printf.printf "%s\n" "could not initialized audio device\n";
  exit 255;;


(* exceptions must be caught *)
let check_file_and_play_it f =
  if (Sys.file_exists f) 
  then begin  
    Printf.printf "Loading music: %s\n" f;
    flush stdout;
    let m = load_music f in
    play_music m ;
    while playing_music() do
      Sdltimer.delay 10;
    done ;
    free_music m
  end
;;

List.iter check_file_and_play_it (List.tl (Array.to_list Sys.argv));;
close_audio ();
Printf.printf "closing audio device\n";
flush stdout;
quit();;
