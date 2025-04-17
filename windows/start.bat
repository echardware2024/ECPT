@echo off

python.exe barcode.py
call ftdi.bat
echo.
color 07
echo Confirm serial number then connect the USB to the linux machine.
echo.
echo Done.
pause
