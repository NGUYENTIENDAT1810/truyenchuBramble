@REM ----------------------------------------------------------------------------
@REM Maven Wrapper Startup Batch script
@REM ----------------------------------------------------------------------------
@IF "%DEBUG%" == "" @ECHO OFF
@SETLOCAL EnableExtensions EnableDelayedExpansion

set MAVEN_CMD_LINE_ARGS=%*
set "BASE_DIR=%~dp0"
set "MAVEN_PROJECTBASEDIR=%BASE_DIR%"

if not "%JAVA_HOME%" == "" (
  set "JAVACMD=%JAVA_HOME%\bin\java.exe"
) else (
  set "JAVACMD=java.exe"
)

"%JAVACMD%" -version >nul 2>&1
if ERRORLEVEL 1 (
  echo Error: JAVA_HOME is not set and no 'java' command could be found in your PATH. >&2
  exit /b 1
)

echo Starting Maven build...
mvn %MAVEN_CMD_LINE_ARGS%
