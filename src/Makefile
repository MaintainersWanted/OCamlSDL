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

# $Id: Makefile,v 1.24 2004/01/31 09:15:50 smkl Exp $


include ../makefile.toplevel

INSTALL_DIR = $(DESTDIR)$(OCAMLSDLDIR)

MODULES = 	sdl sdlcdrom sdltimer sdljoystick \
	        sdlkey sdlmouse sdlevent sdlvideo sdlwm \
                $(if $(LABLGLDIR),sdlgl)

STUB_SRCS = 	$(MODULES:%=%_stub.c) common.c sdlrwops_stub.c
STUB_OBJS =	$(STUB_SRCS:.c=$(OBJSUFFIX))

ML_SRCS =       $(MODULES:%=%.ml)

ML_OBJS	=	$(ML_SRCS:.ml=.cmo)
OPT_OBJS=	$(ML_SRCS:.ml=.cmx)

MLI	=	$(ML_SRCS:.ml=.mli) $(PARTS:%=sdl%.mli)
CMI	=	$(MLI:.mli=.cmi)

TOPLEVEL = 	toplevel
LIBRARY = 	sdl.cma
OLIBRARY = 	sdl.cmxa sdl$(LIBSUFFIX)

all:: libs 

ifdef CYGWIN
libs:: libmlsdl_main.a
libmlsdl_main.a : mlsdl_main.o
else
all:: bin
endif	

bin:  $(TOPLEVEL)
libs:: $(LIBRARY) $(CLIBRARY) $(PARTS:%=sdl%.cma) $(PARTS:%=libsdl%stub$(LIBSUFFIX))

ifdef CAMLDOC
LABLGLINC = $(if $(LABLGLDIR),-I $(LABLGLDIR))
doc : ../doc/html/index.html ../doc/ocamlsdl.texi
../doc/html/index.html : $(CMI)
	mkdir -p ../doc/html
	$(CAMLDOC) -d ../doc/html -html -v -t ocamlsdl $(LABLGLINC) $(MLI)
../doc/ocamlsdl.texi : $(CMI)
	$(CAMLDOC) -d ../doc -texi -v -o $@ -t ocamlsdl $(LABLGLINC) $(MLI)
else
doc : ; $(error "you need ocamldoc to generate the documentation")
endif

$(TOPLEVEL): $(LIBRARY) $(CLIBRARY) $(PARTS:%=sdl%.cma)
	$(CAMLTOP) -custom -I . -o $@ bigarray.cma $(LIBRARY) $(PARTS:%=sdl%.cma)

install:: all
	$(INSTALL) -d $(INSTALL_DIR)
	test -f $(TOPLEVEL) && $(INSTALL) $(TOPLEVEL) $(INSTALL_DIR) || :
	$(INSTALL_DATA) *.cma lib*$(LIBSUFFIX) *.cmi *.mli $(INSTALL_DIR)

ifdef CAMLOPT
libs :: $(OLIBRARY) $(PARTS:%=sdl%.cmxa)

install :: 
	$(INSTALL_DATA) *.cmxa sdl*$(LIBSUFFIX) *.cmx $(INSTALL_DIR)
endif

sdlgl.cmo : MLFLAGS+=  -I $(LABLGLDIR)
sdlgl.cmi : MLFLAGS+=  -I $(LABLGLDIR)
sdlgl.cmx : OMLFLAGS+= -I $(LABLGLDIR)

ifdef CAMLMKLIB
# Use ocamlmklib: requires ocaml >= 3.04
CLIBRARY += dllsdlstub.so

$(LIBRARY): $(ML_OBJS)
	$(CAMLMKLIB) -o sdl -oc sdlstub $(LIBS) $^

sdlmixer.cma : sdlmixer.cmo
	$(CAMLMKLIB) -o sdlmixer -oc sdlmixerstub $(LIBS) $(SDLMIXERLIB) $^

libsdlmixerstub.a dllsdlmixerstub.so : sdlmixer_stub.o 
	$(CAMLMKLIB) -o sdlmixer -oc sdlmixerstub $(LIBS) $(SDLMIXERLIB) $^

sdlttf.cma : sdlttf.cmo
	$(CAMLMKLIB) -o sdlttf -oc sdlttfstub $(LIBS) $(SDLTTFLIB) $^

libsdlttfstub.a dllsdlttfstub.so : sdlttf_stub.o
	$(CAMLMKLIB) -o sdlttf -oc sdlttfstub $(LIBS) $(SDLTTFLIB) $^

sdlloader.cma : sdlloader.cmo 
	$(CAMLMKLIB) -o sdlloader -oc sdlloaderstub $(LIBS) $(SDLLOADERLIB) $^

