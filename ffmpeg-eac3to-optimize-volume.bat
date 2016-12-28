@echo off
chcp 65001

for /f "delims=|" %%f in ('dir /b .\*.mp4') do (
ffmpeg -y ^
-i "%%f" ^
-map_metadata -1 ^
-map_chapters -1 ^
-vn ^
-c:a pcm_s16le ^
-ac 2 ^
-af "compand=0 0:1 1:-90/-900 -70/-70 -21/-21 0/-15:0.01:12:0:0" ^
"%%~nf.companded.wav"

"C:\Program Files (x86)\eac3to329\eac3to.exe" "%%~nf.companded.wav" "%%~nf.normalized.wav" -normalize -log="%%~nf.normalized.log"

ffmpeg -y ^
-i "%%f" ^
-i "%%~nf.normalized.wav" ^
-map_metadata -1 ^
-map_chapters -1 ^
-map 0:v ^
-map 1:a ^
-c:v copy ^
-c:a libfdk_aac ^
"%%~nf.audio_optimized.mp4"

del /Q "%%~nf.companded.wav"
del /Q "%%~nf.normalized.wav"
del /Q "%%~nf.normalized.log"
)
)
@echo 
PING 1.1.1.1 -n 1 -w 2000 >NUL