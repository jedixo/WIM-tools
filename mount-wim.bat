@echo off
mkdir %~dp1mnt
set /p index=Enter index of Image to mount (Eg. 1): 
DISM /mount-image /imageFile:%1 /index:%index% /mountDir:%~dp1mnt
