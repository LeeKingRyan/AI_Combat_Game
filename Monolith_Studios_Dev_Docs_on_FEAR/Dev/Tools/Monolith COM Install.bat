@echo off

rem Registers DLLs for use with source control.
rem Whichever DLL is registered *LAST* will be the DLL the applications
rem such as GDBEdit and WorldEdit will use during -silent operation.
rem
rem The last one registered is the default.
rem 

rem Since AlienBrain is not used at TimeGate (and thus the DLL registration would fail),
rem it is not registered here.  The statement has been left in a remark in case there
rem is a need for AlienBrain source control in the future.

rem regsvr32 Monolith.AlienBrain7.dll

echo Registering SourceControlManager
regsvr32 /s Monolith.SourceControlManager.dll
echo Registering Perforce
regsvr32 /s Monolith.Perforce.dll
echo Registering NoneEmulation
regsvr32 /s Monolith.NoneEmulation.dll

REM drp031307 - we don't use "Perforce.URL.dll"
REM xcopy Monolith.Perforce.URL.dll %SYSTEMROOT%\System32\ /I /Y /F /R
REM regsvr32 %SYSTEMROOT%\System32\Monolith.Perforce.URL.dll

