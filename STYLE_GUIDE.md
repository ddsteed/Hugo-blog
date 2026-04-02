# Hugo Stack 主题自定义样式配置指南

> 本文档详细说明了博客对 Stack 主题的所有自定义样式改动
> 最后更新：2026-03-26

---

## 📁 自定义文件清单

```
hugo.stack/
├── layouts/                          # 模板覆盖
│   ├── archives.html                 # 自定义归档页面
│   ├── single.html                   # 自定义文章页面
│   └── partials/
│       ├── head/
│       │   └── custom.html           # CSS 变量注入
│       ├── widget/
│       │   └── archives.html         # 自定义归档小部件
│       ├── article-list/
│       │   └── default.html          # 自定义文章列表（含摘要）
│       └── article/components/
│           ├── details.html          # 自定义文章元数据（字数、阅读时间）
│           ├── tags.html             # 自定义标签显示
│           └── navigation.html       # 自定义文章导航（上一篇/下一篇）
│
├── assets/
│   └── scss/
│       └── custom.scss               # 自定义样式（使用 CSS 变量）
│
└── hugo.toml                         # 主配置文件（含 [params.style]）
```

---

## 🎨 配置系统架构

```
┌─────────────────────────────────────────────────────────────┐
│                      hugo.toml                              │
│                    [params.style]                           │
│         (颜色、字体、间距、圆角、阴影、过渡)                  │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│           layouts/partials/head/custom.html                 │
│              (读取 hugo.toml → 生成 CSS 变量)                 │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              assets/scss/custom.scss                        │
│           (使用 CSS 变量定义所有样式)                         │
└─────────────────────────────────────────────────────────────┘
```

**核心思想**：所有样式参数集中在 `hugo.toml` 配置，CSS 通过变量使用这些参数。

---

## 📋 功能模块详细说明

### 1. 可移植样式系统

#### 1.1 配置文件：`hugo.toml`

**新增 `[params.style]` 配置节**（第 202-303 行）：

```toml
[params.style]
  # 布局尺寸
  sidebarWidth = "320px"
  headerHeight = "64px"
  articleMaxWidth = "720px"

  # 组件尺寸
  sidebarAvatarSize = "160px"
  articleTitleSize = "1.4rem"
  articleBodySize = "1.1rem"

  # 颜色系统
  [params.style.colors]
    primary = "#3b82f6"           # 主色
    accent = "#8b5cf6"            # 强调色
    bgPrimary = "#ffffff"         # 背景色
    textPrimary = "#1e293b"       # 文字色
    # ... 更多颜色

  # 字体系统
  [params.style.fonts]
    base = "'-apple-system', ..."
    heading = "'-apple-system', ..."
    mono = "'JetBrains Mono', ..."

  # 间距系统
  [params.style.spacing]
    xs = "0.5rem"
    sm = "0.75rem"
    md = "1rem"
    # ... 更多间距

  # 效果（圆角、阴影、过渡）
  [params.style.effects]
    radiusMd = "8px"
    shadowMd = "0 4px 6px rgba(0, 0, 0, 0.07)"
    transitionFast = "150ms ease"
```

#### 1.2 CSS 变量注入：`layouts/partials/head/custom.html`

**功能**：从 `hugo.toml` 读取配置，生成 CSS 变量

**关键实现**：
```html
<style>
:root {
  --primary-color: {{ $colors.primary | default "#3b82f6" }};
  --bg-primary: {{ $colors.bgPrimary | default "#ffffff" }};
  --font-family-base: {{ $fonts.base | default "..." }};
  --spacing-md: {{ $spacing.md | default "1rem" }};
  /* ... 所有 CSS 变量 */
}

/* 暗色模式变量 */
--dark-bg-primary: {{ $colors.darkBgPrimary | default "#0f172a" }};
--dark-text-primary: {{ $colors.darkTextPrimary | default "#f1f5f9" }};
</style>
```

#### 1.3 样式实现：`assets/scss/custom.scss`

**功能**：使用 CSS 变量定义所有样式

```scss
body {
  font-size: var(--font-size-base);
  color: var(--text-primary);
  background-color: var(--bg-primary);
}

.article-list article {
  padding: var(--spacing-md);
  border-radius: var(--radius-lg);
  background-color: var(--bg-secondary);
}
```

