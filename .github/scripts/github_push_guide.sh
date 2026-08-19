#!/bin/bash
# =============================================================================
# GitHub 推送指南 - 在本地终端执行
# =============================================================================
# 仓库: https://github.com/YYYJane/weekly.git
# 本地路径: /Users/11100111/Desktop/桌面/管理提效专项
# =============================================================================

echo "========================================"
echo "  🚀 GitHub 推送操作指南"
echo "========================================"
echo ""
echo "仓库: https://github.com/YYYJane/weekly"
echo "本地路径: /Users/11100111/Desktop/桌面/管理提效专项"
echo ""

# 检查GitHub是否可访问
echo "📡 检查GitHub网络连接..."
if curl -s --connect-timeout 5 https://github.com > /dev/null; then
    echo "✅ GitHub 可访问"
else
    echo "⚠️  GitHub 连接超时，请检查："
    echo "   1. 是否连接了公司内网VPN？"
    echo "   2. 是否需要配置代理？"
    echo ""
    echo "如果需要代理，请设置："
    echo "   export https_proxy=http://代理地址:端口"
    echo ""
fi

echo ""
echo "========================================"
echo "  步骤1: 检查SSH密钥"
echo "========================================"

if [ -f "$HOME/.ssh/id_ed25519.pub" ] || [ -f "$HOME/.ssh/id_rsa.pub" ]; then
    echo "✅ 已有SSH密钥"
    if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
        echo "   公钥文件: ~/.ssh/id_ed25519.pub"
    else
        echo "   公钥文件: ~/.ssh/id_rsa.pub"
    fi
else
    echo "🔑 需要生成SSH密钥"
    echo ""
    echo "请执行以下命令（按3次回车使用默认设置）："
    echo ""
    echo "   ssh-keygen -t ed25519 -C '11100111@vivo.com'"
    echo ""
    echo "生成后，复制公钥到GitHub："
    echo "   1. 访问: https://github.com/settings/keys"
    echo "   2. 点击 'New SSH key'"
    echo "   3. 粘贴以下公钥内容："
    echo ""
    echo "   $(cat ~/.ssh/id_ed25519.pub 2>/dev/null || cat ~/.ssh/id_rsa.pub 2>/dev/null || echo '请先执行上面的ssh-keygen命令')"
    echo ""
fi

echo ""
echo "========================================"
echo "  步骤2: 配置SSH方式推送"
echo "========================================"
echo ""
echo "请执行以下命令："
echo ""
echo "   cd '/Users/11100111/Desktop/桌面/管理提效专项'"
echo "   git remote set-url origin git@github.com:YYYJane/weekly.git"
echo "   git remote -v"
echo ""

echo ""
echo "========================================"
echo "  步骤3: 推送代码"
echo "========================================"
echo ""
echo "执行推送："
echo ""
echo "   git push -u origin main"
echo ""
echo "如果是第一次连接GitHub，会提示确认主机指纹，输入 yes 即可。"
echo ""

echo ""
echo "========================================"
echo "  步骤4: 验证推送"
echo "========================================"
echo ""
echo "推送成功后，访问以下链接查看："
echo "   https://github.com/YYYJane/weekly"
echo ""

echo ""
echo "========================================"
echo "  后续使用（上传周报）"
echo "========================================"
echo ""
echo "方法一: 手动上传"
echo "   cd '/Users/11100111/Desktop/桌面/管理提效专项'"
echo "   .github/scripts/upload_report.sh"
echo ""
echo "方法二: GitHub Actions自动上传（已配置）"
echo "   - 每周二 09:00 自动检测最新周报并推送"
echo "   - 可在GitHub仓库 Actions 标签页手动触发"
echo ""
echo "========================================"
