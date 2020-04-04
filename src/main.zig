const std = @import("std");
const assert = std.debug.assert;
const mem = std.mem;
const Allocator = mem.Allocator;
const fs = std.fs;
const fmt = std.fmt;
const debug = std.debug;

usingnamespace @import("win32.zig");
usingnamespace user32;
usingnamespace comdlg32;
usingnamespace gdi32;

const IDC_MAIN_EDIT = 101;

const ID_NEW_ITEM = 1001;
const ID_OPEN_ITEM = 1002;
const ID_SAVE_ITEM = 1003;
const ID_SAVE_AS_ITEM = 1004;
const ID_EXIT_ITEM = 1005;
const ID_FONT_ITEM = 1006;
const ID_SELECT_REPORT_ITEM = 1007;

const app_name = "ztxt";
const title_fmt = "{} - " ++ app_name;
const default_window_title = "[Untitled] - " ++ app_name;
const max_edit_chars = 32767;

var allocator: *Allocator = undefined;

const max_title_len = max_file_path_len + title_fmt.len;
const max_file_path_len = MAX_PATH - 1;
var open_file_path = [_:0]u8{0} ** max_file_path_len;
var current_font: HFONT = undefined;

fn winAssert(result: BOOL) void {
    if (result == 0) {
        std.debug.panic("/!\\ winAssert failed: {}", .{kernel32.GetLastError()});
    }
}

fn errBox(hwnd: ?HWND, err: anyerror) void {
    var buf = [_:0]u8{0} ** 64;
    _ = fmt.bufPrint(buf[0..], "Error: {}", .{@errorName(err)}) catch "Error"[0..];
    _ = MessageBoxA(hwnd, &buf, null, MB_OK | MB_ICONERROR);
}

fn updateOpenFile(hwnd: HWND, file_path: []const u8) !void {
    mem.copy(u8, open_file_path[0..], file_path);
    var buf = [_:0]u8{0} ** max_title_len;
    _ = try fmt.bufPrint(&buf, title_fmt, .{file_path});
    winAssert(SetWindowTextA(hwnd, &buf));
}

fn openFile(hwnd: HWND, file_path: []const u8) !void {
    const txt = try fs.cwd().readFileAlloc(allocator, file_path, max_edit_chars);
    defer allocator.free(txt);
    // this is gross
    const txtz = try std.cstr.addNullByte(allocator, txt);
    defer allocator.free(txtz);

    try updateOpenFile(hwnd, file_path);

    winAssert(SetDlgItemTextA(hwnd, IDC_MAIN_EDIT, txtz));
}

fn saveFile(hwnd: HWND, file_path: []const u8) anyerror!void {
    const h_edit = GetDlgItem(hwnd, IDC_MAIN_EDIT).?;
    const txt_len = GetWindowTextLengthA(h_edit);

    var buf = try allocator.alloc(u8, @intCast(usize, txt_len+1));
    defer allocator.free(buf);
    buf[buf.len-1] = 0;
    var bufz = buf[0..buf.len-1 :0];

    const recv_len = GetDlgItemTextA(hwnd, IDC_MAIN_EDIT, bufz, txt_len+1);
    if (recv_len == 0) {
        // recv_len being 0 could be an error, or just an empty text box.
        const lastErr = kernel32.GetLastError();
        if (lastErr != .SUCCESS) return (error{Win32Error}).Win32Error;
    }

    if (fs.cwd().writeFile(file_path, buf[0..recv_len])) {
        winAssert(SetDlgItemTextA(hwnd, IDC_MAIN_EDIT, bufz));
    } else |e| {
        errBox(hwnd, e);
    }

    try updateOpenFile(hwnd, file_path);
}

fn MyOPENFILENAMEA(hwnd: HWND, file_path_buffer: [*:0]u8) OPENFILENAMEA {
    var ofn = mem.zeroes(OPENFILENAMEA);
    ofn.lStructSize = @sizeOf(OPENFILENAMEA);
    ofn.hwndOwner = hwnd;
    ofn.lpstrFilter = "Text Files (*.txt)\x00*.txt\x00All Files (*.*)\x00*.*\x00";
    ofn.lpstrFile = file_path_buffer;
    ofn.nMaxFile = MAX_PATH;
    ofn.Flags = OFN_EXPLORER | OFN_FILEMUSTEXIST | OFN_HIDEREADONLY;
    ofn.lpstrDefExt = "txt";
    return ofn;
}

