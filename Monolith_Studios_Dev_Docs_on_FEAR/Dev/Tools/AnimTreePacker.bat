@echo off

echo animtreepacker -lib %1 -input %2 -gamedir %3
animtreepacker -lib %1 -input %2 -gamedir %3
if errorlevel 1 goto Error
goto End
:Error
if "%4"=="1" goto End
notepad AnimTreePackerError.log
:End
