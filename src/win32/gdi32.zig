usingnamespace @import("bits.zig");

pub extern "gdi32" fn GetObject(h: HANDLE, c: INT, pv: LPVOID) callconv(.Stdcall) INT;
pub extern "gdi32" fn GetStockObject(i: INT) callconv(.Stdcall) HGDIOBJ;