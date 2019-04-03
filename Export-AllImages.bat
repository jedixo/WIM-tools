@echo off

 if exist %~dp0scm (RD %~dp0scm /S /Q)
 md %~dp0scm

 for /L %%A IN (1, 1, 25) Do (

echo %1|find ".swm" >nul
if errorlevel 1 (dism /export-image /sourceimageFile:%1 /sourceindex:%%A /destinationimagefile:%~dpn1_index%%A.wim /compress:max > %~dp0scm\%%A.txt) else dism /export-image /sourceimageFile:%1 /swmfile:%~dpn1*.swm /sourceindex:%%A /destinationimagefile:%~dpn1_index%%A.wim /compress:max > %~dp0scm\%%A.txt
 timeout 0 >nul
	Find /i "Error:" "%~dp0scm\%%A.TXT" > nul && (
        goto:next
 ) 
 )
if exist %~dp0scm (RD %~dp0scm /S /Q)
 exit/b

 :next
if exist %~dp0scm (RD %~dp0scm /S /Q)
