pub usingnamespace @import("std").os.windows;

pub const HWND = HANDLE;
pub const WPARAM = UINT_PTR;
pub const LPARAM = LONG_PTR;
pub const LRESULT = *LONG;
pub const HICON = HANDLE;
pub const HCURSOR = HICON;
pub const HBRUSH = HANDLE;
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