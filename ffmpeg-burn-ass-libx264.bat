@echo off
chcp 65001

set FC_CONFIG_DIR=C:\Fonts
if exist Fonts (
	set FC_CONFIG_DIR=%~dp0Fonts
)
set FONTCONFIG_FILE=%FC_CONFIG_DIR%\fonts.conf

echo %FC_CONFIG_DIR%
echo %FONTCONFIG_FILE%

mkdir MP4
for /f "delims=|" %%f in ('dir /b .\*.mkv .\*.mp4 .\*.avi .\*.rmvb') do (
if exist tmp.ass (
	del tmp.ass
)
if exist %%~nf.ass (
	copy /Y "%%~nf.ass" tmp.ass
)
if exist %%~nf.tc.ass (
	copy /Y "%%~nf.tc.ass" tmp.ass
)
if exist %%~nf.cht.ass (
	copy /Y "%%~nf.cht.ass" tmp.ass
)
if exist %%~nf.big5.ass (
	copy /Y "%%~nf.big5.ass" tmp.ass
)
if exist %%~nf.uni_big5.ass (
	copy /Y "%%~nf.uni_big5.ass" tmp.ass
)
if exist tmp.ass (
ffmpeg -y ^
-ss 00:00:00 ^
-i "%%f" ^
-map_metadata -1 -map_chapters -1 -movflags +faststart ^
-c:v libx264 -crf 23 -r 23.976 -pix_fmt yuv420p -profile:v high ^
-vf scale=-1:-1,ass='tmp.ass' ^
-c:a libfdk_aac ^
-ac 2 ^
-map 0:v -map 0:a:language:jpn ^
"MP4\%%~nf.mp4"
del tmp.ass
)
)
@echo 
PING 1.1.1.1 -n 1 -w 2000 >NUL
