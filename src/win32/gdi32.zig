usingnamespace @import("bits.zig");

pub extern "gdi32" fn GetObject(h: HANDLE, c: INT, pv: LPVOID) callconv(.Stdcall) INT;
pub extern "gdi32" fn GetStockObject(i: INT) callconv(.Stdcall) HGDIOBJ;
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