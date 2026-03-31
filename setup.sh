#!/bin/bash
# flatcare-config セットアップスクリプト
# 使い方: curl -sL https://raw.githubusercontent.com/entorepp/flatcare-config/main/setup.sh | bash

set -e

REPO_URL="https://github.com/entorepp/flatcare-config.git"
LOCAL_DIR="$HOME/.flatcare-config"
SKILLS_DIR="$HOME/.claude/skills"
PLIST_NAME="com.flatcare.config-sync"
PLIST_PATH="$HOME/Library/LaunchAgents/${PLIST_NAME}.plist"

echo "=== フラットちゃん設定セットアップ ==="

# 1. git が使えるか確認
if ! command -v git &>/dev/null; then
  echo "ERROR: git がインストールされていません"
  exit 1
fi

# 2. リポジトリをクローン（既にあれば pull）
if [ -d "$LOCAL_DIR/.git" ]; then
  echo "既存の設定を更新中..."
  cd "$LOCAL_DIR" && git pull --ff-only origin main 2>/dev/null || true
else
  echo "設定をダウンロード中..."
  rm -rf "$LOCAL_DIR"
  git clone "$REPO_URL" "$LOCAL_DIR"
fi

# 3. スキルディレクトリにシンボリックリンクを作成
mkdir -p "$SKILLS_DIR"
if [ -L "$SKILLS_DIR/q" ]; then
  rm "$SKILLS_DIR/q"
elif [ -d "$SKILLS_DIR/q" ]; then
  echo "既存の /q スキルをバックアップ: ${SKILLS_DIR}/q.backup"
  mv "$SKILLS_DIR/q" "${SKILLS_DIR}/q.backup"
fi
ln -s "$LOCAL_DIR/.claude/skills/q" "$SKILLS_DIR/q"
echo "スキルをリンク: $SKILLS_DIR/q -> $LOCAL_DIR/.claude/skills/q"

# 4. 自動同期用の launchd plist を作成（1時間ごとに git pull）
cat > "$PLIST_PATH" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${PLIST_NAME}</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/git</string>
    <string>-C</string>
    <string>${LOCAL_DIR}</string>
    <string>pull</string>
    <string>--ff-only</string>
    <string>origin</string>
    <string>main</string>
  </array>
  <key>StartInterval</key>
  <integer>3600</integer>
  <key>StandardOutPath</key>
  <string>${LOCAL_DIR}/.sync.log</string>
  <key>StandardErrorPath</key>
  <string>${LOCAL_DIR}/.sync.log</string>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
PLIST

# 5. launchd に登録
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo ""
echo "=== セットアップ完了 ==="
echo "  設定場所: $LOCAL_DIR"
echo "  スキル: $SKILLS_DIR/q (symlink)"
echo "  自動同期: 1時間ごとに最新版を取得"
echo ""
echo "Claude Code を起動して /q を試してください。"
