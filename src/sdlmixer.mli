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

(* $Id: sdlmixer.mli,v 1.7 2002/06/26 11:05:58 oliv__a Exp $ *)

(* Define a new exception for loader errors and register 
   it to be callable from C code. *)

(* Exception *)
exception SDLmixer_exception of string

(*d Types *)
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
  freq:int -> format -> ?chunksize:int -> channels -> unit
    = "sdlmixer_open_audio";;
(*d 
  [open_audio frequency format channels [chunksize]] open the mixer with a certain 
  audio format.
  frequency could be 8000 11025 22050 44100
*)

val close_audio : unit -> unit
(*d Close the mixer, halting all playing audio *)

val query_specs : unit -> specs option
(*d This function returns what the actual audio device parameters are. *)

(*1 Loading and freeing sounds *)

val loadWAV : string -> chunk 
(*d Load a wave file *)

val load_string : string -> chunk
(*d Load a wave file of the mixer format from a memory buffer *)

val load_music : string -> music
(*d Load a music file (.mod .s3m .it .xm) *)

val free_chunk : chunk -> unit
(*d Free an audio chunk previously loaded *)

val free_music : music -> unit
(*d Free music previously loaded *)

(*1 Hooks *)

val set_postmix : (string -> unit) -> unit
(*d 
  Set a function [string -> unit] that is called after all mixing 
  is performed. This can be used to provide real-time visual 
  display of the audio stream or add a custom mixer filter 
  for the stream data.
*)

val set_music : (string -> unit) -> unit
(*d Add your own music player or additional mixer function. *)

val set_music_finished : (unit -> unit) -> unit
(*d Add your own callback [unit -> unit] when the music has finished 
  playing. *)

(*1 Groups and channels *)

val allocate_channels : int -> int
(*d 
  Dynamically change the number of channels managed by the mixer.
  If decreasing the number of channels, the upper channels are
  stopped.
  This function returns the new number of allocated channels.
 *)

val reserve_channels : int -> int
(*d
  Reserve the first channels (0 -> n-1) for the application, i.e. don't allocate
   them dynamically to the next sample if requested with a -1 value below.
   Returns the number of reserved channels.
*)

val group_channel : channel -> group option -> unit
val group_available : group -> channel
(*d Finds the first available [channel] in a [group] of channels *)

val group_count : group -> int
(*d 
  Returns the number of channels in a group. This is also a subtle
  way to get the total number of channels when [group] is -1 
*)
val group_oldest : group -> channel
(*d Finds the "oldest" sample playing in a [group] of channels *)

val group_newer : group -> channel
(*d Finds the "most recent" (i.e. last) sample playing in a [group] of channels *)

(*1 Playing *)

val play_sound : chunk -> unit
(*d Play an audio chunk *)

val play_channel : channel option -> chunk -> int option -> float option -> channel
(*d [play_channel channel chunck loops ticks]
  Play an audio chunk 
  If the specified channel is -1, play on the first free channel.
  If 'loops' is greater than zero, loop the sound that many times.
  If 'loops' is -1, loop inifinitely (~65000 times).
  Returns which channel was used to play the sound. 
*)

val play_music : music -> int option -> channel
(*d  The same as above, but the sound is played at most 'ticks' milliseconds *)

val fadein_channel : channel option -> chunk -> int option -> float option -> float option -> channel
(*d [fadein_channel channel chunck loops ticks]
  Fade in a channel over "ms" milliseconds, same semantics as the [play] functions *)

val fadein_music : music -> int option -> float option -> channel
(*d [fadein_music music chunck loops ticks]
  Fade in music over "ms" milliseconds, same semantics as the [play] functions *)

(*1 Volume control *)

val volume_channel : channel option -> float
val volume_chunk : chunk -> float
val volume_music : music -> float
(*d Returns the original volume of a specific channel, chunk or music *)

val setvolume_channel : channel option -> float -> unit
val setvolume_chunk : chunk -> float -> unit
val setvolume_music : music -> float -> unit
(*d Set the volume in the range of 0-128 of a specific channel, chunk 
  or music.
  If the specified channel is -1, set volume for all channels.*)


(*1 Stopping playing *)

val halt_channel : channel -> unit
val halt_group : group -> unit
val halt_music : unit -> unit

val expire_channel : channel -> float option -> unit
(*d  [expire_channel channel ticks]
  Change the expiration delay for a particular channel.
  The sample will stop playing after the 'ticks' milliseconds have elapsed,
  or remove the expiration if 'ticks' is -1
*)
val fadeout_channel : channel -> float -> unit
(*d [fadeout_channel channel ticks]
  Halt a channel, fading it out progressively till it's silent
  The ms parameter indicates the number of milliseconds the fading
  will take.
 *)

val fadeout_group : group -> float -> unit
(*d [fadeout_group group ticks]
  Halt a group of channel, fading it out progressively till it's silent
  The ms parameter indicates the number of milliseconds the fading
  will take.
*)

val fadeout_music : float -> unit
(*d [fadeout_music ticks]
  Halt the music, fading it out progressively till it's silent
  The ms parameter indicates the number of milliseconds the fading
  will take.
*)
val fading_music : unit -> fade_status
(*d Query the fading status of a music *)

val fading_channel : channel -> fade_status
(*d Query the fading status of a channel *)

(*1 Pausing / resuming *)

val pause_channel : channel -> unit
val resume_channel : channel -> unit
val paused_channel : channel -> bool
val pause_music : unit -> unit
val resume_music : unit -> unit
val rewind_music : unit -> unit
val paused_music : unit -> bool
val playing : channel option -> bool
val playing_music : unit -> bool
