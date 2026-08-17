# OS交互设计部周报仓库

> 📊 自动化周报管理与可视化展示

---

## 🚀 快速开始

### 1. 首次配置（只需要一次）

```bash
# 给脚本执行权限
chmod +x .github/scripts/upload_report.sh

# 配置Git身份（如果没有配置过）
git config --global user.name "你的名字"
git config --global user.email "你的邮箱@vivo.com"

# 关联GitHub仓库（需要先在GitHub创建仓库）
git remote add origin https://github.com/你的用户名/仓库名.git
```

### 2. 手动上传最新周报

```bash
# 自动检测并上传最新周报
.github/scripts/upload_report.sh

# 上传指定日期的周报
.github/scripts/upload_report.sh 20260811

# 上传可视化版本
.github/scripts/upload_report.sh --visual

# 上传指定日期的可视化版本
.github/scripts/upload_report.sh 20260811 --visual
```

### 3. 查看帮助

```bash
.github/scripts/upload_report.sh --help
```

---

## 📁 目录结构

```
.
├── OS交互设计部周报_20260811.html          # 标准版周报
├── OS交互设计部周报_20260811_visual.html   # 可视化版周报
├── .github/
│   ├── scripts/
│   │   └── upload_report.sh                # 上传脚本
│   └── workflows/
│       └── weekly-report.yml               # GitHub Actions自动上传
├── README.md
└── .gitignore
```

---

## 🎨 周报版本说明

| 版本 | 文件名后缀 | 特点 |
|------|-----------|------|
| 标准版 | `_YYYYMMDD.html` | 传统表格形式，文字详细 |
| 可视化版 | `_YYYYMMDD_visual.html` | 图表展示，数据驱动，视觉丰富 |

---

## ⚙️ 自动化配置

### GitHub Actions 自动上传

已配置每周二上午9点自动检测并上传最新周报。

**触发方式：**
- ⏰ **定时触发**：每周二 09:00（UTC+8）
- 🖱️ **手动触发**：GitHub仓库页面 → Actions → Weekly Report Upload → Run workflow

**手动触发参数：**
- `report_date`: 指定上传的周报日期（YYYYMMDD格式，留空自动检测最新）
- `use_visual`: 是否上传可视化版本（默认是）

---

## 📈 上传历史

查看上传记录：

```bash
cat .github/logs/upload_history.log
```

---

## 🔗 相关链接

- [BlueCode 自动化面板](https://bluecode.vivo.xyz) - 查看和管理自动化任务
- [周报数据源](https://wiki.vivo.xyz) - vivo wiki 项目看板

---

## 💡 提示

- 周报文件命名规则：`OS交互设计部周报_YYYYMMDD.html` 或 `OS交互设计部周报_YYYYMMDD_visual.html`
- 可视化版周报包含：KPI卡片、项目状态卡、堆叠柱状图、环形进度图、风险热力图、里程碑时间轴等
- 所有上传记录都会保存在 `.github/logs/upload_history.log` 中

---

*Generated with [Claude Code](https://claude.com/claude-code)*
