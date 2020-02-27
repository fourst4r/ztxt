usingnamespace @import("bits.zig");

pub extern "advapi32" fn RegOpenKeyExA(
     hKey: HKEY,
   lpSubKey: LPCSTR,
    ulOptions: DWORD,
   samDesired: REGSAM,
    phkResult: PHKEY,
) callconv(.Stdcall) LSTATUS;

pub extern "advapi32" fn RegCreateKeyExA(
                          hKey: HKEY,
                        lpSubKey: LPCSTR,
                         Reserved: DWORD,
                         lpClass: ?LPSTR,
                         dwOptions: DWORD,
                        samDesired: REGSAM,
   lpSecurityAttributes: ?LPSECURITY_ATTRIBUTES,
                         phkResult: PHKEY,
                       lpdwDisposition: ?LPDWORD,
) callconv(.Stdcall) LSTATUS;