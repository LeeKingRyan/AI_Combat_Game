@echo off

rem ------------------------------------------
rem setup our vars
rem ------------------------------------------
set FEAR_LOCAL=FEAR_Original.arch00
set FEARA_LOCAL=FEARA_Original.arch00
set FEARL_LOCAL=FEARL_Original.arch00
set FEAR_NETWORK=x:\projects\builds\FEAR\OriginalArchives\FEAR_Original.arch00
set FEARA_NETWORK=x:\projects\builds\FEAR\OriginalArchives\FEARA_Original.arch00
set FEARL_NETWORK=x:\projects\builds\FEAR\OriginalArchives\FEARL_Original.arch00

rem ------------------------------------------
rem check if user has fastload files
rem ------------------------------------------
if not exist %FEAR_LOCAL% goto get
if not exist %FEARA_LOCAL% goto get
if not exist %FEARL_LOCAL% goto get

rem ------------------------------------------
rem verify they're up-to-date
rem ------------------------------------------
call :sizer %FEAR_NETWORK%
set sizeNET=%sizeRESULT%
call :sizer %FEAR_LOCAL%
set sizeLOCAL=%sizeRESULT%
if "%sizeNET%" NEQ "%sizeLOCAL%" goto update

call :sizer %FEARA_NETWORK%
set sizeNET=%sizeRESULT%
call :sizer %FEARA_LOCAL%
set sizeLOCAL=%sizeRESULT%
if "%sizeNET%" NEQ "%sizeLOCAL%" goto update

call :sizer %FEARL_NETWORK%
set sizeNET=%sizeRESULT%
call :sizer %FEARL_LOCAL%
set sizeLOCAL=%sizeRESULT%
if "%sizeNET%" NEQ "%sizeLOCAL%" goto update

rem ------------------------------------------
rem run normally
rem ------------------------------------------
echo Starting with fastload config
start FEARXP2 -archcfg FastLoad.archcfg %1 %2 %3 %4 %5 %6 %7 %8 %9
goto :eof

rem ------------------------------------------
rem user must get the fast load files first
rem ------------------------------------------
:get
echo Error: Original archives were not found.
echo        You must run "Setup Fast Load.bat" 
echo        before using this option.
echo.
pause
goto :eof

rem ------------------------------------------
rem notify user of update, still attempt to run
rem ------------------------------------------
:update
echo Warning: One or more of your files are
echo          out of date.
echo          Please run"Setup Fast Load.bat"
echo          to update your files.
echo.
echo Fast Load will still attempt to run with
echo this warning.
echo.
pause
echo Starting with fastload config
start FEARXP2 -archcfg FastLoad.archcfg %1 %2 %3 %4 %5 %6 %7 %8 %9
echo.
goto :eof

rem ------------------------------------------
rem helper function used to set sizeRESULT to
rem size of file passed in
rem ------------------------------------------
:sizer

set sizeRESULT=%~z1
goto :eof
:: DONE
