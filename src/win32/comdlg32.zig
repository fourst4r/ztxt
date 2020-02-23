usingnamespace @import("bits.zig");

pub const CF_SCREENFONTS            = 0x00000001;
pub const CF_PRINTERFONTS           = 0x00000002;
pub const CF_BOTH                   = (CF_SCREENFONTS | CF_PRINTERFONTS);
pub const CF_SHOWHELP               = 0x00000004;
pub const CF_ENABLEHOOK             = 0x00000008;
pub const CF_ENABLETEMPLATE         = 0x00000010;
pub const CF_ENABLETEMPLATEHANDLE   = 0x00000020;
pub const CF_INITTOLOGFONTSTRUCT    = 0x00000040;
pub const CF_USESTYLE               = 0x00000080;
pub const CF_EFFECTS                = 0x00000100;
pub const CF_APPLY                  = 0x00000200;
pub const CF_ANSIONLY               = 0x00000400;
pub const CF_SCRIPTSONLY            = CF_ANSIONLY;
pub const CF_NOVECTORFONTS          = 0x00000800;
pub const CF_NOOEMFONTS             = CF_NOVECTORFONTS;
pub const CF_NOSIMULATIONS          = 0x00001000;
pub const CF_LIMITSIZE              = 0x00002000;
pub const CF_FIXEDPITCHONLY         = 0x00004000;
pub const CF_WYSIWYG                = 0x00008000; // must also have CF_SCREENFONTS & CF_PRINTERFONTS
pub const CF_FORCEFONTEXIST         = 0x00010000;
pub const CF_SCALABLEONLY           = 0x00020000;
pub const CF_TTONLY                 = 0x00040000;
pub const CF_NOFACESEL              = 0x00080000;
pub const CF_NOSTYLESEL             = 0x00100000;
pub const CF_NOSIZESEL              = 0x00200000;
pub const CF_SELECTSCRIPT           = 0x00400000;
pub const CF_NOSCRIPTSEL            = 0x00800000;
pub const CF_NOVERTFONTS            = 0x01000000;
pub const CF_INACTIVEFONTS          = 0x02000000;

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
  lfFaceName: [LF_FACESIZE]CHAR,
};
pub const LPLOGFONTA = *LOGFONTA;

pub const LPCFHOOKPROC = extern fn (Arg1: HWND, Arg2: UINT, Arg3: WPARAM, Arg4: LPARAM) callconv(.Stdcall) UINT_PTR;

pub const CHOOSEFONTA = extern struct {
            lStructSize: DWORD,
             hwndOwner: HWND,
              hDC: HDC,
       lpLogFont: LPLOGFONTA,
              iPointSize: INT,
            Flags: DWORD,
         rgbColors: COLORREF,
           lCustData: LPARAM,
     lpfnHook: LPCFHOOKPROC,
           lpTemplateName: LPCSTR,
        hInstance: HINSTANCE,
            lpszStyle: LPSTR,
             nFontType: WORD,
             ___MISSING_ALIGNMENT__: WORD,
              nSizeMin: INT,
              nSizeMax: INT,
};
pub const LPCHOOSEFONTA = *CHOOSEFONTA;

pub extern "comdlg32" fn ChooseFontA(lpcf: LPCHOOSEFONTA) callconv(.Stdcall) BOOL;

pub const LPOFNHOOKPROC = extern fn (Arg1: HWND, Arg2: UINT, Arg3: WPARAM, Arg4: LPARAM) callconv(.Stdcall) UINT_PTR;

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
