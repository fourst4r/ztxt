const std = @import("std");
const assert = std.debug.assert;
const mem = std.mem;
const Allocator = mem.Allocator;
const fs = std.fs;
const fmt = std.fmt;
const cstr = std.cstr;
const debug = std.debug;

usingnamespace @import("win32.zig");
usingnamespace user32;
usingnamespace comdlg32;

const IDC_MAIN_EDIT = 101;

const ID_NEW_ITEM = 1001;
const ID_OPEN_ITEM = 1002;
const ID_SAVE_ITEM = 1003;
const ID_SAVE_AS_ITEM = 1004;
const ID_QUIT_ITEM = 1005;
const ID_SHOW_ALL_ITEM = 1006;
const ID_SELECT_REPORT_ITEM = 1007;

const MAX_PATH_Z = MAX_PATH - 1;

const app_name = "ztxt";
const title_fmt = "{} - " ++ app_name;
const def_window_title = "Untitled - " ++ app_name;
const max_txt_chars = 32767;

var allocator: *Allocator = undefined;
var open_file_path = [_:0]u8{0} ** MAX_PATH_Z;

const win32_error = error.Win32Error;

fn errBox(hwnd: ?HWND, err: anyerror) void {
    var buf = [_:0]u8{0} ** 64;
    _ = fmt.bufPrint(buf[0..], "Error: {}", .{@errorName(err)}) catch "Error"[0..];
    _ = MessageBoxA(hwnd, &buf, null, MB_OK | MB_ICONERROR);
}

fn createMenu(hwnd: HWND) void {
    const h_menu = CreateMenu();
    var h_submenu = CreatePopupMenu();

    assert(AppendMenuA(h_submenu, MF_STRING, ID_NEW_ITEM, "&New") != 0);
    assert(AppendMenuA(h_submenu, MF_STRING, ID_OPEN_ITEM, "&Open...") != 0);
    assert(AppendMenuA(h_submenu, MF_STRING, ID_SAVE_ITEM, "&Save") != 0);
    assert(AppendMenuA(h_submenu, MF_STRING, ID_SAVE_AS_ITEM, "&Save As...") != 0);
    assert(AppendMenuA(h_submenu, MF_STRING, ID_QUIT_ITEM, "&Quit") != 0);
    assert(AppendMenuA(h_menu, MF_STRING | MF_POPUP, @ptrToInt(h_submenu), "&File") != 0);

    h_submenu = CreatePopupMenu();
    assert(AppendMenuA(h_submenu, MF_STRING, ID_SHOW_ALL_ITEM, "Show &All Data") != 0);
    assert(AppendMenuA(h_submenu, MF_STRING, ID_SELECT_REPORT_ITEM, "S&elect report") != 0);
    assert(AppendMenuA(h_menu, MF_STRING | MF_POPUP, @ptrToInt(h_submenu), "&Reports") != 0);

    assert(SetMenu(hwnd, h_menu) != 0);
}

fn updateOpenFile(hwnd: HWND, file_path: []const u8) !void {
    mem.copy(u8, open_file_path[0..], file_path);
    const max_title_len = MAX_PATH_Z + title_fmt.len;
    var buf = [_:0]u8{0} ** max_title_len;
    _ = try fmt.bufPrint(&buf, title_fmt, .{file_path});
    assert(SetWindowTextA(hwnd, &buf) != 0);
}

fn openFile(hwnd: HWND, file_path: []const u8) !void {
    const txt = try fs.cwd().readFileAlloc(allocator, file_path, max_txt_chars);
    defer allocator.free(txt);
    // this is gross
    const txtz = try cstr.addNullByte(allocator, txt);
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
        if (lastErr != .SUCCESS) return win32_error;
    }

    if (fs.cwd().writeFile(file_path, buf[0..recv_len])) {
        assert(SetDlgItemTextA(hwnd, IDC_MAIN_EDIT, bufz) != 0);
    } else |e| {
        errBox(hwnd, e);
    }

    try updateOpenFile(hwnd, file_path);
}

pub fn MainProc(hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM) callconv(.Stdcall) ?LRESULT {
    switch (uMsg) {
        WM_CREATE => {
            createMenu(hWnd);

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
                ID_NEW_ITEM => {
                    assert(SetWindowTextA(hWnd, def_window_title) != 0);
                    assert(SetDlgItemTextA(hWnd, IDC_MAIN_EDIT, "") != 0);
                },
                ID_OPEN_ITEM, ID_SAVE_AS_ITEM => {
                    var file_path = [_:0]u8{0} ** MAX_PATH_Z;
                    var ofn = mem.zeroes(OPENFILENAMEA);
                    ofn.lStructSize = @sizeOf(OPENFILENAMEA);
                    ofn.hwndOwner = hWnd;
                    ofn.lpstrFilter = "Text Files (*.txt)\x00*.txt\x00All Files (*.*)\x00*.*\x00";
                    ofn.lpstrFile = &file_path;
                    ofn.nMaxFile = MAX_PATH;
                    ofn.Flags = OFN_EXPLORER | OFN_FILEMUSTEXIST | OFN_HIDEREADONLY;
                    ofn.lpstrDefExt = "txt";

                    if (lo_word == ID_OPEN_ITEM and GetOpenFileNameA(&ofn) != 0) {
                        openFile(hWnd, mem.toSliceConst(u8, &file_path)) catch |e| errBox(hWnd, e);
                    } else if (lo_word == ID_SAVE_AS_ITEM and GetSaveFileNameA(&ofn) != 0) {
                        saveFile(hWnd, mem.toSliceConst(u8, &file_path)) catch |e| errBox(hWnd, e);
                    } else {
                        const err = CommDlgExtendedError();

                    }
                },
                ID_SAVE_ITEM => {
                    if (mem.len(u8, &open_file_path) == 0) 
                        return null;
                    saveFile(hWnd, mem.toSliceConst(u8, &open_file_path)) catch |e| errBox(hWnd, e);
                },
                ID_QUIT_ITEM => assert(PostMessageA(hWnd, WM_CLOSE, 0, 0) != 0),
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

pub fn main() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    allocator = &arena.allocator;

    // lidl WinMain args
    const hInstance = @ptrCast(HINSTANCE, kernel32.GetModuleHandleW(null));
    const nCmdShow = SW_SHOWNORMAL;

    // Register the window class
    var wc = mem.zeroes(WNDCLASSA);
    wc.lpfnWndProc = MainProc;
    wc.hInstance = hInstance;
    wc.lpszClassName = app_name;

    assert(RegisterClassA(&wc) != 0);

    // Create the window
    const hwnd = CreateWindowExA(0, // Optional window styles.
        app_name, // Window class
        def_window_title, // Window text
        WS_OVERLAPPEDWINDOW, // Window style

        // Size and position
        @bitCast(c_int, CW_USEDEFAULT), @bitCast(c_int, CW_USEDEFAULT), @bitCast(c_int, CW_USEDEFAULT), @bitCast(c_int, CW_USEDEFAULT), null, // Parent window
        null, // Menu
        hInstance, // Instance handle
        null // Additional application data
    ).?;

    _ = ShowWindow(hwnd, nCmdShow);
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
