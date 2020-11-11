#!/bin/bash

BUILD_SCRIPT=./configure-build.sh

source ./configure-build.sh

if [[ ! -f "$BUILD_SCRIPT" ]]; then
    echo "Missing build configuration script at $BUILD_SCRIPT" 1>&2
    exit 1
fi

if [[ -z "$OAVP_PROJECT_PATH" ]]; then
    echo "Must provide OAVP_PROJECT_PATH in environment" 1>&2
    exit 1
fi

if [[ -z "$OAVP_BUILD_PATH" ]]; then
    echo "Must provide OAVP_BUILD_PATH in environment" 1>&2
    exit 1
fi

echo Accessing project source from: $OAVP_PROJECT_PATH
echo Exporting application to: $OAVP_BUILD_PATH

OAVP_SOURCE=$OAVP_PROJECT_PATH/src
OAVP_RESOURCES=$OAVP_PROJECT_PATH/resources

RAW_EXPORT=$OAVP_SOURCE/application.macosx64
RAW_APP=$RAW_EXPORT/src.app

APP_CONTENTS=$RAW_APP/Contents
APP_PLIST=$APP_CONTENTS/Info.plist

processing-java --sketch=$OAVP_SOURCE --platform=macosx --export
rm -r $RAW_EXPORT/source
plutil -insert NSMicrophoneUsageDescription -string "Oavp needs access to the microphone for audio visualization" $APP_PLIST
cp $OAVP_RESOURCES/sketch.icns $APP_CONTENTS/Resources/sketch.icns
mv $RAW_APP $OAVP_BUILD_PATH/oavp.app
rm -r $RAW_EXPORT
open $OAVP_BUILD_PATH