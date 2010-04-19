/*
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
 */

/* $Id: sdlmixer_stub.c,v 1.36 2010/04/19 20:26:20 oliv__a Exp $ */

#include <stdio.h>
#include <string.h>

#include <SDL.h>
#include <SDL_mixer.h>

#include "common.h"
#include "sdlrwops_stub.h"

/*
 * memory management (custom blocks)
 */
#ifdef __GNUC__ /* typechecked macro */
#define ML_CHUNK(chunk)  ( { Mix_Chunk *_mlsdl__c=chunk; \
                             abstract_ptr(_mlsdl__c); } )
#else
#define ML_CHUNK(chunk)  abstract_ptr(chunk);
#endif
#define SDL_CHUNK(chunk) ((Mix_Chunk *)Field((chunk), 0))


#ifdef __GNUC__ /* typechecked macro */
#define ML_MUS(music)  ( { Mix_Music *_mlsdl__m=music; \
                           abstract_ptr(_mlsdl__m); } )
#else
#define ML_MUS(music)  abstract_ptr(music);
#endif
#define SDL_MUS(music) ((Mix_Music *)Field((music), 0))

/*
 * Raise an OCaml exception with a message
 */

static void
sdlmixer_raise_exception (char *msg) Noreturn;
static void
sdlmixer_raise_exception (char *msg)
{
  static value *mixer_exn = NULL;
  if(! mixer_exn){
    mixer_exn = caml_named_value("SDLmixer_exception");
    if(! mixer_exn) {
      fprintf(stderr, "exception not registered."); 
      abort();
    }
  }
  raise_with_string(*mixer_exn, msg);
}

/*
 * OCaml/C conversion functions
 */

CAMLprim value
sdlmixer_open_audio(value frequency, value format, 
		    value chunksize, value channels, value unit)
{
  static const int format_of_val[] = { 
    AUDIO_U8, AUDIO_S8, 
    AUDIO_U16LSB, AUDIO_S16LSB,
    AUDIO_U16MSB, AUDIO_S16MSB,
    AUDIO_U16SYS, AUDIO_S16SYS, } ;
  int ret, mstr, c_format;
  int c_frequency = Opt_arg(frequency, Int_val, MIX_DEFAULT_FREQUENCY);
  int c_chunksize = Opt_arg(chunksize, Int_val, 1024);

  if(channels == Val_none)
    mstr = MIX_DEFAULT_CHANNELS;
  else
    mstr = Int_val(Unopt(channels)) + 1;
  
  if(format == Val_none)
    c_format = MIX_DEFAULT_FORMAT;
  else
    c_format = format_of_val[ Int_val(Unopt(format)) ];

  ret = Mix_OpenAudio(c_frequency, c_format, mstr, c_chunksize);

  if (ret == -1)
    sdlmixer_raise_exception(Mix_GetError());

  return Val_unit;
}

CAMLprim value
sdlmixer_allocate_channels(value channels)
{
  return Val_int(Mix_AllocateChannels(Int_val(channels)));
}

CAMLprim value
sdlmixer_version(value unit)
{
  const SDL_version *v;
  value r;

  r = alloc_small(3, 0);

#ifdef MIX_VERSION
  v = Mix_Linked_Version();
  Field(r, 0) = Val_int(v->major);
  Field(r, 1) = Val_int(v->minor);
  Field(r, 2) = Val_int(v->patch);
#else
  Field(r, 0) = Val_int(1);
  Field(r, 1) = Val_int(2);
  Field(r, 2) = Val_int(0);
#endif
  return r;
}


CAMLprim value
sdlmixer_query_specs(value unit)
{
  int freq, chan, ret, ml_format;
  value query;
  Uint16 form;

  ret = Mix_QuerySpec(&freq, &form, &chan);
  if(ret == 0)
    sdlmixer_raise_exception(Mix_GetError());

  switch (form) {
  case AUDIO_U8:     ml_format = 0; break;
  case AUDIO_S8:     ml_format = 1; break;
  case AUDIO_U16LSB: ml_format = 2; break;
  case AUDIO_S16LSB: ml_format = 3; break;
  case AUDIO_U16MSB: ml_format = 4; break;
  case AUDIO_S16MSB: ml_format = 5; break;
  default: 
    abort();
  }
  query  = alloc_small(3, 0);
  Field(query, 0) = Val_int(freq);
  Field(query, 1) = Val_int(ml_format);
  Field(query, 2) = Val_int(chan-1);
  return query;
}

