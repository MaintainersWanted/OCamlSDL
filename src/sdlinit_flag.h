/* init_flag : tags and macros */
#define MLTAG_TIMER	Val_int(237238181)
#define MLTAG_AUDIO	Val_int(628011190)
#define MLTAG_VIDEO	Val_int(887770203)
#define MLTAG_CDROM	Val_int(-1056317969)
#define MLTAG_JOYSTICK	Val_int(-176721732)
#define MLTAG_NOPARACHUTE	Val_int(516093760)
#define MLTAG_EVENTTHREAD	Val_int(61759044)
#define MLTAG_EVERYTHING	Val_int(283065971)

extern lookup_info ml_table_init_flag[];
#define Val_init_flag(data) mlsdl_lookup_from_c (ml_table_init_flag, data)
#define Init_flag_val(key) mlsdl_lookup_to_c (ml_table_init_flag, key)

