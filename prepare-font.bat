@echo off
chcp 950

for /f "delims=|" %%f in ('dir /b .\*font*.rar .\*font*.zip .\*font*.7z') do (
"C:\Program Files\7-Zip\7z.exe" e "%%f" -oFonts -y
)
cd Fonts
if exist *.ttc (
for /f "delims=|" %%f in ('dir /b .\*.ttc') do (
rem Adobe Font Development Kit for OpenType
cmd /C otc2otf "%%f"
)
)
if exist *.otf (
SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
for /f "delims=|" %%f in ('dir /b .\*.otf') do (
ren "%%~f" "!count!.otf"
set /a count=!count!+1
)
ENDLOCAL
)

copy /Y "C:\Program Files\ffmpeg\getFontName.py" .

python getFontName.py

pause