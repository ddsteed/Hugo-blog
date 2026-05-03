# Hugo Stack 迁移指南

## 当前状态

- **主题**: Stack Theme (v3)
- **当前样式**: study (温暖的书房)
- **配置方式**: 单文件 `hugo.toml`（通过主题切换系统管理）
- **内容格式**: Org-mode → ox-hugo → Markdown
- **主题切换**: 支持 dark-blue 和 study 两种样式

---

## 快速开始

```bash
# 本地预览
hugo server -D

# 构建生产版本
hugo --minify
```

---

## 主题切换系统

博客使用自定义主题切换系统，可在不同样式配置间快速切换：

```bash
# 查看可用主题
./theme-select

# 切换主题
./theme-select dark-blue    # 完整样式配置
./theme-select study     # 温暖的书房（当前）
```

详见 [README-THEME-SWITCH.md](README-THEME-SWITCH.md)

---

## 配置结构

### 单文件配置（当前使用）

```
hugo.toml                    # 主配置文件（从 theme-profiles/ 复制）
theme-profiles/              # 主题配置目录
├── dark-blue/
│   ├── config.toml         # 完整配置（含 [params.style]）
│   └── layouts/            # 自定义布局
└── study/                   # 当前主题
    ├── config.toml         # 简洁配置
    └── layouts/            # 自定义布局
```

### 配置文件说明

**dark-blue/config.toml**:
- 完整的 [params.style] 配置系统
- 深蓝极简配色（#0f1b3d 主色）
- 自动深色模式 + 手动切换按钮
- 代码高亮：catppuccin-macchiato

**study/config.toml**:
- 简洁配置，使用主题默认样式
- 自动深色模式（无手动切换按钮）
- 代码高亮：monokai

---

## 样式系统

### dark-blue 主题样式配置

所有样式参数集中在 `config.toml` 的 `[params.style]` 配置节：

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

- `layouts/partials/head/custom.html` — 从配置读取 CSS 变量
- `assets/scss/custom.scss` — 使用 CSS 变量定义样式

### 深色模式

- **选择器**: `:root[data-scheme="dark"]`
- **dark-blue**: 自动 + 手动切换
- **study**: 仅自动跟随系统

---

## 内容工作流

博客文章在 `content-org/` 中以 Org-mode 格式编写，通过 ox-hugo 导出为 `content/post/` 下的 Markdown 文件。

### Org-mode 文章结构

```org
#+hugo_base_dir: ../
#+hugo_section: /post/

* ✔ DONE 文章标题                                          :标签1:标签2:@分类:
CLOSED: [2026-03-21 Sat 19:34]
:PROPERTIES:
:EXPORT_FILE_NAME: 20260321-post-slug
:END:

内容...
```

---

## 与 PaperMod 的主要区别

| 特性 | PaperMod | Stack |
|------|----------|-------|
| 布局 | 单列 | 三列（侧边栏 + 内容 + 小部件） |
| 首页 | 自定义 info | 文章卡片列表 |
| 侧边栏 | 无 | 左侧个人信息 |
| 小部件 | 无 | 右侧可配置 |
| 搜索 | 需配置 | 内置 Fuse.js |
| 深色模式 | 需手动 | 自动跟随系统 |

---

## 常见问题

### Q: 如何切换主题样式？
A: 使用 `./theme-select <theme-name>` 命令

### Q: 头像不显示？
A: 确保图片在 `static/img/` 目录，检查配置中的 `avatar` 路径

### Q: 如何隐藏某个小部件？
A: 编辑 `theme-profiles/<theme>/config.toml`，从 `[params.widgets]` 数组中删除对应条目

### Q: 深色模式卡片背景是灰色？
A: 在 `assets/scss/custom.scss` 的 `:root[data-scheme="dark"]` 块中设置 `--card-background`

### Q: 如何修改样式？
A: 编辑 `theme-profiles/<theme>/config.toml`，然后重新运行 `./theme-select <theme>` 应用

---

## 资源链接

- [Stack 主题文档](https://stack.jimmycai.com/)
- [GitHub 仓库](https://github.com/CaiJimmy/hugo-theme-stack)
- [在线演示](https://demo.stack.cai.im/)
