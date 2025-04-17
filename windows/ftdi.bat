@echo off
echo SCAN and PROG
"C:\Program Files (x86)\FTDI\FT_Prog\FT_Prog-CmdLine.exe" SCAN PROG 0 .\ftdi.xml
echo SCAN and CYCL
"C:\Program Files (x86)\FTDI\FT_Prog\FT_Prog-CmdLine.exe" SCAN CYCL 0
echo DONE
