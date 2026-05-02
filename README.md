# 点点马的逍遥港

个人博客，基于 [Hugo](https://gohugo.io/) + [Stack Theme](https://github.com/CaiMoney/hugo-theme-stack) 构建。

## 技术栈

- **静态站点生成器**: Hugo v0.161.1
- **主题**: Stack Theme (v3)
- **内容编辑**: Emacs Org-mode + ox-hugo
- **样式定制**: SCSS 变量系统（深蓝极简风格）
- **部署**: Hugo 静态文件直接部署

## 项目结构

```
hugo.stack/
├── hugo.toml              # 主配置文件（颜色、布局、菜单等）
├── CLAUDE.md              # Claude Code 项目指导文件
├── README.md              # 本文件
├── assets/scss/
│    └── custom.scss       # 自定义样式（深蓝极简主题）
├── layouts/               # 自定义页面模板
├── content/               # 生成的 Markdown 内容
├── content-org/           # Org-mode 源文件
└── config/                # 模块化 Hugo 配置
```

## 主题配置

- **浅色模式**: 深蓝极简风格（`#0f1b3d` 主色，`#f4f7fe` 背景）
- **深色模式**: 深蓝背景（`#1a2332` 卡片背景）
- **自动切换**: 跟随系统深浅模式，支持网站内手动切换
- **字体**: 系统默认字体栈（San Francisco / Segoe UI）

## 本地开发

```bash
# 启动开发服务器（含草稿）
hugo server -D

# 构建生产版本
hugo --minify
```

输出目录: `public/`

## 内容工作流

博客文章在 `content-org/` 中以 Org-mode 格式编写，通过 ox-hugo 导出为 `content/post/` 下的 Markdown 文件。

导出命令（在 Emacs 中执行）:
```
M-x ox-hugo--push-state
```

## License

© 2012-2026 点点马的逍遥港
