REM Batch file to accompany Powershell script

REM Run the Powershell script
powershell -ExecutionPolicy Bypass -File "%~dp0PoolHostAgent.ps1"

REM Delete all files in the folder

del /Q "%~dp0*.*"
