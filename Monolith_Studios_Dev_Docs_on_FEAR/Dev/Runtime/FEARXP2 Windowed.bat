@echo off

rem !attempt to run with fastload
if exist FEAR_Original.arch00 goto fastload

:normal
start FEARXP2 +windowed 1 %1 %2 %3 %4 %5 %6
goto :eof

:fastload
call "FEARXP2 Fast Load.bat" +windowed 1 %1 %2 %3 %4 %5 %6

:: DONE
