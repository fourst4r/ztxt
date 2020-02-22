usingnamespace @import("bits.zig");

pub const CW_USEDEFAULT: DWORD = 0x80000000;

// https://docs.microsoft.com/en-us/windows/win32/winmsg/window-styles
pub const WS_OVERLAPPED = 0x00000000;
pub const WS_POPUP = 0x80000000;
pub const WS_CHILD = 0x40000000;
pub const WS_MINIMIZE = 0x20000000;
pub const WS_VISIBLE = 0x10000000;
pub const WS_DISABLED = 0x08000000;
pub const WS_CLIPSIBLINGS = 0x04000000;
pub const WS_CLIPCHILDREN = 0x02000000;
pub const WS_MAXIMIZE = 0x01000000;
pub const WS_BORDER = 0x00800000;
pub const WS_DLGFRAME = 0x00400000;
pub const WS_VSCROLL = 0x00200000;
pub const WS_HSCROLL = 0x00100000;
pub const WS_SYSMENU = 0x00080000;
pub const WS_THICKFRAME = 0x00040000;
pub const WS_GROUP = 0x00020000;
pub const WS_TABSTOP = 0x00010000;
pub const WS_MINIMIZEBOX = 0x00020000;
pub const WS_MAXIMIZEBOX = 0x00010000;
pub const WS_CAPTION = WS_BORDER | WS_DLGFRAME;
pub const WS_TILED = WS_OVERLAPPED;
pub const WS_ICONIC = WS_MINIMIZE;
pub const WS_SIZEBOX = WS_THICKFRAME;
pub const WS_TILEDWINDOW = WS_OVERLAPPEDWINDOW;
pub const WS_OVERLAPPEDWINDOW = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;
pub const WS_POPUPWINDOW = WS_POPUP | WS_BORDER | WS_SYSMENU;
pub const WS_CHILDWINDOW = WS_CHILD;
//Extended Window Styles
pub const WS_EX_DLGMODALFRAME = 0x00000001;
pub const WS_EX_NOPARENTNOTIFY = 0x00000004;
pub const WS_EX_TOPMOST = 0x00000008;
pub const WS_EX_ACCEPTFILES = 0x00000010;
pub const WS_EX_TRANSPARENT = 0x00000020;
pub const WS_EX_MDICHILD = 0x00000040;
pub const WS_EX_TOOLWINDOW = 0x00000080;
pub const WS_EX_WINDOWEDGE = 0x00000100;
pub const WS_EX_CLIENTEDGE = 0x00000200;
pub const WS_EX_CONTEXTHELP = 0x00000400;
pub const WS_EX_RIGHT = 0x00001000;
pub const WS_EX_LEFT = 0x00000000;
pub const WS_EX_RTLREADING = 0x00002000;
pub const WS_EX_LTRREADING = 0x00000000;
pub const WS_EX_LEFTSCROLLBAR = 0x00004000;
pub const WS_EX_RIGHTSCROLLBAR = 0x00000000;
pub const WS_EX_CONTROLPARENT = 0x00010000;
pub const WS_EX_STATICEDGE = 0x00020000;
pub const WS_EX_APPWINDOW = 0x00040000;
pub const WS_EX_OVERLAPPEDWINDOW = (WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE);
pub const WS_EX_PALETTEWINDOW = (WS_EX_WINDOWEDGE | WS_EX_TOOLWINDOW | WS_EX_TOPMOST);
pub const WS_EX_LAYERED = 0x00080000;
pub const WS_EX_NOINHERITLAYOUT = 0x00100000; // Disable inheritence of mirroring by children
pub const WS_EX_LAYOUTRTL = 0x00400000; // Right to left mirroring
pub const WS_EX_COMPOSITED = 0x02000000;
pub const WS_EX_NOACTIVATE = 0x08000000;

