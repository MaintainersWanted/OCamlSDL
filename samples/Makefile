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

# $Id: Makefile,v 1.13 2006/09/29 14:50:36 jboulnois Exp $


include ../makefile.platform
include ../makefile.config.$(OCAML_C_BACKEND)
include ../makefile.rules

LIB_DIR = ../src

MLINC += -I $(LIB_DIR)
MLFLAGS  += -w s
OMLFLAGS += -w s

SAMPLES = test_cdrom ocamlplayer \
          testalpha testjoystick ocamlsdl_logo checkkeys \
          showfont ocamlsdl_gfx
ifdef LABLGLDIR
SAMPLES += sdlgears
endif

all: $(addsuffix .test,$(SAMPLES))
opt: $(addsuffix .opt,$(SAMPLES))

event_loop.test event_loop.opt : EXTRA = ttf
example.test example.opt : EXTRA = ttf loader
ocamlplayer.test ocamlplayer.opt : EXTRA = mixer
ocamlsdl_logo.test ocamlsdl_logo.opt : EXTRA = loader
ocamlsdl_gfx.test ocamlsdl_gfx.opt : EXTRA = loader gfx
ocamlsdl_logo2.test ocamlsdl_logo2.opt : EXTRA = loader
showfont.test showfont.opt : EXTRA = ttf
sdlgears.test sdlgears.opt : MLINC+=-I $(LABLGLDIR)



sdlgears.test : sdlgears.ml
	$(OCAMLC) -o $@ $(MLINC) -dllpath $(LIB_DIR) bigarray.cma lablgl.cma sdl.cma $<

sdlgears.opt : sdlgears.ml
	$(OCAMLOPT) -o $@ $(MLINC) bigarray.cmxa lablgl.cmxa sdl.cmxa $<

%.test : %.cmo
	$(OCAMLC) -o $@ $(MLINC) -dllpath $(LIB_DIR) bigarray.cma sdl.cma $(EXTRA:%=sdl%.cma) $<

%.opt : %.cmx
	$(OCAMLOPT) -o $@ $(MLINC) bigarray.cmxa sdl.cmxa $(EXTRA:%=sdl%.cmxa) $<

distclean: clean
	rm -f .depend *~

clean:
	rm -f *.cm* *.o *.a *.so *.opt *.test

depend: .depend

.depend: $(SAMPLES:%=%.ml)
	@$(OCAMLDEP) $(MLINC) $^ > $@

.PHONY: all opt clean distclean depend

-include .depend
