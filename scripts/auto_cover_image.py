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

        # Check if cover image is already set and not empty
        cover_match = re.search(r'cover:\s*\n\s*image:\s*(.+)', content)
        if cover_match and cover_match.group(1).strip() and cover_match.group(1).strip() != '""':
            # Cover image already set, skip
            continue

        # Find first Obsidian-style image link: ![[image.png]]
        first_image = re.search(r'!\[\[([^]]+\.(?:png|jpg|jpeg|gif|webp))\]\]', content, re.IGNORECASE)

        if first_image:
            image_filename = first_image.group(1)
            # Update cover image in front matter
            updated_content = re.sub(
                r'(cover:\s*\n\s*image:\s*)([^\n]*)',
                rf'\1/images/{image_filename}',
                content
            )

            with open(filepath, "w", encoding="utf-8") as file:
                file.write(updated_content)

            print(f"✓ Set cover image for {filename}: {image_filename}")

print("Auto cover image assignment complete.")