// Edit Control Styles
pub const ES_LEFT = 0x0000;
pub const ES_CENTER = 0x0001;
pub const ES_RIGHT = 0x0002;
pub const ES_MULTILINE = 0x0004;
pub const ES_UPPERCASE = 0x0008;
pub const ES_LOWERCASE = 0x0010;
pub const ES_PASSWORD = 0x0020;
pub const ES_AUTOVSCROLL = 0x0040;
pub const ES_AUTOHSCROLL = 0x0080;
pub const ES_NOHIDESEL = 0x0100;
pub const ES_OEMCONVERT = 0x0400;
pub const ES_READONLY = 0x0800;
pub const ES_WANTRETURN = 0x1000;
pub const ES_NUMBER = 0x2000;

// https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-showwindow
pub const SW_SHOWNORMAL = 1;

pub const DialogResult = extern enum {
    ABORT = 3,
    CANCEL = 2,
    CONTINUE = 5,
    IGNORE = 5,
    NO = 7,
    OK = 1,
    RETRY = 4,
    TRYAGAIN = 4,
    YES = 6,
};

pub const MB_ABORTRETRYIGNORE = 0x2;
pub const MB_CANCELTRYCONTINUE = 0x2;
pub const MB_HELP = 0x4000;
pub const MB_OK = 0x0;
pub const MB_OKCANCEL = 0x1;
pub const MB_RETRYCANCEL = 0x5;
pub const MB_YESNO = 0x4;
pub const MB_YESNOCANCEL = 0x3;
pub const MB_ICONASTERISK = 0x40;
pub const MB_ICONERROR = 0x10;
pub const MB_ICONEXCLAMATION = 0x30;
pub const MB_ICONHAND = 0x10;
pub const MB_ICONINFORMATION = 0x40;
pub const MB_ICONQUESTION = 0x20;
pub const MB_ICONSTOP = 0x10;
pub const MB_ICONWARNING = 0x30;
pub const MB_DEFBUTTON1 = 0x0;
pub const MB_DEFBUTTON2 = 0x100;
pub const MB_DEFBUTTON3 = 0x200;
pub const MB_DEFBUTTON4 = 0x300;
pub const MB_APPLMODAL = 0x0;
pub const MB_SYSTEMMODAL = 0x1000;
pub const MB_TASKMODAL = 0x2000;
pub const MB_DEFAULT_DESKTOP_ONLY = 0x20000;
pub const MB_RIGHT = 0x80000;
pub const MB_RTLREADING = 0x100000;
pub const MB_SETFOREGROUND = 0x10000;

pub const CREATESTRUCTA = extern struct {
    lpCreateParams: LPVOID,
    hInstance: HINSTANCE,
    hMenu: HMENU,
    hwndParent: ?HWND,
    cy: INT,
    cx: INT,
    y: INT,
    x: INT,
    style: LONG,
    lpszName: LPCSTR,
    lpszClass: LPCSTR,
    dwExStyle: DWORD,
};

pub const WNDCLASSA = extern struct {
    style: UINT,
    lpfnWndProc: WNDPROC,
    cbClsExtra: INT,
    cbWndExtra: INT,
    hInstance: HINSTANCE,
    hIcon: ?HICON,
    hCursor: ?HCURSOR,
    hbrBackground: ?HBRUSH,
    lpszMenuName: ?LPCSTR,
    lpszClassName: LPCSTR,
};

pub const POINT = extern struct {
    x: LONG,
    y: LONG,
};

pub const MSG = extern struct {
    hwnd: ?HWND,
    message: UINT,
    wParam: WPARAM,
    lParam: LPARAM,
    time: DWORD,
    pt: POINT,
    lPrivate: DWORD,
};
pub const LPMSG = *MSG;

