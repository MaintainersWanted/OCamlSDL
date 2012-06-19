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

(* $Id: sdlcdrom.mli,v 1.12 2012/06/19 18:20:59 oliv__a Exp $ *)

(** This module provides CD-ROM handling *)

exception SDLcdrom_exception of string
(** Exception used to report errors *)

exception Trayempty
(** Exception to report that thre's no cd in the drive *)

(** {3 Types} *)

type cdrom_drive
(** abstract type for handling cdrom *)

type cdrom_drive_status = 
  | CD_TRAYEMPTY (** cdrom drive is empty *)
  | CD_STOPPED   (** cdrom drive is stopped *)
  | CD_PLAYING   (** cdrom drive is playing *)
  | CD_PAUSED    (** cdrom drive is paused *)
(** enumeration of different status cdrom drive *)

type track_type =
  | TRACK_AUDIO (** audio track type *)
  | TRACK_DATA  (** data track type *)
(** the types of CD-ROM track possible *)

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

(** {3 General API} *)
 
(** An SDLcdrom_exception is raised on errors *)

val get_num_drives : unit -> int
(** [get_num_drives] returns the number of CD-ROM drives on the system *)

val drive_name : int -> string
(** [drive_name drive] returns a human-readable, system-dependent identifier 
  for the CD-ROM. 
  [drive] is the index of the drive. Drive indices start to 0 and end 
  at [get_num_drives()-1].*)

(** {3 CD-ROM drive handling} *)

val cd_open : int -> cdrom_drive
(** [cd_open drive] open a CD-ROM drive for access *)

val cd_close : cdrom_drive -> unit
(** Closes the handle for the cdrom_drive *)

val cd_status : cdrom_drive -> cdrom_drive_status
(** @return the current status of the given drive. *)

val cd_info : cdrom_drive -> cdrom_info
(** @return the table of contents of the CD and current play position 
   @raise Trayempty if there's no cd in the drive *)

(** {3 Playing audio tracks } *)

val msf_of_frames : int -> int * int * int
val frames_of_msf : int * int * int -> int

val cd_play_tracks : cdrom_drive -> start_track:int -> 
  start_frame:int -> num_tracks:int -> num_frames:int -> unit
(** [cd_play_tracks cdrom_drive start_track start_frame num_tracks num_frames] 
  play the given CD with these parameters
   @param start_track the starting track
   @param start_frame the starting frame
   @param num_tracks the number of tracks to play
   @param num_frames the number of frames to play 

   @raise Trayempty if there's no cd in the drive
*)

val cd_play_track : cdrom_drive -> track -> unit
(** Play the track n on the given cdrom_drive *)

val cd_pause : cdrom_drive -> unit
(** Pause play *)

val cd_resume : cdrom_drive -> unit
(** Resume play *)

val cd_stop : cdrom_drive -> unit
(** Stop play *)

val cd_eject : cdrom_drive -> unit
(** Eject CD-ROM *) 
