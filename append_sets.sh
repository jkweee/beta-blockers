#!/bin/bash

# Redirect all output to append_sets.log and terminal
exec > >(tee -a append_sets.log) 2>&1

# Ensures we are in the correct directory
pwd

# Exit early if input_files directory does not exist
if [ ! -d "input_files" ]; then
    echo "Error: input_files directory does not exist. Exiting."
    exit 1
fi

# Generate input_files.txt dynamically from the input_files directory
ls -1v input_files/* | awk '{print "file '\''" $0 "'\''"}' > input_files.txt

# Print the contents of input_files.txt
echo "We will append the following input files:"
cat input_files.txt
echo ""

# Default output filename with today's date
default_output="$(date +%Y-%m-%d)-combined-highquality.mp4"

# Ask user for confirmation
echo "Output filename will be: $default_output"
read -p "Is this OK? (Y/N): " confirm

if [[ $confirm != [Yy]* ]]; then
    read -p "Enter the desired output filename: " custom_output
    output_file="$custom_output"
else
    output_file="$default_output"
fi

echo "Using output filename: $output_file"
echo ""

# Record start time
start_time=$(date +%s)
echo "Starting ffmpeg processing at $(date)"
echo ""

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
  "$output_file"

# Record end time and calculate duration
end_time=$(date +%s)
duration=$((end_time - start_time))
hours=$((duration / 3600))
minutes=$(((duration % 3600) / 60))
seconds=$((duration % 60))

echo ""
echo "========================================="
echo "Processing completed at $(date)"
echo "Total time: ${hours}h ${minutes}m ${seconds}s"
echo "========================================="