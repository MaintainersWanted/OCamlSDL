/* video_flag : tags and macros */
#define MLTAG_SWSURFACE	Val_int(830934505)
#define MLTAG_HWSURFACE	Val_int(556239582)
#define MLTAG_SRCCOLORKEY	Val_int(-122876192)
#define MLTAG_SRCALPHA	Val_int(-961997318)
#define MLTAG_ASYNCBLIT	Val_int(-14289583)
#define MLTAG_ANYFORMAT	Val_int(565310211)
#define MLTAG_HWPALETTE	Val_int(809613100)
#define MLTAG_DOUBLEBUF	Val_int(-786331486)
#define MLTAG_FULLSCREEN	Val_int(-339890629)
#define MLTAG_OPENGL	Val_int(-736685969)
#define MLTAG_OPENGLBLIT	Val_int(708015140)
#define MLTAG_RESIZABLE	Val_int(615032651)
#define MLTAG_NOFRAME	Val_int(-970104788)

extern lookup_info ml_table_video_flag[];
#define Val_video_flag(data) mlsdl_lookup_from_c (ml_table_video_flag, data)
#define Video_flag_val(key) mlsdl_lookup_to_c (ml_table_video_flag, key)
