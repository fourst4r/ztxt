usingnamespace @import("bits.zig");

pub const LPOFNHOOKPROC = extern fn (Arg1: HWND, Arg2: UINT, Arg3: WPARAM, Arg4: LPARAM) callconv(.Stdcall) UINT_PTR;

pub const EDITMENU = extern struct {
    hmenu: HMENU,
    idEdit: WORD,
    idCut: WORD,
    idCopy: WORD,
    idPaste: WORD,
    idClear: WORD,
    idUndo: WORD,
};
pub const LPEDITMENU = *EDITMENU;

pub const OFN_READONLY = 0x1;
pub const OFN_OVERWRITEPROMPT = 0x2;
pub const OFN_HIDEREADONLY = 0x4;
pub const OFN_NOCHANGEDIR = 0x8;
pub const OFN_SHOWHELP = 0x10;
pub const OFN_ENABLEHOOK = 0x20;
pub const OFN_ENABLETEMPLATE = 0x40;
pub const OFN_ENABLETEMPLATEHANDLE = 0x80;
pub const OFN_NOVALIDATE = 0x100;
pub const OFN_ALLOWMULTISELECT = 0x200;
pub const OFN_EXTENSIONDIFFERENT = 0x400;
pub const OFN_PATHMUSTEXIST = 0x800;
pub const OFN_FILEMUSTEXIST = 0x1000;
pub const OFN_CREATEPROMPT = 0x2000;
pub const OFN_SHAREAWARE = 0x4000;
pub const OFN_NOREADONLYRETURN = 0x8000;
pub const OFN_NOTESTFILECREATE = 0x10000;
pub const OFN_NONETWORKBUTTON = 0x20000;
pub const OFN_NOLONGNAMES = 0x40000; // Force no long names for 4.x modules
pub const OFN_EXPLORER = 0x80000; // New look commdlg
pub const OFN_NODEREFERENCELINKS = 0x100000;
pub const OFN_LONGNAMES = 0x200000; // Force long names for 3.x modules

pub const OPENFILENAMEA = extern struct {
    lStructSize: DWORD,
    hwndOwner: HWND,
    hInstance: HINSTANCE,
    lpstrFilter: LPCSTR,
    lpstrCustomFilter: ?LPSTR,
    nMaxCustFilter: DWORD,
    nFilterIndex: DWORD,
    lpstrFile: LPSTR,
    nMaxFile: DWORD,
    lpstrFileTitle: LPSTR,
    nMaxFileTitle: DWORD,
    lpstrInitialDir: LPCSTR,
    lpstrTitle: LPCSTR,
    Flags: DWORD,
    nFileOffset: WORD,
    nFileExtension: WORD,
    lpstrDefExt: LPCSTR,
    lCustData: LPARAM,
    lpfnHook: ?LPOFNHOOKPROC,
    lpTemplateName: LPCSTR,
    pvReserved: *c_void,
    dwReserved: DWORD,
    FlagsEx: DWORD,
};
pub const LPOPENFILENAMEA = *OPENFILENAMEA;

pub extern "comdlg32" fn GetOpenFileNameA(Arg1: LPOPENFILENAMEA) callconv(.Stdcall) BOOL;
pub extern "comdlg32" fn GetSaveFileNameA(Arg1: LPOPENFILENAMEA) callconv(.Stdcall) BOOL;
pub extern "comdlg32" fn CommDlgExtendedError() callconv(.Stdcall) DWORD;
