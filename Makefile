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

# $Id: Makefile,v 1.24 2010/04/19 21:01:14 oliv__a Exp $

all doc clean install:
	$(MAKE) -C src $@
.PHONY: all doc clean install

include makefile.platform
include makefile.config.$(OCAML_C_BACKEND)

ifeq ($(OCAML_C_BACKEND),gcc)
makefile.config.gcc : makefile.config.gcc.in configure
	$(error "please run ./configure or edit makefile.platform")
configure : configure.in
	aclocal -I support
	autoconf
endif

DISTSRC := AUTHORS COPYING INSTALL INSTALL.win32 README README.macosx NEWS \
           Makefile META.in \
           configure.in aclocal.m4 configure \
           makefile.platform.in makefile.config.gcc.in makefile.config.msvc makefile.rules \
           support/install-sh support/ocaml.m4 support/config.sub support/config.guess \
	   src/sdl*.ml src/sdl*.mli src/sdl*.c src/sdl*.h \
           src/common.c src/common.h src/mlsdl_main.c \
           src/config.h.in src/config.h.msvc \
	   src/Makefile src/.depend src/.depend_c \
           doc/ocamlsdl.texi doc/ocamlsdl.info doc/ocamlsdl-mingw.txt \
           doc/html xpm_to_ml

# hackish targets to build tarballs
dist : dist-zip dist-tgz
dist-zip : ../ocamlsdl-$(VERSION).zip
dist-tgz : ../ocamlsdl-$(VERSION).tar.gz
.PHONY : dist dist-zip dist-tgz
../ocamlsdl-$(VERSION).zip : $(DISTSRC)
	export DIRNAME=$${PWD##*/} ; \
	cd .. && mv $$DIRNAME ocamlsdl-$(VERSION) && \
        zip -9rl $(@F) $(addprefix ocamlsdl-$(VERSION)/,$(DISTSRC)) && \
	mv ocamlsdl-$(VERSION) $$DIRNAME 
../ocamlsdl-$(VERSION).tar.gz : $(DISTSRC)
	export DIRNAME=$${PWD##*/} ; \
	cd .. && mv $$DIRNAME ocamlsdl-$(VERSION) && \
	tar zcvf $(@F) $(addprefix ocamlsdl-$(VERSION)/,$(DISTSRC)) && \
	mv ocamlsdl-$(VERSION) $$DIRNAME 
