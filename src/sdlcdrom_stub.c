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

/* $Id: sdlcdrom_stub.c,v 1.1.1.1 2000/01/02 01:32:28 fbrunel Exp $ */

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <stdio.h>
#include <SDL.h>

/*
 * Define some error messages (not from SDL)
 */

#define ERRORMSG_BAD_CDROM_INDEX "Invalid CD-ROM drive index"
#define ERRORMSG_BAD_CDROM_TRACK "Invalid CD-ROM track number"

/*
 * Raise an OCaml exception with a message
 */

static void
sdlcdrom_raise_exception (char *msg)
{
  raise_with_string(*caml_named_value("SDLcdrom_exception"), msg);
}

/*
 * OCaml/C conversion functions
 */

value
sdlcdrom_get_num_drives (void)
{
  int num_of_drives = SDL_CDNumDrives();

  if (num_of_drives < 0) {
    sdlcdrom_raise_exception(SDL_GetError());
  }
    
  return Val_int(num_of_drives);
}

value
sdlcdrom_drive_name (value num_drive)
{
  int num_of_drives = Int_val(sdlcdrom_get_num_drives());
  int num = Int_val(num_drive);

  if (num >= num_of_drives) {
    sdlcdrom_raise_exception(ERRORMSG_BAD_CDROM_INDEX);
  }
  else if (SDL_CDName(num) == NULL) {
    sdlcdrom_raise_exception(SDL_GetError());
  }
  
  return copy_string(SDL_CDName(Int_val(num_drive)));;
}

value
sdlcdrom_open (value num_drive)
{
  SDL_CD *cdrom = SDL_CDOpen(Int_val(num_drive));

  if (cdrom == NULL) {
    sdlcdrom_raise_exception(SDL_GetError());
  }

  return (value)cdrom;
}

value
sdlcdrom_close (value cdrom)
{
  SDL_CDClose((SDL_CD *)cdrom);
  return Val_unit;
}

value
sdlcdrom_play_tracks (value cdrom, value start_track,
			value start_frame, int ntracks,
			int nframes)
{
  SDL_CD *cd = (SDL_CD *)cdrom;
  
  if (CD_INDRIVE(SDL_CDStatus(cd))) {
    SDL_CDPlayTracks(cd, Int_val(start_track), Int_val(start_frame),
		     Int_val(ntracks), Int_val(nframes));
  }

  return Val_unit;
}

value
sdlcdrom_pause (value cdrom)
{
  if (SDL_CDPause((SDL_CD *)cdrom) < 0) {
    sdlcdrom_raise_exception(SDL_GetError());
  }

  return Val_unit;
}

value
sdlcdrom_resume (value cdrom)
{
  if (SDL_CDResume((SDL_CD *)cdrom) < 0) {
    sdlcdrom_raise_exception(SDL_GetError());
  }

  return Val_unit;
}

value
sdlcdrom_stop (value cdrom)
{
  if (SDL_CDStop((SDL_CD *)cdrom) < 0) {
    sdlcdrom_raise_exception(SDL_GetError());
  }

  return Val_unit;
}

value
sdlcdrom_eject (value cdrom)
{
  if (SDL_CDEject((SDL_CD *)cdrom) < 0) {
    sdlcdrom_raise_exception(SDL_GetError());
  }

  return Val_unit;
}

value
sdlcdrom_status (value cdrom)
{
  SDL_CD *cd = (SDL_CD *)cdrom;
  CDstatus s = SDL_CDStatus(cd);

  /* Convert the C enum to the OCaml type:
   *
   * type cdrom_drive_status = 
   *     CD_TRAYEMPTY   0
   *   | CD_STOPPED     1
   *   | CD_PLAYING     2
   *   | CD_PAUSED      3
   *   | CD_ERROR       4
   */
  return s < 0 ? Val_int(4) : Val_int(s);
}

value
sdlcdrom_get_num_tracks (value cdrom)
{
  SDL_CD *cd = (SDL_CD *)cdrom;

  if (CD_INDRIVE(SDL_CDStatus(cd))) {
    return Val_int(cd->numtracks);
  }

  return Val_int(0);
}

value
sdlcdrom_track_num (value cdrom, value num)
{
  int track_num = Int_val(num);
  int num_tracks = Int_val(sdlcdrom_get_num_tracks(cdrom));
  SDL_CD *cd = (SDL_CD *)cdrom;
  
  if (track_num >= num_tracks) {
    sdlcdrom_raise_exception(ERRORMSG_BAD_CDROM_TRACK);
  }
  
  return (value)(cd->track + track_num);
}

value
sdlcdrom_track_length (value track)
{
  CAMLparam1(track);
  CAMLlocal1(result);
  SDL_CDtrack *tr = (SDL_CDtrack *)track;
  int min, sec, frame;
  
  FRAMES_TO_MSF(tr->length, &min, &sec, &frame);

  result = alloc(2, 0);
  Store_field(result, 0, Val_int(min));
  Store_field(result, 1, Val_int(sec));

  CAMLreturn result;
}

value
sdlcdrom_track_type (value track)
{
  SDL_CDtrack *tr = (SDL_CDtrack *)track;;
  return (tr->type == 0) ? Val_int(0) : Val_int(1);
}
