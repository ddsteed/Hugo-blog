# Hugo Stack 主题自定义样式配置指南

> 本文档详细说明了博客对 Stack 主题的所有自定义样式改动
> 最后更新：2026-05-02

---

## 配置系统架构

```
┌──────────────────────────────────────────────────────────────────┐
│                      hugo.toml                                   │
│                     [params.style]                               │
│          (颜色、字体、间距、圆角、阴影、过渡)                        │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────────────┐
│         layouts/partials/head/custom.html                          │
│              (读取 hugo.toml → 生成 CSS 变量)                        │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────────────┐
│               assets/scss/custom.scss                              │
│            (使用 CSS 变量定义所有样式)                                │
└──────────────────────────────────────────────────────────────────┘
```

**核心思想**：所有样式参数集中在 `hugo.toml` 配置，CSS 通过变量使用这些参数。

---

## 文件清单

```
hugo.stack/
├── hugo.toml                           # 主配置（含 [params.style]）
├── layouts/
│    ├── archives.html                  # 自定义归档页
│    ├── single.html                    # 自定义文章页
│    └── partials/
│        ├── head/
│        │    ├── custom.html           # CSS 变量注入
│        │    ├── custom-dark-forced.html
│        │     └── custom-backup-light-normal.html
│        ├── article/components/
│        │    ├── details.html          # 文章元数据
│        │    ├── navigation.html       # 上一篇/下一篇
│        │    ├── tags.html             # 标签显示
│        │     └── tip.html             # 赞赏组件
│        ├── article-list/
│         │     └── default.html         # 文章列表
│        ├── sidebar/
│         │     └── left.html            # 左侧边栏
│         └── widget/
│             ├── archives.html          # 归档小部件
│              └── toc.html              # 目录小部件
├── assets/
│     └── scss/
│          └── custom.scss              # 全部自定义样式
└── content-org/                       # Org-mode 源文件
```

---

## 功能模块详细说明

### 1. 深蓝极简浅色模式

#### 配色方案

| 用途 | 颜色 | 说明 |
|------|------|------|
| 主色 | `#0f1b3d` | 深蓝（链接、按钮、标题） |
| 悬停色 | `#1a2b5e` | 稍浅的深蓝 |
| 背景 | `#ffffff` | 纯白 |
| 次背景 | `#f4f7fe` | 极浅蓝 |
| 主文本 | `#0f1b3d` | 深蓝 |
| 次文本 | `#4a5a7a` | 中蓝灰 |

#### 关键配置

`hugo.toml`:
```toml
[params.style.colors]
  primary = "#0f1b3d"
  primaryHover = "#1a2b5e"
  bgPrimary = "#ffffff"
  bgSecondary = "#f4f7fe"
  textPrimary = "#0f1b3d"
  textSecondary = "#4a5a7a"
```

#### 样式实现

`assets/scss/custom.scss`:
- 首页文章标题使用 `var(--primary-hover)` 深蓝色
- 卡片圆角 `var(--radius-lg)` = 12px
- 标签圆角 `20px`
- 按钮渐变效果

---

### 2. 深蓝深色模式

#### 配色方案

| 用途 | 颜色 | 说明 |
|------|------|------|
| 卡片背景 | `#1a2332` | 深蓝黑 |
| 次背景 | `#1e293b` | 稍浅的深蓝黑 |
| 主文本 | `#e2e8f0` | 浅米白 |
| 次文本 | `#cbd5e1` | 提亮至中灰色 |
| 标题颜色 | `#f0f4ff` | 极浅冷白 |

#### 深色模式选择器

**重要**: 使用 `:root[data-scheme="dark"]` 而非 `html[data-scheme="dark"]`。`:root` 比 `html` 有更高的 specificity，能正确覆盖主题默认值。

```scss
:root[data-scheme="dark"] {
  --card-background: #1a2332;
  --card-background-selected: rgba(255, 255, 255, .08);
  --card-text-color-main: #e2e8f0;

  body {
    background-color: var(--dark-bg-primary);
    color: var(--dark-text-primary);
  }
}
```

