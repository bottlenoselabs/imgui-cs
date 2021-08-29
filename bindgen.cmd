@echo off
setlocal

call:download_C2CS_windows
call:bindgen
EXIT /B %errorlevel%

:exit_if_last_command_failed
if %errorlevel% neq 0 (
    exit %errorlevel%
)
goto:eof

:download_C2CS_windows
if not exist "%~dp0\C2CS.exe" (
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://nightly.link/lithiumtoast/c2cs/workflows/build-test-deploy/develop/win-x64.zip', '%~dp0\win-x64.zip')"
    "C:\Program Files\7-Zip\7z.exe" x "%~dp0\win-x64.zip" -o"%~dp0"
    del "%~dp0\win-x64.zip"
)
goto:eof

:bindgen
%~dp0\C2CS ast -i .\ext\cimgui\cimgui.h -o .\ast\cimgui.json -s .\ext\cimgui -b 64 -s .\ext\cimgui .\ext\cimgui\generator/output
call:exit_if_last_command_failed
%~dp0\C2CS cs -i .\ast\cimgui.json -o .\src\cs\production\imgui-cs\imgui.cs -l "cimgui" -c "imgui" --namespaces "System.Numerics" -g .\ignored.txt -a ^
 "ImWchar -> char" ^
 "ImWchar16 -> char" ^
 "ImWchar32 -> uint" ^
 "ImVec4 -> Vector4" ^
 "ImVec3 -> Vector3" ^
 "ImVec2 -> Vector2" ^
 "ImVec1 -> float" ^
 "ImU64 -> ulong" ^
 "ImU32 -> uint" ^
 "ImU16 -> ushort" ^
 "ImU8 -> byte" ^
 "ImS64 -> long" ^
 "ImS32 -> int" ^
 "ImS16 -> short" ^
 "ImS8 -> sbyte"
call:exit_if_last_command_failed
goto:eof 