pub const WNDPROC = fn (hWnd: HWND, message: UINT, wParam: WPARAM, lParam: LPARAM) callconv(.Stdcall) ?LRESULT;
pub extern "user32" fn DefWindowProcA(hWnd: HWND, message: UINT, wParam: WPARAM, lParam: LPARAM) callconv(.Stdcall) LRESULT;
pub extern "user32" fn RegisterClassA(lpWndClass: *const WNDCLASSA) callconv(.Stdcall) ATOM;
pub extern "user32" fn CreateWindowExA(dwExStyle: DWORD, lpClassName: LPCSTR, lpWindowName: LPCSTR, dwStyle: DWORD, X: INT, Y: INT, nWidth: INT, nHeight: INT, hWndParent: ?HWND, hMenu: ?HMENU, hInstance: HINSTANCE, lpParam: ?LPVOID) callconv(.Stdcall) ?HWND;
pub extern "user32" fn DestroyWindow(hWnd: HWND) callconv(.Stdcall) BOOL;
pub extern "user32" fn ShowWindow(hWnd: HWND, nCmdShow: INT) callconv(.Stdcall) BOOL;
pub extern "user32" fn UpdateWindow(hWnd: HWND) callconv(.Stdcall) BOOL;
pub extern "user32" fn PostQuitMessage(nExitCode: INT) callconv(.Stdcall) void;
pub extern "user32" fn PostMessageA(hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM) callconv(.Stdcall) BOOL;
pub extern "user32" fn GetMessageA(lpMsg: LPMSG, hWnd: ?HWND, wMsgFilterMin: UINT, wMsgFilterMax: UINT) callconv(.Stdcall) BOOL;
pub extern "user32" fn TranslateMessage(lpMsg: *MSG) callconv(.Stdcall) BOOL;
pub extern "user32" fn DispatchMessageA(lpMsg: *MSG) callconv(.Stdcall) LRESULT;
pub extern "user32" fn MessageBoxA(hWnd: ?HWND, lpText: LPCSTR, lpCaption: ?LPCSTR, uType: UINT) callconv(.Stdcall) DialogResult;
pub extern "user32" fn LoadCursorA(hInstance: HINSTANCE, lpCursorName: LPCSTR) callconv(.Stdcall) HCURSOR;
pub extern "user32" fn CreateMenu() callconv(.Stdcall) HMENU;
pub extern "user32" fn CreatePopupMenu() callconv(.Stdcall) HMENU;
pub extern "user32" fn AppendMenuA(hMenu: HMENU, uFlags: UINT, uIDNewItem: UINT_PTR, lpNewItem: LPCSTR) callconv(.Stdcall) BOOL;
pub extern "user32" fn SetMenu(hWnd: HWND, hMenu: HMENU) callconv(.Stdcall) BOOL;
pub extern "user32" fn InsertMenuItemA(hMenu: HMENU, uItem: UINT, fByPosition: BOOL, lpmi: LPCMENUITEMINFOA) callconv(.Stdcall) BOOL;
pub extern "user32" fn EnableMenuItem(hMenu: HMENU, uIDEnableItem: UINT, uEnable: UINT) callconv(.Stdcall) BOOL;
pub extern "user32" fn GetClientRect(hWnd: HWND, lpRect: LPRECT) callconv(.Stdcall) BOOL;
pub extern "user32" fn GetDlgItem(hWnd: HWND, nIDDlgItem: INT) callconv(.Stdcall) ?HWND;
pub extern "user32" fn SetDlgItemTextA(hDlg: HWND, nIDDlgItem: INT, lpString: LPCSTR) callconv(.Stdcall) BOOL;
pub extern "user32" fn GetDlgItemTextA(hDlg: HWND, nIDDlgItem: INT, lpString: LPCSTR, cchMax: INT) callconv(.Stdcall) UINT;
pub extern "user32" fn SetWindowPos(hWnd: HWND, hWndInsertAfter: ?HWND, X: INT, Y: INT, cx: INT, cy: INT, uFlags: UINT) callconv(.Stdcall) BOOL;
pub extern "user32" fn SetWindowTextA(hWnd: HWND, lpString: LPCSTR) callconv(.Stdcall) BOOL;
pub extern "user32" fn GetWindowTextA(hWnd: HWND, lpString: LPCSTR) callconv(.Stdcall) INT;
pub extern "user32" fn GetWindowTextLengthA(hWnd: HWND) callconv(.Stdcall) INT;

