
include ../makefile.platform
include ../$(MAKEFILE_CONFIG)
include ../makefile.rules

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

ifdef INSTALL
INSTALL_DIR = $(DESTDIR)$(OCAMLSDLDIR)
INSTALL_TARGETS = $(if $(OCAMLFIND), \
                    install-findlib, \
                    install-byte $(if $(OCAMLOPT),install-opt) $(if $(OCAMLMKLIB),install-dll))
install : all $(INSTALL_TARGETS)
install-byte:
	$(INSTALL) -d $(INSTALL_DIR)
	$(INSTALL_DATA) *.cma lib*.$(A) *.cmi *.mli $(INSTALL_DIR)
install-opt:
	$(INSTALL_DATA) *.cmxa sdl*.$(A) *.cmx $(INSTALL_DIR)
install-dll:
	$(INSTALL) -d $(DESTDIR)$(OCAMLLIBDIR)/stublibs
	$(INSTALL) dll*.so $(DESTDIR)$(OCAMLLIBDIR)/stublibs

ifdef OCAMLFIND
install-findlib :
	$(OCAMLFIND) install sdl ../META \
          *.cma lib*.$(A) *.cmi *.mli \
          $(if $(OCAMLOPT),*.cmxa sdl*.$(A) *.cmx) \
          $(if $(OCAMLMKLIB),dll*.so)
else
install-findlib : ; $(error "findlib is not installed")
endif

.PHONY : install install-byte install-opt install-dll install-findlib
endif

ifdef OCAMLDOC
MLI = $(foreach part,sdl $(PARTS),$(patsubst %.ml,%.mli,$(call ML_SRCS,$(part))))
CMI = $(patsubst %.mli,%.cmi,$(MLI))

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
-include .depend

ifeq ($(OCAML_C_BACKEND),gcc)
.depend_c : $(wildcard *.c)
	@echo "making C deps..."
	@$(CC) -MM $^ > $@
-include .depend_c
else
include .depend_c
endif

.PHONY: all doc clean depend
