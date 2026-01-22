#!/bin/bash
# Ensures we are in the correct directory
pwd

# CPU/IO Priority: Only uses resources when the system is idle
ionice -c3 nice -n 19 ffmpeg \
  -f concat \
  -safe 0 \
  -i input_files.txt \
  -c:v libx264 \
  -preset medium \
  -crf 18 \
  -pix_fmt yuv420p \
  -r 60 \
  -c:a aac \
  -b:a 256k \
  -max_muxing_queue_size 1024 \
  -maxrate 50M \
  -bufsize 64M \
  2026-01-22-combined-highquality.mp4