---

### 3. 文章列表优化

#### 文章摘要显示

**文件**: `layouts/partials/article-list/default.html`

添加三行截断的文章摘要，优先使用 `.Description`，否则截取前 90 个字符。

#### 文章元数据

**文件**: `layouts/partials/article/components/details.html`

显示字数统计和阅读时间。

---

### 4. 分类和标签样式

移除默认的彩色背景，改为简洁边框样式：

```scss
.article-category a,
.category-link {
  background-color: transparent !important;
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  padding: 6px 14px;

  &:hover {
    background-color: var(--accent-color) !important;
    color: white !important;
  }
}
```

---

### 5. 侧边栏 Logo

使用 CSS `::before` 伪元素添加 Logo 图片，隐藏默认 avatar/emoji：

```toml
[params.sidebar]
  emoji = ""
  subtitle = "Old Fashion Man"
  avatar = "/img/fox.png"
```

---

### 6. 归档页面

自定义归档页 `layouts/archives.html`：
- 分类卡片在顶部展示
- 时间线按年份分组
- 移除分类卡片图片

---

### 7. 归档小部件

- 移除年份数量限制
- 添加滚动条
- 移除"更多"链接

---

### 8. 文章导航

移除块状相关文章，改为简洁的上一篇/下一篇导航：

```html
<div class="nav-container">
  <div class="nav-item nav-prev">
    <span class="nav-label">上一篇</span>
    <a href="{{ .RelPermalink }}">{{ .Title }}</a>
  </div>
  <div class="nav-item nav-next">
    <span class="nav-label">下一篇</span>
    <a href="{{ .RelPermalink }}">{{ .Title }}</a>
  </div>
</div>
```

---

### 9. 正文图片自适应

```scss
.article-content img {
  width: 100% !important;
  height: auto !important;
  max-width: 100% !important;
}
```

使正文内图片宽度自动适配容器，不再固定 `400px`。

---

### 10. 赞赏组件

自定义赞赏组件 `layouts/partials/article/components/tip.html`：
- 点击展开/收起微信/支付宝二维码
- 暗色模式适配

---

## 与原主题对比

| 功能 | 原主题 | 自定义 |
|------|--------|--------|
| 样式配置 | 修改 SCSS 文件 | `hugo.toml` 集中配置 |
| 配色 | 默认蓝灰 | 深蓝极简（浅色/深色） |
| 深色模式 CSS | `@media` 查询 | `:root[data-scheme="dark"]` |
| 分类/标签 | 彩色背景块 | 简洁边框样式 |
| 文章摘要 | 无 | 三行截断 |
| 字数统计 | 无 | 显示 |
| 归档页面分类 | 卡片式（带图片） | 链接式（无图片） |
| 归档小部件 | 限制 5-10 年 | 无限制 + 滚动 |
| 文章底部导航 | 相关文章卡片 | 上一篇/下一篇链接 |
| 正文图片 | 固定宽度 | 自适应 `100%` |

---

## 快速配置检查清单

### 颜色主题
- [ ] 主色：`[params.style.colors.primary]`
- [ ] 背景色：`[params.style.colors.bgPrimary]`
- [ ] 暗色模式：`[params.style.colors.darkBgSecondary]`
- [ ] 标题颜色：`:root[data-scheme="dark"] .article-title`

### 字体排版
- [ ] 正文字号：`[params.style.fonts.base]` + `[params.articleBodySize]`
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

## 调试技巧

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

## 移植到新主题

只需复制这 3 个文件/配置：

1. **hugo.toml** — 复制 `[params.style]` 整个配置节
2. **layouts/partials/head/custom.html** — CSS 变量注入
3. **assets/scss/custom.scss** — 样式定义（可根据需要裁剪）

然后在新主题中引用：
```hugo
{{ partial "head/custom.html" . }}
```

---

*本文档由 AI 助手生成，记录博客样式配置的完整实现。*
