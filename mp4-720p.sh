#!/bin/bash

if [[ $# -eq 0 ]] ; then
  find . -type f -name "*.mkv" -o -name "*.mp4" -exec $0 "{}" \;
  exit
elif [[ $# -eq 1 ]] ; then
  echo "$1"
  dest="$(dirname "$1")""/output/"$(basename "${1%.*}.mp4")
  echo "$dest"
  
  mkdir -p "$(pwd)/output/"

  if ! [[ -f "$dest" ]] ; then
    ffmpeg -y \
    -ss 00:00:00 \
    -i "$1" \
    -map_metadata -1 -map_chapters -1 -movflags +faststart \
    -c:v libx264 -r 24000/1001 -pix_fmt yuv420p -profile:v high -preset medium -crf 23 \
    -vf scale="'if(gt(a,16/9),1280,-2)':'if(gt(a,16/9),-2,720)'" \
    -c:a aac \
    -ac 2 \
    -map 0:v -map 0:a \
    "$dest"
  fi
fi
