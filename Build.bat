@echo off
setlocal enabledelayedexpansion enableextensions

rem TODO: fetch more variables from variables.h
rem AuthorName, Example skin name, Plugin name (which has to be the same as plugin project name!), 

echo.
echo.
echo "Building Plugin"
echo --------------------

set Plugin=Plugin
set Project=Source\%Plugin%

echo Finding version for plugin
for /f "delims=" %%x in (%Project%\version.h) do ( 
	echo %%x|findstr "PLUGIN_VERSION " >nul 2>&1
	if not errorlevel 1 (
		set Version=%%x
	)
	rem if not x%str1:PLUGIN_VERSION=%==x%str1% echo It contains PLUGIN_VERSION
)

if not DEFINED Version (
		echo Could not find Version
		echo Try running build with version number as first argument to override
		goto END
	)  

set Version=%Version:#define PLUGIN_VERSION =%
set "Version=%Version:*"=%
echo Version found: %Version%

echo.

set ReleaseLocation=Releases\%Version%
if exist "%ReleaseLocation%" echo Release already built for Version %Version%, Aborting & goto END

echo Finding msbuild.exe

SET msbuildLoc="msbuild.exe"
if not exist %msbuildLoc% (
	echo.
	echo Notice: msbuild.exe not in environment variables, falling back to "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\msbuild.exe"
	echo.
	SET msbuildLoc="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\msbuild.exe"
)

if not exist %msbuildLoc% echo ERROR: msbuild.exe not found, searched in %msbuildLoc% & goto END

set MSBUILD=%msbuildLoc% /nologo^
 /p:Configuration=Release^
 /t:rebuild^
 /v:q

echo Building x86 version of plugin
call %MSBUILD% /p:Platform=Win32 /p:IntDir="%~dp0%Project%\Intermediate\Release\x86" /p:OutDir="%~dp0%ReleaseLocation%\x86" /m "Source\SDK-CPP.sln" > "BuildLog.txt"
if not %ERRORLEVEL% == 0 echo   ERROR %ERRORLEVEL%: Build failed & goto END

echo.

echo Building x64 version of plugin
call %MSBUILD% /p:Platform=x64 /p:IntDir="%~dp0%Project%\Intermediate\Release\x64" /p:OutDir="%~dp0%ReleaseLocation%\x64" /m "Source\SDK-CPP.sln" > "BuildLog.txt"
if not %ERRORLEVEL% == 0 echo   ERROR %ERRORLEVEL%: Build failed & goto END

echo Removing build log
del "BuildLog.txt"

echo Packing rmskin:
call "CreateSkinPluginPackage.exe" %Plugin% theAzack9 "%Version%" "Example Skin" "%ReleaseLocation%\%Plugin%.rmskin" "ExampleSkin\\" "%ReleaseLocation%\x86\%Plugin%.dll" "%ReleaseLocation%\x64\%Plugin%.dll"

echo "Finished sucessfully"
:END
pause