pub const HWND_TOP = @intToPtr(?HWND, 0);
pub const HWND_BOTTOM = @intToPtr(HWND, 1);
pub const HWND_TOPMOST = @intToPtr(HWND, -1);
pub const HWND_NOTOPMOST = @intToPtr(HWND, -2);

pub const SWP_NOSIZE = 0x0001;
pub const SWP_NOMOVE = 0x0002;
pub const SWP_NOZORDER = 0x0004;
pub const SWP_NOREDRAW = 0x0008;
pub const SWP_NOACTIVATE = 0x0010;
pub const SWP_FRAMECHANGED = 0x0020; // The frame changed: send WM_NCCALCSIZE
pub const SWP_SHOWWINDOW = 0x0040;
pub const SWP_HIDEWINDOW = 0x0080;
pub const SWP_NOCOPYBITS = 0x0100;
pub const SWP_NOOWNERZORDER = 0x0200; // Don't do owner Z ordering
pub const SWP_NOSENDCHANGING = 0x0400; // Don't send WM_WINDOWPOSCHANGING
pub const SWP_DRAWFRAME = SWP_FRAMECHANGED;
pub const SWP_NOREPOSITION = SWP_NOOWNERZORDER;
pub const SWP_DEFERERASE = 0x2000;
pub const SWP_ASYNCWINDOWPOS = 0x4000;

// Menu flags for Add/Check/EnableMenuItem()
pub const MF_INSERT = 0x00000000;
pub const MF_CHANGE = 0x00000080;
pub const MF_APPEND = 0x00000100;
pub const MF_DELETE = 0x00000200;
pub const MF_REMOVE = 0x00001000;
pub const MF_BYCOMMAND = 0x00000000;
pub const MF_BYPOSITION = 0x00000400;
pub const MF_SEPARATOR = 0x00000800;
pub const MF_ENABLED = 0x00000000;
pub const MF_GRAYED = 0x00000001;
pub const MF_DISABLED = 0x00000002;
pub const MF_UNCHECKED = 0x00000000;
pub const MF_CHECKED = 0x00000008;
pub const MF_USECHECKBITMAPS = 0x00000200;
pub const MF_STRING = 0x00000000;
pub const MF_BITMAP = 0x00000004;
pub const MF_OWNERDRAW = 0x00000100;
pub const MF_POPUP = 0x00000010;
pub const MF_MENUBARBREAK = 0x00000020;
pub const MF_MENUBREAK = 0x00000040;
pub const MF_UNHILITE = 0x00000000;
pub const MF_HILITE = 0x00000080;
pub const MF_DEFAULT = 0x00001000;
pub const MF_SYSMENU = 0x00002000;
pub const MF_HELP = 0x00004000;
pub const MF_RIGHTJUSTIFY = 0x00004000;
pub const MF_MOUSESELECT = 0x00008000;
pub const MF_END = 0x00000080; // Obsolete -- only used by old RES = files

pub const MFT_STRING = MF_STRING;
pub const MFT_BITMAP = MF_BITMAP;
pub const MFT_MENUBARBREAK = MF_MENUBARBREAK;
pub const MFT_MENUBREAK = MF_MENUBREAK;
pub const MFT_OWNERDRAW = MF_OWNERDRAW;
pub const MFT_RADIOCHECK = 0x00000200;
pub const MFT_SEPARATOR = MF_SEPARATOR;
pub const MFT_RIGHTORDER = 0x00002000;
pub const MFT_RIGHTJUSTIFY = MF_RIGHTJUSTIFY;

