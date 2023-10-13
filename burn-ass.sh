#!/bin/bash


if [[ $# -eq 0 ]] ; then
  find . -type f -name "*.ass" -exec $0 "{}" \;
  exit
elif [[ $# -eq 1 ]] ; then
  if [[ -f "${1%.*}.mp4" ]] ; then
    $0 "$1" "${1%.*}.mp4"
  elif [[ -f "${1%.*}.mkv" ]] ; then
    $0 "$1" "${1%.*}.mkv"
  elif [[ -f "${1%.*}.avi" ]] ; then
    $0 "$1" "${1%.*}.avi"
  elif [[ -f "${1%.*}.wmv" ]] ; then
    $0 "$1" "${1%.*}.wmv"
  elif [[ -f "${1%.*}.mpg" ]] ; then
    $0 "$1" "${1%.*}.mpg"
  else
    echo "No video file is found for $1"
  fi
elif [[ $# -eq 2 ]] ; then
  echo "$1"
  echo "$2"
  dest="$(dirname "$1")""/output/"$(basename "${1%.*}.mp4")
  echo "$dest"

  if ! [[ -f "$dest" ]] ; then
    export FONTCONFIG_FILE="/home/soruly/font/font.conf"
    export FONTCONFIG_PATH="/home/soruly/font"
    
    echo $'<?xml version="1.0"?>' > $FONTCONFIG_FILE
    echo "<fontconfig>" >>  $FONTCONFIG_FILE
    echo "<dir>$FONTCONFIG_PATH</dir>" >>  $FONTCONFIG_FILE
    echo "<cachedir>$FONTCONFIG_PATH</cachedir>" >>  $FONTCONFIG_FILE
    echo "</fontconfig>" >>  $FONTCONFIG_FILE

    mkdir -p "$(dirname "$1")""/output/"

    ffmpeg -y \
    -ss 00:00:00 \
    -i "$2" \
    -map_metadata -1 -map_chapters -1 -movflags +faststart \
    -c:v libx264 -r 24000/1001 -pix_fmt yuv420p -profile:v high -preset medium \
    -vf scale=-1:-1,ass="'$1'" \
    -c:a aac \
    -ac 2 \
    -map 0:v -map 0:a:m:language:jpn \
    "$dest"
  fi
fi
