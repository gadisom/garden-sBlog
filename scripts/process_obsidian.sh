#!/bin/sh

# Define the path to Python3 scripts
COPY_IMAGES_SCRIPT="scripts/copy_images_and_update_image_path.py"
UPDATE_YOUTUBE_PATH_SCRIPT="scripts/update_youtube_path.py"

echo "Processing Obsidian content for Hugo..."

# Run the copy_images_and_update_image_path.py script
echo "Step 1: Processing images..."
python3 "$COPY_IMAGES_SCRIPT"
if [ $? -ne 0 ]; then
  echo "❌ Image processing failed."
  exit 1
fi

# Run the update_youtube_path.py script
echo "Step 2: Converting YouTube links..."
python3 "$UPDATE_YOUTUBE_PATH_SCRIPT"
if [ $? -ne 0 ]; then
  echo "❌ YouTube link conversion failed."
  exit 1
fi

echo "✅ All scripts executed successfully."
exit 0
