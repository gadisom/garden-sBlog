#!/bin/bash

# 환경변수 설정
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - 2>/dev/null || true)"

# Obsidian publish 폴더에서 Hugo content/posts로 동기화
OBSIDIAN_PUBLISH="/Users/kim-jeongwon/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian Vault/publish"
HUGO_POSTS="/Users/kim-jeongwon/Desktop/blog/garden/content/posts"
HUGO_ROOT="/Users/kim-jeongwon/Desktop/blog/garden"

echo "🔄 Syncing from Obsidian to Hugo..."

# posts 폴더가 없으면 생성
mkdir -p "$HUGO_POSTS"

# publish 폴더의 모든 파일을 Hugo content/posts로 복사
rsync -av --delete \
  --exclude='.obsidian' \
  --exclude='.DS_Store' \
  --exclude='.trash' \
  "$OBSIDIAN_PUBLISH/" "$HUGO_POSTS/"

echo "✅ Sync complete!"
echo "📝 Files synced from: $OBSIDIAN_PUBLISH"
echo "📂 To: $HUGO_POSTS"

# Hugo 프로젝트 디렉토리로 이동
cd "$HUGO_ROOT"

echo "🔧 Processing Obsidian content..."

# 이미지 처리
if [ -f "scripts/copy_images_and_update_image_path.py" ]; then
    echo "  📸 Converting image links..."
    python3 scripts/copy_images_and_update_image_path.py
else
    echo "  ⚠️  Image processing script not found, skipping..."
fi

# YouTube 링크 변환
if [ -f "scripts/update_youtube_path.py" ]; then
    echo "  🎥 Converting YouTube links..."
    python3 scripts/update_youtube_path.py
else
    echo "  ⚠️  YouTube conversion script not found, skipping..."
fi

echo "🚀 Building and deploying..."

# Hugo 빌드 (만약 필요하다면)
# hugo

# Fly.io 배포
if command -v fly >/dev/null 2>&1; then
    fly deploy
    echo "✅ Deployment complete!"
else
    echo "❌ fly command not found. Please install Fly CLI."
    exit 1
fi
