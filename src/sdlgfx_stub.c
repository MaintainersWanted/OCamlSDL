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

  return Val_bool(r);
}

CAMLprim value ml_pixelRGBA(value dst,value x,value y, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Color c;
  int r;

  SDLColor_of_value(&c,col);
  r=pixelRGBA(sur,Int_val(x),Int_val(y),c.r,c.g,c.b, Int_val(alpha));

  return Val_bool(r);
}

/* rectangle */

CAMLprim value ml_rectangleColor(value dst,value p1,value p2, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect rect1, rect2;
  int r;

  SDLRect_of_value(&rect1,p1);
  SDLRect_of_value(&rect2,p2);
  r=rectangleColor(sur,rect1.x,rect1.y,rect2.x,rect2.y,Int32_val(col));

  return Val_bool(r);
}


CAMLprim value ml_rectangleRGBA(value dst,value p1,value p2, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect rect1, rect2;
  SDL_Color c;
  int r;

  SDLRect_of_value(&rect1,p1);
  SDLRect_of_value(&rect2,p2);
  SDLColor_of_value(&c,col);
  r=rectangleRGBA(sur,rect1.x,rect1.y,rect2.x,rect2.y,c.r,c.g,c.b, Int_val(alpha));

  return Val_bool(r);
}

CAMLprim value ml_boxColor(value dst,value p1,value p2, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect rect1,rect2;
  int r;

  SDLRect_of_value(&rect1,p1);
  SDLRect_of_value(&rect2,p2);
  r=boxColor(sur,rect1.x,rect1.y,rect2.x,rect2.y,Int32_val(col));

  return Val_bool(r);
}


CAMLprim value ml_boxRGBA(value dst,value p1,value p2, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect rect1,rect2;
  SDL_Color c;
  int r;

  SDLRect_of_value(&rect1,p1);
  SDLRect_of_value(&rect2,p2);
  SDLColor_of_value(&c,col);
  r=boxRGBA(sur,rect1.x,rect1.y,rect2.x,rect2.y,c.r,c.g,c.b, Int_val(alpha));

  return Val_bool(r);
}

/* line */

CAMLprim value ml_lineColor(value dst,value p1,value p2, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect rect1,rect2;
  int r;

  SDLRect_of_value(&rect1,p1);
  SDLRect_of_value(&rect2,p2);
  r=lineColor(sur,rect1.x,rect1.y,rect2.x,rect2.y,Int32_val(col));

  return Val_bool(r);
}


CAMLprim value ml_lineRGBA(value dst,value p1,value p2, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect rect1,rect2;
  SDL_Color c;
  int r;

  SDLRect_of_value(&rect1,p1);
  SDLRect_of_value(&rect2,p2);
  SDLColor_of_value(&c,col);
  r=lineRGBA(sur,rect1.x,rect1.y,rect2.x,rect2.y,c.r,c.g,c.b, Int_val(alpha));

  return Val_bool(r);
}


CAMLprim value ml_aalineColor(value dst,value p1,value p2, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect rect1,rect2;
  int r;

  SDLRect_of_value(&rect1,p1);
  SDLRect_of_value(&rect2,p2);
  r=aalineColor(sur,rect1.x,rect1.y,rect2.x,rect2.y,Int32_val(col));

  return Val_bool(r);
}


CAMLprim value ml_aalineRGBA(value dst,value p1,value p2, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect rect1,rect2;
  SDL_Color c;
  int r;

  SDLRect_of_value(&rect1,p1);
  SDLRect_of_value(&rect2,p2);
  SDLColor_of_value(&c,col);
  r=aalineRGBA(sur,rect1.x,rect1.y,rect2.x,rect2.y,c.r,c.g,c.b, Int_val(alpha));

  return Val_bool(r);
}

/* circle */

CAMLprim value ml_circleColor(value dst,value p,value ra, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect prect;
  int r;

  SDLRect_of_value(&prect,p);
  r=circleColor(sur,prect.x,prect.y,Int_val(ra),Int32_val(col));

  return Val_bool(r);
}


CAMLprim value ml_circleRGBA(value dst,value p,value ra, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect prect;
  SDL_Color c;
  int r;

  SDLRect_of_value(&prect,p);
  SDLColor_of_value(&c,col);
  r=circleRGBA(sur,prect.x,prect.y,Int_val(ra),c.r,c.g,c.b, Int_val(alpha));

  return Val_bool(r);
}


CAMLprim value ml_aacircleColor(value dst,value p,value ra, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect prect;
  int r;

  SDLRect_of_value(&prect,p);
  r=aacircleColor(sur,prect.x,prect.y,Int_val(ra),Int32_val(col));

  return Val_bool(r);
}


