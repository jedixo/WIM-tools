setlocal enabledelayedexpansion
@echo off
setlocal EnableDelayedExpansion
cd %~dp1
cls
Powershell.exe write-host -foregroundcolor yellow PROC: Validating Administrative Rights
ping 127.0.0.1 -n 2 >nul
net session >nul 2>&1
if %errorlevel%== 0 (
Powershell.exe write-host -foregroundcolor green DONE: Success
  
  ping 127.0.0.1 -n 2 >nul
  goto start
) else (
Powershell.exe write-host -foregroundcolor red ERROR: Please run as an Administrator
  echo.
  Powershell.exe write-host -foregroundcolor cyan Press any key to continue . . .
  pause>nul
  goto exit
)

:start
cls
echo.
if exist %~dp1mnt (
dism /unmount-image /mountdir:%~dp1mnt\ /discard > %~dp1\log.txt
RD %~dp1mnt /S /Q)
md %~dp1mnt
dism /mount-image /imagefile:%1 /index:1 /mountdir:%~dp1mnt\ > %~dp1\log.txt
cls

:selectPackage
set /p PackageDir=Drag an pacakge file onto this window to apply package, or press x to Exit... 
if %PackageDir% EQU x goto exit
echo %PackageDir%|find ".cab" >nul
if errorlevel 1 (echo.) else goto addPackage
echo %PackageDir%|find ".msu" >nul
if errorlevel 1 (echo.) else goto addPackage
goto selectPackage

:addPackage
dism /add-package /image:%~dp1mnt\ /packagepath:%PackageDir% > %~dp1\log.txt
goto selectPackage

:exit
dism /unmount-image /mountdir:%~dp1mnt\ /commit > %~dp1\log.txt
if exist %~dp1mnt (RD %~dp1mnt /S /Q)
Powershell.exe write-host -foregroundcolor cyan Press any key to continue . . .
pause>nul