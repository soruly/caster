@echo off
chcp 65001
set FC_CONFIG_DIR=D:\Anime\Fonts
set FONTCONFIG_FILE=D:\Anime\Fonts\fonts.conf

rem ffmpeg -i "%%f" -vf "ass='%%~nf.ass',scale=1280:720" "%%~nf.mp4"
rem ffmpeg -i "%%f" -vf "subtitles='%%f',scale=1280:720" "%%~nf.mp4"
rem ffmpeg -i "%%f" -map 0:0 -map 0:2 -map_chapters -1 -vf "ass='%%~nf.ass'" "MP4\%%~nf.mp4" -y
rem ffmpeg -y -canvas_size 1024x576 -i "%%f" -vcodec nvenc -filter_complex "[0:s]scale=width=2732:height=1080[sub];[0:v][sub]overlay=x=0:y=0[v]" -map [v] -map 0:a  -map_chapters -1 -ac 2 "MP4\%%~nf.mp4"

mkdir MP4
for /f "delims=|" %%f in ('dir /b .\*.ts') do (
ffmpeg -y ^
-canvas_size 1920x1080 ^
-ss 00:00:00 ^
-i "%%f" ^
-map_metadata -1 -map_chapters -1 ^
-c:v nvenc -r 23.976 -pix_fmt yuv420p -profile:v high ^
-filter_complex "[0:v]setpts=PTS-STARTPTS[v0];[0:s]setpts=PTS-STARTPTS-1/TB[s0];[s0]scale=width=2732:height=1080[sub];[v0][sub]overlay=x=0:y=0"
-c:a libfdk_aac ^
-ac 2 ^
-map 0:v -map 0:a:language:jpn ^
"MP4\%%~nf.mp4"
)

@echo 
PING 1.1.1.1 -n 1 -w 2000 >NUL