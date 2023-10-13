
src="$1"
dest="$(pwd)/output/""${1%.*}.mp4"

mkdir -p "$(pwd)/output/"

ffmpeg -y \
-canvas_size 1920x1080 \
-ss 00:00:00 \
-i "$src" \
-map_metadata -1 -map_chapters -1 -movflags +faststart \
-c:v libx264 -r 24000/1001 -pix_fmt yuv420p -profile:v high -preset medium -crf 23 \
-filter_complex "[0:s]scale=width=1280:height=720[sub];[0:v][sub]overlay=x=0:y=0" \
-c:a aac \
-ac 2 \
-map 0:v -map 0:a:m:language:jpn \
"$dest"
