#!/bin/bash
ffmpeg -f concat -safe 0 -i input_files.txt -c copy 2025-11-20-combined-lossless.mp4