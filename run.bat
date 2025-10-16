@echo off
echo Starting EmuBot build...
echo Setting up environment...
set JAVA_HOME=C:\Program Files\Android\Android Studio3\jbr

echo Cleaning project...
call gradlew.bat clean

echo Building project...
call gradlew.bat build

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ BUILD SUCCESSFUL!
    echo.
    echo Project built successfully. APKs are available in:
    echo   - Debug: app\build\outputs\apk\debug\app-debug.apk
    echo   - Release: app\build\outputs\apk\release\app-release.apk
    echo.
) else (
    echo.
    echo ❌ BUILD FAILED!
    echo Please check the error messages above.
    echo.
)

pause