#!/bin/bash
pwd
ionice -c3 nice -n 19 ffmpeg \
  -f concat \
  -safe 0 \
  -i input_files.txt \
  -c:v libx264 \
  -preset slow \
  -crf 18 \
  -pix_fmt yuv420p \
  -r 60 \
  -c:a aac \
  -b:a 256k \
  -threads 2 \
  -bufsize 32M \
  -max_muxing_queue_size 512 \
  2026-01-21-combined-highquality.mp4