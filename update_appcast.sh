#!/bin/bash
set -euo pipefail

if [ "$#" -lt 1 ]
then
    echo
    echo "Usage: generate_appcast archive_dmg"
    echo
    exit 1
fi

ARCHIVE="$1"

# Verify dmg is signed
xcrun stapler validate "$ARCHIVE"
echo

# Copy archive to sparkle dir
DATA_PATH=$(ls -d "$HOME/Library/Developer/Xcode/DerivedData/MacDial-"* 2>/dev/null | head -n 1)
if [[ -z "$DATA_PATH" ]]; then
    echo "Error: Could not find derived data path" >&2
    exit 1
fi

echo "Found derived data path: $DATA_PATH"
echo "Copying archive to sparkle directory..."

SPARKLE_PATH="$DATA_PATH/SourcePackages/artifacts/sparkle/Sparkle"
cp "$ARCHIVE" "$SPARKLE_PATH/MacDial.dmg"

# Get app version
BUILD_PATH="$DATA_PATH/Build/Products/Debug"
VERSION=$(defaults read "$BUILD_PATH/MacDial.app/Contents/Info" CFBundleShortVersionString)

DOWNLOAD_LINK="https://github.com/SoCuul/mac-dial/releases/download/v$VERSION/MacDial.dmg"

echo
echo "Download source: $DOWNLOAD_LINK"

# Generate appcast
echo
"$SPARKLE_PATH/bin/generate_appcast" \
    --account com.socuul.macdial \
    --download-url-prefix "https://github.com/SoCuul/mac-dial/releases/download/v$VERSION/" \
    --full-release-notes-url "https://github.com/SoCuul/mac-dial/releases" \
    -o "./appcast.xml" \
    "$SPARKLE_PATH"

open "./appcast.xml"
