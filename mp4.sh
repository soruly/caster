#!/bin/bash

if [[ $# -eq 0 ]] ; then
  find . -type f \( -iname \*.mkv -o -iname \*.mp4 \) -exec $0 "{}" \;
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
    -vf scale=-2:-2 \
    -c:a aac \
    -ac 2 \
    -map 0:v -map 0:a:m:language:jpn \
    "$dest"
  fi
fi
