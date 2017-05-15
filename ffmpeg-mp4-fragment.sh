ffmpeg -i input.mp4 -c copy -movflags frag_keyframe+empty_moov+default_base_moof+faststart fragmented.mp4
