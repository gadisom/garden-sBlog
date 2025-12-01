#!/bin/bash

# 환경변수 설정
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - 2>/dev/null || true)"

# Obsidian publish 폴더에서 Hugo content/posts로 동기화
OBSIDIAN_PUBLISH="/Users/kim-jeongwon/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian Vault/publish"
HUGO_POSTS="/Users/kim-jeongwon/Library/Mobile Documents/com~apple~CloudDocs/blog/garden/content/posts"
HUGO_ROOT="/Users/kim-jeongwon/Library/Mobile Documents/com~apple~CloudDocs/blog/garden"

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

# 자동 커버 이미지 설정 (이미지 변환 전에 먼저 실행!)
if [ -f "scripts/auto_cover_image.py" ]; then
    echo "  🖼️  Auto-setting cover images..."
    python3 scripts/auto_cover_image.py
else
    echo "  ⚠️  Auto cover image script not found, skipping..."
fi

# 이미지 처리
if [ -f "scripts/copy_images_and_update_image_path.py" ]; then
    echo "  📸 Converting image links..."
    python3 scripts/copy_images_and_update_image_path.py
else
    echo "  ⚠️  Image processing script not found, skipping..."
fi

# 중복 커버 이미지 제거
if [ -f "scripts/remove_first_image.py" ]; then
    echo "  🗑️  Removing duplicate cover images..."
    python3 scripts/remove_first_image.py
else
    echo "  ⚠️  Remove duplicate image script not found, skipping..."
fi

# YouTube 링크 변환
if [ -f "scripts/update_youtube_path.py" ]; then
    echo "  🎥 Converting YouTube links..."
    python3 scripts/update_youtube_path.py
else
    echo "  ⚠️  YouTube conversion script not found, skipping..."
fi

echo "🚀 Committing and pushing to GitHub..."

# Git에 변경사항 추가
git add .

# 커밋 메시지 생성
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
git commit -m "Update: Sync from Obsidian ($TIMESTAMP)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# GitHub에 푸시
if git push; then
    echo "✅ Successfully pushed to GitHub!"
    echo "🌐 Vercel will automatically deploy your changes"
    echo "📍 Check deployment status at: https://vercel.com"
else
    echo "❌ Git push failed. Please check your credentials."
    exit 1
fi
