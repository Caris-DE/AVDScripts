REM Batch file to accompany Powershell script

REM Run the Powershell script
powershell -ExecutionPolicy Bypass -File "%~dp0PoolHostAgent.ps1"

REM Delete files in the folder

del /Q "%~dp0*.ps1"
del /Q "%~dp0*.exe"
del /Q "%~dp0*.msi"