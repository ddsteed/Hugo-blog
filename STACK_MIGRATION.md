# Hugo Theme Stack 迁移指南

## 配置完成 ✓

Stack 主题配置已创建完成，使用模块化配置目录结构（`config/_default/`）。

---

## 快速开始

### 方式一：直接替换配置目录（推荐）

```bash
# 备份原配置
cp -r config config.backup.$(date +%Y%m%d)

# 配置已就绪，直接预览
hugo server -D
```

访问 http://localhost:1313 查看效果

### 方式二：使用单一配置文件

如果更喜欢使用单一的 `hugo.toml` 文件：

```bash
# 删除 config 目录
rm -rf config/

# 使用预配置的单文件
cp hugo.toml.stack hugo.toml
```

---

## 配置文件结构

```
config/_default/
├── hugo.toml      # 基础配置 + 菜单
├── params.toml    # 主题参数
├── languages.toml # 语言设置
├── markup.toml    # Markdown 渲染
└── social.toml    # 社交媒体
```

---

## 主要配置说明

### 主题特点

- **三列布局**：左侧个人信息 + 中间文章 + 右侧小部件
- **深色模式**：自动切换
- **内置搜索**：无需额外配置
- **响应式**：适配桌面/平板/移动端

### 侧边栏配置

```toml
# config/_default/params.toml
[sidebar]
  emoji = "🦊"
  subtitle = "无所事事的创业者 | 技术生活的观察者"
  avatar = "img/fox.png"
  compact = false
```

### 小部件配置

```toml
[widgets]
  homepage = [
    { type = "search" },
    { type = "archives", params = { limit = 10 } },
    { type = "categories", params = { limit = 10 } },
    { type = "tag-cloud", params = { limit = 20 } },
  ]
  page = [
    { type = "toc" }
  ]
```

### 可用小部件类型

| 类型 | 说明 | 参数 |
|------|------|------|
| `search` | 搜索框 | - |
| `archives` | 文章归档 | `limit` |
| `categories` | 分类列表 | `limit` |
| `tag-cloud` | 标签云 | `limit` |
| `toc` | 文章目录 | - |

---

## 内容文件适配

### 首页

Stack 主题会自动展示文章列表，`content/_index.md` 已更新。

### 搜索页面

Stack 主题内置搜索，`content/search/_index.md` 已保留用于搜索结果页面。

### 关于页面

`content/about/_index.md` 已更新，移除了自定义 layout。

---

## 自定义样式

### 修改代码高亮风格

编辑 `config/_default/markup.toml`：

```toml
[highlight]
  style = "monokai"  # 可选: catppuccin-macchiato, dracula, nord 等
```

### 添加自定义 CSS

创建 `layouts/partials/head/custom.html`：

```html
<style>
:root {
    --article-font-family: "字体名称", var(--base-font-family);
}
</style>
```

### 修改主题颜色

编辑 `assets/scss/custom.scss`（需创建）：

```scss
:root {
    --primary-color: #你的颜色;
    --secondary-color: #你的颜色;
}
```

---

## 资源链接

- [Stack 主题文档](https://stack.jimmycai.com/)
- [GitHub 仓库](https://github.com/CaiJimmy/hugo-theme-stack)
- [在线演示](https://demo.stack.cai.im/)

---

## 与 PaperMod 的主要区别

| 特性 | PaperMod | Stack |
|------|----------|-------|
| 布局 | 单列 | 三列 |
| 首页 | 自定义 info | 文章卡片列表 |
| 侧边栏 | 无 | 左侧个人信息 |
| 小部件 | 无 | 右侧可配置 |
| 搜索 | 需配置 | 内置 |
| 配置方式 | 单文件 | 模块化目录 |

---

## 常见问题

### Q: 头像不显示？

A: 确保图片文件在 `static/img/` 目录下，检查 `config/_default/params.toml` 中的 `avatar` 路径。

### Q: 如何隐藏某个小部件？

A: 从 `widgets.homepage` 或 `widgets.page` 数组中删除对应条目。

### Q: 如何添加评论系统？

A: 编辑 `config/_default/params.toml` 中的 `[comments]` 配置，Stack 支持 giscus、disqus 等。

### Q: 菜单图标不显示？

A: Stack 主题菜单默认不显示图标，如需图标可修改主题模板或使用 `pre` 参数。

---

## 构建部署

```bash
# 本地预览
hugo server -D

# 构建生产版本
hugo --minify

# 输出在 public/ 目录
```

---

*配置生成时间：2026-03-24*
