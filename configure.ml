let _ = 
  print_string "PLATFORM        := " ;
  print_endline Sys.os_type ;

  print_string "OCAML_C_BACKEND := " ;
  print_endline
    (match Sys.os_type with
    | "Unix" | "Cygwin" -> "gcc"
    | "Win32" -> "msvc"
    | p -> Printf.sprintf "$(error unsupported platform %s)" p) ;

  print_endline "MAKEFILE_CONFIG = makefile.config.$(OCAML_C_BACKEND)"
