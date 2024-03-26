#!/usr/bin/env bash
input_file=${1}
output_file=${2}
resolution=${3}
loudnorm=${4}

if [ $# != 4 ]; then
  echo "transcode.sh <input file> <output file> <resolution> <lufs>
  resolution:
    full_hd, hd
  lufs:
    -24
  "
  exit 1
fi

if [ ${resolution} = "hd" ]; then
  echo "hd"
  resolution_value=1280x720
  video_bitrate=1280k
  audio_bitrate=128k
else
  echo "full hd"
  resolution_value=1920x1080
  video_bitrate=4096k
  audio_bitrate=128k
fi

for pass in {1..2}
do
  ffmpeg -i ${input_file} -y -r 30 -f mp4 -async 1 -threads 0 -pass ${pass} \
    -s ${resolution_value} -b:v ${video_bitrate} -bt ${video_bitrate} \
    -ab ${audio_bitrate} -acodec aac -ar 48000 -af loudnorm=I=${loudnorm}:LRA=11:TP=-2 \
    $output_file
done
