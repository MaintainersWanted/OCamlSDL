# Generated automatically from Makefile.in by configure.
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

# $Id: Makefile,v 1.1 2001/06/11 17:15:38 xtrm Exp $

INSTALL_DIR=$(DESTDIR)/usr/share/doc/ocamlsdl/doc
HTML_FILES=index.html sdl.html sdlcdrom.html sdlvideo.html sdlevent.html \
	sdltimer.html sdlmixer.html sdlttf.html #sdlimage.html

install:
	mkdir -p $(INSTALL_DIR)
	cp $(HTML_FILES) $(INSTALL_DIR)

uninstall:
	@rm $(INSTALL_DIR)

clean:

distclean: clean
	@rm -f Makefile

include ../makefile.toplevel

