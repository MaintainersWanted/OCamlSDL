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

(* $Id: sdlmixer.mli,v 1.12 2002/09/30 21:01:04 oliv__a Exp $ *)

(** Simple multi-channel audio mixer *)

exception SDLmixer_exception of string
(** Exception used to report errors *)


(** {1 General API} *)

external version : unit -> Sdl.version ="sdlmixer_version"
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

(** {1 Samples} *)

type chunk

external loadWAV : string -> chunk = "sdlmixer_loadWAV"
(** Load a wave file *)

external load_string : string -> chunk = "sdlmixer_load_string"
(** Load a wave file of the mixer format from a memory buffer *)

external volume_chunk   : chunk -> float = "sdlmixer_volume_chunk"
external setvolume_chunk : chunk -> float -> unit = "sdlmixer_setvolume_chunk"

external free_chunk : chunk -> unit = "sdlmixer_free_chunk"
(** Free an audio chunk previously loaded *)

(** {1 Channels} *)

type channel = int

val all_channels  : channel
(** A special value for representing all channels (-1 actually). *)

val num_channels : unit -> int
(** @return the number of channels currently allocated *)

external allocate_channels : int -> int = "sdlmixer_allocate_channels"
(** Dynamically change the number of channels managed by the mixer.
    If decreasing the number of channels, the upper channels are
    stopped.
    @return the new number of allocated channels
 *)

external play_channel : 
  ?channel:channel -> ?loops:int -> ?ticks:float -> chunk -> unit
  = "sdlmixer_play_channel_timed"
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

external fadein_channel : 
  ?channel:channel -> ?loops:int -> ?ticks:float -> chunk -> float -> unit
  = "sdlmixer_fadein_channel"
(** [fadein_channel channel loops ticks chunck ms] :
   same as [play_channel] but fades in a over [ms] seconds.
*)

external volume_channel : channel -> float = "sdlmixer_volume_channel"
(** Returns the original volume of a specific channel, chunk or music 
  @return float between 0 and 1. *)
external setvolume_channel : channel -> float -> unit = "sdlmixer_setvolume_channel"
(** Sets the volume for specified channel or chunk. 
   Volume is a float between 0 and 1. 
   If lower than 0, nothing is done.
   If greater than 1, volume is set to 1 *)

external pause_channel : channel -> unit = "sdlmixer_pause_channel"
external resume_channel : channel -> unit = "sdlmixer_resume_channel"

external halt_channel : channel -> unit = "sdlmixer_halt_channel"

external expire_channel : channel -> float option -> unit = "sdlmixer_expire_channel"
(**  [expire_channel channel ticks]
  Change the expiration delay for a particular channel.
  The sample will stop playing after the 'ticks' seconds have elapsed,
  or remove the expiration if 'ticks' is [None]
*)

external fadeout_channel : channel -> float -> unit = "sdlmixer_fadeout_channel"
(** [fadeout_channel channel ticks]
  Halt a channel, fading it out progressively till it's silent
  The ms parameter indicates the number of seconds the fading
  will take.
 *)

external playing_channel : channel -> bool = "sdlmixer_playing"
external num_playing_channel : unit -> int = "sdlmixer_numplaying"
external paused_channel : channel -> bool = "sdlmixer_paused_channel"
external num_paused_channel : unit -> int = "sdlmixer_numpaused_channel"

(** The different fading types supported *)
type fade_status =
 | NO_FADING
 | FADING_OUT
 | FADING_IN

external fading_channel : channel -> fade_status = "sdlmixer_fading_channel"
(** Query the fading status of a channel *)


(** {1 Groups} *)

type group = int

val default_group : group
(** The group tag used to represent the group of all the channels.
   Used to remove a group tag *)


external reserve_channels : int -> int = "sdlmixer_reserve_channels"
(** Reserve the first channels (0 -> n-1) for the application,
    i.e. don't allocate them dynamically to the next sample if
    no channel is specified (see {! Sdlmixer.play_channel}).
    @return the number of reserved channels 
*)

external group_channel : channel -> group -> unit = "sdlmixer_group_channel"
(** Attach a group tag to a channel. A group tag can be assigned to several
   mixer channels, to form groups of channels.  
   If group is [default_group], the tag is removed.
*)

external group_channels : from_c:channel -> to_c:channel -> group -> unit = "sdlmixer_group_channel"
(** Same as above but for a range of channels. *)

external group_count : group -> int = "sdlmixer_group_count"
(** Returns the number of channels in a group. 
   This is also a subtle way to get the total number of channels 
   when [group] is [default_group].
*)

external group_available : group -> channel = "sdlmixer_group_available"
(** Finds the first available [channel] in a [group] of channels 
   @raise Not_found if none are available. 
*)

external group_oldest : group -> channel = "sdlmixer_group_oldest"
(** Finds the "oldest" sample playing in a [group] of channels *)

external group_newer : group -> channel = "sdlmixer_group_newer"
(** Finds the "most recent" (i.e. last) sample playing in a [group] of
   channels *)

external fadeout_group : group -> float -> unit = "sdlmixer_fadeout_group"
(** [fadeout_group group ticks]
  Halt a group of channel, fading it out progressively till it's silent
  The ms parameter indicates the number of seconds the fading
  will take.
*)

external halt_group : group -> unit = "sdlmixer_halt_group"


(** {1 Music} *)

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

external load_music : string -> music = "sdlmixer_loadMUS"
(** Load a music file (.mod .s3m .it .xm .ogg) *)

external free_music : music -> unit = "sdlmixer_free_music"
(** Free music previously loaded *)

external play_music : ?loops:int -> music -> unit = "sdlmixer_play_music"
(** Play a music chunk.
   @param loops number of times to play through the music *)

external fadein_music : ?loops:int -> music -> float -> unit
  = "sdlmixer_fadein_music"
(** [fadein_music chunck loops music ms] :
   fade in music over [ms] seconds, same semantics as the [play_music]
   function *)

external volume_music   : music -> float = "sdlmixer_volume_music"
external setvolume_music : music -> float -> unit = "sdlmixer_setvolume_music"

external pause_music   : unit -> unit = "sdlmixer_pause_music"

external resume_music   : unit -> unit = "sdlmixer_resume_music"

external rewind_music : unit -> unit = "sdlmixer_rewind_music"


external set_music_cmd : string -> unit = "sdlmixer_set_music_cmd"
(** Stop music and set external music playback command *)

external unset_music_cmd : unit -> unit = "sdlmixer_unset_music_cmd"
(** Turn off using an external command for music, returning to the
    internal music playing functionality *)

external halt_music : unit -> unit = "sdlmixer_halt_music"

external fadeout_music : float -> unit = "sdlmixer_fadeout_music"
(** [fadeout_music ticks]
  Halt the music, fading it out progressively till it's silent.
  The ms parameter indicates the number of seconds the fading
  will take.
*)

external music_type : music option -> music_kind = "sdlmixer_get_music_type"
(** Find out the music format of a mixer music, or the currently
    playing music, if parameter is [None]. *)

external playing_music   : unit -> bool = "sdlmixer_playing_music"

external paused_music   : unit -> bool = "sdlmixer_paused_music"

external fading_music : unit -> fade_status = "sdlmixer_fading_music"
(** Query the fading status of a music *)
