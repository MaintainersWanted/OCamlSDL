#
# OCamlSDL - An ML interface to the SDL library
# Copyright (C) 1999  Frederic Brunel
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

# $Id: Makefile,v 1.1 2000/01/02 01:32:24 fbrunel Exp $

CC = 		gcc
CFLAGS =	-Wall -O3 -pipe -pedantic -m486 
CAMLC =		ocamlc
CAMLOPT =	ocamlopt
CAMLTOP =	ocamlmktop
CAMLDEP =	ocamldep
MLFLAGS =

CLIBS =		-lm -lpthread -lSDL
MLLIBS =	-cclib -lpthread -cclib -lSDL
LIBDIR =
INCLUDES = 	-I/usr/local/include/SDL/ -I/usr/lib/ocaml/

C_OBJS = 	sdl_stub.o sdlcdrom_stub.o sdltimer_stub.o sdlvideo_stub.o
ML_OBJS	=	sdl.cmo sdlcdrom.cmo sdltimer.cmo sdlvideo.cmo

OBJS =		$(C_OBJS) $(ML_OBJS)

TOPLEVEL = toplevel

all: $(TOPLEVEL)

$(TOPLEVEL): $(OBJS)
	$(CAMLTOP) -custom -o $@ $(OBJS) $(MLLIBS)

.SUFFIXES:
.SUFFIXES: .c .o .ml .mli .cmo .cmi

%.cmo : %.ml
	$(CAMLC) -c $(MLFLAGS) $<

%.cmi : %.mli
	$(CAMLC) -c $(MLFLAGS) $<

%.o : %.c
	$(CC) $(INCLUDES) -o $@ -c $(CFLAGS) $<

distclean:
	rm -f $(TOPLEVEL) *.o *~ *.cm[iox] .depend

clean:
	rm -f *.o *~ *.cm[iox] .depend

depend:
	$(CAMLDEP) *.mli *.ml > .depend

.depend: 
	$(CAMLDEP) *.mli *.ml > .depend

include .depend
