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

/* $Id: common.c,v 1.2 2002/05/27 22:06:25 xtrm Exp $ */


#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
/*  #include <caml/fail.h>
 *  #include <caml/callback.h> */

/*

  Caml list manipulations

  Grabbed in ocamlsdl-0.3/sdl_stub.c 1.8 (2000/09/25)
  made by Jean-Christophe FILLIATRE 
*/

#include "common.h"


#define NIL_tag 0
#define CONS_tag 1

value nil(void)
{
  return Val_int(0);
}

value cons(value x,value l)
{
  CAMLparam2(x,l);
  CAMLlocal1(m);
  m=alloc(2,CONS_tag);
  Store_field(m,0,x);
  Store_field(m,1,l);
  CAMLreturn (m);
}

/*
  block 2 vals conversion

  Guillaume Cottenceau <guillaume.cottenceau at free.fr>
  Inspired by http://caml.inria.fr/oreilly-book/html/book-ora115.html
*/

void recurse_block(value v, struct vals * values) 
{
  long i;
  
  if (Is_long(v)) 
    {
      values->values[values->size] = Long_val(v);
      values->size++;

      if (values->size >= values->maxsize) 
	{
	  long * nv = malloc(sizeof(long) * values->maxsize);

	  values->maxsize *= 2;
	  memcpy(nv, values->values, (values->size-1) * sizeof(long));
	  free(values->values);
	  values->values = nv;
	}
      return;
    }
  switch (Tag_val(v))
    {
    case Closure_tag : 
    case String_tag : 
    case Double_tag: 
    case Double_array_tag : 
    case Abstract_tag :
      break;
	
    default:  
      if (Tag_val(v)>=No_scan_tag) 
	{ 
	  printf("unknown tag"); 
	  break; 
	};
      
      for (i=0;i<Wosize_val(v);i++)
	recurse_block(Field(v,i), values);
    }
  return;
}


void block2vals(value v, struct vals * values)
{
  values->size = 0;
  values->maxsize = 10;
  values->values = malloc(sizeof(long) * values->maxsize);
  
  recurse_block(v, values);
}

void freevals(struct vals * values)
{
  free(values->values);
}

