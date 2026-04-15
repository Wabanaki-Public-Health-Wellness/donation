@echo off
set DRIVE=%~d0
powershell -NoProfile -ExecutionPolicy Bypass -File "%DRIVE%\User_Files\rawprint.ps1"