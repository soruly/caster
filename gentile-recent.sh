#!/bin/bash

#find /mnt/data/anime/1 -type f -name "*.mp4" -exec /home/soruly/project/caster/gentile.sh "{}" \;
find /mnt/data/anime -type f -name "*.mp4" -mmin -1440 -exec /home/soruly/project/caster/gentile.sh "{}" \;

