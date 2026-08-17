#!/bin/bash
# =============================================================================
# OS交互设计部周报自动上传脚本
# =============================================================================
# 用法:
#   ./upload_report.sh                    # 自动查找最新周报并上传
#   ./upload_report.sh 20260811           # 上传指定日期的周报
#   ./upload_report.sh --visual           # 上传最新可视化版
#   ./upload_report.sh 20260811 --visual  # 上传指定日期可视化版
# =============================================================================

set -e

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GITHUB_REPO=""
BRANCH="main"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_err() { echo -e "${RED}[ERROR]${NC} $1"; }

# 解析参数
TARGET_DATE=""
USE_VISUAL=false

for arg in "$@"; do
    case "$arg" in
        --visual) USE_VISUAL=true ;;
        --help|-h)
            echo "OS交互设计部周报上传脚本"
            echo ""
            echo "用法:"
            echo "  ./upload_report.sh                    自动查找最新周报并上传"
            echo "  ./upload_report.sh YYYYMMDD           上传指定日期的周报"
            echo "  ./upload_report.sh --visual           上传最新可视化版周报"
            echo "  ./upload_report.sh YYYYMMDD --visual  上传指定日期可视化版周报"
            exit 0
            ;;
        *)
            if [[ "$arg" =~ ^[0-9]{8}$ ]]; then
                TARGET_DATE="$arg"
            fi
            ;;
    esac
done

cd "$REPO_ROOT"

# 检查GitHub配置
if ! git remote get-url origin &>/dev/null; then
    log_err "未配置GitHub远程仓库！"
    log_info "请先在GitHub创建仓库，然后运行："
    log_info "  git remote add origin https://github.com/你的用户名/仓库名.git"
    exit 1
fi

# 读取远程仓库信息
REMOTE_URL=$(git remote get-url origin)
log_info "远程仓库: $REMOTE_URL"

# 查找要上传的周报文件
if [ -n "$TARGET_DATE" ]; then
    # 指定日期
    if [ "$USE_VISUAL" = true ]; then
        REPORT_FILE="OS交互设计部周报_${TARGET_DATE}_visual.html"
    else
        REPORT_FILE="OS交互设计部周报_${TARGET_DATE}.html"
    fi

    if [ ! -f "$REPORT_FILE" ]; then
        log_err "未找到周报文件: $REPORT_FILE"
        log_info "可用周报文件:"
        ls -1 OS交互设计部周报_*.html 2>/dev/null || echo "  (无)"
        exit 1
    fi
else
    # 自动查找最新
    if [ "$USE_VISUAL" = true ]; then
        REPORT_FILE=$(ls -1t OS交互设计部周报_*_visual.html 2>/dev/null | head -1)
        PATTERN="*_visual.html"
    else
        # 优先找非visual的最新文件
        REPORT_FILE=$(ls -1t OS交互设计部周报_*.html 2>/dev/null | grep -v "_visual" | head -1)
        PATTERN="*.html (排除visual)"
    fi

    if [ -z "$REPORT_FILE" ]; then
        log_err "未找到周报文件！"
        log_info "可用周报文件:"
        ls -1 OS交互设计部周报_*.html 2>/dev/null || echo "  (无)"
        exit 1
    fi
fi

log_info "准备上传: $REPORT_FILE"

# 提取日期
FILE_DATE=$(echo "$REPORT_FILE" | grep -oE '[0-9]{8}' | head -1)
if [ -z "$FILE_DATE" ]; then
    FILE_DATE=$(date +%Y%m%d)
fi

# 格式化日期用于commit message
FORMAT_DATE="${FILE_DATE:0:4}-${FILE_DATE:4:2}-${FILE_DATE:6:2}"

# 检查是否是visual版本
if [[ "$REPORT_FILE" == *"_visual"* ]]; then
    COMMIT_PREFIX="🎨"
    COMMIT_TYPE="可视化版"
else
    COMMIT_PREFIX="📊"
    COMMIT_TYPE="标准版"
fi

# Git操作
log_info "开始Git操作..."

# 确保在主分支
git checkout "$BRANCH" 2>/dev/null || git checkout -b "$BRANCH"

# 拉取最新代码（如果有远程分支）
if git ls-remote --exit-code origin "$BRANCH" &>/dev/null; then
    log_info "同步远程分支..."
    git pull origin "$BRANCH" --rebase || true
fi

# 添加文件
git add "$REPORT_FILE"

# 检查是否有变更
if git diff --cached --quiet; then
    log_warn "文件未变更，无需提交"
    exit 0
fi

# 提交
git commit -m "${COMMIT_PREFIX} 周报 ${FORMAT_DATE} (${COMMIT_TYPE})

- 文件: ${REPORT_FILE}
- 生成时间: $(date '+%Y-%m-%d %H:%M:%S')
- 类型: ${COMMIT_TYPE}

🤖 Generated with [Claude Code](https://claude.com/claude-code)"

# 推送
log_info "推送到GitHub..."
git push origin "$BRANCH"

log_ok "✅ 周报上传成功！"
log_info "文件: $REPORT_FILE"
log_info "日期: $FORMAT_DATE"
log_info "类型: $COMMIT_TYPE"

# 尝试显示GitHub链接
if [[ "$REMOTE_URL" == *"github.com"* ]]; then
    # 转换URL格式
    if [[ "$REMOTE_URL" == git@github.com:* ]]; then
        REPO_PATH="${REMOTE_URL#git@github.com:}"
        REPO_PATH="${REPO_PATH%.git}"
    else
        REPO_PATH="${REMOTE_URL#https://github.com/}"
        REPO_PATH="${REPO_PATH%.git}"
    fi

    GITHUB_LINK="https://github.com/${REPO_PATH}/blob/${BRANCH}/${REPORT_FILE}"
    log_info "在线查看: $GITHUB_LINK"
fi

# 更新最近上传记录
mkdir -p .github/logs
echo "$(date '+%Y-%m-%d %H:%M:%S') | $REPORT_FILE | $COMMIT_TYPE" >> .github/logs/upload_history.log

log_ok "完成！"
