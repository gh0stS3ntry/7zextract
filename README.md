# 7zextract
A Windows Batch Script that uses 7zip software to recursively extract multiple zip files within a target directory.

How to use:

1. Install 7zip from official website (https://www.7-zip.org/download.html)
2. Set the path in Environment Variables -> User Variables -> Path -> Edit -> new (add the path: "C:\Program Files\7-Zip") -> OK
3. Open target directory with list of zip files using File Explorer
4. Copy "7zextract.bat" to target directory
5. With the target directory opened using File Explorer, press "Alt + D"
6. Type "cmd" and press "Enter"
7. In the Command Prompt, type "7zextract.bat /y" to extract all zip files. Alternatively, type "7zextract.bat /yd" to extract all zip files and delete the original zip files

8. If the zip files are password-protected, add the password as a second argument, e.g. "7zextract.bat /y MyPassword" or "7zextract.bat /yd MyPassword". Wrap the password in double quotes if it contains spaces or special characters (e.g. "7zextract.bat /y "my pass&word""). The same password is used for every archive; unencrypted archives still extract normally. Passwords containing % or " are not supported.
9. Running "7zextract.bat" without /y or /yd does a dry run that only prints the 7z commands (the password is shown as ****).
