#!/bin/bash

# Set paths
SOURCE="main.c"
OUTPUT="flipent"
DISK_IMAGE="flipent.dsk"

# Check if cc65 is installed
if ! command -v cl65 &> /dev/null
then
    echo "Error: cc65 is not installed. Install it with 'sudo apt install cc65' or visit https://cc65.github.io/"
    exit 1
fi

echo "Compiling $SOURCE for Apple IIc..."
cl65 -t apple2 -o "$OUTPUT" "$SOURCE"

if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi

echo "Creating disk image: $DISK_IMAGE..."
cadius CREATEVOLUME "$DISK_IMAGE" ProDOS 140K
cadius ADDFILE "$DISK_IMAGE" / "$OUTPUT"

echo "Build complete! Run it in an Apple IIc emulator (or make a floppy from our sticker models)."
echo "To run: Load $DISK_IMAGE and type 'BRUN FLIPENT'"
