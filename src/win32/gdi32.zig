usingnamespace @import("bits.zig");

pub extern "gdi32" fn DeleteObject(ho: HGDIOBJ) callconv(.Stdcall) BOOL;
pub extern "gdi32" fn GetObject(h: HANDLE, c: INT, pv: LPVOID) callconv(.Stdcall) INT;
pub extern "gdi32" fn GetStockObject(i: INT) callconv(.Stdcall) HGDIOBJ;

pub const OUT_DEFAULT_PRECIS =          0;
pub const OUT_STRING_PRECIS =           1;
pub const OUT_CHARACTER_PRECIS =        2;
pub const OUT_STROKE_PRECIS =           3;
pub const OUT_TT_PRECIS =               4;
pub const OUT_DEVICE_PRECIS =           5;
pub const OUT_RASTER_PRECIS =           6;
pub const OUT_TT_ONLY_PRECIS =          7;
pub const OUT_OUTLINE_PRECIS =          8;
pub const OUT_SCREEN_OUTLINE_PRECIS =   9;
pub const OUT_PS_ONLY_PRECIS =          10;

pub const CLIP_DEFAULT_PRECIS =     0;
pub const CLIP_CHARACTER_PRECIS =   1;
pub const CLIP_STROKE_PRECIS =      2;
pub const CLIP_MASK =               0xf;
pub const CLIP_LH_ANGLES =          (1<<4);
pub const CLIP_TT_ALWAYS =          (2<<4);
pub const CLIP_DFA_DISABLE =        (4<<4);
pub const CLIP_EMBEDDED =           (8<<4);

pub const DEFAULT_QUALITY =         0;
pub const DRAFT_QUALITY =           1;
pub const PROOF_QUALITY =           2;
pub const NONANTIALIASED_QUALITY =  3;
pub const ANTIALIASED_QUALITY =     4;
pub const CLEARTYPE_QUALITY =       5;
pub const CLEARTYPE_NATURAL_QUALITY =       6;

pub const DEFAULT_PITCH =           0;
pub const FIXED_PITCH =             1;
pub const VARIABLE_PITCH =          2;
pub const MONO_FONT =               8;

pub const ANSI_CHARSET =            0;
pub const DEFAULT_CHARSET =         1;
pub const SYMBOL_CHARSET =          2;
pub const SHIFTJIS_CHARSET =        128;
pub const HANGEUL_CHARSET =         129;
pub const HANGUL_CHARSET =          129;
pub const GB2312_CHARSET =          134;
pub const CHINESEBIG5_CHARSET =     136;
pub const OEM_CHARSET =             255;
pub const JOHAB_CHARSET =           130;
pub const HEBREW_CHARSET =          177;
pub const ARABIC_CHARSET =          178;
pub const GREEK_CHARSET =           161;
pub const TURKISH_CHARSET =         162;
pub const VIETNAMESE_CHARSET =      163;
pub const THAI_CHARSET =            222;
pub const EASTEUROPE_CHARSET =      238;
pub const RUSSIAN_CHARSET =         204;
pub const MAC_CHARSET =             77;
pub const BALTIC_CHARSET =          186;

// Font Weights
pub const FW_DONTCARE =         0;
pub const FW_THIN =             100;
pub const FW_EXTRALIGHT =       200;
pub const FW_LIGHT =            300;
pub const FW_NORMAL =           400;
pub const FW_MEDIUM =           500;
pub const FW_SEMIBOLD =         600;
pub const FW_BOLD =             700;
pub const FW_EXTRABOLD =        800;
pub const FW_HEAVY =            900;
pub const FW_ULTRALIGHT =       FW_EXTRALIGHT;
pub const FW_REGULAR =          FW_NORMAL;
pub const FW_DEMIBOLD =         FW_SEMIBOLD;
pub const FW_ULTRABOLD =        FW_EXTRABOLD;
pub const FW_BLACK =            FW_HEAVY;

pub extern "gdi32" fn CreateFontA(
      cHeight: INT,
      cWidth: INT,
      cEscapement: INT,
      cOrientation: INT,
      cWeight: INT,
    bItalic: DWORD,
    bUnderline: DWORD,
    bStrikeOut: DWORD,
    iCharSet: DWORD,
    iOutPrecision: DWORD,
    iClipPrecision: DWORD,
    iQuality: DWORD,
    iPitchAndFamily: DWORD,
   pszFaceName: ?LPCSTR,
) callconv(.Stdcall) ?HFONT;
pub extern "gdi32" fn CreateFontIndirectA(lplf: LPCLOGFONTA) callconv(.Stdcall) ?HFONT;

// Logical Font
pub const LF_FACESIZE        = 32;

pub const LOGFONTA = extern struct {
  lfHeight: LONG,
  lfWidth: LONG,
  lfEscapement: LONG,
  lfOrientation: LONG,
  lfWeight: LONG,
  lfItalic: BYTE,
  lfUnderline: BYTE,
  lfStrikeOut: BYTE,
  lfCharSet: BYTE,
  lfOutPrecision: BYTE,
  lfClipPrecision: BYTE,
  lfQuality: BYTE,
  lfPitchAndFamily: BYTE,
  lfFaceName: [LF_FACESIZE-1:0]CHAR,
};
pub const LPLOGFONTA = *LOGFONTA;
pub const LPCLOGFONTA = *const LOGFONTA;