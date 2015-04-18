dnl ****** -*- autoconf -*-
dnl OCamlSdl autoconf input
dnl ******
dnl
dnl $Id: configure.in,v 1.44 2012/07/03 19:14:20 oliv__a Exp $

AC_INIT(ocamlsdl, 0.9.1)
AC_CONFIG_AUX_DIR(./support)
AC_CONFIG_HEADERS(src/config.h)

# Check for OCaml programs 
AC_PROG_OCAML
AC_PROG_FINDLIB
if test "$OCAML" = no ; then 
   AC_MSG_ERROR([Cannot find ocaml])
fi
if test "$OCAMLFIND" = no ; then 
   unset OCAMLFIND
fi


# OCaml platform
AC_CHECK_OCAML_OS_TYPE
PLATFORM="$OCAML_OS_TYPE"
AC_SUBST(PLATFORM)

# Check for programs
if test -z "$CFLAGS" ; then
   CFLAGS="-g -O"
fi
AC_PROG_CC
AC_OBJEXT
AC_PROG_RANLIB
AC_FUNC_ALLOCA
AC_C_INLINE
if test "$ac_cv_c_inline" != no ; then
  AC_DEFINE(HAVE_INLINE)
fi

AC_PROG_INSTALL

# Checking for lablGL
AC_ARG_WITH(lablgldir,
            [  --with-lablgldir=DIR	  specify location of lablgl],
            LABLGLDIR="$withval")
AC_CHECK_OCAML_MODULE(LABLGLDIR,lablGL,Gl,+lablGL)
if test "$LABLGLDIR" = no ; then unset LABLGLDIR ; fi

# Where to install the library ?
AC_ARG_WITH(installdir,
            [  --with-installdir=DIR	  specify installation directory [defaults to +sdl]],
            OCAMLSDLDIR="$withval",
            OCAMLSDLDIR="$OCAMLLIB/sdl")
AC_SUBST(OCAMLSDLDIR)

# Check for libraries

# Check for SDL libraries 
SDL_VERSION=1.2.0
AM_PATH_SDL($SDL_VERSION, :,
    AC_MSG_ERROR([*** SDL version $SDL_VERSION not found!])
)

case $target in
 *-apple-darwin*) PLATFORM=Apple ;;
esac

LIBS="$LIBS $SDL_LIBS"
CPPFLAGS="$CPPFLAGS $SDL_CFLAGS"

# cmdline options 
AC_ARG_ENABLE(sdl_ttf,
 	      [  --disable-sdl-ttf       without freetype support  [default is enabled]],
	      sdl_ttf=$enableval, sdl_ttf=yes)
AC_ARG_ENABLE(sdl_image,
 	      [  --disable-sdl-image     without sdl image support [default is enabled]],
	      sdl_image=$enableval, sdl_image=yes)
AC_ARG_ENABLE(sdl_mixer,
 	      [  --disable-sdl-mixer     without sdl mixer support [default is enabled]],
	      sdl_mixer=$enableval, sdl_mixer=yes)
AC_ARG_ENABLE(sdl_gfx,
 	      [  --disable-sdl-gfx       without sdl gfx support   [default is enabled]],
	      sdl_gfx=$enableval, sdl_gfx=yes)
AC_SUBST(PARTS)

# Checking for lib SDL_ttf
if test "$sdl_ttf" = yes ; then
  AC_CHECK_HEADERS(SDL_ttf.h, : , sdl_ttf=no)
  if test "$sdl_ttf" = yes ; then 
    AC_CHECK_LIB(SDL_ttf, TTF_OpenFontRW, AC_DEFINE(OCAMLSDL_TTF_VERSION,206),[
      AC_CHECK_LIB(SDL_ttf, TTF_OpenFontIndex, AC_DEFINE(OCAMLSDL_TTF_VERSION,204),[
        AC_CHECK_LIB(SDL_ttf, TTF_OpenFont, AC_DEFINE(OCAMLSDL_TTF_VERSION,200),
        AC_MSG_ERROR(Cannot find SDL_tff library.))
      ])
    ])
    PARTS="$PARTS ttf"
  fi
fi

# Checking for lib SDL_image
if test "$sdl_image" = yes ; then
  AC_CHECK_HEADERS(SDL_image.h, : , sdl_image=no)
  if test "$sdl_image" = yes ; then 
    AC_CHECK_LIB(SDL_image, IMG_ReadXPMFromArray, AC_DEFINE(OCAMLSDL_IMAGE_VERSION,121),[
      AC_CHECK_LIB(SDL_image, IMG_Load_RW, AC_DEFINE(OCAMLSDL_IMAGE_VERSION,120),
        AC_MSG_ERROR(Cannot find SDL_image library.))	
    ])
    PARTS="$PARTS loader"
  fi
fi

# Checking for lib SDL_mixer
if test "$sdl_mixer" = yes ; then
  AC_CHECK_HEADERS(SDL_mixer.h, : , sdl_mixer=no)
  if test "$sdl_mixer" = yes ; then 
    AC_CHECK_LIB(SDL_mixer, Mix_QuickLoad_WAV, :,
      AC_MSG_ERROR(Cannot find SDL_mixer library.))
    PARTS="$PARTS mixer"
  fi
fi

# Checking for lib SDL_gfx
if test "$sdl_gfx" = yes ; then
  AC_CHECK_HEADERS(SDL_gfxPrimitives.h, : , sdl_gfx=no)
  if test "$sdl_gfx" = yes ; then 
    AC_CHECK_LIB(SDL_gfx, pixelColor, :,
      AC_MSG_ERROR(Cannot find SDL_gfx library.))
    PARTS="$PARTS gfx"
  fi
fi

# Output configuration files
AC_CONFIG_FILES([META makefile.platform makefile.config.gcc])
AC_OUTPUT

# Output the configuration summary
echo
echo "Configure summary:"
if test -n "$LABLGLDIR" ; then lablgl_support=yes ; else lablgl_support=no ; fi
echo "  LablGL	" $lablgl_support
echo "  SDL_image	" $sdl_image
echo "  SDL_mixer	" $sdl_mixer
echo "  SDL_tff	" $sdl_ttf
echo "  SDL_gfx	" $sdl_gfx
echo
echo "Configure finished, type 'make' to build."
