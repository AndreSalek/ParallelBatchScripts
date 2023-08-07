@echo off
REM You can write status logs to %logPath%
set "logName=StatusLog_%subroutineIndex%.log"
set "logPath=%tempPath%\%logName%"

REM Add implementation here
:start
echo Log for executing script >> %logPath%


timeout /t 10
echo All Tasks finished



REM Keep this
goto end

:end
echo ***Subroutine log: %tempPath%\%subroutineIndex%.log*** >> %tempPath%\%subroutineIndex%.log
type %logPath% >> %tempPath%\%subroutineIndex%.log
echo ______________________________________________________________________ >> %tempPath%\%subroutineIndex%.log
goto :eof



