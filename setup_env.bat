@echo off
REM Setup environment variables for EmuBot Android development
set JAVA_HOME=%USERPROFILE%\scoop\apps\openjdk17\current
set ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk
set PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\tools;%PATH%

echo Environment setup complete!
echo JAVA_HOME=%JAVA_HOME%
echo ANDROID_HOME=%ANDROID_HOME%
echo.
echo To build the project, run:
echo   gradlew assembleDebug       (for debug build)
echo   gradlew build              (for full build - requires internet)
echo   gradlew tasks              (to see all available tasks)
echo.