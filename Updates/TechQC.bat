@Echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )



:timeSet
tzutil /s "Central Standard Time"
net start w32Time
w32tm /resync /nowait
ECHO Time Set
pause

:updates
For %%# in (*.msu) Do (
    Echo: Installing update: %%#
    Wusa "%%#" /quiet /norestart
)
Echo Windows Update finished.
Pause&Exit