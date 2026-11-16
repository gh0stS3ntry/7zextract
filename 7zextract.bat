:: To actually include the path expansion character (tilde), I had to give valid numbers; see http://ss64.com/nt/rem.html for bug reference. Also, try call /? for more info.
@REM The %~n0 extracts the name sans extension to use as output folder. If you need full paths, use "%~dpn0". The -y forces overwriting by saying yes to everything. Or use -aoa to overwrite.
@REM Using `x` instead of `e` maintains dir structure (usually what we want)
@REM The optional 2nd argument is the archive password (applied to every archive). Wrap it in quotes if it contains
@REM spaces or cmd special characters (& | < > ^). Passwords containing % or " are not supported.

@setlocal

:: Build the password argument only when one was given; without -p, 7z behaves as before (prompts if encrypted).
@set "PWARG="
@set "PWSHOW="
@if not "%~2"=="" (
    @set PWARG=-p"%~2"
    @set PWSHOW=-p"****"
)

:: If you want recursive, use FOR /R
@FOR /R %%a IN (*.zip) DO @(
    @if [%1] EQU [/y] (
        @7z x "%%a" -o"%%~dpna" -aoa %PWARG%
    ) else if [%1] EQU [/yd] (
        @7z x "%%a" -o"%%~dpna" -aoa %PWARG%
        @if errorlevel 1 (
            @echo There was an error so I won't delete
        ) else (
            REM You can also prompt with del /p
            @del "%%a"
        )
    ) else (
        @echo 7z x "%%a" -o"%%~dpna" -aoa %PWSHOW%
    )
)

@echo USAGE: 7zextract.bat [/y ^| /yd] [password]
@echo   /y  actually do the extraction. /yd extract then delete the zip file. Omit for a dry run.
@echo   password (optional) is passed to 7z for encrypted archives; quote it if it contains spaces.
@endlocal
