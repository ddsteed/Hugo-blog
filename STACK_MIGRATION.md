# Hugo Stack 迁移指南

## 当前状态

- **主题**: Stack Theme (v3) + 深蓝极简定制
- **配置方式**: 单文件 `hugo.toml`（非模块化 config 目录）
- **内容格式**: Org-mode → ox-hugo → Markdown

## 快速开始

```bash
# 本地预览
hugo server -D

# 构建生产版本
hugo --minify
```

## 配置结构

```
hugo.toml                    # 单文件配置（含 [params.style] 全部样式参数）
config/                      # 模块化配置（备用，不常用）
├── hugo.toml               # 基础配置 + 菜单
├── params.toml             # 主题参数
├── languages.toml          # 语言设置
├── markup.toml             # Markdown 渲染
└── social.toml             # 社交媒体
```

## 样式系统

### 配置方式

所有样式参数集中在 `hugo.toml` 的 `[params.style]` 配置节：

```toml
[params.style]
  sidebarWidth = "320px"
  articleMaxWidth = "720px"
  [params.style.colors]
    primary = "#0f1b3d"
    bgPrimary = "#ffffff"
    darkBgSecondary = "#1a2332"
   [params.style.fonts]
    base = "'-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', sans-serif"
   [params.style.effects]
    radiusMd = "8px"
    shadowMd = "0 4px 6px rgba(0, 0, 0, 0.07)"
```

### 自定义样式

- `layouts/partials/head/custom.html` — 从 `hugo.toml` 读取配置，生成 CSS 变量
- `assets/scss/custom.scss` — 使用 CSS 变量定义所有样式

### 深色模式

- **选择器**: `:root[data-scheme="dark"]`（非 `html[data-scheme="dark"]`）
- **模式**: 自动跟随系统 + 手动切换按钮

## 内容工作流

博客文章在 `content-org/` 中以 Org-mode 格式编写，通过 ox-hugo 导出为 `content/post/` 下的 Markdown 文件。

## 与 PaperMod 的主要区别

| 特性 | PaperMod | Stack |
|------|----------|-------|
| 布局 | 单列 | 三列（侧边栏 + 内容 + 小部件） |
| 首页 | 自定义 info | 文章卡片列表 |
| 侧边栏 | 无 | 左侧个人信息 |
| 小部件 | 无 | 右侧可配置 |
| 搜索 | 需配置 | 内置 |
| 深色模式 | 需手动 | 自动跟随系统 |

## 常见问题

### Q: 头像不显示？
A: 确保图片在 `static/img/` 目录，检查 `hugo.toml` 中的 `avatar` 路径。

### Q: 如何隐藏某个小部件？
A: 从 `[params.widgets]` 数组中删除对应条目。

### Q: 如何添加评论系统？
A: 编辑 `hugo.toml` 中的 `[params.comments]` 配置。

### Q: 深色模式卡片背景是灰色？
A: 在 `assets/scss/custom.scss` 的 `:root[data-scheme="dark"]` 块中设置 `--card-background`。

## 资源链接

- [Stack 主题文档](https://stack.jimmycai.com/)
- [GitHub 仓库](https://github.com/CaiMoney/hugo-theme-stack)
- [在线演示](https://demo.stack.cai.im/)
