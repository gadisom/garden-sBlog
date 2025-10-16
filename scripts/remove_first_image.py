import os
import re

# Paths
hugo_posts_dir = "/Users/kim-jeongwon/Desktop/blog/garden/content/posts"

# Process each markdown file
for filename in os.listdir(hugo_posts_dir):
    if filename.endswith(".md"):
        filepath = os.path.join(hugo_posts_dir, filename)

        with open(filepath, "r", encoding="utf-8") as file:
            content = file.read()

        # Check if cover image is set
        cover_match = re.search(r'cover:\s*\n\s*image:\s*(.+)', content)
        if not cover_match or not cover_match.group(1).strip() or cover_match.group(1).strip() == '""':
            # No cover image set, skip
            continue

        cover_image = cover_match.group(1).strip()

        # Extract filename from cover image path
        cover_filename = cover_image.split('/')[-1]

        # Remove the first occurrence of this image in markdown format
        # Matches: !![filename](/images/...)
        pattern = rf'!\!\[[^\]]*\]\(/images/{re.escape(cover_filename)}\)'

        # Check if pattern exists
        if re.search(pattern, content):
            # Remove first occurrence
            content = re.sub(pattern, '', content, count=1)

            with open(filepath, "w", encoding="utf-8") as file:
                file.write(content)

            print(f"✓ Removed duplicate cover image from {filename}")

print("Duplicate image removal complete.")
