@echo off
:: To actually include the path expansion character (tilde), I had to give valid numbers; see http://ss64.com/nt/rem.html for bug reference. Also, try call /? for more info.
REM %%~dpn extracts the archive's full path sans extension to use as the output folder. -aoa overwrites existing files without prompting.
REM Using `x` instead of `e` maintains dir structure (usually what we want)
REM The optional 2nd argument is the archive password (applied to every archive). Wrap it in quotes if it contains
REM spaces or cmd special characters (& | < > ^). Passwords containing % or " are not supported.

setlocal

REM Archive types to look for (searched recursively). Add or remove patterns as needed.
REM Disk images (*.iso *.vhd *.vhdx *.wim) are deliberately left out so /yd never deletes evidence images; add them here if you want them.
set "EXTS=*.zip *.7z *.rar *.tar *.gz *.gzip *.tgz *.bz2 *.tbz *.tbz2 *.xz *.txz *.zst *.tzst *.lz *.lzma *.z *.cab *.arj"

set "MODE=%~1"
set "FOUND="

REM Build the password argument only when one was given; without -p, 7z behaves as before (prompts if encrypted).
set "PWARG="
set "PWSHOW="
if not "%~2"=="" (
    set PWARG=-p"%~2"
    set PWSHOW=-p"****"
)

REM FOR /R makes it recursive
for /R %%a in (%EXTS%) do call :extract "%%a"

if not defined FOUND echo No archive files found under "%CD%". Looked for: %EXTS%
echo.
echo USAGE: 7zextract.bat [/y ^| /yd] [password]
echo   /y  actually do the extraction. /yd extract then delete the archive. Omit for a dry run.
echo   password (optional) is passed to 7z for encrypted archives; quote it if it contains spaces.
endlocal
goto :eof


REM ---------------------------------------------------------------------------
REM :extract "full\path\to\archive"
REM Extracts one archive into a folder named after it. Compressed tarballs
REM (.tar.gz, .tgz, .tar.bz2, .tar.xz, ...) are streamed straight through tar
REM so the result is the tar's contents, not a leftover .tar file.
REM ---------------------------------------------------------------------------
:extract
set "FOUND=1"
set "ARC=%~1"
set "OUT=%~dpn1"
set "TARBALL="
for %%e in (.tgz .tbz .tbz2 .txz .tzst) do if /i "%~x1"=="%%e" set "TARBALL=1"
for %%b in ("%~dpn1") do if /i "%%~xb"==".tar" (
    set "TARBALL=1"
    set "OUT=%%~dpnb"
)

if /i "%MODE%"=="/y" goto :extract_run
if /i "%MODE%"=="/yd" goto :extract_run

REM Dry run: only show what would be executed (password masked)
if defined TARBALL (
    echo 7z x "%ARC%" -so %PWSHOW% ^| 7z x -si -ttar -o"%OUT%" -aoa
) else (
    echo 7z x "%ARC%" -o"%OUT%" -aoa %PWSHOW%
)
goto :eof

:extract_run
if defined TARBALL (
    7z x "%ARC%" -so %PWARG% | 7z x -si -ttar -o"%OUT%" -aoa
) else (
    7z x "%ARC%" -o"%OUT%" -aoa %PWARG%
)
if errorlevel 1 (
    echo There was an error extracting "%ARC%" so I won't delete it
    goto :eof
)
REM You can also prompt with del /p
if /i "%MODE%"=="/yd" del "%ARC%"
goto :eof