**移植方法**：要移植到其他主题，只需复制：
1. `hugo.toml` 中的 `[params.style]` 配置
2. `layouts/partials/head/custom.html`（CSS 变量注入）
3. `assets/scss/custom.scss`（样式定义）

---

### 2. 深色模式修复

#### 问题原因
Stack 主题使用 **JavaScript 切换 `data-scheme="dark"` 属性**，而非 CSS 媒体查询。

#### 解决方案
使用 `html[data-scheme="dark"]` 选择器：

```scss
/* ❌ 错误 - 不起作用 */
@media (prefers-color-scheme: dark) {
  body { background-color: var(--dark-bg-primary); }
}

/* ✅ 正确 */
html[data-scheme="dark"] {
  body {
    background-color: var(--dark-bg-primary) !important;
    color: var(--dark-text-primary) !important;
  }

  .sidebar {
    background-color: var(--dark-bg-secondary) !important;
  }

  /* ... 所有元素都要用 !important 覆盖 */
}
```

#### 文件位置
- `assets/scss/custom.scss` 第 473-658 行

---

### 3. 文章列表优化

#### 3.1 文章摘要显示
**文件**：`layouts/partials/article-list/default.html`

**改动**：添加三行文章摘要

```hugo
<div class="article-preview">
    {{ if .Params.description }}
        {{ .Description }}
    {{ else }}
        {{ $summary := substr .Plain 0 90 }}
        {{ $summary }}...
    {{ end }}
</div>
```

**样式**：`custom.scss` 第 41-64 行
```scss
.article-preview {
  display: -webkit-box;
  -webkit-line-clamp: 3;  /* 最多三行 */
  overflow: hidden;
  text-overflow: ellipsis;
}
```

#### 3.2 文章元数据增强
**文件**：`layouts/partials/article/components/details.html`

**改动**：添加字数统计

```hugo
{{ if $showWordCount }}
    <span class="article-word-count">
        <svg>...</svg>
        <span>{{ $Page.WordCount }} 字</span>
    </span>
{{ end }}
```

---

### 4. 分类和标签样式简化

#### 改动说明
移除默认的彩色背景，改为简洁的边框样式。

#### 模板覆盖
- **分类**：`layouts/partials/article/components/details.html`
- **标签**：`layouts/partials/article/components/tags.html`

#### 样式实现
`custom.scss` 第 361-443 行

```scss
.article-category a,
.category-link {
  background-color: transparent !important;
  color: var(--text-secondary) !important;
  border: 1px solid var(--border-color);
  padding: 6px 14px;
  border-radius: var(--radius-md);

  &:hover {
    background-color: var(--accent-color) !important;
    color: white !important;
  }
}
```

---

### 5. 侧边栏 Logo 替换

#### 改动说明
使用 CSS `::before` 伪元素添加 Logo 图片，隐藏默认的 avatar/emoji。

#### 配置
`hugo.toml` 第 96-100 行：

```toml
[params.sidebar]
  emoji = ""          # 留空以隐藏
  subtitle = "Old Fashion Man"
  avatar = "/img/fox.png"
```

#### 样式实现
`custom.scss` 第 110-134 行：

```scss
.sidebar header::before {
  content: "";
  display: block;
  width: 80px;
  height: 80px;
  margin: 0 auto var(--spacing-md);
  background-image: url('/img/fox.png');
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
}

.sidebar .site-avatar {
  display: none !important;
}
```

---

### 6. 归档页面简化

#### 改动说明
移除分类卡片显示，改为简单的链接列表。

#### 文件
`layouts/archives.html`

#### 对比
```hugo
<!-- 原主题：卡片式 -->
<div class="article-list--tile">
    {{ range $terms }}
        {{ partial "article-list/tile" . }}
    {{ end }}
</div>

<!-- 自定义：链接式 -->
<div class="category-list-simple">
    {{ range $terms }}
    <a href="{{ .RelPermalink }}" class="category-link-simple">
        {{ .Title }}
    </a>
    {{ end }}
</div>
```

#### 样式
`custom.scss` 第 797-830 行

---

### 7. 归档小部件优化

#### 改动说明
移除年份数量限制，添加滚动条。

#### 配置
`hugo.toml` 第 131 行：
```toml
# 原来：{ type = "archives", params = { limit = 10 } }
# 现在：{ type = "archives" }  # 无限制
```

