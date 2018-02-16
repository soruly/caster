#!/bin/bash

anime_path=/mnt/nfs/data/anime/
thumb_path=/mnt/nfs/data/anime_thumb/
tmp_path="/tmp/thumb/${1//$anime_path/}/"

if [[ "$1" == "$anime_path"*.mp4 ]] ; then
  relative_path="${1//$anime_path/}"
else
  echo "Invalid input file"
  exit
fi
file="$1"
thumbxxx="${file%.mp4}.jpg"
thumbfile="${thumbxxx//$anime_path/$thumb_path}"
thumbpath=$(dirname "$thumbfile")

echo "${file}"

if [ ! -f "$thumbfile" ] || [ "$2" == "-f" ]; then

  # Froce remove old temp folder (e.g. due to unclean exit)
  if [[ -d $tmp_path ]] && [ "$3" == "-f" ]; then
    echo Removing old files
    rm -rf "${tmp_path}"
  elif [[ -d $tmp_path ]] ; then
    echo "Another process is working on this file, exiting"
    exit
  fi

  echo Creating temp directory
  mkdir -p "${tmp_path}" || exit

  echo Counting total frames
  total_frame=$(ffmpeg -i "$file" -map 0:v:0 -c copy -f null -y /dev/null 2>&1 | grep -Eo 'frame= *[0-9]+ *' | grep -Eo '[0-9]+' | tail -1)
  echo $total_frame

  echo Calculating n
  n=$(expr $total_frame / 144 + 1)
  echo $n

  echo Creating output directory
  mkdir -p "$thumbpath"

  echo Generating thumbnail map
  ffmpeg -y -ss 00:00:00 -i "$file" -frames 1 -vf "select=not(mod(n\,"$n")),scale=160:90,tile=12x12" -qscale:v 2 "$thumbfile"

  echo Removing temp files
  rm -rf "${tmp_path}"

  echo Completed
fi