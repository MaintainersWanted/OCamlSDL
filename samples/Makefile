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

# $Id: Makefile,v 1.9 2003/01/05 09:43:24 oliv__a Exp $


include ../makefile.toplevel

LIB_DIR = ../src

MLFLAGS  += -w s -I $(LIB_DIR)
OMLFLAGS += -w s -I $(LIB_DIR)

SAMPLES = test_cdrom ocamlplayer event_loop \
          testalpha testjoystick ocamlsdl_logo checkkeys \
          showfont
ifdef LABLGLDIR
SAMPLES +=  sdlgears
endif

all: $(addsuffix .test,$(SAMPLES))
opt: $(addsuffix .opt,$(SAMPLES))

event_loop.test event_loop.opt : EXTRA = ttf
example.test example.opt : EXTRA = ttf loader
ocamlplayer.test ocamlplayer.opt : EXTRA = mixer
ocamlsdl_logo.test ocamlsdl_logo.opt : EXTRA = loader
ocamlsdl_logo2.test ocamlsdl_logo2.opt : EXTRA = loader
showfont.test showfont.opt : EXTRA = ttf

sdlgears.test : sdlgears.ml
	$(CAMLC) -o $@ -I $(LIB_DIR) -I $(LABLGLDIR) -dllpath $(LIB_DIR) bigarray.cma lablgl.cma sdl.cma $<

sdlgears.opt : sdlgears.ml
	$(CAMLOPT) -o $@ -I $(LIB_DIR) -I $(LABLGLDIR) bigarray.cmxa lablgl.cmxa sdl.cmxa $<

%.test : %.cmo
	$(CAMLC) -o $@ -I $(LIB_DIR) -dllpath $(LIB_DIR) bigarray.cma sdl.cma $(EXTRA:%=sdl%.cma) $<

%.opt : %.cmx
	$(CAMLOPT) -o $@ -I $(LIB_DIR) bigarray.cmxa sdl.cmxa $(EXTRA:%=sdl%.cmxa) $<

distclean: clean
	rm -f .depend *~

clean:
	rm -f *.cm* *.[oa] *.so *.opt *.test

depend: .depend

.depend: $(SAMPLES:%=%.ml)
	@$(CAMLDEP) -I $(LIB_DIR) $^ > $@

.PHONY: all opt clean distclean depend

-include .depend
