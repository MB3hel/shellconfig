// From https://github.com/Krzysiu/cmdwinutils/blob/main/recycler.c
/*
 * MIT License
 * 
 * Copyright (c) 2024 Krzysiu
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 * 
 */

#include <windows.h>
#include <shellapi.h>  
#include <stdio.h>

int moveToRecycleBin(const wchar_t* filePath) {
    SHFILEOPSTRUCTW fileOp;
    wchar_t pathBuffer[MAX_PATH];

    wcsncpy(pathBuffer, filePath, MAX_PATH - 1);
    pathBuffer[MAX_PATH - 1] = L'\0';
    pathBuffer[wcslen(pathBuffer) + 1] = L'\0'; // Double null termination

    ZeroMemory(&fileOp, sizeof(fileOp));
    fileOp.wFunc = FO_DELETE;
    fileOp.pFrom = pathBuffer;
    fileOp.fFlags = FOF_NOCONFIRMATION | FOF_SILENT | FOF_ALLOWUNDO;

    int result = SHFileOperationW(&fileOp);
    if (result != 0) {
        printf("Failed to delete file. Error code: %d\n", result);
        return 1;
    } else {
    // optional message on success
    }

    return 0;
}

int wmain(int argc, wchar_t* argv[]) {
    if (argc != 2) {
        printf("recycler.exe v0.0.1\n(C) 2024, krzysiu.net, MIT license\nMoves file/directory to recycle bin in Windows\nUsage: recycler <file_path>\n");
        return 1;
    }

    return moveToRecycleBin(argv[1]);
}

