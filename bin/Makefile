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

# $Id: Makefile,v 1.1 2002/06/04 23:10:36 oliv__a Exp $

include ../makefile.toplevel

INSTALL_DIR=$(DESTDIR)$(BINDIR)
SCRIPT_TOPLEVEL=ocamlsdl

$(SCRIPT_TOPLEVEL) : $(SCRIPT_TOPLEVEL).in
	sed -e "s\\@OCAMLSDLDIR@\\$(OCAMLSDLDIR)\\" < $< > $@

install: $(SCRIPT_TOPLEVEL)
	$(INSTALL) -d $(INSTALL_DIR)
	$(INSTALL) $(SCRIPT_TOPLEVEL) $(INSTALL_DIR)

uninstall:
	rm $(INSTALL_DIR)/$(SCRIPT_TOPLEVEL)

clean:
	rm -f $(SCRIPT_TOPLEVEL)

distclean: clean

.PHONY: install uninstall clean distclean
