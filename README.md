# ParallelBatchScripts
This script iterates through array of parameters and executes `Subroutine.cmd` for each parameter to the maximum `numberOfSubroutines` times in parallel.
Each command-line window has it's own log file that is written to `script.log` after execution finishes.
This script is useful for example when there is need to execute some other long running script with multiple parameters (perhaps multiple directory paths).
