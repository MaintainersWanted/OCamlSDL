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
# MERCHANTABILTY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

# $Id: Makefile,v 1.12 2002/09/04 17:46:32 oliv__a Exp $


include ../makefile.toplevel

INSTALL_DIR = $(DESTDIR)$(OCAMLSDLDIR)

MODULES = 	sdl sdlvideo sdlcdrom sdlevent sdltimer sdljoystick \
	        sdlkey sdlmouse sdlevent2 sdlvideo2 sdlwm \
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
libs:: $(LIBRARY) $(CLIBRARY) 

ifdef CAMLDOC
doc : ../doc/html/index.html
../doc/html/index.html : $(MLI)
	mkdir -p ../doc/html
	$(CAMLDOC) -d ../doc/html -html -v -t ocamlsdl $^
else
doc : ; $(error "you need ocamldoc to generate the documentation")
endif

$(TOPLEVEL): $(LIBRARY) $(CLIBRARY)
	$(CAMLTOP) -custom -I . -o $@ bigarray.cma $(LIBRARY)

install:: all
	$(INSTALL) -d $(INSTALL_DIR)
	$(INSTALL) $(TOPLEVEL) $(INSTALL_DIR)
	$(INSTALL_DATA) $(LIBRARY) $(CLIBRARY) $(CMI) $(INSTALL_DIR)
	$(INSTALL_DATA) $(MLI) $(INSTALL_DIR)

ifdef CAMLOPT
libs :: $(OLIBRARY)

install :: 
	$(INSTALL_DATA) $(OLIBRARY) sdl.a $(INSTALL_DIR)
	$(INSTALL_DATA) $(OPT_OBJS) $(INSTALL_DIR)
endif

ifdef CAMLMKLIB
# Use ocamlmklib: requires ocaml >= 3.04
CLIBRARY += dllsdlstub.so

$(LIBRARY): $(ML_OBJS)
	$(CAMLMKLIB) -o sdl -oc sdlstub $(filter -l% -L%,$(LIBS)) $^

$(OLIBRARY): $(OPT_OBJS)
	$(CAMLMKLIB) -o sdl -oc sdlstub $(filter -l% -L%,$(LIBS)) $^

$(CLIBRARY): $(STUB_OBJS)
	$(CAMLMKLIB) -o sdl -oc sdlstub $(filter -l% -L%,$(LIBS)) $^

install:: dllsdlstub.so
	-$(INSTALL) -d $(DESTDIR)$(CAMLLIBDIR)/shlibs
	-ln -sf $(OCAMLSDLDIR)/$< $(DESTDIR)$(CAMLLIBDIR)/shlibs

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
	rm -f .depend .depend.c *~

clean:
	rm -f *.cm* *.[oa] *.so $(TOPLEVEL)

depend: .depend .depend.c

.depend: $(ML_SRCS) $(MLI)
	@echo "making deps..."
	@$(CAMLDEP) $^ > $@

.depend.c : $(STUB_SRCS)
	@echo "making C deps..."
	@$(CC) $(CPPFLAGS) -I $(CAMLLIBDIR) -MM $^ > $@

.PHONY: all bin doc libs clean distclean depend install uninstall

-include .depend
-include .depend.c
