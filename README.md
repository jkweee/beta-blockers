# Usage

1. List input files in `input_files.txt`
2. Set output file in `append_sets.sh`
3. Create a new screen instance: `screen -S beta-blockers`
    - _Ensure that you are in the_ `preprocess-append` _folder_!
4. Run script: `source append_sets.sh`
    - At this point, it's safe to close the terminal and exit the IDE
5. Come back in the morning and reattach and exit: `screen -r beta-blockers`

### Notes

- As of 21/01/2026, use `append_sets.sh` as lossless isn't worth the storage space
- Lossless outputs variable framerate - not what we want!



# What Your Script Is Doing 🔍

GEMINI

| Parameter | Function | Why it's here |
|-----------|----------|---------------|
| ionice -c3 | Disk Idle Priority | Ensures FFmpeg only uses USB 3.0 bandwidth when idle. |
| nice -n 19 | CPU Idle Priority | Lowest priority; FFmpeg steps aside for any other app. |
| -f concat | Stream Joiner | Seamlessly stitches your 4K files together. |
| -preset medium | Efficiency Balance | Best trade-off between encoding speed and file size. |
| -crf 18 | Quality Control | Visually lossless quality for high-end 4K footage. |
| -pix_fmt yuv420p | Compatibility | Standardizes colors for playback on all devices. |
| -r 60 | Frame Rate | Forces 60fps to prevent audio/video sync drifting. |
| -maxrate 50M | Bitrate Ceiling | Prevents data spikes from overwhelming the USB cable. |
| -bufsize 64M | Rate Buffer | Smooths out data flow to the external hard drive. |
| (Auto Threads) | Hardware Scaling | Utilizes all 12 threads of your hybrid CPU automatically. |


~~~
ffmpeg -f concat -safe 0 -i input_files.txt -c:v libx264 -c:a aac -strict experimental -b:a 192k 2025-11-12-combined.mp4
~~~

- `-f concat -safe 0 -i input_files.txt`: Uses the concat demuxer to stitch together multiple files listed in input_files.txt.
- `-c:v libx264`: Re-encodes video using H.264 (lossy unless configured for lossless).
- `-c:a aac -b:a 192k`: Re-encodes audio using AAC at 192 kbps (lossy).
- `-strict experimental`: Enables experimental features (not needed for modern FFmpeg versions).

Output: `<YYYY-MM-DD>-combined.mp4`

⚠️ Why the File Size Is Smaller
- Re-encoding with libx264 defaults to a compression level that balances quality and file size.
- Unless you explicitly set -crf 0 or -preset ultrafast, you're getting lossy compression.
- AAC audio at 192k is also compressed.
