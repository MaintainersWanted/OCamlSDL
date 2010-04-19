open Sdlvideo

(* Primitives *)

(* pixel *)
external pixelColor : surface -> int -> int -> int32 -> bool = "ml_pixelColor"
external pixelRGBA : surface -> int -> int -> color -> int -> bool = "ml_pixelRGBA"

(* rectangle *)
external rectangleColor : surface -> rect -> rect -> int32 -> bool = "ml_rectangleColor"
external rectangleRGBA : surface -> rect -> rect -> color -> int -> bool = "ml_rectangleRGBA"
external boxColor : surface -> rect -> rect -> int32 -> bool = "ml_boxColor"
external boxRGBA : surface -> rect -> rect -> color -> int -> bool = "ml_boxRGBA"

(* line *)
external lineColor : surface -> rect -> rect -> int32 -> bool = "ml_lineColor"
external lineRGBA : surface -> rect -> rect -> color -> int -> bool = "ml_lineRGBA"

external aalineColor : surface -> rect -> rect -> int32 -> bool = "ml_aalineColor"
external aalineRGBA : surface -> rect -> rect -> color -> int -> bool = "ml_aalineRGBA"

(* circle *)
external circleColor : surface -> rect -> int -> int32 -> bool = "ml_circleColor"
external circleRGBA : surface -> rect -> int -> color -> int -> bool = "ml_circleRGBA"

external aacircleColor : surface -> rect -> int -> int32 -> bool = "ml_aacircleColor"
external aacircleRGBA : surface -> rect -> int -> color -> int -> bool = "ml_aacircleRGBA"

external filledCircleColor : surface -> rect -> int -> int32 -> bool = "ml_filledCircleColor"
external filledCircleRGBA : surface -> rect -> int -> color -> int -> bool = "ml_filledCircleRGBA"


(* ellipse *)
external ellipseColor : surface -> rect -> rect -> int32 -> bool = "ml_ellipseColor"
external ellipseRGBA : surface -> rect -> rect -> color -> int -> bool = "ml_ellipseRGBA"

external aaellipseColor : surface -> rect -> rect -> int32 -> bool = "ml_aaellipseColor"
external aaellipseRGBA : surface -> rect -> rect -> color -> int -> bool = "ml_aaellipseRGBA"

external filledEllipseColor : surface -> rect -> rect -> int32 -> bool = "ml_filledEllipseColor"
external filledEllipseRGBA : surface -> rect -> rect -> color -> int -> bool = "ml_filledEllipseRGBA"

(* text *)

external characterColor : surface -> rect -> char -> int32 -> bool = "ml_characterColor"
external characterRGBA : surface -> rect -> char -> color ->int -> bool = "ml_characterRGBA"
external stringColor : surface -> rect -> string -> int32 -> bool = "ml_stringColor"
external stringRGBA : surface -> rect -> string -> color ->int -> bool = "ml_stringRGBA"
external gfxPrimitivesSetFont : string -> int -> int -> unit = "ml_gfxPrimitivesSetFont"

(* Rotozoom *)

external rotozoomSurface : surface -> float -> float-> bool->surface="ml_rotozoomSurface"
external rotozoomSurfaceXY : surface -> float -> float->float-> bool->surface="ml_rotozoomSurfaceXY"
external zoomSurface : surface -> float -> float -> bool -> surface="ml_zoomSurface"
