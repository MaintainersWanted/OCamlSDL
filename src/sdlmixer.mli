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

(* $Id: sdlmixer.mli,v 1.3 2000/03/05 17:01:35 smkl Exp $ *)

(* Define a new exception for loader errors and register 
   it to be callable from C code. *)

exception SDLmixer_exception of string

type format =
 | AUDIO_FORMAT_DEFAULT
 | AUDIO_FORMAT_U8
 | AUDIO_FORMAT_S8
 | AUDIO_FORMAT_U16
 | AUDIO_FORMAT_S16

type fade_status =
 | NO_FADING
 | FADING_OUT
 | FADING_IN

type channels = STEREO | MONO

type chunk
type music
type channel = int
type group = int

val open_audio : int -> format -> channels -> unit
val close_audio : unit -> unit
val query_specs : unit -> int * format * int

(* Loading and freeing sounds *)

val loadWAV : string -> chunk
val load_string : string -> chunk
val load_music : string -> music
val free_chunk : chunk -> unit
val free_music : music -> unit

(* Hooks *)

val set_postmix : (string -> unit) -> unit
val set_music : (string -> unit) -> unit
val set_music_finished : (unit -> unit) -> unit

(* Groups and channels *)

val allocate_channels : int -> int
val reserve_channels : int -> int
val group_channel : channel -> group option -> unit
val group_available : group -> channel
val group_count : group -> int
val group_oldest : group -> channel
val group_newer : group -> channel

(* Playing *)

val play_sound : chunk -> unit
val play_channel : channel option -> chunk -> int option -> float option -> channel
val play_music : music -> int option -> channel
val fadein_channel : channel option -> chunk -> int option -> float option -> float option -> channel
val fadein_music : music -> int option -> float option -> channel

(* Volume control *)

val volume_channel : channel option -> float
val volume_chunk : chunk -> float
val volume_music : music -> float

val setvolume_channel : channel option -> float -> unit
val setvolume_chunk : chunk -> float -> unit
val setvolume_music : music -> float -> unit

(* Stopping playing *)

val halt_channel : channel -> unit
val halt_group : group -> unit
val halt_music : unit -> unit
val expire_channel : channel -> float option -> unit
val fadeout_channel : channel -> float -> unit
val fadeout_group : group -> float -> unit
val fadeout_music : float -> unit
val fading_music : unit -> fade_status
val fading_channel : channel -> fade_status

(* Pausing / resuming *)

val pause_channel : channel -> unit
val resume_channel : channel -> unit
val paused_channel : channel -> bool
val pause_music : unit -> unit
val resume_music : unit -> unit
val rewind_music : unit -> unit
val paused_music : unit -> bool
val playing : channel option -> bool
val playing_music : unit -> bool
