#!/bin/bash

# Define app name and paths
APP_NAME="MCO Flipent"
BUILD_DIR="../build"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_BUNDLE/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

# Create necessary directories
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Copy and rename the Info.plist
cp AppInfo.plist "$CONTENTS_DIR/Info.plist"

# Compile main.m into the MacOS directory
gcc -o "$MACOS_DIR/Flipent" main.m -framework Cocoa -framework Foundation -fobjc-exceptions

# Set the application icon
cp Flipent.icns "$RESOURCES_DIR/Flipent.icns"

# Ensure execution permissions
chmod +x "$MACOS_DIR/Flipent"

echo "Build completed! The app is located at: $APP_BUNDLE"
