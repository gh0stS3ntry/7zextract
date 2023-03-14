:: To actually include the path expansion character (tilde), I had to give valid numbers; see http://ss64.com/nt/rem.html for bug reference. Also, try call /? for more info.
@REM The %~n0 extracts the name sans extension to use as output folder. If you need full paths, use "%~dpn0". The -y forces overwriting by saying yes to everything. Or use -aoa to overwrite.
@REM Using `x` instead of `e` maintains dir structure (usually what we want)

:: If you want recursive, use FOR /R
@FOR /R %%a IN (*.zip) DO @(
    @if [%1] EQU [/y] (
        @7z x "%%a" -o"%%~dpna" -aoa
    ) else if [%1] EQU [/yd] (
        @7z x "%%a" -o"%%~dpna" -aoa
        @if errorlevel 1 (
            @echo There was an error so I won't delete
        ) else (
            REM You can also prompt with del /p
            @del "%%a"
        )
    ) else (
        @echo 7z x "%%a" -o"%%~dpna" -aoa
    )
)

@echo USAGE: Use /y to actually do the extraction. Use /yd to extract then delete the zip file.