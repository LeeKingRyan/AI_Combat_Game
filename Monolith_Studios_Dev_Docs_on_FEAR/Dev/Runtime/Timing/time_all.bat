@echo off
if NOT EXIST FEARXP.exe goto error
call Timing/time_load -archcfg timing/fa-xa.archcfg
call Timing/time_load -archcfg timing/fa-xa.archcfg
call Timing/time_load plain
call Timing/time_load -archcfg timing/fa-xa.archcfg
call Timing/time_load -archcfg timing/fa-xa.archcfg
call Timing/time_load plain
call Timing/time_load plain
call Timing/time_load -archcfg timing/fa-gx.archcfg
call Timing/time_load -archcfg timing/fa-gx.archcfg
call Timing/time_load -archcfg timing/fa-xa-gx.archcfg
call Timing/time_load -archcfg timing/fa-xa-gx.archcfg
call Timing/time_load -archcfg timing/fxa-gx.archcfg
call Timing/time_load -archcfg timing/fxa-gx.archcfg
call Timing/time_load -archcfg timing/fa-g.archcfg
call Timing/time_load -archcfg timing/fa-g.archcfg
call Timing/time_load -archcfg timing/fxa-g.archcfg
call Timing/time_load -archcfg timing/fxa-g.archcfg
call Timing/time_load -archcfg timing/fa-xa-g.archcfg
call Timing/time_load -archcfg timing/fa-xa-g.archcfg
call Timing/time_load -archcfg timing/fa-xa.archcfg
call Timing/time_load -archcfg timing/fa-xa.archcfg
call Timing/time_load -archcfg timing/fxa.archcfg
call Timing/time_load -archcfg timing/fxa.archcfg
call Timing/time_load plain
call Timing/time_load -archcfg timing/fa-gx.archcfg
call Timing/time_load -archcfg timing/fa-gx.archcfg
call Timing/time_load plain
call Timing/time_load -archcfg timing/fa-xa-gx.archcfg
call Timing/time_load -archcfg timing/fa-xa-gx.archcfg
call Timing/time_load plain
call Timing/time_load -archcfg timing/fxa-gx.archcfg
call Timing/time_load -archcfg timing/fxa-gx.archcfg
call Timing/time_load plain
call Timing/time_load -archcfg timing/fa-g.archcfg
call Timing/time_load -archcfg timing/fa-g.archcfg
call Timing/time_load plain
call Timing/time_load -archcfg timing/fxa-g.archcfg
call Timing/time_load -archcfg timing/fxa-g.archcfg
call Timing/time_load plain
call Timing/time_load -archcfg timing/fa-xa-g.archcfg
call Timing/time_load -archcfg timing/fa-xa-g.archcfg
call Timing/time_load plain
call Timing/time_load -archcfg timing/fa-xa.archcfg
call Timing/time_load -archcfg timing/fa-xa.archcfg
call Timing/time_load plain
call Timing/time_load -archcfg timing/fxa.archcfg
call Timing/time_load -archcfg timing/fxa.archcfg
goto end
:error
echo Must be run from "runtime" as "Timing\time_all.bat" 
:end
