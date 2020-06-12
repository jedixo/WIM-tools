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
if exist %~dp1mnt (
cls
Powershell.exe write-host -foregroundcolor yellow PROC: Previously mounted image found... unmounting and discarding changes...
dism /unmount-image /mountdir:%~dp1mnt\ /discard > %~dp1\log.txt
RD %~dp1mnt /S /Q)
md %~dp1mnt
cls
Powershell.exe write-host -foregroundcolor yellow PROC: Mounting .WIM Image...
dism /mount-image /imagefile:%1 /index:1 /mountdir:%~dp1mnt\ > %~dp1\log.txt
cls

:selectPackage
cls
Powershell.exe write-host -foregroundcolor cyan Drag an pacakge file onto this window to apply package, or press x to Exit... 
set /p PackageDir= 
if %PackageDir% EQU x goto exit
echo %PackageDir%|find ".cab" >nul
if errorlevel 1 (echo.) else goto addPackage
echo %PackageDir%|find ".msu" >nul
if errorlevel 1 (echo.) else goto addPackage
goto selectPackage

:addPackage
Powershell.exe write-host -foregroundcolor yellow PROC: Adding package to mounted image...
dism /add-package /image:%~dp1mnt\ /packagepath:%PackageDir% >> %~dp1\log.txt
goto selectPackage

:exit
cls
Powershell.exe write-host -foregroundcolor yellow PROC: Unmounting Image and saving changes...
dism /unmount-image /mountdir:%~dp1mnt\ /commit >> %~dp1\log.txt
if exist %~dp1mnt (RD %~dp1mnt /S /Q)
Powershell.exe write-host -foregroundcolor cyan DONE: Press any key to exit . . .
pause>nul