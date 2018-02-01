#!/bin/bash

if [[ -d $1 ]]; then
  echo "Dir"
elif [[ -f $1 ]] ; then
  if [[ $# -eq 2 ]] ; then
    if [[ ${2: -4} == ".ass" ]] ; then
        echo "Burn ass on video"
        #"$0" "$(pwd)/$1" "$(pwd)/$2"
      fi
    else
      echo "\$2 is not an ass file"
    fi
  else
    echo "Simple video convert"
  fi
else
  echo "\$1 is not a file or directory"
fi

export FONTCONFIG_FILE="$(pwd)/font/font.conf"
export FONTCONFIG_PATH="$(pwd)/font"

echo "Creating fontconfig at $FONTCONFIG_FILE"

echo $'<?xml version="1.0"?>' > $FONTCONFIG_FILE
echo "<fontconfig>" >>  $FONTCONFIG_FILE
echo "<dir>$FONTCONFIG_PATH</dir>" >>  $FONTCONFIG_FILE
echo "<cachedir>$FONTCONFIG_PATH</cachedir>" >>  $FONTCONFIG_FILE
echo "</fontconfig>" >>  $FONTCONFIG_FILE

echo "Created fontconfig at $FONTCONFIG_FILE"

#<match target="pattern">
#  <test qual="any" name="family"><string>方正大黑_GBK</string></test>
#  <edit name="family" mode="assign"><string>1_GBK</string></edit>
#</match>

ffmpeg -y \
-ss 00:00:00 \
-i "$1" \
-map_metadata -1 -map_chapters -1 \
-c:v libx264 -r 24000/1001 -pix_fmt yuv420p -profile:v high -preset ultrafast \
-vf scale=-1:-1,ass='$2' \
-c:a aac \
-ac 2 \
-map 0:v -map 0:a:language:jpn \
"$(pwd)/output/""${1%.*}.mp4"
