#!/bin/bash
bash -c "c920 -F -o -c0 | ffmpeg -r 15 -i - -r 15 -an -vcodec copy -hls_list_size 2 -hls_time 3 -hls_flags delete_segments /tmp/c920/video.m3u8" 2> /dev/null
