@echo off

rem allow versions 3.17 and 3.18
SET PATH=%PATH%;C:\Program Files (x86)\Renesas Electronics\Programming Tools\Renesas Flash Programmer V3.17
SET PATH=%PATH%;C:\Program Files (x86)\Renesas Electronics\Programming Tools\Renesas Flash Programmer V3.18

"RFPV3.Console.exe" .\P115.rpj

echo Result Code should be zero (0): %ErrorLevel%

rem removed for all.bat
rem timeout 60
