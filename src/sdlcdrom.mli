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

(* $Id: sdlcdrom.mli,v 1.7 2002/08/07 21:26:25 xtrm Exp $ *)

(** This module provides cdrom handling *)

(*d Exception *)

exception SDLcdrom_exception of string
(** Exception used to report errors *)


(** {1 Types} *)

type cdrom_drive
(** abstract type for handling cdrom *)
 
type cdrom_track
(** abstract type for handling cdrom track *)


type cdrom_drive_status = 
    CD_TRAYEMPTY (** cdrom drive is empty *)
  | CD_STOPPED   (** cdrom drive is stopped *)
  | CD_PLAYING   (** cdrom drive is playing *)
  | CD_PAUSED    (** cdrom drive is paused *)
  | CD_ERROR     (** error *)
(** enumeration of different status cdrom drive *)

(** the types of CD-ROM track possible *)
type cdrom_track_type =
    TRACK_AUDIO (** audio track type *)
  | TRACK_DATA  (** data ttrack type *)

(** {1 General API} *)
 
(* An SDLcdrom_exception is raised on errors *)

val get_num_drives : unit -> int;;
(** [get_num_drives] returns the number of CD-ROM drives on the system *)

val drive_name : drive:int -> string;;
(** [drive_name drive] returns a human-readable, system-dependent identifier 
  for the CD-ROM. 
  [drive] is the index of the drive. Drive indices start to 0 and end 
  at [get_num_drives()-1].*)

(** {2 cdrom drive handling} *)

val cd_open : int -> cdrom_drive;;
(** [cd_open drive] open a CD-ROM drive for access *)

val cd_close : cdrom_drive -> unit;;
(** Closes the handle for the cdrom_drive *)

val cd_status : cdrom_drive -> cdrom_drive_status;;
(** @return the current status of the given drive. *)

val cd_pause : cdrom_drive -> unit;;
(** Pause play *)

val cd_resume : cdrom_drive -> unit;;
(** Resume play *)

val cd_stop : cdrom_drive -> unit;;
(** Stop play *)

val cd_eject : cdrom_drive -> unit;;
(** Eject CD-ROM *) 

(** {2 Tracks} *)

val cd_play_tracks : cdrom_drive:cdrom_drive -> start_track:int -> 
  start_frame:int -> num_tracks:int -> num_frames:int -> unit;;
(** [cd_play_tracks cdrom_drive start_track start_frame num_tracks num_frames] 
  play the given CD with these parameters
   - start_track : int => the starting track
   - start_frame : int => the starting frame
   - ntracks : int     => the number of tracks to play
   - nframes : int     => the number of frames to play 
*)

val cd_play_track : cdrom_drive:cdrom_drive -> n:int -> unit;;
(** Play the track n on the given cdrom_drive *)

val cd_get_num_tracks : cdrom_drive -> int;;
(** @return the number of tracks *)

val cd_track_num : cdrom_drive:cdrom_drive -> n:int -> cdrom_track;;
(** @return the Nth track *)

val cd_track_list : cdrom_drive -> cdrom_track list;;
(** @return list of track *) 

val track_length : cdrom_track -> int * int;;
(** @return length of track *)

val track_type : cdrom_track -> cdrom_track_type;;
(** @return type of cdrom_track (TRACK_AUDIO or TRACK_DATA) *)

val cd_track_current_time : cdrom_drive -> int * int ;;
(** @return the minute and seconds elapted *)

val cd_current_track : cdrom_drive -> cdrom_track;;
(** @return the current track played *)

val track_get_number : cdrom_track -> int ;;
(** convert cdrom_track type to int *)


