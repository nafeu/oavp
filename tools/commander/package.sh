#!/bin/bash

if [ -z "$1" ]; then
  echo "[ oavp:package.sh ] Error: no package id specified."
  exit 1
fi

if [ -z "$2" ]; then
  echo "[ oavp:package.sh ] Error: no sketch id specified."
  exit 1
fi

PROJECT_DIR=$(dirname $(dirname $(pwd)))
EXPORTS_DIR=$PROJECT_DIR/exports
SKETCH_DIR=$PROJECT_DIR/src
PACKAGE_EXPORT_DIR=$PROJECT_DIR/package-export-files
PACKAGES_DIR=$PROJECT_DIR/packages
FPS_TIMELAPSE=30
FPS_BROLL=60
RECORDING_FILE_TIMELAPSE=$1_raw-timelapse.mp4
TIMELAPSE_FILE=$1_timelapse.mp4
TIMELAPSE_VERTICAL_FILE=$1_timelapse-vertical.mp4
RECORDING_FILE_BROLL=$1_broll.mp4
BROLL_VERTICAL_FILE=$1_broll-vertical.mp4
SKETCH_PDE=$2.txt
SKETCH_DATA_OBJECT=$2.json
ORIGINAL_IMAGE=$2.png

echo "[ oavp:package.sh ] Executing video construction for:"
echo $PACKAGES_DIR/$1

echo "[ oavp:package.sh ] Launching editor..."
processing-java --sketch=$SKETCH_DIR --run

cd $PACKAGE_EXPORT_DIR

echo "[ oavp:package.sh ] Converting frames to video for timelapse..."
ffmpeg -framerate $FPS_TIMELAPSE -pattern_type glob -i 'timelapse-*.png' -r $FPS_TIMELAPSE -pix_fmt yuv420p $RECORDING_FILE_TIMELAPSE

echo "[ oavp:package.sh ] Converting recording to timelapse..."
ffmpeg -i $RECORDING_FILE_TIMELAPSE -vf "setpts=0.1*PTS" -an $TIMELAPSE_FILE

echo "[ oavp:package.sh ] Creating vertical version of timelapse..."
ffmpeg -i $TIMELAPSE_FILE -vf 'split[original][copy];[copy]scale=-1:ih*(16/9)*(16/9),crop=w=ih*9/16[copy_cropped];[copy_cropped][original]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2' $TIMELAPSE_VERTICAL_FILE

echo "[ oavp:package.sh ] Converting frames to video for broll..."
ffmpeg -framerate $FPS_BROLL -pattern_type glob -i 'broll-*.png' -r $FPS_BROLL -pix_fmt yuv420p $RECORDING_FILE_BROLL

echo "[ oavp:package.sh ] Creating vertical version of broll..."
ffmpeg -i $RECORDING_FILE_BROLL -vf 'split[original][copy];[copy]scale=-1:ih*(16/9)*(16/9),crop=w=ih*9/16[copy_cropped];[copy_cropped][original]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2' $BROLL_VERTICAL_FILE

echo "[ oavp:package.sh ] Cleaning up frames..."
rm *.png

echo "[ oavp:package.sh ] Creating package folder..."

NEW_PACKAGE_DIR=$PACKAGES_DIR/$1
DUPLICATE_SUFFIX=0

while [ -d "$NEW_PACKAGE_DIR" ]; do
  NEW_PACKAGE_DIR="${NEW_PACKAGE_DIR}_${DUPLICATE_SUFFIX}"
  let DUPLICATE_SUFFIX+=1
done

mkdir $NEW_PACKAGE_DIR

echo "[ oavp:package.sh ] Moving files into package..."
mv ./* $NEW_PACKAGE_DIR/

echo "[ oavp:package.sh ] Copying export files..."
cd $EXPORTS_DIR
cp ./$SKETCH_PDE $NEW_PACKAGE_DIR/$1_sketch.pde
cp ./$SKETCH_DATA_OBJECT $NEW_PACKAGE_DIR/$1_sketchDataObject.json
cp ./$ORIGINAL_IMAGE $NEW_PACKAGE_DIR/$1_original.png

echo "[ oavp:package.sh ] Opening new package directory..."
open $NEW_PACKAGE_DIR
