@echo off
setlocal
if "%~3"=="" (
  echo Usage: slice-and-print.cmd model.stl PLA^|ABS voron-v24.local^|voron-v01.local [upload^|print]
  exit /b 2
)

set "STL=%~f1"
set "GCODE=%~dpn1.gcode"
set "MATERIAL=%~2"
set "HOST=%~3"
set "MODE=%~4"
if "%MODE%"=="" set "MODE=upload"

if /i "%MATERIAL%"=="PLA" set "MATERIAL=PLA"
if /i "%MATERIAL%"=="ABS" set "MATERIAL=ABS"
if not "%MATERIAL%"=="PLA" if not "%MATERIAL%"=="ABS" ( echo Material must be PLA or ABS, got: %~2 & exit /b 2 )
set "CONFIG=%~dp0superslicerconfig-%MATERIAL%.ini"

if /i "%HOST%"=="voron-v24.local" set "HOST=voron-v24.local"
if /i "%HOST%"=="voron-v01.local" set "HOST=voron-v01.local"
if not "%HOST%"=="voron-v24.local" if not "%HOST%"=="voron-v01.local" ( echo Printer must be voron-v24.local or voron-v01.local, got: %~3 & exit /b 2 )

if not exist "%STL%" ( echo STL not found: %STL% & exit /b 1 )
if not exist "%CONFIG%" ( echo Config not found: %CONFIG% & exit /b 1 )

echo Slicing with %CONFIG%
superslicer_console.exe --load "%CONFIG%" -g -o "%GCODE%" "%STL%" || exit /b 1
if not exist "%GCODE%" ( echo Slicing produced no G-code & exit /b 1 )

set "PRINT=false"
if /i "%MODE%"=="print" set "PRINT=true"

curl --fail -sS -F "file=@%GCODE%" -F "print=%PRINT%" http://%HOST%/server/files/upload || exit /b 1
echo.
echo Uploaded %GCODE% to %HOST% (material=%MATERIAL%, print=%PRINT%)