#### 模板
`layouts/partials/widget/archives.html`
- 移除了 `limit` 限制逻辑
- 移除了"更多"链接

#### 样式
`custom.scss` 第 157-190 行
```scss
.widget-archive--list {
  max-height: 400px;
  overflow-y: auto;
  /* 自定义滚动条 */
}
```

---

### 8. 文章导航

#### 改动说明
移除块状相关文章，添加简洁的上一篇/下一篇导航。

#### 文件
`layouts/partials/article/components/navigation.html`

#### 实现
```hugo
{{ $prev := .PrevInSection }}
{{ $next := .NextInSection }}

<div class="nav-container">
    {{ with $prev }}
    <div class="nav-item nav-prev">
        <span class="nav-label">上一篇</span>
        <a href="{{ .RelPermalink }}">{{ .Title }}</a>
    </div>
    {{ end }}
    {{ with $next }}
    <div class="nav-item nav-next">
        <span class="nav-label">下一篇</span>
        <a href="{{ .RelPermalink }}">{{ .Title }}</a>
    </div>
    {{ end }}
</div>
```

#### 样式
`custom.scss` 第 714-794 行

---

### 9. 文章页面覆盖

#### 文件
`layouts/single.html`

#### 改动
```hugo
{{/* 移除：*/}}
{{ partial "article/components/related-content" . }}

{{/* 添加：*/}}
{{ partial "article/components/navigation" . }}
```

---

## 🔄 与原主题的对比

| 功能 | 原主题 | 自定义 |
|------|--------|--------|
| 样式配置 | 修改 SCSS 文件 | `hugo.toml` 集中配置 |
| 分类/标签 | 彩色背景块 | 简洁边框样式 |
| 文章摘要 | 无 | 三行截断 |
| 字数统计 | 无 | 显示 |
| 侧边栏头像 | emoji + avatar | CSS Logo 图片 |
| 归档页面分类 | 卡片式（带图片） | 链接式（无图片） |
| 归档小部件 | 限制 5-10 年 | 无限制 + 滚动 |
| 文章底部导航 | 相关文章卡片 | 上一篇/下一篇链接 |
| 深色模式 CSS | `@media` 查询 | `data-scheme` 属性 |

---

## 📝 快速配置检查清单

### 颜色主题
- [ ] 主色：`[params.style.colors.primary]`
- [ ] 强调色：`[params.style.colors.accent]`
- [ ] 背景色：`[params.style.colors.bgPrimary]`
- [ ] 暗色模式：`[params.style.colors.darkBgPrimary]`

### 字体排版
- [ ] 正文字号：`[params.style.fonts.base]` + `[params.articleTitleSize]`
- [ ] 行高：`[params.style.fonts.lineHeightNormal]`
- [ ] 等宽字体：`[params.style.fonts.mono]`

### 布局间距
- [ ] 侧边栏宽度：`[params.style.sidebarWidth]`
- [ ] 文章最大宽度：`[params.style.articleMaxWidth]`
- [ ] 间距系统：`[params.style.spacing]`

### 组件样式
- [ ] 圆角：`[params.style.effects.radiusMd]`
- [ ] 阴影：`[params.style.effects.shadowMd]`
- [ ] 过渡动画：`[params.style.effects.transitionFast]`

---

## 🚀 移植到新主题

只需复制这 3 个文件/配置：

1. **hugo.toml** - 复制 `[params.style]` 整个配置节
2. **layouts/partials/head/custom.html** - CSS 变量注入
3. **assets/scss/custom.scss** - 样式定义（可根据需要裁剪）

然后在新主题中引用：
```hugo
{{ partial "head/custom.html" . }}
```

---

## 🛠️ 调试技巧

### 1. 检查 CSS 变量是否加载
```javascript
// 浏览器控制台
getComputedStyle(document.documentElement)
  .getPropertyValue('--primary-color')
```

### 2. 检查深色模式状态
```javascript
// 查看当前 scheme
document.documentElement.getAttribute('data-scheme')
```

### 3. 查看最终渲染的 HTML
```bash
hugo server -D --disableFastRender
```

---

## 📚 相关技能

- **hugo-stack-dark-mode** - 深色模式 CSS 修复详解
- **hugo-portable-style-config** - 可移植样式配置系统
- **hugo-stack-customization** - Stack 主题高级定制

---

*本文档由 AI 助手生成，记录博客样式配置的完整实现。*