pub fn MainProc(hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM) callconv(.Stdcall) ?LRESULT {
    switch (uMsg) {
        WM_CREATE => {
            const style = WS_CHILD | WS_VISIBLE | WS_VSCROLL | WS_HSCROLL | ES_MULTILINE | ES_AUTOVSCROLL | ES_AUTOHSCROLL;
            const h_edit = CreateWindowExA(WS_EX_STATICEDGE, "EDIT", "", style, 0, 0, 100, 100, hWnd, @intToPtr(HMENU, IDC_MAIN_EDIT), @ptrCast(HINSTANCE, kernel32.GetModuleHandleW(null)), null).?;

            const default_font = CreateFontA(
                0, // height
                0, // width
                0,  // escapement
                0,  // orientation
                FW_NORMAL, // weight
                FALSE, // italic
                FALSE,  // underline
                FALSE, // strikeout
                DEFAULT_CHARSET, // charset
                OUT_OUTLINE_PRECIS, // out precision
                CLIP_DEFAULT_PRECIS, // clip precision
                DRAFT_QUALITY, // quality
                49, // pitch and family
                "Consolas" // face name
            );
            current_font = default_font;
            _ = SendDlgItemMessageA(hWnd, IDC_MAIN_EDIT, WM_SETFONT, @ptrToInt(current_font), TRUE);
            // current_font = CreateFontIndirectA(default_font);
        },
        WM_PAINT => {
            var ps = mem.zeroes(PAINTSTRUCT);
            const hdc = BeginPaint(hWnd, &ps);
            defer winAssert(EndPaint(hWnd, &ps));

            winAssert(FillRect(hdc, &ps.rcPaint, @intToPtr(HBRUSH, COLOR_WINDOW + 1)));
        },
        WM_COMMAND => {
            const lo_word = wParam & 0xFFFF;
            switch (lo_word) {
                // File
                ID_NEW_ITEM => {
                    open_file_path = [_:0]u8{0} ** max_file_path_len;
                    winAssert(SetWindowTextA(hWnd, default_window_title));
                    winAssert(SetDlgItemTextA(hWnd, IDC_MAIN_EDIT, ""));
                },
                ID_OPEN_ITEM => {
                    var file_path = [_:0]u8{0} ** max_file_path_len;
                    var ofn = MyOPENFILENAMEA(hWnd, &file_path);

                    if (GetOpenFileNameA(&ofn) != 0) {
                        openFile(hWnd, mem.spanZ(&file_path)) catch |e| errBox(hWnd, e);
                    } else {
                        // figure out whether they pressed CANCEL or we had an error
                    }
                    
                },
                ID_SAVE_AS_ITEM => {
                    var file_path = [_:0]u8{0} ** max_file_path_len;
                    var ofn = MyOPENFILENAMEA(hWnd, &file_path);

                    if (GetSaveFileNameA(&ofn) != 0) {
                        saveFile(hWnd, mem.spanZ(&file_path)) catch |e| errBox(hWnd, e);
                    } else {
                        // figure out whether they pressed CANCEL or we had an error
                    }
                },
                ID_SAVE_ITEM => {
                    const is_untitled = (mem.len(&open_file_path) == 0);
                    if (is_untitled) {
                        assert(PostMessageA(hWnd, WM_COMMAND, ID_SAVE_AS_ITEM, 0) != 0);
                    } else {
                        saveFile(hWnd, mem.spanZ(&open_file_path)) catch |e| errBox(hWnd, e);
                    }
                },
                ID_EXIT_ITEM => assert(PostMessageA(hWnd, WM_CLOSE, 0, 0) != 0),
                // Format
                ID_FONT_ITEM => {
                    // var default_font = GetStockObject(DEFAULT_GUI_FONT);
                    var ncm = mem.zeroes(NONCLIENTMETRICSA);
                    ncm.cbSize = @sizeOf(NONCLIENTMETRICSA);
                    winAssert(SystemParametersInfoA(SPI_GETNONCLIENTMETRICS, @sizeOf(NONCLIENTMETRICSA), &ncm, 0));

                    // var lf = mem.zeroes(LOGFONTA);
                    //GetObject(default_font, @sizeOf(LOGFONTA), &lf);

                    var cf = mem.zeroes(CHOOSEFONTA);
                    cf.lStructSize = @sizeOf(CHOOSEFONTA);
                    cf.hwndOwner = hWnd;
                    cf.Flags = CF_EFFECTS | CF_INITTOLOGFONTSTRUCT | CF_SCREENFONTS;
                    cf.lpLogFont = &ncm.lfMessageFont;
                    cf.rgbColors = RGB(0, 0, 0);

                    if (ChooseFontA(&cf) != 0) {
                        //   lfHeight: LONG,
                        //   lfWidth: LONG,
                        //   lfEscapement: LONG,
                        //   lfOrientation: LONG,
                        //   lfWeight: LONG,
                        //   lfItalic: BYTE,
                        //   lfUnderline: BYTE,
                        //   lfStrikeOut: BYTE,
                        //   lfCharSet: BYTE,
                        //   lfOutPrecision: BYTE,
                        //   lfClipPrecision: BYTE,
                        //   lfQuality: BYTE,
                        //   lfPitchAndFamily: BYTE,
                        //   lfFaceName: [LF_FACESIZE-1:0]CHAR,
                        debug.warn("{},{},{},{},{},{},{},{}\n", .{
                            cf.lpLogFont.lfHeight,
                            cf.lpLogFont.lfWidth,
                            cf.lpLogFont.lfEscapement,
                            cf.lpLogFont.lfOrientation,
                            cf.lpLogFont.lfWeight,
                            cf.lpLogFont.lfQuality,
                            cf.lpLogFont.lfPitchAndFamily,
                            cf.lpLogFont.lfFaceName,
                            });
                        winAssert(DeleteObject(current_font));
                        current_font = CreateFontIndirectA(cf.lpLogFont).?;
                        _ = SendDlgItemMessageA(hWnd, IDC_MAIN_EDIT, WM_SETFONT, @ptrToInt(current_font), TRUE);
                        // SelectObject(h_edit, current_font);
                    } else {

                    }
                },
                else => std.debug.warn("UNHANDLED={} ", .{lo_word}),
            }
        },
        WM_SIZE => {
            var rc_client = mem.zeroes(RECT);
            winAssert(GetClientRect(hWnd, &rc_client));

            if (GetDlgItem(hWnd, IDC_MAIN_EDIT)) |h_edit| {
                winAssert(SetWindowPos(h_edit, HWND_TOP, 0, 0, rc_client.right, rc_client.bottom, SWP_NOZORDER));
            }
        },
        WM_CLOSE => {
            winAssert(DeleteObject(current_font));
            winAssert(DestroyWindow(hWnd));
        },
        WM_DESTROY => {
            saveSettings();
            PostQuitMessage(0);
        },
        else => return DefWindowProcA(hWnd, uMsg, wParam, lParam),
    }
    return null;
}

