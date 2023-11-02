@echo off

setlocal

set GITHUB_RELEASE_URL=https://github.com/username/repo/releases/latest
set TEMP_DIR=%TEMP%\jsonataxls

echo Downloading release from %GITHUB_RELEASE_URL%...
curl -L %GITHUB_RELEASE_URL% -o %TEMP_DIR%\release.zip

echo Extracting release to %TEMP_DIR%...
powershell -Command "Expand-Archive -Path %TEMP_DIR%\release.zip -DestinationPath %TEMP_DIR%"

echo Copying DLL and XLSM files to AddIns folder...
copy /Y %TEMP_DIR%\*.dll "%APPDATA%\Microsoft\AddIns"
copy /Y %TEMP_DIR%\*.xlsm "%APPDATA%\Microsoft\AddIns"

echo Replacing AddIns folder for Roaming user profile...
xcopy /E /Y "%APPDATA%\Microsoft\AddIns" "%USERPROFILE%\AppData\Roaming\Microsoft\AddIns"

echo Adding AddIns folder to user path environment variable...
setx PATH "%PATH%;%USERPROFILE%\AppData\Roaming\Microsoft\AddIns"

echo Cleaning up...
rmdir /S /Q %TEMP_DIR%

echo Done.
