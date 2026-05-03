# 主题切换系统

## 目录结构

```
hugo.stack/
├── hugo.toml                 # 主配置（核心配置，自动生成）
├── theme-select              # 切换脚本
├── .active-theme             # 当前主题标识
├── content/                  # 共享：文章
├── static/                   # 共享：静态资源
├── theme-profiles/           # 主题配置
│   ├── normal/               # normal 样式
│   │   ├── config.toml       # 完整配置
│   │   └── layouts/          # 自定义布局
│   └── new/                  # new 样式
│       ├── config.toml       # 完整配置
│       └── layouts/          # 自定义布局
└── themes/                   # Hugo 主题目录
    ├── stack/
    └── new/                  # 新主题（将来添加）
```

## 使用方法

### 切换主题

```bash
./theme-select normal    # 切换到 normal 样式
./theme-select new       # 切换到 new 样式
```

### 查看可用主题

```bash
./theme-select           # 显示当前主题和可用主题列表
./theme-select --help    # 显示帮助
```

## 添加新主题

1. 创建新主题目录：
   ```bash
   mkdir -p theme-profiles/mytheme/layouts
   ```

2. 复制并修改配置：
   ```bash
   cp theme-profiles/normal/config.toml theme-profiles/mytheme/config.toml
   ```

3. 切换到新主题：
   ```bash
   ./theme-select mytheme
   ```

## 工作原理

1. `theme-select` 脚本读取 `theme-profiles/<theme>/config.toml`
2. 复制配置到项目根目录的 `hugo.toml`
3. 复制 `layouts/` 到项目根目录
4. 更新 `.active-theme` 文件

## 共享内容

以下目录在所有主题间共享：
- `content/` - 文章内容
- `static/` - 静态资源（图片、logo等）
- `content-org/` - Org源文件
- `i18n/` - 国际化文件
- `resources/` - Hugo 资源

## 注意事项

- 修改主题配置请编辑 `theme-profiles/<theme>/config.toml`
- 修改主题布局请编辑 `theme-profiles/<theme>/layouts/`
- 不要直接修改根目录的 `hugo.toml` 和 `layouts/`（切换主题时会被覆盖）
