
setlocal enabledelayedexpansion
@echo off
setlocal EnableDelayedExpansion
cd %~dp0
cls
echo **************************************************************************************************************
echo --------------------------------------------------------------------------------------------------------------
echo                                Windows Install USB Update ^& Creation Tool
echo                                              By: Jake DIxon
echo --------------------------------------------------------------------------------------------------------------
echo **************************************************************************************************************
echo.
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
echo **************************************************************************************************************
echo --------------------------------------------------------------------------------------------------------------
echo                                Windows Install USB Update ^& Creation Tool
echo                                              By: Jake DIxon
echo --------------------------------------------------------------------------------------------------------------
echo **************************************************************************************************************
echo.
Powershell.exe write-host -foregroundcolor cyan INFO: Ensure all image files are placed in the images folder for processing.
echo.
Powershell.exe write-host -foregroundcolor cyan Press any key to continue . . .
pause>nul
rmdir output /s /q
mkdir output
sources\uharc.exe x -toutput\ -y+ sources\sources.uha
set selection=0
cd images
FOR %%I in ("*") DO (
  title %%I
  set a=%%I
  set selection=0
  call :innerLoop
  
)
goto break

:innerLoop:
if !selection! NEQ x (
  
  echo **************************************************************************************************************
  echo --------------------------------------------------------------------------------------------------------------
  echo                                Windows Install USB Update ^& Creation Tool
  echo                                              By: Jake DIxon
  echo --------------------------------------------------------------------------------------------------------------
  echo **************************************************************************************************************
  dism /get-imageinfo /imagefile:!a!
  echo.
  Powershell.exe write-host -foregroundcolor cyan Select an index of an Image that you would like to extract or press x to goto next image: 
  set /p selection=
  if !selection! NEQ x ( 
    cls
    echo **************************************************************************************************************
    echo --------------------------------------------------------------------------------------------------------------
    echo                                Windows Install USB Update ^& Creation Tool
    echo                                              By: Jake DIxon
    echo --------------------------------------------------------------------------------------------------------------
    echo **************************************************************************************************************
    echo.
    Powershell.exe write-host -foregroundcolor yellow PROC: Extracting Image to new Install.wim, this can take a while...
    dism /export-image /sourceimageFile:%~dp0\images\!a! /sourceindex:!selection! /destinationimagefile:%~dp0\output\sources\install.wim /compress:max
    goto innerloop  
   )
) ELSE (
  set selection=0
)
exit /b

:break
if exist %~dp0scm (RD %~dp0scm /S /Q)
md %~dp0scm
cls
echo **************************************************************************************************************
echo --------------------------------------------------------------------------------------------------------------
echo                                Windows Install USB Update ^& Creation Tool
echo                                              By: Jake DIxon
echo --------------------------------------------------------------------------------------------------------------
echo **************************************************************************************************************
echo.
Powershell.exe write-host -foregroundcolor yellow PROC: Installing any applicable packages from Updates folder onto images
Powershell.exe write-host -foregroundcolor cyan INFO: This can take a long time...
for /L %%A IN (1, 1, 25) Do (
  set b=%%A
  call :innerloop2
)
goto break2

:innerLoop2:
if exist %~dp0mnt (RD %~dp0mnt /S /Q)
md %~dp0mnt
dism /mount-image /imagefile:%~dp0\output\sources\install.wim /index:!b! /mountdir:%~dp0mnt\ > %~dp0scm\%%A.txt
dism /add-package /image:%~dp0mnt\ /packagepath:%~dp0\updates\ > %~dp0scm\%%A.txt
dism /unmount-image /mountdir:%~dp0mnt\ /commit > %~dp0scm\%%A.txt
exit /b

:break2
if exist %~dp0scm (RD %~dp0scm /S /Q)
if exist %~dp0mnt (RD %~dp0mnt /S /Q)
cls
echo **************************************************************************************************************
echo --------------------------------------------------------------------------------------------------------------
echo                                Windows Install USB Update ^& Creation Tool
echo                                              By: Jake DIxon
echo --------------------------------------------------------------------------------------------------------------
echo **************************************************************************************************************
echo.
Powershell.exe write-host -foregroundcolor yellow PROC: Splitting Image to allow FAT32 support
dism /split-image /imagefile:%~dp0\output\sources\install.wim /SWMFile:%~dp0\output\sources\install.swm /filesize:4000
del %~dp0\output\sources\install.wim
cd..
cls
echo **************************************************************************************************************
echo --------------------------------------------------------------------------------------------------------------
echo                                Windows Install USB Update ^& Creation Tool
echo                                              By: Jake DIxon
echo --------------------------------------------------------------------------------------------------------------
echo **************************************************************************************************************
echo.
Powershell.exe write-host -foregroundcolor green DONE: operations have completed. Copy all contents of the output folder to a FAT32 formatted USB
echo.
Powershell.exe write-host -foregroundcolor cyan Press any key to continue . . .
pause>nul

:exit