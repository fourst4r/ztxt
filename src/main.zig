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
const def_window_title = "[Untitled] - " ++ app_name;
const max_edit_chars = 32767;

var allocator: *Allocator = undefined;

const max_title_len = max_file_path_len + title_fmt.len;
const max_file_path_len = MAX_PATH - 1;
var open_file_path = [_:0]u8{0} ** max_file_path_len;

fn errBox(hwnd: ?HWND, err: anyerror) void {
    var buf = [_:0]u8{0} ** 64;
    _ = fmt.bufPrint(buf[0..], "Error: {}", .{@errorName(err)}) catch "Error"[0..];
    _ = MessageBoxA(hwnd, &buf, null, MB_OK | MB_ICONERROR);
}

fn updateOpenFile(hwnd: HWND, file_path: []const u8) !void {
    mem.copy(u8, open_file_path[0..], file_path);
    var buf = [_:0]u8{0} ** max_title_len;
    _ = try fmt.bufPrint(&buf, title_fmt, .{file_path});
    assert(SetWindowTextA(hwnd, &buf) != 0);
}

fn openFile(hwnd: HWND, file_path: []const u8) !void {
    const txt = try fs.cwd().readFileAlloc(allocator, file_path, max_edit_chars);
    defer allocator.free(txt);
    // this is gross
    const txtz = try std.cstr.addNullByte(allocator, txt);
    defer allocator.free(txtz);

    try updateOpenFile(hwnd, file_path);

    assert(SetDlgItemTextA(hwnd, IDC_MAIN_EDIT, txtz) != 0);
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
        assert(SetDlgItemTextA(hwnd, IDC_MAIN_EDIT, bufz) != 0);
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
        },
        WM_PAINT => {
            var ps = mem.zeroes(PAINTSTRUCT);
            const hdc = BeginPaint(hWnd, &ps);
            defer assert(EndPaint(hWnd, &ps) != 0);

            assert(FillRect(hdc, &ps.rcPaint, @intToPtr(HBRUSH, COLOR_WINDOW + 1)) != 0);
        },
        WM_COMMAND => {
            const lo_word = wParam & 0xFFFF;
            switch (lo_word) {
                // File
                ID_NEW_ITEM => {
                    open_file_path = [_:0]u8{0} ** max_file_path_len;
                    assert(SetWindowTextA(hWnd, def_window_title) != 0);
                    assert(SetDlgItemTextA(hWnd, IDC_MAIN_EDIT, "") != 0);
                },
                ID_OPEN_ITEM => {
                    var file_path = [_:0]u8{0} ** max_file_path_len;
                    var ofn = MyOPENFILENAMEA(hWnd, &file_path);

                    if (GetOpenFileNameA(&ofn) != 0) {
                        openFile(hWnd, mem.toSliceConst(u8, &file_path)) catch |e| errBox(hWnd, e);
                    } else {
                        // figure out whether they pressed CANCEL or we had an error
                    }
                    
                },
                ID_SAVE_AS_ITEM => {
                    var file_path = [_:0]u8{0} ** max_file_path_len;
                    var ofn = MyOPENFILENAMEA(hWnd, &file_path);

                    if (GetSaveFileNameA(&ofn) != 0) {
                        saveFile(hWnd, mem.toSliceConst(u8, &file_path)) catch |e| errBox(hWnd, e);
                    } else {
                        // figure out whether they pressed CANCEL or we had an error
                    }
                },
                ID_SAVE_ITEM => {
                    const is_untitled = (mem.len(u8, &open_file_path) == 0);
                    if (is_untitled) {
                        assert(PostMessageA(hWnd, WM_COMMAND, ID_SAVE_AS_ITEM, 0) != 0);
                    } else {
                        saveFile(hWnd, mem.toSliceConst(u8, &open_file_path)) catch |e| errBox(hWnd, e);
                    }
                },
                ID_EXIT_ITEM => assert(PostMessageA(hWnd, WM_CLOSE, 0, 0) != 0),
                // Format
                ID_FONT_ITEM => {
                    var default_font = GetStockObject(DEFAULT_GUI_FONT);
                    var lf = mem.zeroes(LOGFONTA);
                    GetObject(default_font, @sizeOf(LOGFONTA), &lf);

                    var cf = mem.zeroes(CHOOSEFONTA);
                    cf.lStructSize = @sizeOf(CHOOSEFONTA);
                    cf.hwndOwner = hWnd;
                    cf.Flags = CF_EFFECTS | CF_INITTOLOGFONTSTRUCT | CF_SCREENFONTS;
                    cf.lpLogFont = &lf;
                    cf.rgbColors = RGB(0, 0, 0);

                    if (ChooseFontA(&cf) != 0) {

                    } else {

                    }
                },
                else => std.debug.warn("UNHANDLED={} ", .{lo_word}),
            }
        },
        WM_SIZE => {
            var rc_client = mem.zeroes(RECT);
            assert(GetClientRect(hWnd, &rc_client) != 0);

            if (GetDlgItem(hWnd, IDC_MAIN_EDIT)) |h_edit| {
                assert(SetWindowPos(h_edit, HWND_TOP, 0, 0, rc_client.right, rc_client.bottom, SWP_NOZORDER) != 0);
            }
        },
        WM_CLOSE => assert(DestroyWindow(hWnd) != 0),
        WM_DESTROY => PostQuitMessage(0),
        else => return DefWindowProcA(hWnd, uMsg, wParam, lParam),
    }
    return null;
}

fn createMenu() HMENU {
    const h_menu = CreateMenu();
    var h_submenu = CreatePopupMenu();

    assert(AppendMenuA(h_submenu, MF_STRING, ID_NEW_ITEM, "&New") != 0);
    assert(AppendMenuA(h_submenu, MF_STRING, ID_OPEN_ITEM, "&Open...") != 0);
    assert(AppendMenuA(h_submenu, MF_STRING, ID_SAVE_ITEM, "&Save") != 0);
    assert(AppendMenuA(h_submenu, MF_STRING, ID_SAVE_AS_ITEM, "Save &As...") != 0);
    assert(AppendMenuA(h_submenu, MF_SEPARATOR, 0, "") != 0);
    assert(AppendMenuA(h_submenu, MF_STRING, ID_EXIT_ITEM, "&Exit") != 0);
    assert(AppendMenuA(h_menu, MF_STRING | MF_POPUP, @ptrToInt(h_submenu), "&File") != 0);

    h_submenu = CreatePopupMenu();
    assert(AppendMenuA(h_submenu, MF_STRING, ID_FONT_ITEM, "&Font") != 0);
    assert(AppendMenuA(h_menu, MF_STRING | MF_POPUP, @ptrToInt(h_submenu), "F&ormat") != 0);

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
    assert(RegisterClassA(&wc) != 0);

    // Create the window
    const hwnd = CreateWindowExA(
        0, // Optional window styles.
        app_name, // Window class
        def_window_title, // Window text
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
    assert(UpdateWindow(hwnd) != 0);

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