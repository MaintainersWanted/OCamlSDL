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

/* $Id: common.c,v 1.8 2002/08/24 21:01:37 oliv__a Exp $ */


#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>

#include "common.h"

/*

  Caml list manipulations

  Grabbed in ocamlsdl-0.3/sdl_stub.c 1.8 (2000/09/25)
  made by Jean-Christophe FILLIATRE 
*/
value cons(value x,value l)
{
  CAMLparam2(x,l);
  CAMLlocal1(m);
  m=alloc_small(2,Tag_cons);
  Field(m, 0)=x;
  Field(m, 1)=l;
  CAMLreturn (m);
}

int list_length(value l)
{  
  int len = 0;
  while(is_not_nil(l)){
    len++;
    l = tl(l);
  }
  return len;
}

/* 
   Polymorphic variants <-> C ints conversion

   taken from LablGTK
*/
value mlsdl_lookup_from_c (lookup_info *table, int data)
{
    int i;
    for (i = table[0].data; i > 0; i--)
	if (table[i].data == data) return table[i].key;
    invalid_argument ("ml_lookup_from_c");
}
    
int mlsdl_lookup_to_c (lookup_info *table, value key)
{
    int first = 1, last = table[0].data, current;

    while (first < last) {
	current = (first+last)/2;
	if (table[current].key >= key) last = current;
	else first = current + 1;
    }
    if (table[first].key == key) return table[first].data;
    invalid_argument ("ml_lookup_to_c");
}


/*
  Wrapping of malloc'ed C pointers in Abstract blocks.
*/
value abstract_ptr(void *p)
{
  value v = alloc_small(1, Abstract_tag);
  Field(v, 0) = Val_bp(p);
  return v;
}


value Val_some(value v)
{
  CAMLparam1(v);
  CAMLlocal1(r);
  r = alloc_small(1, 0);
  Field(r, 0) = v;
  CAMLreturn(r);
}
