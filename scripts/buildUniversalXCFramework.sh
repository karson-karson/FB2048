#!/bin/bash

PROJECT="FB2048.xcodeproj"
FRAMEWORK_NAME="FB2048"
ARCHIVE_FOLDER="archives"
BUILD_FOLDER="../product"

IOS_ARCHIVE_PATH="$ARCHIVE_FOLDER/ios.xcarchive"
SIM_ARCHIVE_PATH="$ARCHIVE_FOLDER/sim.xcarchive"

### Remove existing archive & build folder...
echo "Remove existing archive & build folder..."

rm -rf $ARCHIVE_FOLDER
rm -rf $BUILD_FOLDER

### Building for iOS...
echo "Building for iOS..."

xcodebuild archive \
  -project "../$PROJECT" \
  -scheme $FRAMEWORK_NAME \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath $IOS_ARCHIVE_PATH \
  DEBUG_INFORMATION_FORMAT=DWARF \
  GCC_GENERATE_DEBUGGING_SYMBOLS=NO \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

if [ $? -ne 0 ]; then
    echo "❌ iOS build failed"
    exit 1
fi

echo "✅ iOS archive complete"

### Building for iOS Simulator...
echo "Building for iOS Simulator..."

xcodebuild archive \
  -project "../$PROJECT" \
  -scheme $FRAMEWORK_NAME \
  -configuration Release \
  -destination "generic/platform=iOS Simulator" \
  -archivePath $SIM_ARCHIVE_PATH \
  DEBUG_INFORMATION_FORMAT=DWARF \
  GCC_GENERATE_DEBUGGING_SYMBOLS=NO \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

if [ $? -ne 0 ]; then
    echo "❌ iOS Simulator build failed"
    exit 1
fi

echo "✅ iOS Simulator archive complete"

### Create XCFramework...
echo "Creating XCFramework..."

xcodebuild -create-xcframework \
  -archive $IOS_ARCHIVE_PATH -framework $FRAMEWORK_NAME.framework \
  -archive $SIM_ARCHIVE_PATH -framework $FRAMEWORK_NAME.framework \
  -output $BUILD_FOLDER/$FRAMEWORK_NAME.xcframework

if [ $? -ne 0 ]; then
    echo "❌ Create XCFramework failed"
    exit 1
fi

echo "✅ Create XCFramework complete"

# Cleanup
rm -rf $ARCHIVE_FOLDER
