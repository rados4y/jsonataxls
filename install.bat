@echo off
setlocal enabledelayedexpansion

set USER=rados4y
set REPO=jsonataxls
set TEMP_DIR=%TEMP%\jsonataxls
set ADDINS_DIR=%APPDATA%\Microsoft\AddIns

echo Creating temporary directory...
if not exist "!TEMP_DIR!" mkdir "!TEMP_DIR!"

echo Downloading source code of the latest release...
powershell -Command "$releaseInfo = Invoke-RestMethod -Uri 'https://api.github.com/repos/%USER%/%REPO%/releases/latest'; $releaseInfo.tarball_url" > "!TEMP_DIR!\tarball_url.txt"
set /p TAR_URL=<"!TEMP_DIR!\tarball_url.txt"
curl -L "!TAR_URL!" -o "!TEMP_DIR!\source_code.tar.gz"

echo Extracting source code to !TEMP_DIR!...
powershell -Command "Expand-Archive -Path '!TEMP_DIR!\source_code.tar.gz' -DestinationPath '!TEMP_DIR!'"

echo Copying DLL and XLSM files to AddIns folder...
if not exist "!ADDINS_DIR!" mkdir "!ADDINS_DIR!"
copy /Y "!TEMP_DIR!\*.dll" "!ADDINS_DIR!"
copy /Y "!TEMP_DIR!\*.xlsm" "!ADDINS_DIR!"

echo Adding AddIns folder to user path environment variable...
for /f "tokens=*" %%i in ('echo !PATH!') do set OLD_PATH=%%i
setx PATH "!OLD_PATH!;!ADDINS_DIR!" /M

echo Waiting for environment variables to update...
timeout /t 5 /nobreak >nul

echo Cleaning up...
rmdir /S /Q "!TEMP_DIR!"

echo Done.
