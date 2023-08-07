@echo off
::Version=1.1
REM This script utilizes `start` command to execute scripts in parallel

echo Current path: %~dp0
del script.log >nul 2>&1
REM Define global variables
set "currentPath=%~dp0"
set "tempPath=%currentPath%temp"
set /a subroutineIndex=0
set /a numberOfSubroutines=6

REM Create some array to loop through
set "SomeValues=1 2 3 4 5" 

if not exist %tempPath% mkdir %tempPath%
echo nul > script.log

:Main
setlocal enabledelayedexpansion
set /a srCounter=0

REM Loop through array and pass each value to ProcessLoop
for %%A in (%SomeValues%) do (
	call :ProcessLoop %%A
)
set /a subroutineIndex=!subroutineIndex!-1
call :UnfinishedSubroutinesCheck
endlocal

echo Finished subroutines: %subroutineIndex%
call :Cleanup
goto :eof
 
 
 
:ProcessLoop
call :ManageSubroutineLogs

if !srCounter! LSS %numberOfSubroutines% (
	echo Starting subroutine...
	set /a srCounter=!srCounter!+1
	echo Subroutine count: !srCounter!	Index:!subroutineIndex!
	REM In Subroutine.cmd you define what to execute in each cmd instance
	start cmd /c Subroutine.cmd %1
	set /a subroutineIndex=!subroutineIndex!+1
	timeout /t 1 > nul
) else (
	REM When maximum number of subroutines is reached, loop this function
	echo Maximum number of subroutines are running. Retry in 5 seconds...
	timeout /t 5 > nul
	goto ProcessLoop
)
goto :eof

REM Check if there are finished subroutine logs to move and delete
:ManageSubroutineLogs
echo ____________________________________________________
Echo Checking subroutine status.
for /l %%X in (0,1,!subroutineIndex!) do ( 
	if exist "%tempPath%\%%X.log" (
		echo Subroutine with index %%X finished.
		type %tempPath%\%%X.log >> script.log
		del %tempPath%\%%X.log
		set /a srCounter=!srCounter!-1
	)
)
goto :eof

REM Check if all indexes are in script.log (Contains finished indexes of finished subroutines).
:UnfinishedSubroutinesCheck
for /l %%I in (0,1,!subroutineIndex!) do (
	findstr /C:%tempPath%\%%I.log script.log>nul
	if errorlevel 1 (
		REM Index is missing(unfinished), wait and retry
		echo Subroutine with Index %%I not finished. Wait for 5 seconds...
		timeout /t 5 > nul
		call :ManageSubroutineLogs
		goto UnfinishedSubroutinesCheck
	)
)

goto :eof

:Cleanup
echo Cleaning up...
pushd %tempPath%
del /S /Q *>nul
popd
goto :eof


