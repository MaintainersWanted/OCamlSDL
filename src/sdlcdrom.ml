(*
 * OCamlSDL - An ML interface to the SDL library
 * Copyright (C) 1999  Frederic Brunel
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *)

(* $Id: sdlcdrom.ml,v 1.1 2000/01/02 01:32:27 fbrunel Exp $ *)

(* Define a new exception for CD-ROM errors and register 
   it to be callable from C code. *)

exception SDLcdrom_exception of string
let _ = Callback.register_exception "SDLcdrom_exception" (SDLcdrom_exception "Any string")

(* Types *)

type cdrom_drive
type cdrom_track

type cdrom_drive_status = 
    CD_TRAYEMPTY
  | CD_STOPPED
  | CD_PLAYING
  | CD_PAUSED
  | CD_ERROR

type cdrom_track_type =
    TRACK_AUDIO
  | TRACK_DATA

(* Native C external functions *)

external get_num_drives : unit -> int = "sdlcdrom_get_num_drives";;
external drive_name : int -> string = "sdlcdrom_drive_name";;
external cd_open : int -> cdrom_drive = "sdlcdrom_open";;
external cd_close : cdrom_drive -> unit = "sdlcdrom_close";;

external cd_play_tracks : cdrom_drive -> int -> int -> int -> int -> unit = "sdlcdrom_play_tracks";;
external cd_pause : cdrom_drive -> unit = "sdlcdrom_pause";;
external cd_resume : cdrom_drive -> unit = "sdlcdrom_resume";;
external cd_stop : cdrom_drive -> unit = "sdlcdrom_stop";;
external cd_eject : cdrom_drive -> unit = "sdlcdrom_eject";;
external cd_status : cdrom_drive -> cdrom_drive_status = "sdlcdrom_status";;

external cd_get_num_tracks : cdrom_drive -> int = "sdlcdrom_get_num_tracks";;
external cd_track_num : cdrom_drive -> int -> cdrom_track = "sdlcdrom_track_num";;
external track_length : cdrom_track -> int * int = "sdlcdrom_track_length";;
external track_type : cdrom_track -> cdrom_track_type = "sdlcdrom_track_type";;

(* ML functions *)

let cd_play_track cdrom track_num =
  cd_play_tracks cdrom track_num 0 1 0;;

let cd_track_list cdrom =
  let rec aux cdrom track_num =
    if track_num < 0
    then []
    else (cd_track_num cdrom track_num)::(aux cdrom (track_num - 1))
  in
  aux cdrom ((cd_get_num_tracks cdrom) - 1);;
