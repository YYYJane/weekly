#!/bin/bash
# =============================================================================
# GitHub 仓库设置向导
# =============================================================================
# 本脚本帮助你完成GitHub仓库的初始配置
# =============================================================================

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "========================================"
echo "  📦 GitHub 仓库设置向导"
echo "========================================"
echo ""

# 检查是否已配置远程仓库
if git -C "$REPO_ROOT" remote get-url origin &>/dev/null; then
    echo "✅ 远程仓库已配置:"
    git -C "$REPO_ROOT" remote get-url origin
    echo ""
    read -p "是否重新配置? (y/N): " REPLY
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        echo "取消设置"
        exit 0
    fi
    git -C "$REPO_ROOT" remote remove origin
fi

echo ""
echo "📋 设置步骤："
echo ""
echo "1. 在GitHub创建新仓库（不要初始化README/.gitignore）"
echo "   访问: https://github.com/new"
echo ""
echo "2. 输入你的GitHub用户名和仓库名："
read -p "   GitHub用户名: " GITHUB_USER
read -p "   仓库名 (例如: os-weekly-reports): " REPO_NAME

if [ -z "$GITHUB_USER" ] || [ -z "$REPO_NAME" ]; then
    echo "❌ 用户名和仓库名不能为空"
    exit 1
fi

REMOTE_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo ""
echo "3. 选择认证方式："
echo "   a) HTTPS + Personal Access Token (推荐)"
echo "   b) SSH密钥"
read -p "   选择 (a/b): " AUTH_METHOD

case "$AUTH_METHOD" in
    [Aa])
        echo ""
        echo "📎 获取Personal Access Token步骤："
        echo "   1. 访问: https://github.com/settings/tokens"
        echo "   2. 点击 'Generate new token (classic)'"
        echo "   3. 勾选 'repo' 权限"
        echo "   4. 生成并复制token"
        echo ""
        read -p "   输入Token (输入时不显示): " -s TOKEN
        echo ""

        # 配置远程URL（包含token）
        AUTH_URL="https://${GITHUB_USER}:${TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"
        git -C "$REPO_ROOT" remote add origin "$AUTH_URL"

        # 保存token到git配置（可选）
        echo ""
        read -p "是否保存Token到git凭证管理器? (y/N): " SAVE_TOKEN
        if [[ "$SAVE_TOKEN" =~ ^[Yy]$ ]]; then
            git -C "$REPO_ROOT" config credential.helper store
            echo "✅ Token已保存"
        fi
        ;;

    [Bb])
        # 检查SSH key
        if [ ! -f "$HOME/.ssh/id_rsa.pub" ] && [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
            echo ""
            echo "🔑 未找到SSH密钥，正在生成..."
            read -p "   输入邮箱 (用于SSH密钥): " SSH_EMAIL
            ssh-keygen -t ed25519 -C "$SSH_EMAIL" -f "$HOME/.ssh/id_ed25519" -N ""
            echo ""
            echo "📋 请复制以下公钥到GitHub:"
            echo "   访问: https://github.com/settings/keys"
            echo "   点击 'New SSH key' 并粘贴："
            echo ""
            cat "$HOME/.ssh/id_ed25519.pub"
            echo ""
            read -p "按Enter继续..."
        fi

        REMOTE_URL="git@github.com:${GITHUB_USER}/${REPO_NAME}.git"
        git -C "$REPO_ROOT" remote add origin "$REMOTE_URL"
        ;;

    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac

echo ""
echo "🚀 推送到GitHub..."
git -C "$REPO_ROOT" push -u origin main

echo ""
echo "✅ 设置完成！"
echo ""
echo "📊 仓库地址: https://github.com/${GITHUB_USER}/${REPO_NAME}"
echo ""
echo "📌 后续使用："
echo "   手动上传: .github/scripts/upload_report.sh"
echo "   GitHub Actions自动上传: 每周二 09:00 UTC+8"
echo ""
