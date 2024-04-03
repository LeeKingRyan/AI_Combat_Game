@echo off
echo Running: %1 %2 %3 %4 
fearxp %1 %2 %3 %4 +windowed 1 +displayasserts 0 +runworld worlds\working\sub_fp_demo 
REM if you have enabled TGD_TIME_LOAD in ScreenPostload.cpp, results will be appended to "time.log"
