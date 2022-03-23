set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

@ECHO OFF
cls
:start
cls
ECHO.
ECHO -------------------------------------------
ECHo 1. QA
ECHO -------------------------------------------
ECHO 'Q' to exit
ECHO.
set choice=
set /p choice=Enter choice: 
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto HELLO1
if '%choice%'=='Q' goto END
if '%choice%'=='q' goto END
ECHO "%choice%" is not valid please try again
ECHO.
goto start

:HELLO1 Run

:Checks Activation
slmgr /xpr

:Sets Time
tzutil /s "Central Standard Time"
net start w32Time
w32tm /resync /nowait
ECHO Time Set



:Opens windows update 8/10
wuapp.exe || start ms-settings:windowsupdate

:Opens Optical Drive
echo Set oWMP = CreateObject("WMPlayer.OCX.7")  >> %temp%\temp.vbs
echo Set colCDROMs = oWMP.cdromCollection       >> %temp%\temp.vbs
echo For i = 0 to colCDROMs.Count-1             >> %temp%\temp.vbs
echo colCDROMs.Item(i).Eject                    >> %temp%\temp.vbs
echo next                                       >> %temp%\temp.vbs
echo oWMP.close                                 >> %temp%\temp.vbs
%temp%\temp.vbs
timeout /t 1
del %temp%\temp.vbs

:Opens Computer Manager
compmgmt.msc

:Opens Task Manager
taskmgr

:Get serial Number
wmic bios get serialnumber
pause

:End
EXIT