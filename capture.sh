#!/bin/bash

# delete any prior video segments
rm /c920pi/*

# run capture utility, pipe to ffmpeg, output to /dev/null
bash -c "c920 -F -o -c0 | ffmpeg -r 15 -i - -r 15 -an -vcodec copy -hls_list_size 2 -hls_time 3 -hls_flags delete_segments /c920pi/video.m3u8" 2> /dev/null
