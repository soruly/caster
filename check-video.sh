#!/bin/sh

cd /home/soruly

if [[ -f $1 ]] ; then

  codec=$(mediainfo "--Inform=Audio;%CodecID%" "$1")
  if [ "$codec" != "40" ] ; then
    echo "$1"
    echo "Wrong Audio Codec $codec"
  fi

  codec=$(mediainfo "--Inform=Video;%Format_Profile%" "$1")
  if [ ! $(echo "$codec" | grep -P "^(High|Main|Baseline)@L[1-5](\.[1-3])*$" ) ] ; then
    echo "$1"
    echo "Wrong Video Codec $codec"
  fi

elif [[ -d $1 ]] ; then
  find "$1" -type f -name "*.mp4" -exec $0 "{}" \;
else
  path=/mnt/Data/Anime\ New
  find "${path}" -type d -empty -printf 'Empty folder: %p\n'
  find "${path}" -not -name "*.mp4" -not -name "*.ass" -not -name "*.txt" -not -type d -printf 'Wrong file type: %p\n'
  find "${path}" -mindepth 1 -maxdepth 2 -type f -printf 'Should not put files here: %p\n'
  find "${path}" -mindepth 3 -type d -printf 'Should not put folders here: %p\n'
fi

#find "${path}" -type f -name "*.mp4" -exec sh -c 'echo "{}" ; codec=$(mediainfo "--Inform=Audio;%CodecID%" "{}") ; if [ "$codec" -     ne "40" ] ; then echo "{}" ; fi' \;

#find "${path}" -type f -name "*.mp4" -exec sh -c 'codec=`mediainfo "--Inform=Video;%Format_Profile%" "{}"` ; if [ `echo "$codec" |      grep "High\|Main\|Baseline"` ] ; then echo "$codec" ; else echo "{}" ; fi' \;

