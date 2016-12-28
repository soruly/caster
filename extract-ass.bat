set /p track="Enter track ID: "
for /f "delims=|" %%f in ('dir /b .\*.mkv') do (
"C:\Program Files\MKVToolNix\mkvextract.exe" --ui-language en tracks "%%f" %track%:"%%~nf.ass"
)
@echo 
PING 1.1.1.1 -n 1 -w 2000 >NUL