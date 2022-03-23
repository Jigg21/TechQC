@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
(echo Rescan
echo List Disk
echo Select Disk 0
echo List Partition
) |diskpart

:start
set /p choice= Part 4?
echo the %choice%
if %choice% == y goto part4
if %choice% == n goto part3
goto start



:part4
(
echo Select Disk 0
echo Select Partition 4
echo Delete Partition Override
echo Select Partition 3
echo extend
)  | diskpart
echo Deleted partition 4
goto end

:part3
(
echo Select Disk 0
echo List Partition
echo Select Partition 3
echo Delete Partition Override
echo Select Partition 2
echo extend
)  | diskpart
echo Deleted partition 3
goto end



:end
pause
EXIT