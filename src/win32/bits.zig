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
pub const HGDIOBJ = HANDLE;
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

// Reserved Key Handles.
pub const HKEY_CLASSES_ROOT                = 0x80000000;
pub const HKEY_CURRENT_USER                = 0x80000001;
pub const HKEY_LOCAL_MACHINE               = 0x80000002;
pub const HKEY_USERS                       = 0x80000003;
pub const HKEY_PERFORMANCE_DATA            = 0x80000004;
pub const HKEY_PERFORMANCE_TEXT            = 0x80000050;
pub const HKEY_PERFORMANCE_NLSTEXT         = 0x80000060;
pub const HKEY_CURRENT_CONFIG              = 0x80000005;
pub const HKEY_DYN_DATA                    = 0x80000006;
pub const HKEY_CURRENT_USER_LOCAL_SETTINGS = 0x80000007;

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