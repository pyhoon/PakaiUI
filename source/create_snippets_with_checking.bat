@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Usage:
    echo    create_snippets_with_checking.bat file1.bas file2.bas
    pause
    exit /b
)

:nextfile
if "%~1"=="" goto done

set "INPUT=%~f1"
if not exist "%INPUT%" (
    echo ERROR: File not found - %INPUT%
    shift
    goto nextfile
)

set "OUTDIR=%~dp1Snippets"
if not exist "%OUTDIR%" mkdir "%OUTDIR%" || (
    echo ERROR: Could not create folder %OUTDIR%
    shift
    goto nextfile
)

set "OUTPUT=%OUTDIR%\%~n1.txt"

echo.
echo Processing: %INPUT%
echo Output:     %OUTPUT%

REM Create a temporary PowerShell script - escape special batch characters
set "PSFILE=%TEMP%\create_snippet_%RANDOM%.ps1"

echo $ErrorActionPreference = 'Stop' > "%PSFILE%"
echo $inputPath = $args[0] >> "%PSFILE%"
echo $outputPath = $args[1] >> "%PSFILE%"
echo $lines = Get-Content -Path $inputPath -ErrorAction Stop >> "%PSFILE%"
echo $idx = $null >> "%PSFILE%"
echo for ($i = 0; $i -lt $lines.Count; $i++) { >> "%PSFILE%"
echo     if ($lines[$i] -match 'Sub (Class^|Process)_Globals') { >> "%PSFILE%"
echo         $idx = $i >> "%PSFILE%"
echo         break >> "%PSFILE%"
echo     } >> "%PSFILE%"
echo } >> "%PSFILE%"
echo if ($idx -ne $null) { >> "%PSFILE%"
echo     $snippet = $lines[($idx + 1) .. ($lines.Count - 1)] >> "%PSFILE%"
echo     if ($snippet.Count -gt 0 -and $snippet[-1].Trim() -eq 'End Sub') { >> "%PSFILE%"
echo         $snippet = $snippet[0 .. ($snippet.Count - 2)] >> "%PSFILE%"
echo     } >> "%PSFILE%"
echo     while ($snippet.Count -gt 0 -and [string]::IsNullOrWhiteSpace($snippet[-1])) { >> "%PSFILE%"
echo         $snippet = $snippet[0 .. ($snippet.Count - 2)] >> "%PSFILE%"
echo     } >> "%PSFILE%"
echo     if ($snippet.Count -gt 0) { >> "%PSFILE%"
echo         [System.IO.File]::WriteAllText($outputPath, ($snippet -join [Environment]::NewLine)) >> "%PSFILE%"
echo     } else { >> "%PSFILE%"
echo         New-Item -Path $outputPath -ItemType File -Force ^| Out-Null >> "%PSFILE%"
echo     } >> "%PSFILE%"
echo     Write-Host "Snippet written." >> "%PSFILE%"
echo } else { >> "%PSFILE%"
echo     Write-Host "Marker not found." >> "%PSFILE%"
echo } >> "%PSFILE%"

powershell -NoProfile -ExecutionPolicy Bypass -File "%PSFILE%" "%INPUT%" "%OUTPUT%"
del "%PSFILE%" 2>nul

if exist "%OUTPUT%" (
    echo Success: %OUTPUT% created.
) else (
    echo ERROR: Output file not created. Check the PowerShell output above.
)

shift
goto nextfile

:done
echo.
echo Finished.
pause