CAMLprim value
sdlmixer_loadWAV(value fname)
{
  Mix_Chunk *chunk;
  chunk = Mix_LoadWAV(String_val(fname));

  if (chunk == NULL)
    sdlmixer_raise_exception(Mix_GetError());

  return ML_CHUNK(chunk);
}

CAMLprim value sdlmixer_loadWAV_RW(value o_autoclose, value rwops)
{
  int autoclose = Opt_arg(o_autoclose, Bool_val, SDL_TRUE);
  Mix_Chunk *c = Mix_LoadWAV_RW(SDLRWops_val(rwops), autoclose);
  if(! c)
    sdlmixer_raise_exception(Mix_GetError());
  return ML_CHUNK(c);
}

CAMLprim value
sdlmixer_loadMUS(value fname)
{
  Mix_Music *chunk;
  chunk = Mix_LoadMUS(String_val(fname));

  if (chunk == NULL)
    sdlmixer_raise_exception(Mix_GetError());

  return ML_MUS(chunk);
}

CAMLprim value
sdlmixer_load_string(value data)
{
  Mix_Chunk *chunk;
  chunk = Mix_QuickLoad_WAV(UString_val(data));

  if (chunk == NULL)
    sdlmixer_raise_exception(Mix_GetError());

  return ML_CHUNK(chunk);
}


CAMLprim value
sdlmixer_get_music_type(value music)
{
  Mix_Music *mus = Opt_arg(music, SDL_MUS, NULL);
  value v;

#if (MIX_MAJOR_VERSION >= 1) && (MIX_MINOR_VERSION >= 2) && (MIX_PATCHLEVEL >= 4)
  switch(Mix_GetMusicType(mus)) {
  case MUS_NONE : v = Val_int(0); break;
  case MUS_CMD  : v = Val_int(1); break;
  case MUS_WAV  : v = Val_int(2); break;
  case MUS_MOD  : v = Val_int(3); break;
  case MUS_MID  : v = Val_int(4); break;
  case MUS_OGG  : v = Val_int(5); break;
  case MUS_MP3  : v = Val_int(6); break;

  default       : v = Val_int(0); break;
  }
#else 
  v = Val_int(0);
#endif
  return v;
}


CAMLprim value 
sdlmixer_set_music_cmd(value command)
{
  int ret = Mix_SetMusicCMD(String_val(command));
  if(ret == -1)
    raise_out_of_memory();
  return Val_unit;
}

CAMLprim value 
sdlmixer_unset_music_cmd(value unit)
{
  Mix_SetMusicCMD(NULL);
  return Val_unit;
}

CAMLprim value
sdlmixer_free_chunk(value chunk)
{
  Mix_FreeChunk(SDL_CHUNK(chunk));
  nullify_abstract(chunk);
  return Val_unit;
}

CAMLprim value
sdlmixer_free_music(value chunk)
{
  Mix_FreeMusic(SDL_MUS(chunk));
  nullify_abstract(chunk);
  return Val_unit;
}

CAMLprim value
sdlmixer_reserve_channels(value num)
{
  return Val_int(Mix_ReserveChannels(Int_val(num)));
}

CAMLprim value
sdlmixer_group_channel(value chn, value grp)
{
  int res;
  res = Mix_GroupChannel(Int_val(chn), Int_val(grp));

  if (res == 0)
    sdlmixer_raise_exception(Mix_GetError());
  
  return Val_unit;
}

CAMLprim value
sdlmixer_group_channels(value from_chn, value to_chn, value grp)
{
  int from = Int_val(from_chn);
  int to = Int_val(to_chn);
  if(Mix_GroupChannels(from, to, Int_val(grp)) != (to-from+1))
    sdlmixer_raise_exception(Mix_GetError());
  return Val_unit;
}

