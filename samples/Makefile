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

# $Id: Makefile,v 1.2 2002/08/13 14:46:45 xtrm Exp $


include ../makefile.toplevel

LIB_DIR =	../src

MLFLAGS  += -w s -I $(LIB_DIR)
OMLFLAGS += -w s -I $(LIB_DIR)

LIBRARY = 	$(LIB_DIR)/sdl.cma
OLIBRARY = 	$(LIB_DIR)/sdl.cmxa
CLIBRARY = 	$(LIB_DIR)/libsdlstub.a

SAMPLES = test_cdrom example ocamlplayer event_loop


all: $(SAMPLES)

test_cdrom: test_cdrom.cmx $(CLIBRARY) $(OLIBRARY)
	$(CAMLOPT) -o $@ -I $(LIB_DIR) bigarray.cmxa sdl.cmxa $<

example: example.cmx $(CLIBRARY) $(OLIBRARY)
	$(CAMLOPT) -o $@ -I $(LIB_DIR) bigarray.cmxa sdl.cmxa $<

ocamlplayer: ocamlplayer.cmx $(CLIBRARY) $(OLIBRARY)
	$(CAMLOPT) -o $@ -I $(LIB_DIR) bigarray.cmxa sdl.cmxa $<

event_loop: event_loop.cmx $(CLIBRARY) $(OLIBRARY)
	$(CAMLOPT) -o $@ -I $(LIB_DIR) bigarray.cmxa sdl.cmxa $<

%.cmo : %.ml
	$(CAMLC) -c $(MLFLAGS) $<

%.cmx : %.ml
	$(CAMLOPT) -c $(OMLFLAGS) $<

%.cmi : %.mli
	$(CAMLC) -c $(MLFLAGS) $<

%.o : %.c
	$(CAMLC) -c -ccopt "$(CFLAGS)" $<

distclean: clean
	rm -f .depend *~

clean:
	rm -f *.cm* *.[oa] *.so $(SAMPLES)

depend: .depend

.depend: $(ML_SRCS) $(MLI)
	@$(CAMLDEP) $^ > $@

.PHONY: all clean distclean depend

-include .depend
