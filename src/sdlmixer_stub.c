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

/* $Id: sdlmixer_stub.c,v 1.12 2002/06/26 15:24:55 xtrm Exp $ */

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <stdio.h>
#include <string.h>

#include <SDL.h>
#include <SDL_mixer.h>


#include "common.h"


static value arg_string;
static value music_finished;

/*
 * Conversion macros
 */

#define MAGIC_OF_OPTION(opt)\
   ((opt) == Val_unit ? -1 : Int_val(Field((opt),0)))

/*
 * Raise an OCaml exception with a message
 */

static void
sdlmixer_raise_exception (char *msg)
{
  raise_with_string(*caml_named_value("SDLmixer_exception"), msg);
}

/*
 * Stub initialization
 */

void
sdlmixer_stub_init()
{
  register_global_root(&arg_string);
  register_global_root(&music_finished);
}

/*
 * Stub shutdown
 */

void
sdlmixer_stub_kill()
{
  remove_global_root(&arg_string);
  remove_global_root(&music_finished);
}

/*
 * OCaml/C conversion functions
 */

value
sdlmixer_open_audio(value frequency, value format, 
		    value chunksize, value channels)
{
  static const int format_of_val[] = { 
    MIX_DEFAULT_FORMAT, 
    AUDIO_U8, AUDIO_S8, 
    AUDIO_U16, AUDIO_S16, } ;
  int ret;
  int mstr = 1;
  int c_format = format_of_val[Int_val(format)];
  int c_chunksize = Opt_arg(chunksize, Int_val, 4096);

  if (Int_val (channels) == 1) mstr = 2;

  ret = Mix_OpenAudio(Int_val(frequency), c_format, mstr, Int_val(chunksize));

  if (ret == -1)
    sdlmixer_raise_exception(Mix_GetError());

  return Val_unit;
}

value
sdlmixer_allocate_channels(value channels)
{
  return Val_int(Mix_AllocateChannels(Int_val(channels)));
}

value
sdlmixer_query_specs(void)
{
  CAMLparam0();
  CAMLlocal2(result, query);
  int freq, chan, ret;
  unsigned short form;

  ret = Mix_QuerySpec(&freq, &form, &chan);
  /* return None */
  
  if (ret == 0) {
    result = Val_int(0);
  }
  else {
    int ml_format = 0;
    switch (form)
      {
      case AUDIO_U8:
	ml_format = 1;
	break;
	
      case AUDIO_S8:
	ml_format = 2;
	break;
	
      case AUDIO_U16LSB:
      case AUDIO_U16MSB:
	ml_format = 3;
	break;
	
      case AUDIO_S16LSB:
      case AUDIO_S16MSB:
	ml_format = 4;
	break;
      }

    result = alloc(1, 0);
    query = alloc_tuple(3);
    Store_field(query, 0, Val_int(freq));
    Store_field(query, 1, Val_int(ml_format));
    Store_field(query, 2, Val_int(chan-1));
    Store_field(result, 0, query);
  }
  
  CAMLreturn(result);      
}

value
sdlmixer_loadWAV(value fname)
{
  Mix_Chunk *chunk;
  chunk = Mix_LoadWAV(&Byte(fname,0));
  if (chunk == NULL) sdlmixer_raise_exception(Mix_GetError());
  return (value)chunk;
}

value
sdlmixer_loadMUS(value fname)
{
  Mix_Music *chunk;
  chunk = Mix_LoadMUS(&Byte(fname,0));

  if (chunk == NULL)
    sdlmixer_raise_exception(Mix_GetError());

  return (value)chunk;
}

value
sdlmixer_load_string(value data)
{
  Mix_Chunk *chunk;
  chunk = Mix_QuickLoad_WAV(&Byte(data,0));

  if (chunk == NULL)
    sdlmixer_raise_exception(Mix_GetError());

  return (value)chunk;
}

value
sdlmixer_free_chunk(value chunk)
{
  Mix_FreeChunk((Mix_Chunk *)chunk);
  return Val_unit;
}

value
sdlmixer_free_music(value chunk)
{
  Mix_FreeMusic((Mix_Music *)chunk);
  return Val_unit;
}

void
sdlmixer_data_hook(void *udata, Uint8 *stream, int len)
{
  arg_string = alloc_string(len);
  memcpy(&Byte(arg_string,0), stream, len);
  callback((value)udata, arg_string);
  arg_string = Val_unit;
}

void
sdlmixer_music_finished_hook(void)
{
  if (music_finished != Val_unit)
    callback(music_finished, Val_unit);
}

value
sdlmixer_set_postmix(value cb)
{
  Mix_SetPostMix(sdlmixer_data_hook, (void *)cb);
  return Val_unit;
}

value
sdlmixer_set_music(value cb)
{
  Mix_HookMusic(sdlmixer_data_hook, (void *)cb);
  return Val_unit;
}

value
sdlmixer_set_music_finished(value cb)
{
  music_finished = cb;
  Mix_HookMusicFinished(sdlmixer_music_finished_hook);
  return Val_unit;
}

value
sdlmixer_reserve_channels(value num)
{
  return Val_int(Mix_ReserveChannels(Int_val(num)));
}

value
sdlmixer_group_channel(value chn, value grp)
{
  int res;
  res = Mix_GroupChannel(Int_val(chn), MAGIC_OF_OPTION(grp));

  if (res == -1)
    sdlmixer_raise_exception(Mix_GetError());
  
  return Val_unit;
}

value
sdlmixer_group_available(value grp)
{
  return Val_int(Mix_GroupAvailable(Int_val(grp)));
}

