const gdi32 = @import("gdi32.zig");
pub usingnamespace @import("std").os.windows;

pub const HWND = HANDLE;
pub const WPARAM = UINT_PTR;
pub const LPARAM = LONG_PTR;
pub const LRESULT = *LONG;
pub const HICON = HANDLE;
pub const HCURSOR = HICON;
pub const HBRUSH = HANDLE;
pub const HFONT = HANDLE;
pub const HMENU = HANDLE;
pub const HDC = HANDLE;
pub const HBITMAP = HANDLE;
pub const ATOM = WORD;
pub const UINT_PTR = DWORD_PTR;
pub const LONG_PTR = isize;
pub const COLORREF = DWORD;
pub const LPCOLORREF = *DWORD;
pub inline fn RGB(r: u8, g: u8, b: u8) COLORREF {
    return @intCast(u32, b) << 16 | @intCast(u32, g) << 8 | r;
}

pub const NONCLIENTMETRICSA = extern struct {
       cbSize: UINT,
        iBorderWidth: INT,
        iScrollWidth: INT,
        iScrollHeight: INT,
        iCaptionWidth: INT,
        iCaptionHeight: INT,
   lfCaptionFont: gdi32.LOGFONTA,
        iSmCaptionWidth: INT,
        iSmCaptionHeight: INT,
   lfSmCaptionFont: gdi32.LOGFONTA,
        iMenuWidth: INT,
        iMenuHeight: INT,
   lfMenuFont: gdi32.LOGFONTA,
   lfStatusFont: gdi32.LOGFONTA,
   lfMessageFont: gdi32.LOGFONTA,
        iPaddedBorderWidth: INT,
};