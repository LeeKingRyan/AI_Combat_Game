regsvr32 /u Monolith.NoneEmulation.dll
regsvr32 /u Monolith.SourceControlManager.dll
regsvr32 /u Monolith.AlienBrain7.dll
regsvr32 /u Monolith.Perforce.dll

REM drp031307 - we don't use Perforce.URL.dll
REM regsvr32 /u %SYSTEMROOT%\System32\Monolith.Perforce.URL.dll
REM del /F %SYSTEMROOT%\System32\Monolith.Perforce.URL.dll