value
sdlmixer_group_count(value grp)
{
  return Val_int(Mix_GroupCount(Int_val(grp)));
}

value
sdlmixer_group_oldest(value grp)
{
  return Val_int(Mix_GroupOldest(Int_val(grp)));
}

value
sdlmixer_group_newer(value grp)
{
  return Val_int(Mix_GroupNewer(Int_val(grp)));
}

value
sdlmixer_play_channel_timed(value chn, value sound, value loops, value tme)
{
  int t;
  if (Int_val(tme) == 0) t = -1;
  else t = (int)(1000.0 * Double_val(Field(tme,0)));
  return Val_int(Mix_PlayChannelTimed(MAGIC_OF_OPTION(chn), (Mix_Chunk *)sound,
				      MAGIC_OF_OPTION(loops)-1, t));
}

value
sdlmixer_play_music(value music, value loops)
{
  return Val_int(Mix_PlayMusic((Mix_Music *)music, MAGIC_OF_OPTION(loops)));
}

value
sdlmixer_fadein_music(value music, value loops, value tme)
{
  int t;
  if (Int_val(tme) == 0) t = -1;
  else t = (int)(1000.0 * Double_val(Field(tme,0)));
  return Val_int(Mix_FadeInMusic((Mix_Music *)music,
				 MAGIC_OF_OPTION(loops),t));
}

value
sdlmixer_fadein_channel(value chn, value chunk, value loops, value tme1,
			value tme2)
{
  int t1, t2;
  if (Int_val(tme1) == 0) t1 = -1;
  else t1 = (int)(1000.0 * Double_val(Field(tme1,0)));
  if (Int_val(tme2) == 0) t2 = -1;
  else t2 = (int)(1000.0 * Double_val(Field(tme2,0)));
  return Val_int(Mix_FadeInChannelTimed(MAGIC_OF_OPTION(chn), (Mix_Chunk *)chunk,
					MAGIC_OF_OPTION(loops)-1, t1, t2));
}

value
sdlmixer_volume_channel(value chn)
{
  return copy_double(Mix_Volume(MAGIC_OF_OPTION(chn), -1) / 128.0);
}

value
sdlmixer_volume_chunk(value chunk)
{
  return copy_double(Mix_VolumeChunk((Mix_Chunk *)chunk, -1) / 128.0);
}

value
sdlmixer_volume_music(value unit)
{
  return copy_double(Mix_VolumeMusic(-1) / 128.0);
}

value
sdlmixer_setvolume_channel(value chn, value vol)
{
  Mix_Volume(MAGIC_OF_OPTION(chn), (int)(Double_val(vol)*128.0));
  return Val_unit;
}

value
sdlmixer_setvolume_chunk(value chunk, value vol)
{
  Mix_VolumeChunk((Mix_Chunk *)chunk, (int)(Double_val(vol)*128.0));
  return Val_unit;
}

value
sdlmixer_setvolume_music(value vol)
{
  Mix_VolumeMusic((int)(Double_val(vol)*128.0));
  return Val_unit;
}

value
sdlmixer_halt_channel(value chn)
{
  Mix_HaltChannel(Int_val(chn));
  return Val_unit;
}

value
sdlmixer_halt_group(value grp)
{
  Mix_HaltGroup(Int_val(grp));
  return Val_unit;
}

value
sdlmixer_halt_music(void)
{
  Mix_HaltMusic();
  return Val_unit;
}

value
sdlmixer_expire_channel(value chn, value tme)
{
  int t;
  if (Int_val(tme) == 0) t = -1;
  else t = (int)(1000.0 * Double_val(Field(tme,0)));
  Mix_ExpireChannel(Int_val(chn), t);
  return Val_unit;
}

value
sdlmixer_fadeout_channel(value chn, value ms)
{
  Mix_FadeOutChannel(Int_val(chn), 1000.0 * Double_val(ms));
  return Val_unit;
}

value
sdlmixer_fadeout_group(value grp, value ms)
{
  Mix_FadeOutGroup(Int_val(grp), 1000.0 * Double_val(ms));
  return Val_unit;
}

value
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
  
  return Int_val(conv);
}

value
sdlmixer_fading_music(void)
{
  Mix_Fading f;
  f = Mix_FadingMusic();
  return convert_fading_status(f);
}

value
sdlmixer_fading_channel(value chn)
{
  Mix_Fading f;
  f = Mix_FadingChannel(Int_val(chn));
  return convert_fading_status(f);
}

value
sdlmixer_pause_channel(value chn)
{
  Mix_Pause(Int_val(chn));
  return Val_unit;
}

value
sdlmixer_resume_channel(value chn)
{
  Mix_Resume(Int_val(chn));
  return Val_unit;
}

value
sdlmixer_paused_channel(value chn)
{
  return Val_bool(Mix_Paused(Int_val(chn)));
}

value
sdlmixer_pause_music(void)
{
  Mix_PauseMusic();
  return Val_unit;
}

value
sdlmixer_resume_music(void)
{
  Mix_ResumeMusic();
  return Val_unit;
}

value
sdlmixer_rewind_music(void)
{
  Mix_RewindMusic();
  return Val_unit;
}

value
sdlmixer_paused_music(void)
{
  return Val_bool(Mix_PausedMusic());
}

value
sdlmixer_playing(value chn)
{
  return Val_bool(Mix_Playing(MAGIC_OF_OPTION(chn)));
}

value
sdlmixer_playing_music(void)
{
  return Val_bool(Mix_PlayingMusic());
}

value
sdlmixer_close_audio(void)
{
  Mix_CloseAudio();
  return Val_unit;
}
