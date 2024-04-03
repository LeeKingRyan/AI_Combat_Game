@echo off
set GREP=Utilities\grep.exe -i
set SED=Utilities\sed.exe
set TEMPFILE1=c:\userspec.tmp
set TEMPFILE2=c:\userspec2.tmp

rem Check for %P4Port% and set it if unset 
p4 set p4port | %GREP% p4port > nul
If ErrorLevel 1 (
	p4 set p4port=tgssrv-perforce:1666
)

rem Check for valid ticket and if not ask for password until successful login
p4 login -s > nul
:LoginWhileErrorSet
If ErrorLevel 1 (
	p4 login
	Goto LoginWhileErrorSet
)

:CheckUsername
if NOT '%P4USER%'=='' goto CheckJobView
rem P4USER is not set. We don't want to use %USERNAME% because for external
rem users that does not match what the %P4USER% is supposed to be.
echo ERROR: P4USER is not set - please run p4win and setup the appropriate default user. 
goto End

:CheckJobView
echo Checking Perforce JobView
p4 user -o | %GREP% "^JobView" > nul
if errorlevel 1 goto SetJobView
echo Check OK!
goto CheckEmail

:CheckEmail
echo Checking Perforce Email
p4 user -o | %GREP% "^Email:[^a-z]*%P4USER%@timegate.com" > nul
if errorlevel 1 goto SetEmail
echo Check OK!
goto End

:SetJobView
echo Updating JobView
p4 user -o > %TEMPFILE1%
echo JobView: >> %TEMPFILE1%
%SED% "s/JobView:.*/JobView: (status=_new|status=assigned|status=reopened)\&assigned_to=%P4USER%/" %TEMPFILE1% > %TEMPFILE2%
p4 user -i < %TEMPFILE2%
goto CheckEmail

:SetEmail
echo Updating Email
p4 user -o | %SED% "s/Email:.*/Email: %P4USER%@timegate.com/" > %TEMPFILE1%
p4 user -i < %TEMPFILE1%

:End
rem cleanup!
if exist %TEMPFILE1% del %TEMPFILE1%
if exist %TEMPFILE2% del %TEMPFILE2%

if '%1'=='nopause' goto SkipPause 
echo Done.
pause
:SkipPause
