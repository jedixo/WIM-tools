@echo off
:option
set /p opt=Commit or Discard changes to image?(C/D): 
if %opt% EQU C goto commit
if %opt% EQU c goto commit
if %opt% EQU D goto discard
if %opt% EQU d goto discard
goto option

:commit
DISM /unmount-image /mountdir:%~dp1mnt /commit
goto exit

:discard
DISM /unmount-image /mountdir:%~dp1mnt /discard
goto exit

:exit
rd /S /Q %~dp1mnt