// Menu flags for Add/Check/EnableMenuItem()
pub const MFS_GRAYED = 0x00000003;
pub const MFS_DISABLED = MFS_GRAYED;
pub const MFS_CHECKED = MF_CHECKED;
pub const MFS_HILITE = MF_HILITE;
pub const MFS_ENABLED = MF_ENABLED;
pub const MFS_UNCHECKED = MF_UNCHECKED;
pub const MFS_UNHILITE = MF_UNHILITE;
pub const MFS_DEFAULT = MF_DEFAULT;

pub const MENUITEMINFOA = extern struct {
    cbSize: UINT,
    fMask: UINT,
    fType: UINT,
    fState: UINT,
    wID: UINT,
    hSubMenu: HMENU,
    hbmpChecked: HBITMAP,
    hbmpUnchecked: HBITMAP,
    dwItemData: ULONG_PTR,
    dwTypeData: LPSTR,
    cch: UINT,
    hbmpItem: HBITMAP,
};
pub const LPMENUITEMINFOA = *MENUITEMINFOA;
pub const LPCMENUITEMINFOA = *const MENUITEMINFOA;
pub const MIIM_STRING = 0x00000040;

pub const RECT = extern struct {
    left: LONG,
    top: LONG,
    right: LONG,
    bottom: LONG,
};
pub const LPRECT = *RECT;

pub const PAINTSTRUCT = extern struct {
    hdc: HDC,
    fErase: BOOL,
    rcPaint: RECT,
    fRestore: BOOL,
    fIncUpdate: BOOL,
    rgbReserved: [32]BYTE,
};
pub const LPPAINTSTRUCT = *PAINTSTRUCT;

// Paint functions
pub extern "user32" fn BeginPaint(hWnd: HWND, lpPaint: LPPAINTSTRUCT) callconv(.Stdcall) HDC;
pub extern "user32" fn EndPaint(hWnd: HWND, lpPaint: LPPAINTSTRUCT) callconv(.Stdcall) BOOL;
pub extern "user32" fn FillRect(hDC: HDC, lprc: LPRECT, hbr: HBRUSH) callconv(.Stdcall) BOOL;

pub const COLOR_SCROLLBAR = 0;
pub const COLOR_BACKGROUND = 1;
pub const COLOR_DESKTOP = 1;
pub const COLOR_ACTIVECAPTION = 2;
pub const COLOR_INACTIVECAPTION = 3;
pub const COLOR_MENU = 4;
pub const COLOR_WINDOW = 5;
pub const COLOR_WINDOWFRAME = 6;
pub const COLOR_MENUTEXT = 7;
pub const COLOR_WINDOWTEXT = 8;
pub const COLOR_CAPTIONTEXT = 9;
pub const COLOR_ACTIVEBORDER = 10;
pub const COLOR_INACTIVEBORDER = 11;
pub const COLOR_APPWORKSPACE = 12;
pub const COLOR_HIGHLIGHT = 13;
pub const COLOR_HIGHLIGHTTEXT = 14;
pub const COLOR_BTNFACE = 15;
pub const COLOR_3DFACE = 15;
pub const COLOR_BTNSHADOW = 16;
pub const COLOR_3DSHADOW = 16;
pub const COLOR_GRAYTEXT = 17;
pub const COLOR_BTNTEXT = 18;
pub const COLOR_INACTIVECAPTIONTEXT = 19;
pub const COLOR_BTNHIGHLIGHT = 20;
pub const COLOR_3DHIGHLIGHT = 20;
pub const COLOR_3DHILIGHT = 20;
pub const COLOR_BTNHILIGHT = 20;
pub const COLOR_3DDKSHADOW = 21;
pub const COLOR_3DLIGHT = 22;
pub const COLOR_INFOTEXT = 23;
pub const COLOR_INFOBK = 24;

