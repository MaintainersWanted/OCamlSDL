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

/* $Id: sdlcdrom_stub.c,v 1.13 2002/11/21 11:01:14 oliv__a Exp $ */

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>

#include <stdio.h>

#include <SDL.h>

#include "common.h"

#ifdef __GNUC__ /* typechecked macro */
#define Val_CDROM(p)  ( { SDL_CD *_mlsdl__cd = p; \
                          abstract_ptr(_mlsdl__cd); } )
#else
#define Val_CDROM(p)  abstract_ptr(p);
#endif
#define CDROM_val(v)  ((SDL_CD *)(Field(v, 0)))

/*
 * Raise an OCaml exception with a message
 */

static void
sdlcdrom_raise_exception (char *msg)
{
  static value *cdrom_exn = NULL;
  if(! cdrom_exn)
    cdrom_exn = caml_named_value("SDLcdrom_exception");
  raise_with_string(*cdrom_exn, msg);
}

static void
sdlcdrom_raise_nocd ()
{
  static value *cdrom_exn = NULL;
  if(! cdrom_exn)
    cdrom_exn = caml_named_value("SDLcdrom_nocd");
  raise_constant(*cdrom_exn);
}

/*
 * OCaml/C conversion functions
 */

CAMLprim value
sdlcdrom_get_num_drives (value unit)
{
  int num_of_drives = SDL_CDNumDrives();

  if (num_of_drives < 0) {
    sdlcdrom_raise_exception(SDL_GetError());
  }
    
  return Val_int(num_of_drives);
}

CAMLprim value
sdlcdrom_drive_name (value num_drive)
{
  const char *name = SDL_CDName(Int_val(num_drive));
  if (name == NULL)
    sdlcdrom_raise_exception(SDL_GetError());
  
  return copy_string((char *)name);
}

CAMLprim value
sdlcdrom_open (value num_drive)
{
  SDL_CD *cdrom = SDL_CDOpen(Int_val(num_drive));

  if (cdrom == NULL) {
    sdlcdrom_raise_exception(SDL_GetError());
  }

  return Val_CDROM(cdrom);
}

CAMLprim value
sdlcdrom_close (value cdrom)
{
  SDL_CDClose(CDROM_val(cdrom));
  CDROM_val(cdrom) = NULL;
  return Val_unit;
}

CAMLprim value
sdlcdrom_play_tracks (value cdrom, value start_track,
		      value start_frame, value ntracks,
		      value nframes)
{
  SDL_CD *cd = CDROM_val(cdrom);
  
  if (CD_INDRIVE(SDL_CDStatus(cd))) {
    SDL_CDPlayTracks(cd, Int_val(start_track), Int_val(start_frame),
		     Int_val(ntracks), Int_val(nframes));
  }
  else
    sdlcdrom_raise_nocd();
  
  return Val_unit;
}

CAMLprim value
sdlcdrom_pause (value cdrom)
{
  if (SDL_CDPause(CDROM_val(cdrom)) < 0) {
    sdlcdrom_raise_exception(SDL_GetError());
  }

  return Val_unit;
}

CAMLprim value
sdlcdrom_resume (value cdrom)
{
  if (SDL_CDResume(CDROM_val(cdrom)) < 0) {
    sdlcdrom_raise_exception(SDL_GetError());
  }

  return Val_unit;
}

CAMLprim value
sdlcdrom_stop (value cdrom)
{
  if (SDL_CDStop(CDROM_val(cdrom)) < 0) {
    sdlcdrom_raise_exception(SDL_GetError());
  }

  return Val_unit;
}

CAMLprim value
sdlcdrom_eject (value cdrom)
{
  if (SDL_CDEject(CDROM_val(cdrom)) < 0) {
    sdlcdrom_raise_exception(SDL_GetError());
  }

  return Val_unit;
}

CAMLprim value
sdlcdrom_status (value cdrom)
{
  int v=0;
  switch (SDL_CDStatus(CDROM_val(cdrom))) {
  case CD_TRAYEMPTY : v=0; break;
  case CD_STOPPED   : v=1; break;
  case CD_PLAYING   : v=2; break;
  case CD_PAUSED    : v=3; break;
  case CD_ERROR     : sdlcdrom_raise_exception(SDL_GetError());
  }
  return Val_int(v);
}

CAMLprim value 
sdlcdrom_info(value cdrom)
{
  SDL_CD *cd = CDROM_val(cdrom);
  CDstatus status = SDL_CDStatus(cd);

  switch( SDL_CDStatus(cd) ) {
  case CD_TRAYEMPTY : sdlcdrom_raise_nocd ();
  case CD_ERROR     : sdlcdrom_raise_exception(SDL_GetError());
  default: break;
  } 
  { 
    CAMLparam0();
    CAMLlocal3(v, a, t);
    int i;
    a = alloc(cd->numtracks, 0);
    for(i=0; i<cd->numtracks; i++) {
      SDL_CDtrack tr = cd->track[i];
      t = alloc_small(4, 0);
      Field(t, 0) = Val_int(tr.id) ;
      if(tr.type == SDL_AUDIO_TRACK)
	Field(t, 1) = Val_int(0) ;
      else
  	Field(t, 1) = Val_int(1) ;
      Field(t, 2) = Val_int(tr.length);
      Field(t, 3) = Val_int(tr.offset);
      Store_field(a, i, t);
    }
    v = alloc_small(4, 0);
    Field(v, 0) = Val_int(cd->numtracks);
    Field(v, 1) = Val_int(cd->cur_track);
    Field(v, 2) = Val_int(cd->cur_frame);
    Field(v, 3) = a;
    CAMLreturn(v);
  }
}
