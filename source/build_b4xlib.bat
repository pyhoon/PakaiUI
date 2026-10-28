@echo off
REM Build PakaiUI.b4xlib from the library sources.
REM A .b4xlib is a zip archive that contains .bas modules plus manifest.txt.
setlocal
if "%JAVABIN%"=="" set JAVABIN=C:\Java\jdk-19.0.2\bin
if not exist "Objects" mkdir "Objects"
"%JAVABIN%\jar.exe" -cMf "Objects\PakaiUI.b4xlib" PUI.bas manifest.txt LICENSE
if errorlevel 1 (
	echo Build failed.
	exit /b 1
)
echo Built Objects\PakaiUI.b4xlib
