
include ../makefile.toplevel
include ../makefile.rules

INSTALL_DIR = $(DESTDIR)$(OCAMLSDLDIR)

OMLFLAGS = -unsafe
MLFLAGS  = -g

sdl_MODULES = sdl sdlcdrom sdltimer sdljoystick \
	      sdlkey sdlmouse sdlevent sdlvideo sdlwm \
              $(if $(LABLGLDIR),sdlgl)
sdl_C_SRC    = common.c sdlrwops_stub.c

loader_MODULES = sdlloader
mixer_MODULES  = sdlmixer
ttf_MODULES    = sdlttf

TARGETS  = sdl.cma $(patsubst %,sdl%.cma,$(PARTS))
TARGETS += libsdlstub.$(A) $(patsubst %,libsdl%stub.$(A),$(PARTS))
ifdef OCAMLOPT
TARGETS += sdl.cmxa $(patsubst %,sdl%.cmxa,$(PARTS))
endif

all : $(TARGETS)

sdl.cma : $(call ML_OBJS,sdl)
	$(call MKCMA,sdl,sdlstub,$^,$(SDL_LIBS))
sdl.cmxa : $(call ML_OPT_OBJS,sdl)
	$(call MKCMXA,sdl,sdlstub,$^,$(SDL_LIBS))
libsdlstub.$(A) dllsdlstub.so : $(call STUB_OBJS,sdl)
	$(call MKCLIB,sdl,sdlstub,$^,$(SDL_LIBS))

sdlloader.cma : $(call ML_OBJS,loader)
	$(call MKCMA,sdlloader,sdlloaderstub,$^,-lSDL_image)
sdlloader.cmxa : $(call ML_OPT_OBJS,loader)
	$(call MKCMXA,sdlloader,sdlloaderstub,$^,-lSDL_image)
libsdlloaderstub.$(A) dllsdlloaderstub.so : $(call STUB_OBJS,loader)
	$(call MKCLIB,sdlloader,sdlloaderstub,$^,-lSDL_image)

sdlmixer.cma : $(call ML_OBJS,mixer)
	$(call MKCMA,sdlmixer,sdlmixerstub,$^,-lSDL_mixer)
sdlmixer.cmxa : $(call ML_OPT_OBJS,mixer)
	$(call MKCMXA,sdlmixer,sdlmixerstub,$^,-lSDL_mixer)
libsdlmixerstub.$(A) dllsdlmixerstub.so : $(call STUB_OBJS,mixer)
	$(call MKCLIB,sdlmixer,sdlmixerstub,$^,-lSDL_mixer)

sdlttf.cma : $(call ML_OBJS,ttf)
	$(call MKCMA,sdlttf,sdlttfstub,$^,-lSDL_ttf)
sdlttf.cmxa : $(call ML_OPT_OBJS,ttf)
	$(call MKCMXA,sdlttf,sdlttfstub,$^,-lSDL_ttf)
libsdlttfstub.$(A) dllsdlttfstub.so : $(call STUB_OBJS,ttf)
	$(call MKCLIB,sdlttf,sdlttfstub,$^,-lSDL_ttf)


LABLGLINC = $(if $(LABLGLDIR),-I $(LABLGLDIR))
sdlgl.cm% :  MLINC=$(LABLGLINC)


INSTALL_TARGETS = install-byte $(if $(OCAMLOPT),install-opt) $(if $(OCAMLMKLIB),install-dll)
install : $(INSTALL_TARGETS)
install-byte:
	$(INSTALL) -d $(INSTALL_DIR)
	$(INSTALL_DATA) *.cma lib*.$(A) *.cmi *.mli $(INSTALL_DIR)
install-opt:
	$(INSTALL_DATA) *.cmxa sdl*.$(A) *.cmx $(INSTALL_DIR)
install-dll:
	$(INSTALL) -d $(DESTDIR)$(OCAMLLIBDIR)/stublibs
	$(INSTALL) dll*.so $(DESTDIR)$(OCAMLLIBDIR)/stublibs

MLI = $(foreach part,sdl $(PARTS),$(patsubst %.ml,%.mli,$(call ML_SRCS,$(part))))
CMI = $(patsubst %.mli,%.cmi,$(MLI))

ifdef OCAMLDOC
doc : ../doc/html/index.html ../doc/ocamlsdl.texi
../doc/html/index.html : $(CMI)
	mkdir -p ../doc/html
	$(OCAMLDOC) -d ../doc/html -html -v -t ocamlsdl $(LABLGLINC) $(MLI)
../doc/ocamlsdl.texi : $(CMI)
	mkdir -p ../doc
	$(OCAMLDOC) -d ../doc -texi -v -o $@ -t ocamlsdl $(LABLGLINC) $(MLI)
else
doc : ; $(error "you need ocamldoc to generate the documentation")
endif

clean:
	rm -f *.cm* *.$(OBJEXT) *.$(A) *.so *.do

depend: .depend .depend.c

.depend: $(wildcard *.ml *.mli)
	@echo "making deps..."
	@$(OCAMLDEP) $^ > $@

.depend.c : $(wildcard *_stub.c)
	@echo "making C deps..."
	@$(CC) -MM $^ > $@

.PHONY: all doc clean depend install install-byte install-opt install-dll

-include .depend
-include .depend.c

