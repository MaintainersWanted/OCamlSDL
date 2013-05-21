open Sdlvideo

(* Primitives *)

type vect = int * int

(* pixel *)

external pixelColor : surface -> int -> int -> int32 -> unit = "ml_pixelColor"
external pixelRGBA : surface -> int -> int -> color -> int -> unit = "ml_pixelRGBA"

(* rectangle *)

external rectangleColor : surface -> vect -> vect -> int32 -> unit = "ml_rectangleColor"
external rectangleRGBA : surface -> vect -> vect -> color -> int -> unit = "ml_rectangleRGBA"

external boxColor : surface -> vect -> vect -> int32 -> unit = "ml_boxColor"
external boxRGBA : surface -> vect -> vect -> color -> int -> unit = "ml_boxRGBA"

(* rounded-rectangle *)

external roundedRectangleColor : surface -> vect -> vect -> int -> int32 -> unit = "ml_roundedRectangleColor"
external roundedRectangleRGBA : surface -> vect -> vect -> int -> color -> int -> unit
  = "ml_roundedRectangleRGBA_bc"
    "ml_roundedRectangleRGBA"

external roundedBoxColor : surface -> vect -> vect -> int -> int32 -> unit = "ml_roundedBoxColor"
external roundedBoxRGBA : surface -> vect -> vect -> int -> color -> int -> unit
  = "ml_roundedBoxRGBA_bc"
    "ml_roundedBoxRGBA"

(* line *)

external lineColor : surface -> vect -> vect -> int32 -> unit = "ml_lineColor"
external lineRGBA : surface -> vect -> vect -> color -> int -> unit = "ml_lineRGBA"

external aalineColor : surface -> vect -> vect -> int32 -> unit = "ml_aalineColor"
external aalineRGBA : surface -> vect -> vect -> color -> int -> unit = "ml_aalineRGBA"

(* thick line *)

external thickLineColor : surface -> vect -> vect -> int -> int32 -> unit = "ml_thickLineColor"
external thickLineRGBA : surface -> vect -> vect -> int -> color -> int -> unit
  = "ml_thickLineRGBA_bc"
    "ml_thickLineRGBA"

(* circle *)

external circleColor : surface -> vect -> int -> int32 -> unit = "ml_circleColor"
external circleRGBA : surface -> vect -> int -> color -> int -> unit = "ml_circleRGBA"

external aacircleColor : surface -> vect -> int -> int32 -> unit = "ml_aacircleColor"
external aacircleRGBA : surface -> vect -> int -> color -> int -> unit = "ml_aacircleRGBA"

external filledCircleColor : surface -> vect -> int -> int32 -> unit = "ml_filledCircleColor"
external filledCircleRGBA : surface -> vect -> int -> color -> int -> unit = "ml_filledCircleRGBA"

(* arc *)

external arcColor : surface -> vect -> int -> int -> int -> int32 -> unit
  = "ml_arcColor_bc" "ml_arcColor"

external arcRGBA : surface -> vect -> int -> int -> int -> color -> int -> unit
  = "ml_arcRGBA_bc" "ml_arcRGBA"

(* ellipse *)

external ellipseColor : surface -> vect -> vect -> int32 -> unit = "ml_ellipseColor"
external ellipseRGBA : surface -> vect -> vect -> color -> int -> unit = "ml_ellipseRGBA"

external aaellipseColor : surface -> vect -> vect -> int32 -> unit = "ml_aaellipseColor"
external aaellipseRGBA : surface -> vect -> vect -> color -> int -> unit = "ml_aaellipseRGBA"

external filledEllipseColor : surface -> vect -> vect -> int32 -> unit = "ml_filledEllipseColor"
external filledEllipseRGBA : surface -> vect -> vect -> color -> int -> unit = "ml_filledEllipseRGBA"

(* text *)

external characterColor : surface -> vect -> char -> int32 -> unit = "ml_characterColor"
external characterRGBA : surface -> vect -> char -> color -> int -> unit = "ml_characterRGBA"
external stringColor : surface -> vect -> string -> int32 -> unit = "ml_stringColor"
external stringRGBA : surface -> vect -> string -> color -> int -> unit = "ml_stringRGBA"
external gfxPrimitivesSetFont : string -> int -> int -> unit = "ml_gfxPrimitivesSetFont"

(* Rotozoom *)

external rotozoomSurface : surface -> float -> float -> bool -> surface = "ml_rotozoomSurface"
external rotozoomSurfaceXY : surface -> float -> float -> float -> bool -> surface = "ml_rotozoomSurfaceXY"
external zoomSurface : surface -> float -> float -> bool -> surface = "ml_zoomSurface"
external shrinkSurface : surface -> float -> float -> surface = "ml_shrinkSurface"