libsdlloaderstub.a dllsdlloaderstub.so : sdlloader_stub.o 
	$(CAMLMKLIB) -o sdlloader -oc sdlloaderstub $(LIBS) $(SDLLOADERLIB) $^

$(OLIBRARY): $(OPT_OBJS)
	$(CAMLMKLIB) -o sdl -oc sdlstub $(LIBS) $^

sdlmixer.cmxa : sdlmixer.cmx
	$(CAMLMKLIB) -o sdlmixer -oc sdlmixerstub $(LIBS) $(SDLMIXERLIB) $^

sdlttf.cmxa : sdlttf.cmx
	$(CAMLMKLIB) -o sdlttf -oc sdlttfstub $(LIBS) $(SDLTTFLIB) $^

sdlloader.cmxa : sdlloader.cmx 
	$(CAMLMKLIB) -o sdlloader -oc sdlloaderstub $(LIBS) $(SDLLOADERLIB) $^

$(CLIBRARY): $(STUB_OBJS)
	$(CAMLMKLIB) -o sdl -oc sdlstub $(LIBS) $^

install:: 
	-$(INSTALL) -d $(DESTDIR)$(CAMLLIBDIR)/stublibs
	-$(INSTALL) *.so $(DESTDIR)$(CAMLLIBDIR)/stublibs


else
# does not use ocamlmklib
$(LIBRARY): $(ML_OBJS)
	$(OCAMLC) -a -o $(LIBRARY) $(ML_OBJS) -cclib -lsdlstub -cclib $(SDLLIB)

$(OLIBRARY): $(OPT_OBJS)
	$(OCAMLC) -a -o $(OLIBRARY) $(OPT_OBJS) -cclib -lsdlstub -cclib $(SDLLIB)

$(CLIBRARY): $(STUB_OBJS)
	$(CMAKELIB)$(CLIBRARY) $(STUB_OBJS)

libsdlmixerstub$(LIBSUFFIX): sdlmixer_stub$(OBJSUFFIX)
	$(CMAKELIB)libsdlmixerstub$(LIBSUFFIX) sdlmixer_stub$(OBJSUFFIX)

libsdlloaderstub.$(LIBSUFFIX): sdlloader_stub.$(OBJSUFFIX)
	$(CMAKELIB)libsdlloaderstub$(LIBSUFFIX) sdlloader_stub$(OBJSUFFIX)

libsdlttfstub.$(LIBSUFFIX): sdlttf_stub.$(OBJSUFFIX)
	$(CMAKELIB)libsdlttfstub$(LIBSUFFIX) sdlttf_stub$(OBJSUFFIX)

sdlmixer.cma  : sdlmixer.cmo
	$(OCAMLC) -a -o sdlmixer.cma sdlmixer.cmo -cclib -lsdlmixerstub -cclib $(SDLMIXERLIB)

sdlmixer.cmxa  : sdlmixer.cmx
	$(OCAMLOPT) -a -o sdlmixer.cmxa sdlmixer.cmx -cclib -lsdlmixerstub -cclib $(SDLMIXERLIB)

sdlloader.cma  : sdlloader.cmo
	$(OCAMLC) -a -o sdlloader.cma sdlloader.cmo -cclib -lsdlloaderstub -cclib $(SDLLOADERLIB)

sdlloader.cmxa  : sdlloader.cmx
	$(OCAMLOPT) -a -o sdlloader.cmxa sdlloader.cmx -cclib -lsdlloaderstub -cclib $(SDLLOADERLIB)

sdlttf.cma  : sdlttf.cmo
	$(OCAMLC) -a -o sdlttf.cma sdlttf.cmo -cclib -lsdlttfstub -cclib $(SDLTTFLIB)

sdlttf.cmxa  : sdlttf.cmx
	$(OCAMLOPT) -a -o sdlttf.cmxa sdlttf.cmx -cclib -lsdlttfstub -cclib $(SDLTTFLIB)

endif

uninstall:	
	-rm -Rf $(INSTALL_DIR)
	-rm -f $(CAMLLIBDIR)/stublibs/dllsdl*.so

distclean: clean
	rm -f config.h .depend .depend.c *~

clean:
	rm -f *.cm* *.[oa] *.so *.do $(TOPLEVEL)

depend: .depend .depend.c

.depend: $(wildcard *.ml *.mli)
	@echo "making deps..."
	@$(CAMLDEP) $^ > $@

.depend.c : $(STUB_SRCS)
	@echo "making C deps..."
	@$(CC) $(CPPFLAGS) -I $(CAMLLIBDIR) -MM $^ > $@

.PHONY: all bin doc libs clean distclean depend install uninstall

-include .depend
-include .depend.c

