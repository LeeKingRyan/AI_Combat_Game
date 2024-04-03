@echo off

setlocal

set types=model fx world prefab texture mat
set vers=00 01

if '%1'=='setup' goto registry
if '%2'=='' goto usage

rem perforce sometimes doesn't change current working directory for us, so change it
echo Diff: %1 vs %2

cd /D "%~dp0"

goto checkfiles

:registry
rem *************************************************************
rem Sets the perforce registry entries for the diff tool
rem *************************************************************

set pwd="%cd%\DiffLTCFiles.bat"

echo Windows Registry Editor Version 5.00> Helpers\DiffLTCFiles.reg
echo.>> Helpers\DiffLTCFiles.reg
echo [HKEY_CURRENT_USER\Software\Perforce\P4Win\DiffAssocs]>> Helpers\DiffLTCFiles.reg
for %%j in (%types%) do (
  echo Registering %%j00a, %%j00c, %%j01c diff tools with perforce.
  echo "%%j00a"=%pwd% | Helpers\sed "s/\\/\\\\/g">> Helpers\DiffLTCFiles.reg
  echo "%%j00c"=%pwd% | Helpers\sed "s/\\/\\\\/g">> Helpers\DiffLTCFiles.reg
  echo "%%j01c"=%pwd% | Helpers\sed "s/\\/\\\\/g">> Helpers\DiffLTCFiles.reg
)

regedit /s Helpers\DiffLTCFiles.reg

exit /b 0

:usage
rem *************************************************************
rem Display usage information
rem *************************************************************

echo Usage:
echo  DiffLTCFiles.bat setup - sets up registry entries
echo  DiffLTCFiles.bat file1 file2 - diff World00c and Model00c files
echo.
echo  EX: DiffLTCFiles.bat setup
echo  EX: DiffLTCFiles.bat C:\Worlds\File1.World00c C:\Worlds\File2.World00c
echo  EX: DiffLTCFiles.bat C:\Worlds\File1.Model00c C:\Worlds\File2.Model00c
pause
exit /b 1


:checkfiles
rem *************************************************************
rem Check for valid parameters
rem *************************************************************

if NOT Exist %1 (
  echo File %1 Not found.
  goto usage
)

if NOT Exist %2 (
  echo File %2 Not found.
  goto usage
)

rem perforce creates tmp files to test so we can't compare file extensions with each other. 
rem Find out if we're dealing with compressed (c) files or ascii (a) files.
rem Assume both files in the comparison are the same type.

for %%e in (%types%) do (
  for %%v in (%vers%) do (
    if /I '%~x1'=='.%%e%%vc' (
      set ext=%%e%%v
      goto process
    )
    if /I '%~x2'=='.%%e%%vc' (
      set ext=%%e%%v
      goto process
    )
    if /I '%~x1'=='.%%e%%va' (
      set ext=%%e%%v
      goto process_direct
    )
    if /I '%~x2'=='.%%e%%va' (
      set ext=%%e%%v
      goto process_direct
    )
  )
)

echo Bad file types.
goto usage


:process
rem *************************************************************
rem Process files
rem *************************************************************
REM drp042507 - changed extensions since both files could have the same name

echo Creating temp files.
copy /Y %1 "%temp%\%~n1.%ext%1c" > NUL 2>&1
copy /Y %2 "%temp%\%~n2.%ext%2c" > NUL 2>&1

echo Generating %ext%a files
echo - %temp%\%~n1.%ext%a1
start /wait LTC "%temp%\%~n1.%ext%1c" -out "%temp%\%~n1.%ext%a1"
echo - %temp%\%~n2.%ext%a2
start /wait LTC "%temp%\%~n2.%ext%2c" -out "%temp%\%~n2.%ext%a2"

echo Filtering output.

Helpers\grep -v -f "Helpers\DiffLTCFiles-ignore.txt" "%temp%\%~n1.%ext%a1" > "%temp%\%~n1.%ext%b1"
Helpers\grep -v -f "Helpers\DiffLTCFiles-ignore.txt" "%temp%\%~n2.%ext%a2" > "%temp%\%~n2.%ext%b2"

echo Diffing.

Helpers\diff "%temp%\%~n1.%ext%b1" "%temp%\%~n2.%ext%b2" > "%temp%\%~n1-%~n2.txt"

start /wait %temp%\%~n1-%~n2.txt

del "%temp%\%~n1.*"
del "%temp%\%~n2.*"

del "%temp%\%~n1-%~n2.txt"

goto end

:process_direct

echo Diffing.

Helpers\diff %1 %2 > %temp%\%~n1-%~n2.txt

start /wait %temp%\%~n1-%~n2.txt

del %temp%\%~n1-%~n2.txt

:end
rem *************************************************************
rem End of Program
rem *************************************************************

echo Files have been diffed.
