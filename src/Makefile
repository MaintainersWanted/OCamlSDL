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

# $Id: Makefile,v 1.16 2002/09/24 22:34:54 oliv__a Exp $


include ../makefile.toplevel

INSTALL_DIR = $(DESTDIR)$(OCAMLSDLDIR)

MODULES = 	sdl sdlvideo sdlcdrom sdlevent sdltimer sdljoystick \
	        sdlkey sdlmouse sdlevent2 sdlvideo2 sdlwm

STUB_SRCS = 	$(MODULES:%=%_stub.c) common.c
STUB_OBJS =	$(STUB_SRCS:.c=$(OBJSUFFIX))

ML_SRCS =       $(MODULES:%=%.ml)

ML_OBJS	=	$(ML_SRCS:.ml=.cmo)
OPT_OBJS=	$(ML_SRCS:.ml=.cmx)

MLI	=	$(ML_SRCS:.ml=.mli) $(PARTS:%=sdl%.mli)
CMI	=	$(MLI:.mli=.cmi)

TOPLEVEL = 	toplevel
LIBRARY = 	sdl.cma
OLIBRARY = 	sdl.cmxa sdl.a

all: libs bin

bin:  $(TOPLEVEL)
libs:: $(LIBRARY) $(CLIBRARY) $(PARTS:%=sdl%.cma) $(PARTS:%=libsdl%stub.a)

ifdef CAMLDOC
doc : ../doc/html/index.html ../doc/ocamlsdl.texi
../doc/html/index.html : $(CMI)
	mkdir -p ../doc/html
	$(CAMLDOC) -d ../doc/html -html -v -t ocamlsdl $(MLI)
../doc/ocamlsdl.texi : $(CMI)
	$(CAMLDOC) -d ../doc -texi -v -o $@ -t ocamlsdl $(MLI)
else
doc : ; $(error "you need ocamldoc to generate the documentation")
endif

$(TOPLEVEL): $(LIBRARY) $(CLIBRARY) $(PARTS:%=sdl%.cma)
	$(CAMLTOP) -custom -I . -o $@ bigarray.cma $(LIBRARY) $(PARTS:%=sdl%.cma)

install:: all
	$(INSTALL) -d $(INSTALL_DIR)
	$(INSTALL) $(TOPLEVEL) $(INSTALL_DIR)
	$(INSTALL_DATA) *.cma lib*stub.a *.cmi *.mli $(INSTALL_DIR)

ifdef CAMLOPT
libs :: $(OLIBRARY) $(PARTS:%=sdl%.cmxa)

install :: 
	$(INSTALL_DATA) *.cmxa sdl*.a *.cmx $(INSTALL_DIR)
endif

ifdef CAMLMKLIB
# Use ocamlmklib: requires ocaml >= 3.04
CLIBRARY += dllsdlstub.so

$(LIBRARY): $(ML_OBJS)
	$(CAMLMKLIB) -o sdl -oc sdlstub $(LIBS) $^

sdlmixer.cma : sdlmixer.cmo
	$(CAMLMKLIB) -o sdlmixer -oc sdlmixerstub $(LIBS) -lSDL_mixer $^

libsdlmixerstub.a dllsdlmixerstub.so : sdlmixer_stub.o 
	$(CAMLMKLIB) -o sdlmixer -oc sdlmixerstub $(LIBS) -lSDL_mixer $^

sdlttf.cma : sdlttf.cmo
	$(CAMLMKLIB) -o sdlttf -oc sdlttfstub $(LIBS) -lSDL_ttf $^

libsdlttfstub.a dllsdlttfstub.so : sdlttf_stub.o
	$(CAMLMKLIB) -o sdlttf -oc sdlttfstub $(LIBS) -lSDL_ttf $^

sdlloader.cma : sdlloader.cmo sdlloader2.cmo
	$(CAMLMKLIB) -o sdlloader -oc sdlloaderstub $(LIBS) -lSDL_image $^

libsdlloaderstub.a dllsdlloaderstub.so : sdlloader_stub.o sdlloader2_stub.o
	$(CAMLMKLIB) -o sdlloader -oc sdlloaderstub $(LIBS) -lSDL_image $^

$(OLIBRARY): $(OPT_OBJS)
	$(CAMLMKLIB) -o sdl -oc sdlstub $(LIBS) $^

sdlmixer.cmxa : sdlmixer.cmx
	$(CAMLMKLIB) -o sdlmixer -oc sdlmixerstub $(LIBS) -lSDL_mixer $^

sdlttf.cmxa : sdlttf.cmx
	$(CAMLMKLIB) -o sdlttf -oc sdlttfstub $(LIBS) -lSDL_ttf $^

sdlloader.cmxa : sdlloader.cmx sdlloader2.cmx
	$(CAMLMKLIB) -o sdlloader -oc sdlloaderstub $(LIBS) -lSDL_image $^

$(CLIBRARY): $(STUB_OBJS)
	$(CAMLMKLIB) -o sdl -oc sdlstub $(LIBS) $^

install:: 
	-$(INSTALL) -d $(DESTDIR)$(CAMLLIBDIR)/stublibs
	-$(INSTALL) *.so $(DESTDIR)$(CAMLLIBDIR)/stublibs


else
# does not use ocamlmklib
$(LIBRARY): $(ML_OBJS)
$(LIBRARY): LIBS += -lsdlstub

$(OLIBRARY): $(OPT_OBJS)
$(OLIBRARY): LIBS += -lsdlstub

$(CLIBRARY): $(STUB_OBJS)

sdlmixer.cma  : sdlmixer.cmo
sdlmixer.cmxa : sdlmixer.cmx
sdlmixer.cma sdlmixer.cmxa : LIBS = -lsdlmixerstub -lSDL_mixer

sdlttf.cma  : sdlttf.cmo
sdlttf.cmxa : sdlttf.cmx
sdlttf.cma sdlttf.cmxa : LIBS = -lsdlttfstub -lSDL_ttf

sdlloader.cma  : sdlloader.cmo sdlloader2.cmo
sdlloader.cmxa : sdlloader.cmx sdlloader2.cmx
sdlloader.cma sdlloader.cmxa : LIBS = -lsdlloaderstub -lSDL_image

libsdlmixerstub.a dllsdlmixerstub.so   : sdlmixer_stub.o 
libsdlttfstub.a dllsdlttfstub.so       : sdlttf_stub.o
libsdlloaderstub.a dllsdlloaderstub.so : sdlloader_stub.o sdlloader2_stub.o
endif

uninstall:	
	-rm -Rf $(INSTALL_DIR)
	-rm -f $(CAMLLIBDIR)/stublibs/dllsdl*.so

distclean: clean
	rm -f .depend .depend.c *~

clean:
	rm -f *.cm* *.[oa] *.so $(TOPLEVEL)

depend: .depend .depend.c

.depend: $(wildcard *.ml *.mli)
	@echo "making deps..."
	@$(CAMLDEP) $^ > $@

.depend.c : $(wildcard *.c)
	@echo "making C deps..."
	@$(CC) $(CPPFLAGS) -I $(CAMLLIBDIR) -MM $^ > $@

.PHONY: all bin doc libs clean distclean depend install uninstall

-include .depend
-include .depend.c