fn loadSettings() void {

}

fn saveSettings() void {
    var hkey: HKEY = undefined;
    //const key_exists = (0 == RegCreateKeyExA(HKEY_CURRENT_USER, //registry_key, &hkey));
    //if (key_exists) {

    //} else {

    //}
}

fn createMenu() HMENU {
    const h_menu = CreateMenu();
    var h_submenu = CreatePopupMenu();

    winAssert(AppendMenuA(h_submenu, MF_STRING, ID_NEW_ITEM, "&New"));
    winAssert(AppendMenuA(h_submenu, MF_STRING, ID_OPEN_ITEM, "&Open..."));
    winAssert(AppendMenuA(h_submenu, MF_STRING, ID_SAVE_ITEM, "&Save"));
    winAssert(AppendMenuA(h_submenu, MF_STRING, ID_SAVE_AS_ITEM, "Save &As..."));
    winAssert(AppendMenuA(h_submenu, MF_SEPARATOR, 0, ""));
    winAssert(AppendMenuA(h_submenu, MF_STRING, ID_EXIT_ITEM, "E&xit"));
    winAssert(AppendMenuA(h_menu, MF_STRING | MF_POPUP, @ptrToInt(h_submenu), "&File"));

    h_submenu = CreatePopupMenu();
    winAssert(AppendMenuA(h_submenu, MF_STRING, ID_FONT_ITEM, "&Font..."));
    winAssert(AppendMenuA(h_menu, MF_STRING | MF_POPUP, @ptrToInt(h_submenu), "F&ormat"));

    return h_menu;
}

pub fn main() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    allocator = &arena.allocator;

    // lidl WinMain args
    const hInstance = @ptrCast(HINSTANCE, kernel32.GetModuleHandleW(null));
    const nShowCmd = SW_SHOW;

    // Register the window class
    var wc = mem.zeroes(WNDCLASSA);
    wc.lpfnWndProc = MainProc;
    wc.hInstance = hInstance;
    wc.lpszClassName = app_name;
    winAssert(RegisterClassA(&wc));

    // Create the window
    const hwnd = CreateWindowExA(
        0, // Optional window styles.
        app_name, // Window class
        default_window_title, // Window text
        WS_OVERLAPPEDWINDOW, // Window style
        // Size and position
        @bitCast(c_int, CW_USEDEFAULT), // X
        @bitCast(c_int, CW_USEDEFAULT), // Y
        @bitCast(c_int, CW_USEDEFAULT), // W
        @bitCast(c_int, CW_USEDEFAULT), // H
        null, // Parent window
        createMenu(), // Menu
        hInstance, // Instance handle
        null // Additional application data
    ).?;

    _ = ShowWindow(hwnd, nShowCmd);
    winAssert(UpdateWindow(hwnd));

    // Message loop...
    var msg = mem.zeroes(MSG);
    while (true) {
        const bRet = GetMessageA(&msg, null, 0, 0);
        
        assert(bRet != -1);
        if (bRet == 0) break;

        _ = TranslateMessage(&msg);
        _ = DispatchMessageA(&msg);
    }
}