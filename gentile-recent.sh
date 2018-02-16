#!/bin/bash

#find /mnt/nfs/data/anime/1 -type f -name "*.mp4" -exec /home/soruly/project/caster/gentile.sh "{}" \;
find /mnt/nfs/data/anime -type f -name "*.mp4" -mmin -86400 -exec /home/soruly/project/caster/gentile.sh "{}" \;