pub const WM_ACTIVATE = 0x0006;
pub const WM_ACTIVATEAPP = 0x001C;
pub const WM_AFXFIRST = 0x0360;
pub const WM_AFXLAST = 0x037F;
pub const WM_APP = 0x8000;
pub const WM_ASKCBFORMATNAME = 0x030C;
pub const WM_CANCELJOURNAL = 0x004B;
pub const WM_CANCELMODE = 0x001F;
pub const WM_CAPTURECHANGED = 0x0215;
pub const WM_CHANGECBCHAIN = 0x030D;
pub const WM_CHANGEUISTATE = 0x0127;
pub const WM_CHAR = 0x0102;
pub const WM_CHARTOITEM = 0x002F;
pub const WM_CHILDACTIVATE = 0x0022;
pub const WM_CLEAR = 0x0303;
pub const WM_CLOSE = 0x0010;
pub const WM_COMMAND = 0x0111;
pub const WM_COMPACTING = 0x0041;
pub const WM_COMPAREITEM = 0x0039;
pub const WM_CONTEXTMENU = 0x007B;
pub const WM_COPY = 0x0301;
pub const WM_COPYDATA = 0x004A;
pub const WM_CREATE = 0x0001;
pub const WM_CTLCOLORBTN = 0x0135;
pub const WM_CTLCOLORDLG = 0x0136;
pub const WM_CTLCOLOREDIT = 0x0133;
pub const WM_CTLCOLORLISTBOX = 0x0134;
pub const WM_CTLCOLORMSGBOX = 0x0132;
pub const WM_CTLCOLORSCROLLBAR = 0x0137;
pub const WM_CTLCOLORSTATIC = 0x0138;
pub const WM_CUT = 0x0300;
pub const WM_DEADCHAR = 0x0103;
pub const WM_DELETEITEM = 0x002D;
pub const WM_DESTROY = 0x0002;
pub const WM_DESTROYCLIPBOARD = 0x0307;
pub const WM_DEVICECHANGE = 0x0219;
pub const WM_DEVMODECHANGE = 0x001B;
pub const WM_DISPLAYCHANGE = 0x007E;
pub const WM_DRAWCLIPBOARD = 0x0308;
pub const WM_DRAWITEM = 0x002B;
pub const WM_DROPFILES = 0x0233;
pub const WM_ENABLE = 0x000A;
pub const WM_ENDSESSION = 0x0016;
pub const WM_ENTERIDLE = 0x0121;
pub const WM_ENTERMENULOOP = 0x0211;
pub const WM_ENTERSIZEMOVE = 0x0231;
pub const WM_ERASEBKGND = 0x0014;
pub const WM_EXITMENULOOP = 0x0212;
pub const WM_EXITSIZEMOVE = 0x0232;
pub const WM_FONTCHANGE = 0x001D;
pub const WM_GETDLGCODE = 0x0087;
pub const WM_GETFONT = 0x0031;
pub const WM_GETHOTKEY = 0x0033;
pub const WM_GETICON = 0x007F;
pub const WM_GETMINMAXINFO = 0x0024;
pub const WM_GETOBJECT = 0x003D;
pub const WM_GETTEXT = 0x000D;
pub const WM_GETTEXTLENGTH = 0x000E;
pub const WM_HANDHELDFIRST = 0x0358;
pub const WM_HANDHELDLAST = 0x035F;
pub const WM_HELP = 0x0053;
pub const WM_HOTKEY = 0x0312;
pub const WM_HSCROLL = 0x0114;
pub const WM_HSCROLLCLIPBOARD = 0x030E;
pub const WM_ICONERASEBKGND = 0x0027;
pub const WM_IME_CHAR = 0x0286;
pub const WM_IME_COMPOSITION = 0x010F;
pub const WM_IME_COMPOSITIONFULL = 0x0284;
pub const WM_IME_CONTROL = 0x0283;
pub const WM_IME_ENDCOMPOSITION = 0x010E;
pub const WM_IME_KEYDOWN = 0x0290;
pub const WM_IME_KEYLAST = 0x010F;
pub const WM_IME_KEYUP = 0x0291;
pub const WM_IME_NOTIFY = 0x0282;
pub const WM_IME_REQUEST = 0x0288;
pub const WM_IME_SELECT = 0x0285;
pub const WM_IME_SETCONTEXT = 0x0281;
pub const WM_IME_STARTCOMPOSITION = 0x010D;
pub const WM_INITDIALOG = 0x0110;
pub const WM_INITMENU = 0x0116;
pub const WM_INITMENUPOPUP = 0x0117;
pub const WM_INPUTLANGCHANGE = 0x0051;
pub const WM_INPUTLANGCHANGEREQUEST = 0x0050;
pub const WM_KEYDOWN = 0x0100;
pub const WM_KEYFIRST = 0x0100;
pub const WM_KEYLAST = 0x0108;
pub const WM_KEYUP = 0x0101;
pub const WM_KILLFOCUS = 0x0008;
pub const WM_LBUTTONDBLCLK = 0x0203;
pub const WM_LBUTTONDOWN = 0x0201;
pub const WM_LBUTTONUP = 0x0202;
pub const WM_MBUTTONDBLCLK = 0x0209;
pub const WM_MBUTTONDOWN = 0x0207;
pub const WM_MBUTTONUP = 0x0208;
pub const WM_MDIACTIVATE = 0x0222;
pub const WM_MDICASCADE = 0x0227;
pub const WM_MDICREATE = 0x0220;
pub const WM_MDIDESTROY = 0x0221;
pub const WM_MDIGETACTIVE = 0x0229;
pub const WM_MDIICONARRANGE = 0x0228;
pub const WM_MDIMAXIMIZE = 0x0225;
pub const WM_MDINEXT = 0x0224;
pub const WM_MDIREFRESHMENU = 0x0234;
pub const WM_MDIRESTORE = 0x0223;
pub const WM_MDISETMENU = 0x0230;
pub const WM_MDITILE = 0x0226;
pub const WM_MEASUREITEM = 0x002C;
pub const WM_MENUCHAR = 0x0120;
pub const WM_MENUCOMMAND = 0x0126;
pub const WM_MENUDRAG = 0x0123;
pub const WM_MENUGETOBJECT = 0x0124;
pub const WM_MENURBUTTONUP = 0x0122;
pub const WM_MENUSELECT = 0x011F;
pub const WM_MOUSEACTIVATE = 0x0021;
pub const WM_MOUSEFIRST = 0x0200;
pub const WM_MOUSEHOVER = 0x02A1;
pub const WM_MOUSELAST = 0x020D;
pub const WM_MOUSELEAVE = 0x02A3;
pub const WM_MOUSEMOVE = 0x0200;
pub const WM_MOUSEWHEEL = 0x020A;
pub const WM_MOUSEHWHEEL = 0x020E;
pub const WM_MOVE = 0x0003;
pub const WM_MOVING = 0x0216;
pub const WM_NCACTIVATE = 0x0086;
pub const WM_NCCALCSIZE = 0x0083;
pub const WM_NCCREATE = 0x0081;
pub const WM_NCDESTROY = 0x0082;
pub const WM_NCHITTEST = 0x0084;
pub const WM_NCLBUTTONDBLCLK = 0x00A3;
pub const WM_NCLBUTTONDOWN = 0x00A1;
pub const WM_NCLBUTTONUP = 0x00A2;
pub const WM_NCMBUTTONDBLCLK = 0x00A9;
pub const WM_NCMBUTTONDOWN = 0x00A7;
pub const WM_NCMBUTTONUP = 0x00A8;
pub const WM_NCMOUSEHOVER = 0x02A0;
pub const WM_NCMOUSELEAVE = 0x02A2;
pub const WM_NCMOUSEMOVE = 0x00A0;
pub const WM_NCPAINT = 0x0085;
pub const WM_NCRBUTTONDBLCLK = 0x00A6;
pub const WM_NCRBUTTONDOWN = 0x00A4;
pub const WM_NCRBUTTONUP = 0x00A5;
pub const WM_NCXBUTTONDBLCLK = 0x00AD;
pub const WM_NCXBUTTONDOWN = 0x00AB;
pub const WM_NCXBUTTONUP = 0x00AC;
pub const WM_NCUAHDRAWCAPTION = 0x00AE;
pub const WM_NCUAHDRAWFRAME = 0x00AF;
pub const WM_NEXTDLGCTL = 0x0028;
pub const WM_NEXTMENU = 0x0213;
pub const WM_NOTIFY = 0x004E;
pub const WM_NOTIFYFORMAT = 0x0055;
pub const WM_NULL = 0x0000;
pub const WM_PAINT = 0x000F;
pub const WM_PAINTCLIPBOARD = 0x0309;
pub const WM_PAINTICON = 0x0026;
pub const WM_PALETTECHANGED = 0x0311;
pub const WM_PALETTEISCHANGING = 0x0310;
pub const WM_PARENTNOTIFY = 0x0210;
pub const WM_PASTE = 0x0302;
pub const WM_PENWINFIRST = 0x0380;
pub const WM_PENWINLAST = 0x038F;
pub const WM_POWER = 0x0048;
pub const WM_POWERBROADCAST = 0x0218;
pub const WM_PRINT = 0x0317;
pub const WM_PRINTCLIENT = 0x0318;
pub const WM_QUERYDRAGICON = 0x0037;
pub const WM_QUERYENDSESSION = 0x0011;
pub const WM_QUERYNEWPALETTE = 0x030F;
pub const WM_QUERYOPEN = 0x0013;
pub const WM_QUEUESYNC = 0x0023;
pub const WM_QUIT = 0x0012;
pub const WM_RBUTTONDBLCLK = 0x0206;
pub const WM_RBUTTONDOWN = 0x0204;
pub const WM_RBUTTONUP = 0x0205;
pub const WM_RENDERALLFORMATS = 0x0306;
pub const WM_RENDERFORMAT = 0x0305;
pub const WM_SETCURSOR = 0x0020;
pub const WM_SETFOCUS = 0x0007;
pub const WM_SETFONT = 0x0030;
pub const WM_SETHOTKEY = 0x0032;
pub const WM_SETICON = 0x0080;
pub const WM_SETREDRAW = 0x000B;
pub const WM_SETTEXT = 0x000C;
pub const WM_SETTINGCHANGE = 0x001A;
pub const WM_SHOWWINDOW = 0x0018;
pub const WM_SIZE = 0x0005;
pub const WM_SIZECLIPBOARD = 0x030B;
pub const WM_SIZING = 0x0214;
pub const WM_SPOOLERSTATUS = 0x002A;
pub const WM_STYLECHANGED = 0x007D;
pub const WM_STYLECHANGING = 0x007C;
pub const WM_SYNCPAINT = 0x0088;
pub const WM_SYSCHAR = 0x0106;
pub const WM_SYSCOLORCHANGE = 0x0015;
pub const WM_SYSCOMMAND = 0x0112;
pub const WM_SYSDEADCHAR = 0x0107;
pub const WM_SYSKEYDOWN = 0x0104;
pub const WM_SYSKEYUP = 0x0105;
pub const WM_TCARD = 0x0052;
pub const WM_TIMECHANGE = 0x001E;
pub const WM_TIMER = 0x0113;
pub const WM_UNDO = 0x0304;
pub const WM_UNINITMENUPOPUP = 0x0125;
pub const WM_USER = 0x0400;
pub const WM_USERCHANGED = 0x0054;
pub const WM_VKEYTOITEM = 0x002E;
pub const WM_VSCROLL = 0x0115;
pub const WM_VSCROLLCLIPBOARD = 0x030A;
pub const WM_WINDOWPOSCHANGED = 0x0047;
pub const WM_WINDOWPOSCHANGING = 0x0046;
pub const WM_WININICHANGE = 0x001A;
pub const WM_XBUTTONDBLCLK = 0x020D;
pub const WM_XBUTTONDOWN = 0x020B;
pub const WM_XBUTTONUP = 0x020C;