CAMLprim value
sdlmixer_group_available(value grp)
{
  int ret = Mix_GroupAvailable(Int_val(grp));
  if(ret == -1)
    raise_not_found();
  return Val_int(ret);
}

CAMLprim value
sdlmixer_group_count(value grp)
{
  return Val_int(Mix_GroupCount(Int_val(grp)));
}

CAMLprim value
sdlmixer_group_oldest(value grp)
{
  int ret = Mix_GroupOldest(Int_val(grp));
  if(ret == -1)
    raise_not_found();
  return Val_int(ret);
}

CAMLprim value
sdlmixer_group_newer(value grp)
{
  int ret = Mix_GroupNewer(Int_val(grp));
  if(ret == -1)
    raise_not_found();
  return Val_int(ret);
}

CAMLprim value
sdlmixer_play_channel_timed(value chn, value loops, value tme, value sound)
{
  int t;
  int ret;
  int c_chn   = Opt_arg(chn, Int_val, -1);
  int c_loops = Opt_arg(loops, Int_val, 1);
  if (c_loops == 0) return Val_unit;
  if (c_loops > 0) c_loops -= 1;
  if (tme == Val_none) t = -1;
  else t = 1000.0 * Double_val(Unopt(tme));
  ret = Mix_PlayChannelTimed(c_chn, SDL_CHUNK(sound),
			     c_loops, t);
  if(ret == -1)
    sdlmixer_raise_exception(Mix_GetError());
  return Val_unit;
}

CAMLprim value
sdlmixer_play_music(value loops, value music)
{
  int c_loops = Opt_arg(loops, Int_val, -1);
  int ret = Mix_PlayMusic(SDL_MUS(music), c_loops);
  if(ret == -1)
    sdlmixer_raise_exception(Mix_GetError());
  return Val_unit;
}

CAMLprim value
sdlmixer_fadein_music(value loops, value music, value ms)
{
  int c_ms    = 1000 * Double_val(ms) ;
  int c_loops = Opt_arg(loops, Int_val, -1);
  int ret = Mix_FadeInMusic(SDL_MUS(music), c_loops, c_ms);
  if(ret == -1)
    sdlmixer_raise_exception(Mix_GetError());
  return Val_unit;
}

CAMLprim value
sdlmixer_fadein_channel(value chn, value loops, value ticks, 
			value chunk, value ms)
{
  int c_ticks, ret;
  int c_ms    = 1000 * Double_val(ms) ;
  int c_chn   = Opt_arg(chn, Int_val, -1);
  int c_loops = Opt_arg(loops, Int_val, 0);
  if (c_loops > 0) c_loops -= 1;
  if (ticks == Val_none) c_ticks = -1;
  else c_ticks = 1000.0 * Double_val(Unopt(ticks));
  ret = Mix_FadeInChannelTimed(c_chn, SDL_CHUNK(chunk), 
			       c_loops, c_ms, c_ticks);
  if(ret == -1)
    sdlmixer_raise_exception(Mix_GetError());
  return Val_unit;    
}

CAMLprim value
sdlmixer_volume_channel(value chn)
{
  return copy_double(Mix_Volume(Int_val(chn), -1) / (double) MIX_MAX_VOLUME);
}

CAMLprim value
sdlmixer_volume_chunk(value chunk)
{
  return copy_double(Mix_VolumeChunk(SDL_CHUNK(chunk), -1) / (double) MIX_MAX_VOLUME);
}

CAMLprim value
sdlmixer_volume_music(value unit)
{
  return copy_double(Mix_VolumeMusic(-1) / (double) MIX_MAX_VOLUME);
}

CAMLprim value
sdlmixer_setvolume_channel(value chn, value vol)
{
  Mix_Volume(Int_val(chn), Double_val(vol) * MIX_MAX_VOLUME);
  return Val_unit;
}

CAMLprim value
sdlmixer_setvolume_chunk(value chunk, value vol)
{
  Mix_VolumeChunk(SDL_CHUNK(chunk), Double_val(vol) * MIX_MAX_VOLUME);
  return Val_unit;
}

