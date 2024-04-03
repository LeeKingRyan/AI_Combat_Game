@echo off
rem nmn021306 - Moved to Tools and fixed paths for commands

cd ..

Call BuildBatchFiles\Helpers\PreOperation.bat NOPERL %1
If ErrorLevel 1 (
  cd Tools
  Exit /B 1
)

if "%1"=="" goto noparam

rem Checks for valid world name
if NOT Exist "Runtime\Game\%1.World00p" (
  echo File Not found.
  echo Usage:
  echo  Run the script file by itself or with an optional world name parameter.
  echo  Make sure to specify the correct path and name relative to the Game folder.
  echo  EX: CreateAsset00Files.bat
  echo  EX: CreateAsset00Files.bat Worlds\Working\LevelNameWithoutExtension
  
  cd Tools
  Exit /B 1
)

cd Runtime

echo.
echo Deleting old Asset00 file
del "Game\%1.Asset00"

echo.
echo Checking out %1.Asset00.
p4 edit "Game\%1.Asset00" > NUL 2>&1

echo.
echo Instructions:
echo  Play through the level thoroughly to have a complete asset list.

echo.
pause

echo Running a world.
FearXP.exe +runworld %1 +UpdateAssetLists 1
pause

echo.
echo Addding %1.Asset00 if created.
p4 add "Game\%1.Asset00" > NUL 2>&1

echo Reverting %1.Asset00 if unchanged.
p4 revert -a "Game\%1.Asset00" > NUL 2>&1

goto end

rem *************************************************************
rem User specified no parameters
rem *************************************************************

:noparam

cd Runtime

echo.
echo Checking out all Asset00 files that could be updated...
p4 edit ....Asset00 > NUL 2>&1

echo.
echo Deleting all Asset00 files
del /S Game\*.asset00 > NUL 2>&1

echo.
echo Instructions:
echo  Play through any levels that need to have the asset list updated.
echo  If you want to run a specific world, specify the path and name relative
echo  to the Game folder.
echo  EX: CreateAsset00Files.bat Worlds\Working\LevelNameWithoutExtension

echo.
pause

echo Running FEAR.
FearXP.exe +UpdateAssetLists 1 > NUL 2>&1
pause

echo.
echo Adding any newly created Asset00 files to perforce...
rem p4 add ....Asset00 doesn't seem to add the new files
dir /s /b *.Asset00 | p4 -x - add > NUL 2>&1

echo Reverting all unchanged Asset00 files from perforce...
p4 revert -a ....Asset00 > NUL 2>&1

rem *************************************************************
rem Exit
rem *************************************************************

:end

cd ..\Tools

echo Updated asset lists have been added to changelist.

echo.
Call ..\BuildBatchFiles\Helpers\PostOperation.bat %1
