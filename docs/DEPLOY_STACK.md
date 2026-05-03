# Hugo Stack 部署指南

## 当前状态

- **主题**: Stack Theme (v3)
- **当前样式**: study (温暖的书房)
- **配置方式**: 单文件 `hugo.toml`（通过主题切换系统管理）
- **颜色模式**: 自动跟随系统（无手动切换按钮）
- **代码高亮**: monokai

---

## 项目结构

```
hugo.stack/
├── theme-select              # 主题切换脚本
├── hugo.toml                 # 主配置文件（自动生成）
├── CLAUDE.md                 # Claude Code 项目指导
├── README.md                 # 项目概述
├── theme-profiles/           # 主题配置目录
│   ├── dark-blue/              # 完整样式配置
│   └── study/               # 当前主题
├── layouts/                  # 自定义页面模板
├── content/                  # Markdown 内容
├── content-org/              # Org-mode 源文件
└── static/                   # 静态资源
```

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

## 主题配置

### 当前主题 (study)

- **深色模式**: 仅自动跟随系统
- **代码高亮**: monokai
- **分页**: 每页 10 篇文章
- **主题切换**: `./theme-select study`

### 备用主题 (dark-blue)

- **深色模式**: 自动 + 手动切换按钮
- **代码高亮**: catppuccin-macchiato
- **分页**: 每页 6 篇文章
- **主题切换**: `./theme-select dark-blue`

---

## 部署步骤

```bash
# 清理旧输出
rm -rf public/

# 构建生产版本
hugo --minify

# 部署 public/ 目录到服务器
```

---

## 配置修改流程

1. 编辑主题配置文件：
   ```bash
   vim theme-profiles/study/config.toml
   ```

2. 应用配置：
   ```bash
   ./theme-select study
   ```

3. 测试：
   ```bash
   hugo server -D
   ```

4. 构建并部署：
   ```bash
   hugo --minify
   ```

---

## 主题切换

如需切换主题样式：

```bash
# 查看可用主题
./theme-select

# 切换主题
./theme-select dark-blue    # 完整样式
./theme-select study     # 当前主题
```

详见 [README-THEME-SWITCH.md](README-THEME-SWITCH.md)

---

## 注意事项

1. **配置管理**: 不要直接编辑根目录 `hugo.toml`，切换主题时会被覆盖
2. **主题配置**: 编辑 `theme-profiles/<theme>/config.toml`
3. **自动备份**: 每次切换主题会自动备份到 `hugo.toml.backup`
4. **深色模式**: study 主题仅支持自动切换，dark-blue 支持手动切换

---

## 功能特性

- **搜索**: 内置 Fuse.js 搜索
- **响应式**: 自动适配移动端
- **RSS**: 已启用 `rssFullContent`
- **数学公式**: 支持 LaTeX（通过 goldmark passthrough）
- **Org 编辑**: 通过 ox-hugo 从 Org-mode 导出

---

## 资源链接

- [Stack 主题文档](https://stack.jimmycai.com/)
- [GitHub 仓库](https://github.com/CaiJimmy/hugo-theme-stack)
- [主题切换指南](README-THEME-SWITCH.md)
- [样式指南](STYLE_GUIDE.md)
