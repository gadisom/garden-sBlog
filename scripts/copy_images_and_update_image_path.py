import os
import re
import shutil

# Paths
obsidian_attachments_dir = "/Users/kim-jeongwon/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian Vault/_attachments"
hugo_posts_dir = "/Users/kim-jeongwon/Desktop/blog/garden/content/posts"
hugo_static_images_dir = "/Users/kim-jeongwon/Desktop/blog/garden/static/images"

# Ensure static/images directory exists
if not os.path.exists(hugo_static_images_dir):
    os.makedirs(hugo_static_images_dir)

# Step 1: Process each markdown file in the posts directory
for filename in os.listdir(hugo_posts_dir):
    if filename.endswith(".md"):
        filepath = os.path.join(hugo_posts_dir, filename)

        with open(filepath, "r") as file:
            content = file.read()

        # Step 2: Find all image links in the format [[image.png]]
        images = re.findall(r"\[\[([^]]*\.(?:png|jpg|jpeg|gif|webp))\]\]", content, re.IGNORECASE)

        # Step 3: Replace image links and ensure URLs are correctly formatted
        for image in images:
            # Prepare the Markdown-compatible link with %20 replacing spaces
            markdown_image = f"![{image}](/images/{image.replace(' ', '%20')})"
            content = content.replace(f"[[{image}]]", markdown_image)

            # Step 4: Copy the image to the Hugo static/images directory if it exists
            image_source = os.path.join(obsidian_attachments_dir, image)
            if os.path.exists(image_source):
                shutil.copy(image_source, hugo_static_images_dir)
                print(f"Copied: {image}")

        # Step 5: Write the updated content back to the markdown file
        with open(filepath, "w") as file:
            file.write(content)

print("Markdown files processed and images copied successfully.")
