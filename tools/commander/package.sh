#!/bin/bash

if [ -z "$1" ]; then
  echo "[ oavp:package.sh ] Error: no package id specified."
  exit 1
fi

if [ -z "$2" ]; then
  echo "[ oavp:package.sh ] Error: no sketch id specified."
  exit 1
fi

if [ -z "$3" ]; then
  echo "[ oavp:package.sh ] Error: no sketch name specified."
  exit 1
fi

if [ -z "$4" ]; then
  echo "[ oavp:package.sh ] Error: missing print-size offset."
  exit 1
fi

if [ -z "$5" ]; then
  echo "[ oavp:package.sh ] Error: missing print-size offset."
  exit 1
fi

if [ -z "$6" ]; then
  echo "[ oavp:package.sh ] Error: missing print-size offset."
  exit 1
fi

if [ -z "$7" ]; then
  echo "[ oavp:package.sh ] Error: missing print-size offset."
  exit 1
fi

if [ -z "$8" ]; then
  echo "[ oavp:package.sh ] Error: missing print-size offset."
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
BROLL_FILE=$1_broll.mp4
SKETCH_PDE=$2.txt
SKETCH_DATA_OBJECT=$2.json
SKETCH_NAME=$1_$3
ORIGINAL_IMAGE=$2.png
IMAGE_ENHANCER_DIR=$PROJECT_DIR/tools/lib/waifu2x-ncnn-vulkan
WATERMARK_FONT=$PROJECT_DIR/tools/lib/fonts/CPMono_v07_Light.otf

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
ffmpeg -framerate $FPS_BROLL -pattern_type glob -i 'broll-*.png' -r $FPS_BROLL -pix_fmt yuv420p $BROLL_FILE

echo "[ oavp:package.sh ] Creating video-list.txt..."
echo "file '$TIMELAPSE_FILE'" > video-list.txt
echo "file '$BROLL_FILE'" >> video-list.txt

echo "[ oavp:package.sh ] Concatenating videos..."
ffmpeg -f concat -safe 0 -i video-list.txt -c copy $1_promo.mp4

echo "[ oavp:package.sh ] Cleaning up frames and video-list..."
rm *.png
rm video-list.txt

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

cd $IMAGE_ENHANCER_DIR
echo "[ oavp:package.sh ] Upscaling original image"
./waifu2x-ncnn-vulkan -i $NEW_PACKAGE_DIR/$1_original.png -o $NEW_PACKAGE_DIR/$1_original-2x.png -s 2 -n 2
./waifu2x-ncnn-vulkan -i $NEW_PACKAGE_DIR/$1_original-2x.png -o $NEW_PACKAGE_DIR/$1_print.png -s 2 -n 2

echo "[ oavp:package.sh ] Creating print size variations"
ffmpeg -i $NEW_PACKAGE_DIR/$1_print.png -vf "crop=2880:4320:$4:0" $NEW_PACKAGE_DIR/$1_print-2x3.png
ffmpeg -i $NEW_PACKAGE_DIR/$1_print.png -vf "crop=3240:4320:$5:0" $NEW_PACKAGE_DIR/$1_print-3x4.png
ffmpeg -i $NEW_PACKAGE_DIR/$1_print.png -vf "crop=3456:4320:$6:0" $NEW_PACKAGE_DIR/$1_print-4x5.png
ffmpeg -i $NEW_PACKAGE_DIR/$1_print.png -vf "crop=3394:4320:$7:0" $NEW_PACKAGE_DIR/$1_print-11x14.png
ffmpeg -i $NEW_PACKAGE_DIR/$1_print.png -vf "crop=3063:4320:$8:0" $NEW_PACKAGE_DIR/$1_print-international.png

echo "[ oavp:package.sh ] Adding watermark to print variations"
ffmpeg -i $NEW_PACKAGE_DIR/$1_print.png -vf "drawtext=text='nafeuvisual.space \: $SKETCH_NAME':fontfile=$WATERMARK_FONT:fontsize=48:fontcolor=white:box=1:boxcolor=black@0.75:boxborderw=16:x=(w-text_w-50):y=(h-text_h-50)" -codec:a copy $NEW_PACKAGE_DIR/$1_print-watermark.png;
ffmpeg -i $NEW_PACKAGE_DIR/$1_print-2x3.png -vf "drawtext=text='nafeuvisual.space \: $SKETCH_NAME':fontfile=$WATERMARK_FONT:fontsize=48:fontcolor=white:box=1:boxcolor=black@0.75:boxborderw=16:x=(w-text_w-50):y=(h-text_h-50)" -codec:a copy $NEW_PACKAGE_DIR/$1_print-2x3-watermark.png;
ffmpeg -i $NEW_PACKAGE_DIR/$1_print-3x4.png -vf "drawtext=text='nafeuvisual.space \: $SKETCH_NAME':fontfile=$WATERMARK_FONT:fontsize=48:fontcolor=white:box=1:boxcolor=black@0.75:boxborderw=16:x=(w-text_w-50):y=(h-text_h-50)" -codec:a copy $NEW_PACKAGE_DIR/$1_print-3x4-watermark.png;
ffmpeg -i $NEW_PACKAGE_DIR/$1_print-4x5.png -vf "drawtext=text='nafeuvisual.space \: $SKETCH_NAME':fontfile=$WATERMARK_FONT:fontsize=48:fontcolor=white:box=1:boxcolor=black@0.75:boxborderw=16:x=(w-text_w-50):y=(h-text_h-50)" -codec:a copy $NEW_PACKAGE_DIR/$1_print-4x5-watermark.png;
ffmpeg -i $NEW_PACKAGE_DIR/$1_print-11x14.png -vf "drawtext=text='nafeuvisual.space \: $SKETCH_NAME':fontfile=$WATERMARK_FONT:fontsize=48:fontcolor=white:box=1:boxcolor=black@0.75:boxborderw=16:x=(w-text_w-50):y=(h-text_h-50)" -codec:a copy $NEW_PACKAGE_DIR/$1_print-11x14-watermark.png;
ffmpeg -i $NEW_PACKAGE_DIR/$1_print-international.png -vf "drawtext=text='nafeuvisual.space \: $SKETCH_NAME':fontfile=$WATERMARK_FONT:fontsize=48:fontcolor=white:box=1:boxcolor=black@0.75:boxborderw=16:x=(w-text_w-50):y=(h-text_h-50)" -codec:a copy $NEW_PACKAGE_DIR/$1_print-international-watermark.png;

echo "[ oavp:package.sh ] Opening new package directory..."
open $NEW_PACKAGE_DIR
