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

(* $Id: sdlcdrom.mli,v 1.3 2000/06/09 07:57:04 xtrm Exp $ *)

(* Exception *)

exception SDLcdrom_exception of string

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

(* 
 * Operations on a CD-ROM drive 
 * An SDLcdrom_exception is raised on errors
 *)

(* Return the number of CD-ROM drives on the system *)
val get_num_drives : unit -> int;;

(* Return a human-redeable identifier for the CD-ROM *)
val drive_name : int -> string;;

val cd_open : int -> cdrom_drive;;
val cd_close : cdrom_drive -> unit;;
val cd_status : cdrom_drive -> cdrom_drive_status;;

(* Play the given CD with these parameters
   start_track : int => the starting track
   start_frame : int => the starting frame
   ntracks : int     => the number of tracks to play
   nframes : int     => the number of frames to play *)
val cd_play_tracks : cdrom_drive -> int -> int -> int -> int -> unit;;

val cd_play_track : cdrom_drive -> int -> unit;;
val cd_pause : cdrom_drive -> unit;;
val cd_resume : cdrom_drive -> unit;;
val cd_stop : cdrom_drive -> unit;;
val cd_eject : cdrom_drive -> unit;;

(*
 * Operations on tracks 
 *)

val cd_get_num_tracks : cdrom_drive -> int;;
val cd_track_num : cdrom_drive -> int -> cdrom_track;;
val cd_track_list : cdrom_drive -> cdrom_track list;;
val track_length : cdrom_track -> int * int;;
val track_type : cdrom_track -> cdrom_track_type;;

val cd_track_offset : cdrom_drive -> int * int ;;
val cd_current_track : cdrom_drive -> cdrom_track;;
val track_of_int : cdrom_track -> int ;;