CAMLprim value ml_aacircleRGBA(value dst,value p,value ra, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect prect;
  SDL_Color c;
  int r;

  SDLRect_of_value(&prect,p);
  SDLColor_of_value(&c,col);
  r=aacircleRGBA(sur,prect.x,prect.y,Int_val(ra),c.r,c.g,c.b, Int_val(alpha));

  return Val_bool(r);
}

CAMLprim value ml_filledCircleColor(value dst,value p,value ra, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect prect;
  int r;

  SDLRect_of_value(&prect,p);
  r=filledCircleColor(sur,prect.x,prect.y,Int_val(ra),Int32_val(col));

  return Val_bool(r);
}


CAMLprim value ml_filledCircleRGBA(value dst,value p,value ra, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect prect;
  SDL_Color c;
  int r;

  SDLRect_of_value(&prect,p);
  SDLColor_of_value(&c,col);
  r=filledCircleRGBA(sur,prect.x,prect.y,Int_val(ra),c.r,c.g,c.b, Int_val(alpha));

  return Val_bool(r);
}

/* ellipse */

CAMLprim value ml_ellipseColor(value dst,value p,value rp, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect prect,rprect;
  int r;

  SDLRect_of_value(&prect,p);
  SDLRect_of_value(&rprect,rp);
  r=ellipseColor(sur,prect.x,prect.y,rprect.x,rprect.y,Int32_val(col));

  return Val_bool(r);
}


CAMLprim value ml_ellipseRGBA(value dst,value p,value rp, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect prect,rprect;
  SDL_Color c;
  int r;

  SDLRect_of_value(&prect,p);
  SDLRect_of_value(&rprect,rp);
  SDLColor_of_value(&c,col);
  r=ellipseRGBA(sur,prect.x,prect.y,rprect.x,rprect.y,c.r,c.g,c.b, Int_val(alpha));

  return Val_bool(r);
}

CAMLprim value ml_aaellipseColor(value dst,value p,value rp, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect prect,rprect;
  int r;

  SDLRect_of_value(&prect,p);
  SDLRect_of_value(&rprect,rp);
  r=aaellipseColor(sur,prect.x,prect.y,rprect.x,rprect.y,Int32_val(col));

  return Val_bool(r);
}


CAMLprim value ml_aaellipseRGBA(value dst,value p,value rp, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect prect,rprect;
  SDL_Color c;
  int r;

  SDLRect_of_value(&prect,p);
  SDLRect_of_value(&rprect,rp);
  SDLColor_of_value(&c,col);
  r=aaellipseRGBA(sur,prect.x,prect.y,rprect.x,rprect.y,c.r,c.g,c.b, Int_val(alpha));

  return Val_bool(r);
}


CAMLprim value ml_filledEllipseColor(value dst,value p,value rp, value col)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect prect,rprect;
  int r;

  SDLRect_of_value(&prect,p);
  SDLRect_of_value(&rprect,rp);
  r=filledEllipseColor(sur,prect.x,prect.y,rprect.x,rprect.y,Int32_val(col));

  return Val_bool(r);
}


CAMLprim value ml_filledEllipseRGBA(value dst,value p,value rp, value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect prect,rprect;
  SDL_Color c;
  int r;

  SDLRect_of_value(&prect,p);
  SDLRect_of_value(&rprect,rp);
  SDLColor_of_value(&c,col);
  r=filledEllipseRGBA(sur,prect.x,prect.y,rprect.x,rprect.y,c.r,c.g,c.b, Int_val(alpha));

  return Val_bool(r);
}

/* text */

CAMLprim value ml_characterColor(value dst,value p,value c,value color)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect rect;
  int r;

  SDLRect_of_value(&rect,p);
  r=characterColor(sur,rect.x,rect.y,(char) c,Int32_val(color));

  return Val_bool(r);
}

CAMLprim value ml_characterRGBA(value dst,value p,value ch,value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect rect;
  SDL_Color c;
  int r;

  SDLRect_of_value(&rect,p);
  SDLColor_of_value(&c,col);
  r=characterRGBA(sur,rect.x,rect.y,(char) ch,c.r,c.g,c.b,Int_val(alpha));

  return Val_bool(r);
}


CAMLprim value ml_stringColor(value dst,value p,value c,value color)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect rect;
  int r;

  SDLRect_of_value(&rect,p);
  r=stringColor(sur,rect.x,rect.y,String_val(c),Int32_val(color));

  return Val_bool(r);
}

CAMLprim value ml_stringRGBA(value dst,value p,value ch,value col,value alpha)
{
  SDL_Surface *sur= SDL_SURFACE(dst);
  SDL_Rect rect;
  SDL_Color c;
  int r;

  SDLRect_of_value(&rect,p);
  SDLColor_of_value(&c,col);
  r=stringRGBA(sur,rect.x,rect.y,String_val(ch),c.r,c.g,c.b,Int_val(alpha));

  return Val_bool(r);
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
