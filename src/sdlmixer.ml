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

(* $Id: sdlmixer.ml,v 1.11 2002/09/30 21:01:04 oliv__a Exp $ *)

(* Define a new exception for loader errors and register 
   it to be callable from C code. *)

exception SDLmixer_exception of string
let _ = 
  Callback.register_exception "SDLmixer_exception" 
    (SDLmixer_exception "")

type format =
 | AUDIO_FORMAT_U8
 | AUDIO_FORMAT_S8
 | AUDIO_FORMAT_U16LSB
 | AUDIO_FORMAT_S16LSB
 | AUDIO_FORMAT_U16MSB
 | AUDIO_FORMAT_S16MSB
 | AUDIO_FORMAT_U16SYS
 | AUDIO_FORMAT_S16SYS

type fade_status =
 | NO_FADING
 | FADING_OUT
 | FADING_IN

type music_kind =
  | NONE
  | CMD
  | WAV
  | MOD
  | MID
  | OGG
  | MP3

type channels = MONO | STEREO

type chunk
type music
type channel = int
type group = int
type specs =
  { frequency : int;
    format : format;
    channels : channels }

external open_audio : 
  ?freq:int -> ?format:format -> ?chunksize:int -> ?channels:channels 
     -> unit -> unit
    = "sdlmixer_open_audio"

external close_audio : unit -> unit = "sdlmixer_close_audio"
external version : unit -> Sdl.version ="sdlmixer_version"
external query_specs : unit -> specs = "sdlmixer_query_specs"

(* Loading and freeing sounds *)

external loadWAV : string -> chunk = "sdlmixer_loadWAV"
external load_string : string -> chunk = "sdlmixer_load_string"
external load_music : string -> music = "sdlmixer_loadMUS"
external music_type : music option -> music_kind = "sdlmixer_get_music_type"
external set_music_cmd : string -> unit = "sdlmixer_set_music_cmd"
external unset_music_cmd : unit -> unit = "sdlmixer_unset_music_cmd"
external free_chunk : chunk -> unit = "sdlmixer_free_chunk"
external free_music : music -> unit = "sdlmixer_free_music"

(* Groups and channels *)
let all_channels  = -1
let default_group = -1
external allocate_channels : int -> int = "sdlmixer_allocate_channels"
let num_channels () = allocate_channels ~-1
external reserve_channels : int -> int = "sdlmixer_reserve_channels"
external group_channel : channel -> group -> unit = "sdlmixer_group_channel"
external group_channels : from_c:channel -> to_c:channel -> group -> unit = "sdlmixer_group_channel"
external group_available : group -> channel = "sdlmixer_group_available"
external group_count : group -> int = "sdlmixer_group_count"
external group_oldest : group -> channel = "sdlmixer_group_oldest"
external group_newer : group -> channel = "sdlmixer_group_newer"

(* Playing *)
external play_channel : ?channel:channel -> ?loops:int -> ?ticks:float -> chunk -> unit = "sdlmixer_play_channel_timed"
external play_music : ?loops:int -> music -> unit = "sdlmixer_play_music"
external fadein_channel : ?channel:channel -> ?loops:int -> ?ticks:float -> chunk -> float -> unit = "sdlmixer_fadein_channel"
external fadein_music : ?loops:int -> music -> float -> unit = 
  "sdlmixer_fadein_music"

let play_sound chunk = ignore (play_channel chunk)

(* Volume control *)

external volume_channel : channel -> float = "sdlmixer_volume_channel"
external volume_chunk   : chunk -> float = "sdlmixer_volume_chunk"
external volume_music   : music -> float = "sdlmixer_volume_music"

external setvolume_channel : channel -> float -> unit = "sdlmixer_setvolume_channel"
external setvolume_chunk : chunk -> float -> unit = "sdlmixer_setvolume_chunk"
external setvolume_music : music -> float -> unit = "sdlmixer_setvolume_music"

(* Stopping playing *)

external halt_channel : channel -> unit = "sdlmixer_halt_channel"
external halt_group : group -> unit = "sdlmixer_halt_group"
external halt_music : unit -> unit = "sdlmixer_halt_music"
external expire_channel : channel -> float option -> unit = "sdlmixer_expire_channel"
external fadeout_channel : channel -> float -> unit = "sdlmixer_fadeout_channel"
external fadeout_group : group -> float -> unit = "sdlmixer_fadeout_group"
external fadeout_music : float -> unit = "sdlmixer_fadeout_music"
external fading_music : unit -> fade_status = "sdlmixer_fading_music"
external fading_channel : channel -> fade_status = "sdlmixer_fading_channel"

(* Pausing / resuming *)

external pause_channel : channel -> unit = "sdlmixer_pause_channel"
external pause_music   : unit -> unit = "sdlmixer_pause_music"

external resume_channel : channel -> unit = "sdlmixer_resume_channel"
external resume_music   : unit -> unit = "sdlmixer_resume_music"

external rewind_music : unit -> unit = "sdlmixer_rewind_music"

external num_paused_channel : unit -> int = "sdlmixer_numpaused_channel"
external paused_channel : channel -> bool = "sdlmixer_paused_channel"
external paused_music   : unit -> bool = "sdlmixer_paused_music"

external num_playing_channel : unit -> int = "sdlmixer_numplaying"
external playing_channel : channel -> bool = "sdlmixer_playing"
external playing_music   : unit -> bool = "sdlmixer_playing_music"
