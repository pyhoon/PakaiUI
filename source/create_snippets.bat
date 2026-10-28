@echo off
setlocal

if "%~1"=="" (
    echo Usage:
    echo    create_snippets.bat file1.bas file2.bas
    pause
    exit /b
)

:nextfile

if "%~1"=="" goto done

set "INPUT=%~1"

REM Create Snippets folder next to the input file
set "OUTDIR=%~dp1Snippets"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"

set "OUTPUT=%OUTDIR%\%~n1.txt"

echo.
echo Processing:
echo    %INPUT%
echo Output:
echo    %OUTPUT%

powershell -NoProfile -ExecutionPolicy Bypass -Command "$lines = @(); $found=$false; Get-Content '%INPUT%' | ForEach-Object { if($found){ $lines += $_ } elseif($_ -match 'Sub (Class|Process)_Globals'){ $found=$true } }; if($lines.Count -gt 0 -and $lines[-1].Trim() -eq 'End Sub'){ $lines = $lines[0..($lines.Count-2)] }; $lines | Set-Content '%OUTPUT%'"

shift
goto nextfile

:done

echo.
echo Finished.
pause