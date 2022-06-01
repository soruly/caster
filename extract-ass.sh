#!/bin/bash


if [[ $# -eq 0 ]] ; then
  find . -type f -name "*.mkv" -exec $0 "{}" \;
  exit
elif [[ $# -eq 1 ]] ; then
  echo "$1"
  dest="$(dirname "$1")""/"$(basename "${1%.*}.ass")
  echo "$dest"

  if ! [[ -f "$dest" ]] ; then
    ffmpeg -y \
    -i "$1" \
    -map 0:3 \
    -c copy \
    "$dest"
  fi
fi
