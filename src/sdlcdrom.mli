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

(* $Id: sdlcdrom.mli,v 1.6 2001/05/27 18:01:49 xtrm Exp $ *)

(*d Exception *)

exception SDLcdrom_exception of string

(*d Types *)

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

(*1 Operations on a CD-ROM drive *)
 
(*d An SDLcdrom_exception is raised on errors *)

val get_num_drives : unit -> int;;
(*d [get_num_drives] returns the number of CD-ROM drives on the system *)

val drive_name : drive:int -> string;;
(*d [drive_name drive] returns a human-readable, system-dependent identifier 
  for the CD-ROM. 
  [drive] is the index of the drive. Drive indices start to 0 and end 
  at [get_num_drives()-1].*)

val cd_open : int -> cdrom_drive;;
(*d [cd_open drive] open a CD-ROM drive for access *)

val cd_close : cdrom_drive -> unit;;
(*d Closes the handle for the cdrom_drive *)

val cd_status : cdrom_drive -> cdrom_drive_status;;
(*d This function returns the current status of the given drive. *)

val cd_play_tracks : cdrom_drive:cdrom_drive -> start_track:int -> 
  start_frame:int -> num_tracks:int -> num_frames:int -> unit;;
(*d Play the given CD with these parameters
   start_track : int => the starting track
   start_frame : int => the starting frame
   ntracks : int     => the number of tracks to play
   nframes : int     => the number of frames to play *)

val cd_play_track : cdrom_drive:cdrom_drive -> n:int -> unit;;
(*d Play the track n on the given cdrom_drive *)

val cd_pause : cdrom_drive -> unit;;
(*d Pause play *)

val cd_resume : cdrom_drive -> unit;;
(*d Resume play *)

val cd_stop : cdrom_drive -> unit;;
(*d Stop play *)

val cd_eject : cdrom_drive -> unit;;
(*d Eject CD-ROM *) 

(*1 Operations on tracks *)

val cd_get_num_tracks : cdrom_drive -> int;;
(*d Return the number of tracks *)

val cd_track_num : cdrom_drive:cdrom_drive -> n:int -> cdrom_track;;
(*d Return the Nth track *)

val cd_track_list : cdrom_drive -> cdrom_track list;;
(*d Return list of track *) 

val track_length : cdrom_track -> int * int;;
(*d Return length of track *)

val track_type : cdrom_track -> cdrom_track_type;;
(*d Return type of cdrom_track (TRACK_AUDIO or TRACK_DATA) *)

val cd_track_current_time : cdrom_drive -> int * int ;;
(*d Return the minute and seconds elapted *)

val cd_current_track : cdrom_drive -> cdrom_track;;
(*d Return the current track played *)

val track_get_number : cdrom_track -> int ;;
(*d Convert cdrom_track type to int *)


