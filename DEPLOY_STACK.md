# Hugo Stack 部署指南

## 当前状态

- **主题**: Stack Theme (v3) + 深蓝极简定制
- **配置方式**: 单文件 `hugo.toml`
- **颜色模式**: 自动跟随系统 + 手动切换
- **深色模式 CSS 选择器**: `:root[data-scheme="dark"]`

## 项目结构

```
hugo.stack/
├── hugo.toml                    # 主配置文件（含 [params.style] 全部样式参数）
├── CLAUDE.md                    # Claude Code 项目指导
├── README.md                    # 项目概述
├── assets/scss/
│    └── custom.scss             # 全部自定义样式（深蓝极简）
├── layouts/
│    ├── archives.html           # 自定义归档页
│    ├── single.html             # 自定义文章页
│    └── partials/
│        ├── head/
│        │    ├── custom.html              # CSS 变量注入
│        │    ├── custom-dark-forced.html  # 强制深色模式备份
│        │    └── custom-backup-light-normal.html  # 自动切换备份
│        ├── article/components/
│        │    ├── details.html
│        │    ├── navigation.html
│        │    ├── tags.html
│        │    └── tip.html
│        ├── article-list/
│        │    └── default.html
│        ├── sidebar/
│        │    └── left.html
│        └── widget/
│            ├── archives.html
│            └── toc.html
├── config/                      # 模块化配置（备用）
├── content/                     # Markdown 内容
├── content-org/                 # Org-mode 源文件
└── static/                      # 静态资源
```

## 本地开发

```bash
# 启动开发服务器（含草稿）
hugo server -D

# 构建生产版本
hugo --minify
```

输出目录: `public/`

## 主题配置

### 浅色模式
- 主色: `#0f1b3d`（深蓝）
- 背景: `#f4f7fe`（极浅蓝）
- 圆角: 12px 卡片, 20px 标签, 8px 按钮

### 深色模式
- 卡片背景: `#1a2332`（深蓝黑）
- 标题颜色: `#f0f4ff`（极浅冷白）

### 自动切换
- 跟随系统深浅模式
- 网站内提供手动切换按钮

## 部署步骤

```bash
# 清理旧输出
rm -rf public/

# 构建生产版本
hugo --minify

# 部署 public/ 目录到服务器
```

## 样式定制

所有样式通过 `hugo.toml` 的 `[params.style]` 配置，无需修改 SCSS：

```toml
[params.style]
  sidebarWidth = "320px"
  articleMaxWidth = "720px"
  [params.style.colors]
    primary = "#0f1b3d"
    bgPrimary = "#ffffff"
    darkBgSecondary = "#1a2332"
```

如需修改，编辑 `assets/scss/custom.scss` 即可。

## 注意事项

1. **深色模式**: 使用 `:root[data-scheme="dark"]` 选择器（非 `html`）
2. **代码高亮**: catppuccin-macchiato 风格
3. **搜索**: 内置 Fuse.js 搜索
4. **响应式**: 自动适配移动端
5. **RSS**: 已启用 `rssFullContent`

## 资源链接

- [Stack 主题文档](https://stack.jimmycai.com/)
- [GitHub 仓库](https://github.com/CaiMoney/hugo-theme-stack)
