# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal blog built with [Hugo](https://gohugo.io/) using the [Stack theme](https://github.com/CaiJimmy/hugo-theme-stack). Content is authored in Emacs Org-mode and exported to Markdown via ox-hugo.

**Working Directory**: `/Users/fengh/Documents/RDS/BLOG/hugo` is a symlink to `hugo.stack/`

**Current Theme**: study (温暖的书房 / Warm Study)

---

## Theme Switching System

This project uses a custom theme switching system that allows quick configuration changes:

```bash
# View available themes
./theme-select

# Switch themes
./theme-select dark-blue    # Full style configuration
./theme-select study     # Warm study (current)
```

**Important**: When making configuration changes, edit `theme-profiles/<theme>/config.toml`, then run `./theme-select <theme>` to apply. Do not edit the root `hugo.toml` directly as it will be overwritten.

See [README-THEME-SWITCH.md](README-THEME-SWITCH.md) for details.

---

## Development Commands

```bash
# Start development server (with drafts)
hugo server -D

# Build for production
hugo --minify

# Output directory: public/
```

---

## Content Workflow (Org-mode → Hugo)

Blog posts are authored in `content-org/` as Org-mode files and exported to `content/post/` via ox-hugo.

### Org-mode Post Structure

```org
#+hugo_base_dir: ../
#+hugo_section: /post/
#+options: author:nil
#+options: ^:nil
#+options: tex:t
#+startup: inlineimages

* ✔ DONE Post Title                                          :tag1:tag2:@category:
CLOSED: [2026-03-21 Sat 19:34]
:PROPERTIES:
:EXPORT_FILE_NAME: 20260321-post-slug
:END:

Content here...
```

### Key Properties

- `EXPORT_FILE_NAME`: Output filename (without extension)
- Tags after title: `:tag1:tag2:` - tags starting with `@` become categories
- `CLOSED`: Date for post metadata

### Export Process

Posts are exported from `content-org/all-posts-*.org` files. Each Org file can contain multiple posts (as headings). The ox-hugo package in Emacs handles the export.

### 公众号文章约定

- 标题以「公众号：」开头（全角冒号）的文章，自动从**首页**（`layouts/home.html`）和**归档页**（`layouts/archives.html`）隐藏，并集中收录在 `/gzh/` 专门页面（`layouts/gzh.html`，按年时间线，菜单 weight 35）。
- 判据只认标题前缀，不依赖 front matter 字段（文章由 ox-hugo 导出，禁止批量改 `content/post/` front matter）。
- 新发文章只要标题带此前缀，即自动进入 `/gzh/`，无需改模板。
- RSS 和分类/标签 term 页有意保留公众号文章，不过滤。
- 误用半角冒号「公众号:」的文章会被漏收（仍出现在首页/归档），发文时注意用全角冒号。
- 相关母本文件：`theme-profiles/study/layouts/{home,archives,gzh}.html`、`theme-profiles/study/config.toml`、`content/gzh/_index.md`。

---

## Configuration Structure

### Theme Profiles

The project uses a theme profile system:

```
theme-profiles/
├── dark-blue/
│   ├── config.toml    # Full configuration with [params.style]
│   └── layouts/       # Custom layouts
└── study/             # Current theme
    ├── config.toml    # Minimal configuration
    └── layouts/       # Custom layouts
```

### Configuration Files

The root `hugo.toml` is auto-generated from the active theme profile. When switching themes:

1. Current config is backed up to `hugo.toml.backup`
2. Theme profile config is copied to `hugo.toml`
3. Theme layouts are copied to `layouts/`
4. `.active-theme` file is updated

### Current Configuration

**Theme**: study
- **Colors**: Default Stack theme
- **Dark mode**: Auto (follows system)
- **Code highlighting**: monokai
- **Pagination**: 10 posts per page

---

## Theme Customization

The Stack theme can be overridden in `layouts/`:

```
layouts/
├── _default/              # Default layout base templates
│      └── rss.xml
├── archives.html           # Custom archive page (shows categories + timeline)
├── baseof.html             # Base layout
├── home.html               # Homepage
├── list.html               # List page
├── partials/               # Partial templates
│      ├─ footer/
│      ├─ head/
│      └─ helper/
└── single.html             # Article layout
```

### Custom Archive Page

`layouts/archives.html` overrides the theme default:
- Shows category tiles at top (with images from `data/categories.yaml`)
- Displays timeline grouped by year below

### Category Images

Category cover images are configured in `data/categories.yaml`:

```yaml
category_name:
  image: "https://example.com/image.jpg"
```

---

## Content Structure

```
content/
├── _index.md            # Homepage
├── _index.zh-cn.md      # Homepage (Chinese)
├── about/
│   └── _index.md        # About page
├── archive/
│   └── _index.md        # Archive page
├── categories/          # Category taxonomy
├── tags/                # Tag taxonomy
└── post/                # Blog posts (exported from org files)
```

---

## Theme Features

- **Three-column layout**: Sidebar (left) + Content (center) + Widgets (right)
- **Widgets**: Search, archives, categories, tag-cloud, TOC (configurable in theme profiles)
- **Dark mode**: Auto-switching based on system preference (study theme)
- **Syntax highlighting**: Configurable per theme
- **Built-in search**: Client-side search via Fuse.js

---

## Static Assets

Place images and static files in:
- `static/img/` - Images (referenced as `/img/filename.png`)
- `static/favicon.ico` - Site favicon

---

## Taxonomies

- **Tags**: `tags` (e.g., `:tech:hugo:`)
- **Categories**: Prefixed with `@` in org files (e.g., `:@教育:`)
- **Main section**: `post`

---

## Build Output

- Production build outputs to `public/`
- Deploy target is typically the root directory of a web server
- No build scripts needed - Hugo handles everything

---

## Making Changes

### When editing configuration:

1. Edit `theme-profiles/<active-theme>/config.toml`
2. Run `./theme-select <active-theme>` to apply
3. Test with `hugo server -D`

### When editing layouts:

1. Edit `theme-profiles/<active-theme>/layouts/<file>`
2. Run `./theme-select <active-theme>` to apply
3. Test with `hugo server -D`

### When adding new content:

1. Create/edit org files in `content-org/`
2. Export via Emacs: `M-x ox-hugo-export-this-to-md`
3. Markdown appears in `content/post/`

---

## Migration Notes

Previously used PaperMod theme. Backup configs exist as:
- `hugo.toml.backup` - Auto-generated backup when switching themes
- Theme profiles preserve both dark-blue and study configurations
