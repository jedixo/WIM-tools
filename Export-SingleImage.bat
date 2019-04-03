@echo off
set /p index=Enter Index of Image to Extract: 
echo %1|find ".swm" >nul
if errorlevel 1 (dism /export-image /sourceimageFile:%1 /sourceindex:%index% /destinationimagefile:%~dpn1_index%index%.wim /compress:max) else dism /export-image /sourceimageFile:%1 /swmfile:%~dpn1*.swm /sourceindex:%index% /destinationimagefile:%~dpn1_index%index%.wim /compress:max