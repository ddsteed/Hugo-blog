# 点点马的逍遥港

个人博客，基于 [Hugo](https://gohugo.io/) + [Stack Theme](https://github.com/CaiMoney/hugo-theme-stack) 构建。

---

## 技术栈

- **静态站点生成器**: Hugo
- **主题**: Stack Theme (v3)
- **内容编辑**: Emacs Org-mode + ox-hugo
- **主题切换**: 自定义主题切换系统
- **当前样式**: study (温暖的书房)

---

## 项目结构

```
hugo.stack/
├── theme-select              # 主题切换脚本
├── hugo.toml                 # 主配置文件
├── CLAUDE.md                 # Claude Code 项目指导
├── README.md                 # 本文件
├── theme-profiles/           # 主题配置目录
│   ├── normal/              # 完整样式配置
│   └── study/               # 温暖的书房（当前）
├── layouts/                  # 自定义页面模板
├── content/                  # 生成的 Markdown 内容
├── content-org/              # Org-mode 源文件
└── static/                   # 静态资源
```

---

## 主题切换

博客支持两种样式配置，可通过 `theme-select` 脚本快速切换：

```bash
# 查看可用主题
./theme-select

# 切换到 normal（完整样式配置）
./theme-select normal

# 切换到 study（温暖的书房）
./theme-select study
```

**normal**: 完整样式系统，深蓝极简配色，手动深色模式切换
**study**: 简洁配置，专注阅读体验，自动深色模式

详见 [README-THEME-SWITCH.md](README-THEME-SWITCH.md)

---

## 本地开发

```bash
# 启动开发服务器（含草稿）
hugo server -D

# 构建生产版本
hugo --minify
```

输出目录: `public/`

---

## 内容工作流

博客文章在 `content-org/` 中以 Org-mode 格式编写，通过 ox-hugo 导出。

### Org-mode 文章结构

```org
#+hugo_base_dir: ../
#+hugo_section: /post/

* ✔ DONE 文章标题                                          :标签:@分类:
CLOSED: [2026-03-21 Sat 19:34]
:PROPERTIES:
:EXPORT_FILE_NAME: post-slug
:END:

内容...
```

### 导出命令（Emacs）

```
M-x ox-hugo-export-this-to-md
```

---

## 配置说明

- **当前主题**: study（温暖的书房）
- **深色模式**: 自动跟随系统
- **代码高亮**: monokai
- **分页**: 每页 10 篇文章

主题配置位于 `theme-profiles/study/config.toml`。

---

## 相关文档

- [README-THEME-SWITCH.md](README-THEME-SWITCH.md) - 主题切换系统
- [STACK_MIGRATION.md](STACK_MIGRATION.md) - 迁移指南
- [STYLE_GUIDE.md](STYLE_GUIDE.md) - 样式配置指南
- [DEPLOY_STACK.md](DEPLOY_STACK.md) - 部署指南
- [CLAUDE.md](CLAUDE.md) - Claude Code 项目指导

---

## License

© 2012-2026 点点马的逍遥港
