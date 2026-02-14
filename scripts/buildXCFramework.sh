#!/bin/sh

exec > "/tmp/${PRODUCT_NAME}_xcode_post_archive.log" 2>&1

### Setup path environment
echo "⚙️ Setup path environment ⚙️"

FRAMEWORK_NAME="${PRODUCT_NAME}"
IOS_ARCHIVE_PATH="${ARCHIVE_PATH}"
BUILD_PATH="${PROJECT_DIR}/product"

### Removing build folder...
echo "🛠️ Removing build folder... 🛠️"

rm -rf $BUILD_PATH

### Create XCFramework...
echo "📦 Creating XCFramework... 📦"

xcodebuild -create-xcframework \
  -archive "$IOS_ARCHIVE_PATH" -framework $FRAMEWORK_NAME.framework \
  -output "$BUILD_PATH/$FRAMEWORK_NAME.xcframework"

if [ $? -ne 0 ]; then
    echo "❌ Create XCFramework failed ❌"
    exit 1
fi

echo "✅ Create XCFramework complete ✅"

open "$BUILD_PATH"
