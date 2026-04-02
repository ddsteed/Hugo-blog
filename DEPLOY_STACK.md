# Hugo Theme Stack 部署指南

## 状态：✓ 配置完成

---

## 当前配置结构

```
hugo/
├── config/_default/          # Stack 主题配置（新建）
│   ├── hugo.toml            # 基础配置 + 菜单
│   ├── params.toml          # 主题参数
│   ├── languages.toml       # 语言设置
│   ├── markup.toml          # Markdown 渲染
│   └── social.toml          # 社交媒体
├── content/                  # 内容文件
│   ├── _index.md            # 首页（已更新）
│   ├── about/_index.md      # 关于页（已修复）
│   ├── post/                # 文章目录
│   ├── archive/             # 归档页
│   ├── tags/                # 标签页
│   └── categories/          # 分类页
└── layouts.jane-backup/     # 旧主题 layout 备份
```

---

## 启动预览

```bash
hugo server -D
```

访问 http://localhost:1313

---

## 主题预览效果

Stack 主题提供了现代化的卡片式布局：

- **左侧边栏**：显示头像、昵称、社交链接
- **中间区域**：文章卡片列表
- **右侧小部件**：搜索、归档、分类、标签云

---

## 配置调整

### 修改头像

编辑 `config/_default/params.toml`：

```toml
[sidebar]
  avatar = "img/你的头像.png"
  emoji = "🦊"
  subtitle = "你的个人简介"
```

### 修改小部件

编辑 `config/_default/params.toml` 中的 `[widgets]` 部分：

```toml
[widgets]
  homepage = [
    { type = "search" },
    { type = "archives", params = { limit = 10 } },
    { type = "categories", params = { limit = 10 } },
    { type = "tag-cloud", params = { limit = 20 } },
  ]
```

### 添加社交链接

编辑 `config/_default/social.toml`：

```toml
[[social]]
  identifier = "twitter"
  name = "Twitter"
  url = "https://twitter.com/你的用户名"
  [social.params]
    icon = "brand-twitter"
```

---

## 回滚到 PaperMod

如果需要回滚：

```bash
# 恢复配置
cp hugo.toml.papermod hugo.toml
rm -rf config/

# 恢复 layouts
mv layouts.jane-backup/* layouts/
rm -rf layouts.jane-backup

# 恢复首页
cp content/_index.zh-cn.md.bak content/_index.md
```

---

## 构建生产版本

```bash
# 清理旧输出
rm -rf public/

# 构建网站
hugo --minify

# 输出在 public/ 目录
```

---

## 注意事项

1. **搜索功能**：Stack 主题内置搜索，无需额外配置
2. **深色模式**：自动切换，用户可手动控制
3. **代码高亮**：使用 catppuccin-macchiato 风格
4. **响应式**：完美适配移动设备

---

## 资源链接

- [Stack 主题文档](https://stack.jimmycai.com/)
- [GitHub 仓库](https://github.com/CaiJimmy/hugo-theme-stack)
- [配置参考](https://demo.stack.cai.im/)
