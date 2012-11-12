#include <SDL.h>

#include <SDL_gfxPrimitives.h>
#include <SDL_rotozoom.h>

#include "common.h"
#include "sdlvideo_stub.h"

/* PRIMITIVES */
/*
missing:
- vline & hline
- pie & filledPie
- trigon & aatrigon & filledTrigon
- polygon & aapolygon & filledPolygon
- bezier curve
*/

/* pixel */

CAMLprim value ml_pixelColor(value dst,value x,value y, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  int r;
  r=pixelColor(sur,Int_val(x),Int_val(y),Int32_val(col));
  if (r) caml_failwith("Sdlgfx.pixelColor");

  return Val_unit;
}

CAMLprim value ml_pixelRGBA(value dst,value x,value y, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Color c;
  int r;

  SDLColor_of_value(&c,col);
  r=pixelRGBA(sur,Int_val(x),Int_val(y),c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.pixelRGBA");

  return Val_unit;
}

/* rectangle */

CAMLprim value ml_rectangleColor(value dst,value p1,value p2, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  r=rectangleColor(sur,x1,y1,x2,y2,Int32_val(col));
  if (r) caml_failwith("Sdlgfx.rectangleColor");

  return Val_unit;
}


CAMLprim value ml_rectangleRGBA(value dst,value p1,value p2, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  SDL_Color c;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  SDLColor_of_value(&c,col);
  r=rectangleRGBA(sur,x1,y1,x2,y2,c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.rectangleRGBA");

  return Val_unit;
}

CAMLprim value ml_boxColor(value dst,value p1,value p2, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  r=boxColor(sur,x1,y1,x2,y2,Int32_val(col));
  if (r) caml_failwith("Sdlgfx.boxColor");

  return Val_unit;
}


CAMLprim value ml_boxRGBA(value dst,value p1,value p2, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  SDL_Color c;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  SDLColor_of_value(&c,col);
  r=boxRGBA(sur,x1,y1,x2,y2,c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.boxRGBA");

  return Val_unit;
}

/* rounded-rectangle */

CAMLprim value ml_roundedRectangleColor(value dst,value p1,value p2,value rad,value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  r=roundedRectangleColor(sur,x1,y1,x2,y2,Int_val(rad),Int32_val(col));
  if (r) caml_failwith("Sdlgfx.roundedRectangleColor");

  return Val_unit;
}

CAMLprim value ml_roundedRectangleRGBA(value dst,value p1,value p2,value rad,value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  SDL_Color c;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  SDLColor_of_value(&c,col);
  r=roundedRectangleRGBA(sur,x1,y1,x2,y2,Int_val(rad),c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.roundedRectangleRGBA");

  return Val_unit;
}

CAMLprim value ml_roundedRectangleRGBA_bc(value *argv, int argc)
{
  return ml_roundedRectangleRGBA(
      argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

/* rounded-box */

CAMLprim value ml_roundedBoxColor(value dst,value p1,value p2,value rad,value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  r=roundedBoxColor(sur,x1,y1,x2,y2,Int_val(rad),Int32_val(col));
  if (r) caml_failwith("Sdlgfx.roundedBoxColor");

  return Val_unit;
}

CAMLprim value ml_roundedBoxRGBA(value dst,value p1,value p2,value rad,value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  SDL_Color c;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  SDLColor_of_value(&c,col);
  r=roundedBoxRGBA(sur,x1,y1,x2,y2,Int_val(rad),c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.roundedBoxRGBA");

  return Val_unit;
}

CAMLprim value ml_roundedBoxRGBA_bc(value *argv, int argc)
{
  return ml_roundedBoxRGBA(
      argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

/* line */

CAMLprim value ml_lineColor(value dst,value p1,value p2, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  r=lineColor(sur,x1,y1,x2,y2,Int32_val(col));
  if (r) caml_failwith("Sdlgfx.lineColor");

  return Val_unit;
}


CAMLprim value ml_lineRGBA(value dst,value p1,value p2, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  SDL_Color c;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  SDLColor_of_value(&c,col);
  r=lineRGBA(sur,x1,y1,x2,y2,c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.lineRGBA");

  return Val_unit;
}


CAMLprim value ml_aalineColor(value dst,value p1,value p2, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  r=aalineColor(sur,x1,y1,x2,y2,Int32_val(col));
  if (r) caml_failwith("Sdlgfx.aalineColor");

  return Val_unit;
}


CAMLprim value ml_aalineRGBA(value dst,value p1,value p2, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  SDL_Color c;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  SDLColor_of_value(&c,col);
  r=aalineRGBA(sur,x1,y1,x2,y2,c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.aalineRGBA");

  return Val_unit;
}

/* thick line */

CAMLprim value ml_thickLineColor(value dst,value p1,value p2,value width,value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  r=thickLineColor(sur,x1,y1,x2,y2,Int_val(width),Int32_val(col));
  if (r) caml_failwith("Sdlgfx.thickLineColor");

  return Val_unit;
}

CAMLprim value ml_thickLineRGBA(value dst,value p1,value p2,value width,value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x1, y1, x2, y2;
  SDL_Color c;
  int r;

  SDLVect_of_value(&x1,&y1,p1);
  SDLVect_of_value(&x2,&y2,p2);
  SDLColor_of_value(&c,col);
  r=thickLineRGBA(sur,x1,y1,x2,y2,Int_val(width),c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.thickLineRGBA");

  return Val_unit;
}

CAMLprim value ml_thickLineRGBA_bc(value *argv, int argc)
{
  return ml_thickLineRGBA(
      argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

/* circle */

CAMLprim value ml_circleColor(value dst,value pos,value ra, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x, y;
  int r;

  SDLVect_of_value(&x,&y,pos);
  r=circleColor(sur,x,y,Int_val(ra),Int32_val(col));
  if (r) caml_failwith("Sdlgfx.circleColor");

  return Val_unit;
}


CAMLprim value ml_circleRGBA(value dst,value pos,value ra, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Color c;
  Sint16 x, y;
  int r;

  SDLVect_of_value(&x,&y,pos);
  SDLColor_of_value(&c,col);
  r=circleRGBA(sur,x,y,Int_val(ra),c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.circleRGBA");

  return Val_unit;
}


CAMLprim value ml_aacircleColor(value dst,value pos,value ra, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x, y;
  int r;

  SDLVect_of_value(&x,&y,pos);
  r=aacircleColor(sur,x,y,Int_val(ra),Int32_val(col));
  if (r) caml_failwith("Sdlgfx.aacircleColor");

  return Val_unit;
}


CAMLprim value ml_aacircleRGBA(value dst,value pos,value ra, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Color c;
  Sint16 x, y;
  int r;

  SDLVect_of_value(&x,&y,pos);
  SDLColor_of_value(&c,col);
  r=aacircleRGBA(sur,x,y,Int_val(ra),c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.aacircleRGBA");

  return Val_unit;
}


CAMLprim value ml_filledCircleColor(value dst,value pos,value ra, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x, y;
  int r;

  SDLVect_of_value(&x,&y,pos);
  r=filledCircleColor(sur,x,y,Int_val(ra),Int32_val(col));
  if (r) caml_failwith("Sdlgfx.filledCircleColor");

  return Val_unit;
}


CAMLprim value ml_filledCircleRGBA(value dst,value pos,value ra, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Color c;
  Sint16 x, y;
  int r;

  SDLVect_of_value(&x,&y,pos);
  SDLColor_of_value(&c,col);
  r=filledCircleRGBA(sur,x,y,Int_val(ra),c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.filledCircleRGBA");

  return Val_unit;
}

/* arc */

CAMLprim value ml_arcColor(value dst,value pos,value rad,value start,value end,value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x, y;
  int r;

  SDLVect_of_value(&x,&y,pos);
  r=arcColor(sur,x,y,Int_val(rad),Int_val(start),Int_val(end),Int32_val(col));
  if (r) caml_failwith("Sdlgfx.arcColor");

  return Val_unit;
}

CAMLprim value ml_arcColor_bc(value *argv, int argc)
{
  return ml_arcColor(
      argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

CAMLprim value ml_arcRGBA(value dst,value pos,value rad,value start,value end,value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Color c;
  Sint16 x, y;
  int r;

  SDLVect_of_value(&x,&y,pos);
  SDLColor_of_value(&c,col);
  r=arcRGBA(sur,x,y,Int_val(rad),Int_val(start),Int_val(end),c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.arcRGBA");

  return Val_unit;
}

CAMLprim value ml_arcRGBA_bc(value *argv, int argc)
{
  return ml_arcRGBA(
      argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6]);
}

/* ellipse */

CAMLprim value ml_ellipseColor(value dst,value p,value rp, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x, y, rx, ry;
  int r;

  SDLVect_of_value(&x,&y,p);
  SDLVect_of_value(&rx,&ry,rp);
  r=ellipseColor(sur,x,y,rx,ry,Int32_val(col));
  if (r) caml_failwith("Sdlgfx.ellipseColor");

  return Val_unit;
}


CAMLprim value ml_ellipseRGBA(value dst,value p,value rp, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Color c;
  Sint16 x, y, rx, ry;
  int r;

  SDLVect_of_value(&x,&y,p);
  SDLVect_of_value(&rx,&ry,rp);
  SDLColor_of_value(&c,col);
  r=ellipseRGBA(sur,x,y,rx,ry,c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.ellipseRGBA");

  return Val_unit;
}

CAMLprim value ml_aaellipseColor(value dst,value p,value rp, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x, y, rx, ry;
  int r;

  SDLVect_of_value(&x,&y,p);
  SDLVect_of_value(&rx,&ry,rp);
  r=aaellipseColor(sur,x,y,rx,ry,Int32_val(col));
  if (r) caml_failwith("Sdlgfx.aaellipseColor");

  return Val_unit;
}


CAMLprim value ml_aaellipseRGBA(value dst,value p,value rp, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x, y, rx, ry;
  SDL_Color c;
  int r;

  SDLVect_of_value(&x,&y,p);
  SDLVect_of_value(&rx,&ry,rp);
  SDLColor_of_value(&c,col);
  r=aaellipseRGBA(sur,x,y,rx,ry,c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.aaellipseRGBA");

  return Val_unit;
}


CAMLprim value ml_filledEllipseColor(value dst,value p,value rp, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x, y, rx, ry;
  int r;

  SDLVect_of_value(&x,&y,p);
  SDLVect_of_value(&rx,&ry,rp);
  r=filledEllipseColor(sur,x,y,rx,ry,Int32_val(col));
  if (r) caml_failwith("Sdlgfx.filledEllipseColor");

  return Val_unit;
}


CAMLprim value ml_filledEllipseRGBA(value dst,value p,value rp, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x, y, rx, ry;
  SDL_Color c;
  int r;

  SDLVect_of_value(&x,&y,p);
  SDLVect_of_value(&rx,&ry,rp);
  SDLColor_of_value(&c,col);
  r=filledEllipseRGBA(sur,x,y,rx,ry,c.r,c.g,c.b, Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.filledEllipseRGBA");

  return Val_unit;
}

/* text */

CAMLprim value ml_characterColor(value dst,value p,value c,value color)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x, y;
  int r;

  SDLVect_of_value(&x,&y,p);
  r=characterColor(sur,x,y,(char) c,Int32_val(color));
  if (r) caml_failwith("Sdlgfx.characterColor");

  return Val_unit;
}

CAMLprim value ml_characterRGBA(value dst,value p,value ch,value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x, y;
  SDL_Color c;
  int r;

  SDLVect_of_value(&x,&y,p);
  SDLColor_of_value(&c,col);
  r=characterRGBA(sur,x,y,(char) ch,c.r,c.g,c.b,Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.characterRGBA");

  return Val_unit;
}


CAMLprim value ml_stringColor(value dst,value p,value c,value color)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x, y;
  int r;

  SDLVect_of_value(&x,&y,p);
  r=stringColor(sur,x,y,String_val(c),Int32_val(color));
  if (r) caml_failwith("Sdlgfx.stringColor");

  return Val_unit;
}

CAMLprim value ml_stringRGBA(value dst,value p,value ch,value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  Sint16 x, y;
  SDL_Color c;
  int r;

  SDLVect_of_value(&x,&y,p);
  SDLColor_of_value(&c,col);
  r=stringRGBA(sur,x,y,String_val(ch),c.r,c.g,c.b,Int_val(alpha));
  if (r) caml_failwith("Sdlgfx.stringRGBA");

  return Val_unit;
}

CAMLprim value ml_gfxPrimitivesSetFont(value fd,value cw,value ch)
{
  gfxPrimitivesSetFont(String_val(fd),Int_val(cw),Int_val(ch));
  return Val_unit;
}


/* ROTOZOOM */
CAMLprim value ml_rotozoomSurface(value src,value angle,value zoom,value smooth)
{
  SDL_Surface *ssur= SDL_SURFACE(src);
  SDL_Surface *dsur;
  dsur=rotozoomSurface(ssur,Double_val(angle),Double_val(zoom),Bool_val(smooth));
  return ML_SURFACE(dsur);
}

CAMLprim value ml_rotozoomSurfaceXY(value src,value angle,value zoomx,value zoomy,value smooth)
{
  SDL_Surface *ssur= SDL_SURFACE(src);
  SDL_Surface *dsur;
  dsur=rotozoomSurfaceXY(ssur,Double_val(angle),Double_val(zoomx),Double_val(zoomy),Bool_val(smooth));
  return ML_SURFACE(dsur);
}

CAMLprim value ml_zoomSurface(value src,value zoomx,value zoomy,value smooth)
{
  SDL_Surface *ssur= SDL_SURFACE(src);
  SDL_Surface *dsur;
  dsur=zoomSurface(ssur,Double_val(zoomx),Double_val(zoomy),Bool_val(smooth));
  return ML_SURFACE(dsur);
}