CAMLprim value
sdlmixer_setvolume_music(value vol)
{
  Mix_VolumeMusic(Double_val(vol) * MIX_MAX_VOLUME );
  return Val_unit;
}

CAMLprim value
sdlmixer_halt_channel(value chn)
{
  Mix_HaltChannel(Int_val(chn));
  return Val_unit;
}

CAMLprim value
sdlmixer_halt_group(value grp)
{
  Mix_HaltGroup(Int_val(grp));
  return Val_unit;
}

CAMLprim value
sdlmixer_halt_music(void)
{
  Mix_HaltMusic();
  return Val_unit;
}

CAMLprim value
sdlmixer_expire_channel(value chn, value ticks)
{
  int t;
  if (ticks == Val_none) t = -1;
  else t = 1000.0 * Double_val(Unopt(ticks));
  Mix_ExpireChannel(Int_val(chn), t);
  return Val_unit;
}

CAMLprim value
sdlmixer_fadeout_channel(value chn, value ms)
{
  Mix_FadeOutChannel(Int_val(chn), 1000.0 * Double_val(ms));
  return Val_unit;
}

CAMLprim value
sdlmixer_fadeout_group(value grp, value ms)
{
  Mix_FadeOutGroup(Int_val(grp), 1000.0 * Double_val(ms));
  return Val_unit;
}

CAMLprim value
sdlmixer_fadeout_music(value ms)
{
  Mix_FadeOutMusic(1000.0 * Double_val(ms));
  return Val_unit;
}

static value
convert_fading_status(Mix_Fading f)
{
  int conv = 0;

  switch (f)
    {
    case MIX_NO_FADING:
      conv = 0;
      break;
       
    case MIX_FADING_OUT:
      conv = 1;
      break;
       
    case MIX_FADING_IN:
      conv = 2;
      break;
    }
  
  return Val_int(conv);
}

CAMLprim value
sdlmixer_fading_music(void)
{
  Mix_Fading f;
  f = Mix_FadingMusic();
  return convert_fading_status(f);
}

CAMLprim value
sdlmixer_fading_channel(value chn)
{
  Mix_Fading f;
  if(Int_val(chn) < 0)
    invalid_argument("Sdlmixer.fading_channel");
  f = Mix_FadingChannel(Int_val(chn));
  return convert_fading_status(f);
}

CAMLprim value
sdlmixer_pause_channel(value chn)
{
  Mix_Pause(Int_val(chn));
  return Val_unit;
}

CAMLprim value
sdlmixer_resume_channel(value chn)
{
  Mix_Resume(Int_val(chn));
  return Val_unit;
}

CAMLprim value
sdlmixer_numpaused_channel(value unit)
{
  return Val_int(Mix_Paused(-1));
}

CAMLprim value
sdlmixer_paused_channel(value chn)
{
  if(Int_val(chn) < 0)
    invalid_argument("Sdlmixer.paused_channel");
  return Val_bool(Mix_Paused(Int_val(chn)));
}

CAMLprim value
sdlmixer_pause_music(void)
{
  Mix_PauseMusic();
  return Val_unit;
}

CAMLprim value
sdlmixer_resume_music(void)
{
  Mix_ResumeMusic();
  return Val_unit;
}

CAMLprim value
sdlmixer_rewind_music(void)
{
  Mix_RewindMusic();
  return Val_unit;
}

CAMLprim value
sdlmixer_paused_music(void)
{
  return Val_bool(Mix_PausedMusic());
}

CAMLprim value
sdlmixer_numplaying(value unit)
{
  return Val_int(Mix_Playing(-1));
}

CAMLprim value
sdlmixer_playing(value chn)
{
  if(Int_val(chn) < 0)
    invalid_argument("Sdlmixer.playing_channel");
  return Val_bool(Mix_Playing(Int_val(chn)));
}

CAMLprim value
sdlmixer_playing_music(void)
{
  return Val_bool(Mix_PlayingMusic());
}

CAMLprim value
sdlmixer_close_audio(value unit)
{
  Mix_CloseAudio();
  return Val_unit;
}

