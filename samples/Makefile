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

# $Id: Makefile,v 1.4 2002/08/28 13:38:14 xtrm Exp $


include ../makefile.toplevel

LIB_DIR = ../src

MLFLAGS  += -w s -I $(LIB_DIR)
OMLFLAGS += -w s -I $(LIB_DIR)

SAMPLES = test_cdrom example ocamlplayer event_loop \
          testalpha testjoystick ocamlsdl_logo

all: $(addsuffix .test,$(SAMPLES))
opt: $(addsuffix .opt,$(SAMPLES))

%.test : %.cmo
	$(CAMLC) -o $@ -I $(LIB_DIR) bigarray.cma sdl.cma $<

%.opt : %.cmx
	$(CAMLOPT) -o $@ -I $(LIB_DIR) bigarray.cmxa sdl.cmxa $<

distclean: clean
	rm -f .depend *~

clean:
	rm -f *.cm* *.[oa] *.so *.opt *.test

depend: .depend

.depend: $(ML_SRCS) $(MLI)
	@$(CAMLDEP) $^ > $@

.PHONY: all opt clean distclean depend

-include .depend
