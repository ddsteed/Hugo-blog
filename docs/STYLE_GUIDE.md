# Hugo Stack 样式指南

> 本文档说明博客的样式配置系统
> 最后更新：2026-05-03

---

## 配置系统架构

博客使用主题切换系统管理样式，支持两种配置模式：

```
┌─────────────────────────────────────────────────────────────┐
│                   theme-profiles/                           │
│                  （主题配置目录）                            │
├─────────────────────────────────────────────────────────────┤
│  dark-blue/     │  study/ (当前)                               │
│  ┌─────────┐ │  ┌─────────┐                                │
│  │完整样式 │ │  │简洁配置 │                                │
│  │配置系统 │ │  │默认样式 │                                │
│  └─────────┘ │  └─────────┘                                │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼ ./theme-select
┌─────────────────────────────────────────────────────────────┐
│                   hugo.toml                                 │
│              （从主题配置复制）                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 两种主题样式

### dark-blue - 完整样式配置

**特点**：
- 自定义样式系统，完全可控
- 深蓝极简配色
- 自动深色模式 + 手动切换按钮

**配置文件**：`theme-profiles/dark-blue/config.toml`

**核心配置**：
```toml
[params.style]
  sidebarWidth = "320px"
  articleMaxWidth = "720px"

  [params.style.colors]
    primary = "#0f1b3d"           # 深蓝主色
    bgPrimary = "#ffffff"         # 纯白背景
    bgSecondary = "#f4f7fe"       # 极浅蓝
    darkBgSecondary = "#1a2332"   # 深色模式卡片背景

  [params.style.fonts]
    base = "'-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', sans-serif"

  [params.style.effects]
    radiusLg = "12px"             # 卡片圆角
    shadowMd = "0 4px 6px rgba(0, 0, 0, 0.07)"
```

**深色模式**：
- CSS 选择器：`:root[data-scheme="dark"]`
- 卡片背景：`#1a2332`
- 标题颜色：`#f0f4ff`

### study - 温暖的书房（当前）

**特点**：
- 简洁配置，使用主题默认样式
- 自动深色模式（无手动切换按钮）
- 专注阅读体验

**配置文件**：`theme-profiles/study/config.toml`

**代码高亮**：monokai 风格

---

## 切换主题

```bash
# 切换到 dark-blue（完整样式）
./theme-select dark-blue

# 切换到 study（简洁样式）
./theme-select study

# 查看当前主题
./theme-select
```

---

## 自定义样式

### 方法一：修改主题配置

编辑 `theme-profiles/<theme>/config.toml`：

```toml
[params.style.colors]
  primary = "#your-color"      # 修改主色
  bgSecondary = "#your-color"  # 修改背景色
```

然后重新应用主题：
```bash
./theme-select <theme>
```

### 方法二：创建新主题

```bash
# 复制现有主题
cp -r theme-profiles/study theme-profiles/mytheme

# 编辑配置
vim theme-profiles/mytheme/config.toml

# 切换到新主题
./theme-select mytheme
```

---

## 文件清单

```
hugo.stack/
├── theme-select                      # 主题切换脚本
├── .active-theme                     # 当前主题标识
├── hugo.toml                         # 主配置（自动生成）
├── layouts/                          # 自定义布局（自动生成）
├── theme-profiles/                   # 主题配置
│   ├── dark-blue/
│   │   ├── config.toml              # 完整样式配置
│   │   └── layouts/
│   └── study/                        # 当前主题
│       ├── config.toml              # 简洁配置
│       └── layouts/
└── assets/
    └── scss/
        └── custom.scss              # 自定义样式（dark-blue 使用）
```

---

## 配色方案

### dark-blue 浅色模式

| 用途 | 颜色 |
|------|------|
| 主色 | `#0f1b3d` |
| 悬停色 | `#1a2b5e` |
| 背景 | `#ffffff` |
| 次背景 | `#f4f7fe` |
| 主文本 | `#0f1b3d` |
| 次文本 | `#4a5a7a` |

### dark-blue 深色模式

| 用途 | 颜色 |
|------|------|
| 卡片背景 | `#1a2332` |
| 次背景 | `#1e293b` |
| 主文本 | `#e2e8f0` |
| 次文本 | `#cbd5e1` |
| 标题 | `#f0f4ff` |

---

## 组件样式

### 分类/标签

简洁边框样式（dark-blue）：
```scss
.article-category a {
  background-color: transparent;
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
}
```

### 文章列表

- 显示三行截断摘要
- 字数统计和阅读时间
- 卡片圆角 12px

### 侧边栏

- 宽度：320px
- Logo：160x160px
- 头像：CSS `::before` 伪元素

---

## 深色模式实现

### CSS 选择器

使用 `:root[data-scheme="dark"]` 而非 `html[data-scheme="dark"]`：

```scss
:root[data-scheme="dark"] {
  --card-background: #1a2332;
  --card-text-color-main: #e2e8f0;

  body {
    background-color: var(--dark-bg-primary);
  }
}
```

### 切换方式

- **dark-blue**: 自动跟随系统 + 手动切换按钮
- **study**: 仅自动跟随系统

---

## 与原主题对比

| 功能 | 原主题 | dark-blue | study |
|------|--------|--------|-------|
| 样式配置 | 修改 SCSS | hugo.toml | 默认 |
| 配色 | 默认蓝灰 | 深蓝极简 | 默认 |
| 深色切换 | 自动 | 自动+手动 | 自动 |
| 代码高亮 | 默认 | catppuccin | monokai |

---

## 调试技巧

### 检查 CSS 变量

```javascript
// 浏览器控制台
getComputedStyle(document.documentElement)
  .getPropertyValue('--primary-color')
```

### 检查深色模式状态

```javascript
// 查看当前 scheme
document.documentElement.getAttribute('data-scheme')
```

### 本地预览

```bash
hugo server -D --disableFastRender
```

---

## 移植样式到新主题

只需复制这些文件/配置：

1. **theme-profiles/dark-blue/config.toml** — 完整样式配置
2. **layouts/partials/head/custom.html** — CSS 变量注入
3. **assets/scss/custom.scss** — 样式定义

或使用简洁模式（study）：
- 仅需修改基础配置，无需额外样式文件

---

*本文档记录博客样式配置的完整实现*
