let usage () = 
  let basename = Filename.basename Sys.argv.(0) in
  Printf.printf "%s made with OCamlSDL\n\nUsage: %s <input file>\n\n" basename basename ;
  exit 1


let open_audio () =
  try 
    Sdlmixer.open_audio ~freq:44100 () ;
    print_endline "audio device initialised"
  with _ ->
    prerr_endline "could not initialize audio device" ;
    exit 2


let check_file_and_play_it f =
  if Sys.file_exists f
  then begin  
    Printf.printf "Loading music: %s\n%!" f ;
    let m = Sdlmixer.load_music f in
    Sdlmixer.play_music m ;
    while Sdlmixer.playing_music () do
      Sdltimer.delay 500 ;
    done ;
    Sdlmixer.free_music m
  end


let main () = 
  if Array.length Sys.argv <= 1 then usage () ;
  
  Sdl.init [`AUDIO] ;
  open_audio () ;

  for i = 1 to Array.length Sys.argv - 1 do
    check_file_and_play_it Sys.argv.(i)
  done ;
  Sdlmixer.close_audio ();
  print_endline "closing audio device" ;
  Sdl.quit ()

let _ = 
  main ()
