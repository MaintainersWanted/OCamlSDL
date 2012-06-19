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

(* $Id: sdlmixer.mli,v 1.17 2012/06/19 18:20:59 oliv__a Exp $ *)

(** Simple multi-channel audio mixer *)

exception SDLmixer_exception of string
(** Exception used to report errors *)


(** {3 General API} *)

val version : unit -> Sdl.version
(** Get the version of the dynamically linked SDL_mixer library *)

(** Audio format flags *)
type format =
 | AUDIO_FORMAT_U8     (** Unsigned 8-bit samples *)
 | AUDIO_FORMAT_S8     (** Signed 8-bit samples *)
 | AUDIO_FORMAT_U16LSB (** Unsigned 16-bit samples *)
 | AUDIO_FORMAT_S16LSB (** Signed 16-bit samples *)
 | AUDIO_FORMAT_U16MSB (** As above, but big-endian byte order *)
 | AUDIO_FORMAT_S16MSB (** As above, but big-endian byte order *)
 | AUDIO_FORMAT_U16SYS (** Unsigned, native audio byte ordering *)
 | AUDIO_FORMAT_S16SYS (** Signed, native audio byte ordering *)

type channels = MONO | STEREO

val open_audio : 
  ?freq:int -> ?format:format -> ?chunksize:int -> ?channels:channels 
     -> unit -> unit
(** [open_audio frequency format chunksize channels ()] opens the mixer
    with a certain audio format.  
   - frequency could be 8000 11025 22050 44100 ; defaults to 22050
   - format defaults to AUDIO_FORMAT_S16SYS
   - chunksize defaults to 4096
   - channels defaults to STEREO
 *)

val close_audio : unit -> unit
(** Close the mixer, halting all playing audio *)

type specs =
  { frequency : int;
    format    : format;
    channels  : channels }

val query_specs : unit -> specs
(** Find out what the actual audio device parameters are. 
    @raise SDLmixer_exception if the audio has not been opened
 *)

(** {3 Samples} *)

type chunk

val loadWAV : string -> chunk
(** Load a wave file *)

val loadWAV_from_mem : string -> chunk

val load_string : string -> chunk
(** Load a wave file of the mixer format from a memory buffer *)
val load_string_raw : string -> chunk
(** Load raw audio data of the mixer format from a memory buffer *)

val volume_chunk   : chunk -> float
val setvolume_chunk : chunk -> float -> unit

val free_chunk : chunk -> unit
(** Free an audio chunk previously loaded *)

(** {3 Channels} *)

type channel = int

val all_channels  : channel
(** A special value for representing all channels (-1 actually). *)

val num_channels : unit -> int
(** @return the number of channels currently allocated *)

val allocate_channels : int -> int
(** Dynamically change the number of channels managed by the mixer.
    If decreasing the number of channels, the upper channels are
    stopped.
    @return the new number of allocated channels
 *)

val play_channel : 
  ?channel:channel -> ?loops:int -> ?ticks:float -> chunk -> unit
(** [play_channel channel loops ticks chunk ] Play an audio chunk.
  @param channel channel to play on. If not specified, play on the
  first free channel.  
  @param loops number of times to play the chunk. If [-1], loop
  infinitely (~65000 times).  
  @param ticks if specified, play for at most 'ticks' seconds.
*)

val play_sound : chunk -> unit
(** Play an audio chunk. Same as above, without the optional
  parameters *)

val fadein_channel : 
  ?channel:channel -> ?loops:int -> ?ticks:float -> chunk -> float -> unit
(** [fadein_channel channel loops ticks chunck ms] :
   same as [play_channel] but fades in a over [ms] seconds.
*)

val volume_channel : channel -> float
(** Returns the original volume of a specific channel, chunk or music 
  @return float between 0 and 1. *)
val setvolume_channel : channel -> float -> unit
(** Sets the volume for specified channel or chunk. 
   Volume is a float between 0 and 1. 
   If lower than 0, nothing is done.
   If greater than 1, volume is set to 1 *)

