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

/* $Id: common.h,v 1.5 2002/07/13 17:13:07 oliv__a Exp $ */

#ifndef __COMMON_H__
#define __COMMON_H__

#include <caml/mlvalues.h>

/*

  Caml list manipulations

  Grabbed in ocamlsdl-0.3/sdl_stub.c 1.8 (2000/09/25)
  made by Jean-Christophe FILLIATRE 
*/

#define nil()      Val_emptylist
extern value cons(value x,value l);
#define is_nil     Is_long
#define is_not_nil Is_block
#define hd(v)      Field((v), 0)
#define tl(v)      Field((v) ,1)


/* 
   Polymorphic variants <-> C ints conversion

   taken from LablGTK
*/
typedef struct { value key; int data; } lookup_info;
value ml_lookup_from_c (lookup_info *table, int data);
int ml_lookup_to_c (lookup_info *table, value key);


/*
  Wrapping of malloc'ed C pointers in Abstract blocks.
*/
extern value abstract_ptr(void *);

/*
   Optional arguments
*/
#define Opt_arg(v, conv, def) (Is_block(v) ? conv(Field((v),0)) : (def))

#endif /* __COMMON_H__ */
