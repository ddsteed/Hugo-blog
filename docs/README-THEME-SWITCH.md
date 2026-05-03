# 主题切换系统

本博客使用自定义主题切换系统，可在不同样式配置间快速切换。

---

## 目录结构

```
hugo.stack/
├── theme-select              # 切换脚本
├── .active-theme             # 当前主题标识 (study)
├── hugo.toml                 # 主配置（从主题配置复制）
├── layouts/                  # 自定义布局（从主题配置复制）
├── content/                  # 共享：文章
├── static/                   # 共享：静态资源
├── theme-profiles/           # 主题配置
│   ├── dark-blue/               # dark-blue 样式（完整配置）
│   │   ├── config.toml       # 完整配置（含 [params.style]）
│   │   └── layouts/          # 自定义布局
│   └── study/                # study 样式（温暖的书房）
│       ├── config.toml       # 简洁配置
│       └── layouts/          # 自定义布局
└── themes/                   # Hugo 主题目录
    └── stack/                # Stack 主题
```

---

## 使用方法

### 切换主题

```bash
./theme-select dark-blue    # 切换到 dark-blue 样式
./theme-select study     # 切换到 study 样式（温暖的书房）
```

### 查看可用主题

```bash
./theme-select           # 显示当前主题和可用主题列表
./theme-select --help    # 显示帮助
```

---

## 可用主题

### dark-blue - 原始样式

完整的样式配置系统，包含：

- **[params.style]** 配置节：颜色、字体、间距、圆角、阴影、过渡
- **深蓝极简配色**：`#0f1b3d` 主色，`#f4f7fe` 浅蓝背景
- **自动深色模式**：跟随系统，提供手动切换按钮
- **代码高亮**：catppuccin-macchiato 风格
- **分页**：每页 6 篇文章

### study - 温暖的书房

简洁配置，专注于阅读体验：

- **简洁配置**：移除 [params.style]，使用主题默认样式
- **深色模式**：仅自动跟随系统，无手动切换按钮
- **代码高亮**：monokai 风格
- **分页**：每页 10 篇文章

---

## 添加新主题

1. 创建新主题目录：
   ```bash
   mkdir -p theme-profiles/mytheme/layouts
   ```

2. 复制并修改配置：
   ```bash
   cp theme-profiles/study/config.toml theme-profiles/mytheme/config.toml
   # 或复制 dark-blue 的完整配置
   cp theme-profiles/dark-blue/config.toml theme-profiles/mytheme/config.toml
   ```

3. 编辑配置文件：
   ```toml
   # 修改标题、描述等个性化配置
   ```

4. 切换到新主题：
   ```bash
   ./theme-select mytheme
   ```

---

## 工作原理

1. `theme-select` 脚本读取 `theme-profiles/<theme>/config.toml`
2. 备份当前配置到 `hugo.toml.backup`
3. 复制配置到项目根目录的 `hugo.toml`
4. 清理并复制 `layouts/` 到项目根目录
5. 更新 `.active-theme` 文件

---

## 共享内容

以下目录在所有主题间共享，切换主题时不会被影响：

- `content/` - 文章内容
- `static/` - 静态资源（图片、logo等）
- `content-org/` - Org源文件
- `i18n/` - 国际化文件
- `resources/` - Hugo 资源
- `themes/` - Hugo 主题目录

---

## 注意事项

1. **修改主题配置**：请编辑 `theme-profiles/<theme>/config.toml`，不要直接修改根目录的 `hugo.toml`
2. **修改主题布局**：请编辑 `theme-profiles/<theme>/layouts/`，不要直接修改根目录的 `layouts/`
3. **配置会被覆盖**：切换主题时，根目录的 `hugo.toml` 和 `layouts/` 会被完全替换
4. **备份**：每次切换会自动备份到 `hugo.toml.backup`

---

## 当前状态

```
当前主题: study (温暖的书房)
配置文件: theme-profiles/study/config.toml
```