val pause_channel : channel -> unit
val resume_channel : channel -> unit

val halt_channel : channel -> unit

val expire_channel : channel -> float option -> unit
(**  [expire_channel channel ticks]
  Change the expiration delay for a particular channel.
  The sample will stop playing after the 'ticks' seconds have elapsed,
  or remove the expiration if 'ticks' is [None]
*)

val fadeout_channel : channel -> float -> unit
(** [fadeout_channel channel ticks]
  Halt a channel, fading it out progressively till it's silent
  The ms parameter indicates the number of seconds the fading
  will take.
 *)

val playing_channel : channel -> bool
val num_playing_channel : unit -> int
val paused_channel : channel -> bool
val num_paused_channel : unit -> int

(** The different fading types supported *)
type fade_status =
 | NO_FADING
 | FADING_OUT
 | FADING_IN

val fading_channel : channel -> fade_status
(** Query the fading status of a channel *)


(** {3 Groups} *)

type group = int

val default_group : group
(** The group tag used to represent the group of all the channels.
   Used to remove a group tag *)


val reserve_channels : int -> int
(** Reserve the first channels (0 -> n-1) for the application,
    i.e. don't allocate them dynamically to the next sample if
    no channel is specified (see {! Sdlmixer.play_channel}).
    @return the number of reserved channels 
*)

val group_channel : channel -> group -> unit
(** Attach a group tag to a channel. A group tag can be assigned to several
   mixer channels, to form groups of channels.  
   If group is [default_group], the tag is removed.
*)

val group_channels : from_c:channel -> to_c:channel -> group -> unit
(** Same as above but for a range of channels. *)

val group_count : group -> int
(** Returns the number of channels in a group. 
   This is also a subtle way to get the total number of channels 
   when [group] is [default_group].
*)

val group_available : group -> channel
(** Finds the first available [channel] in a [group] of channels 
   @raise Not_found if none are available. 
*)

val group_oldest : group -> channel
(** Finds the "oldest" sample playing in a [group] of channels *)

val group_newer : group -> channel
(** Finds the "most recent" (i.e. last) sample playing in a [group] of
   channels *)

val fadeout_group : group -> float -> unit
(** [fadeout_group group ticks]
  Halt a group of channel, fading it out progressively till it's silent
  The ms parameter indicates the number of seconds the fading
  will take.
*)

val halt_group : group -> unit


(** {3 Music} *)

type music

(** The different music types supported *)
type music_kind =
  | NONE
  | CMD
  | WAV
  | MOD
  | MID
  | OGG
  | MP3

val load_music : string -> music
(** Load a music file (.mod .s3m .it .xm .ogg) *)

val free_music : music -> unit
(** Free music previously loaded *)

val play_music : ?loops:int -> music -> unit
(** Play a music chunk.
   @param loops number of times to play through the music *)

val fadein_music : ?loops:int -> music -> float -> unit
(** [fadein_music chunck loops music ms] :
   fade in music over [ms] seconds, same semantics as the [play_music]
   function *)

val volume_music   : unit -> float

val setvolume_music : float -> unit

val pause_music   : unit -> unit

val resume_music   : unit -> unit

val rewind_music : unit -> unit


val set_music_cmd : string -> unit
(** Stop music and set external music playback command *)

val unset_music_cmd : unit -> unit
(** Turn off using an external command for music, returning to the
    internal music playing functionality *)

val halt_music : unit -> unit

val fadeout_music : float -> unit
(** [fadeout_music ticks]
  Halt the music, fading it out progressively till it's silent.
  The ms parameter indicates the number of seconds the fading
  will take.
*)

val music_type : music option -> music_kind
(** Find out the music format of a mixer music, or the currently
    playing music, if parameter is [None]. *)

val playing_music   : unit -> bool

val paused_music   : unit -> bool

val fading_music : unit -> fade_status
(** Query the fading status of a music *)
