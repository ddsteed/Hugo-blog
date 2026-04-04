#!/bin/bash
# Hugo Stack 主题切换脚本
# 用法：./theme-switch.sh [light|dark]

THEME_DIR="/Users/fengh/Documents/RDS/BLOG/hugo.stack/layouts/partials/head"
CUSTOM_FILE="$THEME_DIR/custom.html"
BACKUP_LIGHT="$THEME_DIR/custom-backup-light-normal.html"
BACKUP_DARK="$THEME_DIR/custom-dark-forced.html"

case "${1:-}" in
  light)
    echo "🌞 切换到正常模式（浅色时浅色，深色时深色）..."
    cp "$BACKUP_LIGHT" "$CUSTOM_FILE"
    echo "✅ 已切换到正常模式"
    ;;
  dark)
    echo "🌙 切换到强制深色模式（始终深色）..."
    cp "$BACKUP_DARK" "$CUSTOM_FILE"
    echo "✅ 已切换到强制深色模式"
    ;;
  *)
    echo "用法: $0 [light|dark]"
    echo ""
    echo "  light  - 正常模式（浅色时浅色，深色时深色）"
    echo "  dark   - 强制深色模式（始终深色）"
    echo ""
    echo "当前状态:"
    if diff -q "$BACKUP_DARK" "$CUSTOM_FILE" > /dev/null 2>&1; then
      echo "  🌙 强制深色模式"
    elif diff -q "$BACKUP_LIGHT" "$CUSTOM_FILE" > /dev/null 2>&1; then
      echo "  🌞 正常模式"
    else
      echo "  ❓ 未知状态"
    fi
    exit 1
    ;;
esac
