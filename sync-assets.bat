@echo off
rem Sync the tracked frontend assets into a B4J project's Objects\www\assets.
rem Usage (from this folder or any folder): sync-assets.bat <project folder>
rem Example: sync-assets.bat demo
rem The copy is additive: files already present in the target that are not
rem tracked under assets\ are left untouched. B4J serves the project's
rem Objects\www from the web root, never the repository's assets folder itself.
setlocal
if "%~1"=="" (
	echo Usage: sync-assets.bat ^<project folder^>
	exit /b 2
)
set "TARGET=%~1\Objects\www\assets"
if not exist "%~1\Objects" (
	echo PakaiUI: target "%~1" has no Objects folder. Build the project once first.
	exit /b 2
)
rem Resolve the tracked assets relative to this script, not the caller's folder.
set "ASSETS=%~dp0assets"
if not exist "%ASSETS%\css\bootstrap.min.css" (
	echo PakaiUI: cannot find assets\css\bootstrap.min.css beside "%ASSETS%".
	exit /b 2
)
robocopy "%ASSETS%" "%TARGET%" /E /XF README.md res.json /NFL /NDL /NJH /NP /NS /NC
if %ERRORLEVEL% LEQ 7 (
	echo PakaiUI: synced assets into %TARGET%
	endlocal
	exit /b 0
)
echo PakaiUI: robocopy failed with code %ERRORLEVEL%
endlocal
exit /b 1
