/*
 * OCamlSDL - An ML interface to the SDL library
 * Copyright (C) 1999  Frederic Brunel
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/* $Id: common.h,v 1.17 2010/04/19 20:14:11 oliv__a Exp $ */

#ifndef _COMMON_H_
#define _COMMON_H_

#include "config.h"

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/bigarray.h>
#include <caml/custom.h>

#define UString_val(v) ((unsigned char *) Bp_val(v))

/*
  Caml list manipulations

  Grabbed in ocamlsdl-0.3/sdl_stub.c 1.8 (2000/09/25)
  made by Jean-Christophe FILLIATRE 
*/

#define nil()      Val_emptylist
extern value mlsdl_cons(value x,value l);
#define is_nil     Is_long
#define is_not_nil Is_block
#define hd(v)      Field((v), 0)
#define tl(v)      Field((v), 1)
extern int mlsdl_list_length(value l);


/* 
   Polymorphic variants <-> C ints conversion

   taken from LablGTK
*/
typedef struct { value key; int data; } lookup_info;
value mlsdl_lookup_from_c (lookup_info *table, int data);
int mlsdl_lookup_to_c (lookup_info *table, value key);


/*
  Wrapping of malloc'ed C pointers in Abstract blocks.
*/
extern value abstract_ptr(void *);
extern void nullify_abstract(value);

/*
   Optional arguments
*/
#define Val_none Val_unit
extern value Val_some(value v);
#define Unopt(v) Field((v), 0)
#define Opt_arg(v, conv, def) (Is_block(v) ? conv(Field((v),0)) : (def))

/*
 * convenient wrappers (stolen from LablGTK)
 */
#define Unit(x) ((x), Val_unit)
#define ML_0(cname, conv) \
CAMLprim value ml_##cname (value unit) { return conv (cname ()); }
#define ML_1(cname, conv1, conv) \
CAMLprim value ml_##cname (value arg1) { return conv (cname (conv1 (arg1))); }
#define ML_1_name(mlname, cname, conv1, conv) \
CAMLprim value mlname (value arg1) { return conv (cname (conv1 (arg1))); }
#define ML_2(cname, conv1, conv2, conv) \
CAMLprim value ml_##cname (value arg1, value arg2) { return conv (cname (conv1 (arg1), conv2 (arg2))); }

#define Unsupported(cname) \
CAMLprim value ml_##cname() { failwith("not implemented"); return Val_unit; }

/*
 * MT stuff
 */
void enter_blocking_section(void);
void leave_blocking_section(void);

/* 
 * VLA / alloca stuff
 */

#ifdef __GNUC__
# define LOCALARRAY(type, x, len)  type x [(len)]
#else
# ifdef HAVE_ALLOCA
#  ifdef HAVE_ALLOCA_H
#   include <alloca.h>
#  else
#   ifdef WIN32
#    include <malloc.h>
#   endif
#  endif
#  define LOCALARRAY(type, x, len) type *x = (type *) alloca(sizeof (type) * (len))
# else
#  error "no alloca available"
# endif
#endif

#endif /* _COMMON_H_ */
