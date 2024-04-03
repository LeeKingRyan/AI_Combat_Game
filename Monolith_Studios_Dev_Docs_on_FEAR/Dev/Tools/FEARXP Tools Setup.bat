@echo off
rem drp012606 - setup a system for running the FEAR XP Tools
rem nmn021306 - added DiffLTCFiles.bat and P4CustomMerge.bat to setup

rem diff tools for World00c and Model00c for perforce
echo Setting up perforce World00c and Model00c diff tools
call DiffLTCFiles.bat setup

rem diff tools for unicode files, (.record)
echo Setting up perforce diff tools for most unicode files
call P4CustomMerge.bat setup

rem drp051807 - merged into External/Mail
echo Running "TimeGate Setup"
cd TimeGate
call "TimeGate Setup.bat" nopause
cd ..

rem MFC/MSVCRT debug DLLs
echo Copying debug runtime DLLs to %WinDir%\System32
cd DLLs
for %%d IN (*.dll) do if not exist %WinDir%\System32\%%d copy %%d %WinDir%\System32\%%d
cd ..

rem source control DLL
echo Setting up SourceControl DLL
call "Monolith COM Install.bat"

echo Setup complete
pause
