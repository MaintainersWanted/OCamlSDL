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

# $Id: Makefile,v 1.2 2002/06/04 23:17:09 oliv__a Exp $


include ../makefile.toplevel

INSTALL_DIR = $(DESTDIR)$(OCAMLSDLDIR)

MODULES = 	sdl sdlvideo sdlcdrom sdlevent sdltimer \
                $(addprefix sdl,$(PARTS))

STUB_SRCS = 	$(addsuffix _stub.c,$(MODULES)) common.c
STUB_OBJS =	$(STUB_SRCS:.c=.o)

ML_SRCS =       $(addsuffix .ml,$(MODULES))
ML_OBJS	=	$(ML_SRCS:.ml=.cmo)
OPT_OBJS=	$(ML_SRCS:.ml=.cmx)
MLI	=	$(ML_SRCS:.ml=.mli)
CMI	=	$(ML_SRCS:.ml=.cmi)

TOPLEVEL = 	toplevel
LIBRARY = 	sdl.cma
OLIBRARY = 	sdl.cmxa
CLIBRARY = 	libsdlstub.a 

all: libs bin

bin:  $(TOPLEVEL)
libs: $(LIBRARY) $(OLIBRARY) $(CLIBRARY) 

$(TOPLEVEL): $(LIBRARY) $(CLIBRARY)
	$(CAMLTOP) -custom -I . -o $@ bigarray.cma $(LIBRARY)

install:: all
	$(INSTALL) -d $(INSTALL_DIR)
	$(INSTALL) $(TOPLEVEL) $(INSTALL_DIR)
	$(INSTALL_DATA) $(LIBRARY) $(OLIBRARY) $(CLIBRARY) $(CMI) $(INSTALL_DIR)
	$(INSTALL_DATA) $(OPT_OBJS) $(INSTALL_DIR)
	$(INSTALL_DATA) $(MLI) $(INSTALL_DIR)

ifdef CAMLMKLIB
# Use ocamlmklib: requires ocaml >= 3.04
CLIBRARY += dllsdlstub.so

$(LIBRARY): $(ML_OBJS)
	$(CAMLMKLIB) -v -o sdl -oc sdlstub $(LIBS) $^

$(OLIBRARY): $(OPT_OBJS)
	$(CAMLMKLIB) -v -o sdl -oc sdlstub $(LIBS) $^

$(CLIBRARY): $(STUB_OBJS)
	$(CAMLMKLIB) -v -o sdl -oc sdlstub $(LIBS) $^

install:: dllsdlstub.so
	$(INSTALL) $^ $(INSTALL_DIR)
	-$(INSTALL) -d $(DESTDIR)$(CAMLLIBDIR)/shlibs
	-ln -s $(OCAMLSDLDIR)/$< $(DESTDIR)$(CAMLLIBDIR)/shlibs

else
$(LIBRARY): $(ML_OBJS)
	$(CAMLC) -o $@ -a -custom $(CLIBS) $(MLLDFLAGS) -cclib -lsdlstub $^

$(OLIBRARY): $(OPT_OBJS)
	$(CAMLOPT) -o $@ -a $(CLIBS) $(MLLDFLAGS) -cclib -lsdlstub $^

$(CLIBRARY): $(STUB_OBJS)
	ar cruvs $@ $^

endif

uninstall:	
	rm -Rf $(INSTALL_DIR)

distclean: clean
	rm -f .depend *~

clean:
	rm -f *.cm* *.[oa] *.so $(TOPLEVEL)

depend: .depend

.depend: $(ML_SRCS) $(MLI)
	@$(CAMLDEP) $^ > $@

.PHONY: all bin libs clean distclean depend install uninstall

-include .depend
