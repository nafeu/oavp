#!/bin/bash

if [ -z "$1" ]; then
  echo "[ oavp:construct-video.sh ] Error: no sketch id specified."
  exit 1
fi

PROJECT_DIR=$(dirname $(dirname $(pwd)))
SKETCH_DIR=$PROJECT_DIR/src
VIDEO_EXPORT_DIR=$PROJECT_DIR/video-export-frames
PACKAGES_DIR=$PROJECT_DIR/packages
FPS=30
RECORDING_FILE=$1_rec.mp4
TIMELAPSE_FILE=$1_tl.mp4
TIMELAPSE_VERTICAL_FILE=$1_tlv.mp4

echo "[ oavp:construct-video.sh ] Executing video construction for:"
echo $PACKAGES_DIR/$1

echo "[ oavp:construct-video.sh ] Launching editor..."
processing-java --sketch=$SKETCH_DIR --run

cd $VIDEO_EXPORT_DIR

echo "[ oavp:construct-video.sh ] Converting frames to video..."
ffmpeg -framerate $FPS -pattern_type glob -i '*.png' -r $FPS -pix_fmt yuv420p $RECORDING_FILE

echo "[ oavp:construct-video.sh ] Converting recording to timelapse..."
ffmpeg -i $RECORDING_FILE -vf "setpts=0.1*PTS" -an $TIMELAPSE_FILE

echo "[ oavp:construct-video.sh ] Creating vertical version of timelapse..."
ffmpeg -i $TIMELAPSE_FILE -vf 'split[original][copy];[copy]scale=-1:ih*(16/9)*(16/9),crop=w=ih*9/16[copy_cropped];[copy_cropped][original]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2' $TIMELAPSE_VERTICAL_FILE

echo "[ oavp:construct-video.sh ] Cleaning up frames..."
rm *.png

echo "[ oavp:construct-video.sh ] Creating package folder..."
mkdir $PACKAGES_DIR/$1

echo "[ oavp:construct-video.sh ] Moving files into package..."
mv ./* $PACKAGES_DIR/$1/
