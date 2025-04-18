@echo off

echo Version 1.00

python.exe barcode.py

echo.
echo Connect the Renesas Programmer.
PAUSE 
echo.

call P115-cli.bat

echo.
echo Disconnect the Renesas Programmer 5x2.
echo Optional: Cycle power, wait for the LED(s) to illuminate, and wait five more seconds.
PAUSE
echo.

call ftdi.bat
echo.
color 07

echo Confirm the serial number above, then connect the USB to the linux machine to continue.
del ftdi.xml
echo.
echo Done.
pause
