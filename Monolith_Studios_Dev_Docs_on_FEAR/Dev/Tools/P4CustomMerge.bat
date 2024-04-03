@echo off

if '%1'=='' goto usage
if '%1'=='setup' goto registry

cd /D "%~dp0"

for %%i in (%*) do (
  for /F %%j in (Helpers\utf16-extensions.txt) do (
    if /i '%%~xi'=='.%%j' (
      set args=-C utf16
      goto end
    )
  )
)

goto end

:registry
rem *************************************************************
rem Sets the perforce registry entries for the diff tool
rem *************************************************************

set pwd="%cd%\P4CustomMerge.bat"

echo Windows Registry Editor Version 5.00> Helpers\P4CustomMerge.reg

echo.>> Helpers\P4CustomMerge.reg
echo [HKEY_CURRENT_USER\Software\Perforce\P4Win\Options]>> Helpers\P4CustomMerge.reg
echo "MergeApp"=%pwd% | Helpers\sed "s/\\/\\\\/g">> Helpers\P4CustomMerge.reg
echo "MergeOptArgs"="%%1 %%2 %%3 %%4">> Helpers\P4CustomMerge.reg
echo "MergeAppInternal"="0">> Helpers\P4CustomMerge.reg

echo.>> Helpers\P4CustomMerge.reg
echo [HKEY_CURRENT_USER\Software\Perforce\P4Win\DiffAssocs]>> Helpers\P4CustomMerge.reg
for /F %%j in (Helpers\utf16-extensions.txt) do (
  echo "%%j"=%pwd% | Helpers\sed "s/\\/\\\\/g">> Helpers\P4CustomMerge.reg
)

regedit /s Helpers\P4CustomMerge.reg

echo Registered P4CustomMerge.bat with perforce.

exit /b 0


:usage
rem *************************************************************
rem Usage information
rem *************************************************************

echo Usage:
echo  P4CustomMerge.bat diffs two files and performs 3 way merge
echo  depending on the number of arguments.  It passes first additional 
echo  parameters to P4Merge to open the file in the correct format.
echo.
echo  EX: P4CustomMerge.bat setup - sets up the registry for perforce
echo  EX: P4CustomMerge.bat file1 file2 [file3 file4]
pause
exit /b 1


:end
start /wait p4merge %args% %1 %2 %3 %4