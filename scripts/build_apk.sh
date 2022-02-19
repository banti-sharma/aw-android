#!/bin/bash

set -e

OUTPUT_NAME="aw-android.apk"

if [ -z $ANDROID_HOME ]; then
    echo "\$ANDROID_HOME needs to be set"
    exit 1
fi

./gradlew assembleRelease
mv mobile/build/outputs/apk/release/mobile-release-unsigned.apk $OUTPUT_NAME
jarsigner -verbose -storepass graphoun1 -keypass graphoun1 -keystore watcher.jks $OUTPUT_NAME activitywatch
jarsigner -verify $OUTPUT_NAME

zipalign=$(find $ANDROID_HOME/build-tools -name "zipalign" -print | head -n 1)
$zipalign -v 4 $OUTPUT_NAME $OUTPUT_NAME.new
mv $OUTPUT_NAME.new $OUTPUT_NAME
