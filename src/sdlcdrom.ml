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

(* $Id: sdlcdrom.ml,v 1.6 2002/08/09 13:40:40 oliv__a Exp $ *)

(* Define a new exception for CD-ROM errors and register 
   it to be callable from C code. *)

exception SDLcdrom_exception of string
exception Trayempty
let _ = 
  Callback.register_exception 
    "SDLcdrom_exception" (SDLcdrom_exception "") ;
  Callback.register_exception
    "SDLcdrom_nocd" Trayempty

(* Types *)

type cdrom_drive

type cdrom_drive_status = 
  | CD_TRAYEMPTY
  | CD_STOPPED
  | CD_PLAYING
  | CD_PAUSED

type track_type =
  | TRACK_AUDIO
  | TRACK_DATA

type track = {
    id     : int ;
    kind   : track_type ;
    length : int ;
    offset : int ;
  }

type cdrom_info = {
    num_tracks : int ;
    curr_track : int ;
    curr_frame : int ;
    tracks     : track array ;
  }


(* Native C external functions *)

external get_num_drives : unit -> int = "sdlcdrom_get_num_drives"
external drive_name : int -> string = "sdlcdrom_drive_name"

external cd_open : int -> cdrom_drive = "sdlcdrom_open"
external cd_close : cdrom_drive -> unit = "sdlcdrom_close"

external cd_status : cdrom_drive -> cdrom_drive_status = "sdlcdrom_status"
external cd_info : cdrom_drive -> cdrom_info = "sdlcdrom_info"

external cd_play_tracks : cdrom_drive -> 
      start_track:int -> 
      start_frame:int -> 
      num_tracks:int -> 
      num_frames:int -> unit = "sdlcdrom_play_tracks"
external cd_pause : cdrom_drive -> unit = "sdlcdrom_pause"
external cd_resume : cdrom_drive -> unit = "sdlcdrom_resume"
external cd_stop : cdrom_drive -> unit = "sdlcdrom_stop"
external cd_eject : cdrom_drive -> unit = "sdlcdrom_eject"

(* ML functions *)

let cd_play_track cdrom { id = num } =
  cd_play_tracks cdrom (num - 1) 0 1 0;;

let msf_of_frames f =
  let s' = f / 75 in
  let m  = s' / 60 in
  (m, s' mod 60, f mod 75)

let frames_of_msf (m, s, f) =
  m * 60 * 75 + s * 75 + f

