# Hugo Stack 主题修改指南

## 问题根源分析

### 搜索功能失效的原因

**原始问题**：Stack 主题的 `layouts/page/search.html` 使用了 `JSXFactory: "createElement"` 来编译 TypeScript/JSX 代码，但 `createElement` 函数在运行时未被定义，导致 JavaScript 错误：

```
ReferenceError: createElement is not defined
    at _Search.render (http://localhost:57538/ts/search.js:205:7)
```

**为什么会发生**：
- 主题的 `assets/ts/search.tsx` 使用 JSX 语法
- Hugo 的 `js.Build` 配置了 `JSXFactory: "createElement"`
- 但原始的 search.html 模板没有提供这个函数的定义

### 其他类似问题

类似的问题也出现在：
1. **首页标题**：硬编码的 "Recent Posts"
2. **归档页面**：硬编码的 "Archive" 和英文日期格式
3. **i18n 配置**：文件名不匹配（`zh.toml` vs `zh-cn.toml`）

## theme-select 脚本的工作机制

### 关键行为（第 165-177 行）

```bash
# 清理并复制 layouts
if [[ -d "${LAYOUTS_DIR}" ]]; then
    rm -rf "${LAYOUTS_DIR}"  # 完全删除 layouts/
    info "已清理旧 layouts"
fi

if [[ -d "${theme_layouts}" ]] && [[ -n "$(ls -A ${theme_layouts} 2>/dev/null)" ]]; then
    cp -r "${theme_layouts}" "${LAYOUTS_DIR}"  # 从 theme-profiles 复制
    info "已应用主题 layouts"
else
    mkdir -p "${LAYOUTS_DIR}"
    warn "主题无自定义 layouts，已创建空目录"
fi
```

### 覆盖规则

| 目录/文件 | 是否被覆盖 | 修改位置 |
|-----------|-----------|---------|
| `layouts/` | ✅ 完全覆盖 | `theme-profiles/<theme>/layouts/` |
| `i18n/` | ❌ 不覆盖 | 项目根目录的 `i18n/` |
| `hugo.toml` | ✅ 覆盖 | `theme-profiles/<theme>/config.toml` |
| `assets/` | ❌ 不覆盖 | 项目根目录的 `assets/` |
| `static/` | ❌ 不覆盖 | 项目根目录的 `static/` |
| `content/` | ❌ 不覆盖 | 项目根目录的 `content/` |

## 修复方案

### 1. 搜索功能修复

**修改文件**：`theme-profiles/study/layouts/page/search.html`

**添加内容**：在 `<script>` 标签中定义 `createElement` 函数

### 2. 中文翻译修复

**i18n 文件**：
- ✅ 正确：`i18n/zh-cn.toml`
- ❌ 错误：`i18n/zh.toml`

**必须匹配**：文件名必须与 `hugo.toml` 中的 `defaultContentLanguage = "zh-cn"` 一致。

### 3. 模板文件使用 i18n

**修改原则**：
- ❌ 错误：`<h1>Archive</h1>`
- ✅ 正确：`<h1>{{ i18n "widget.archives.title" }}</h1>`

## 修改文件的最佳实践

### ✅ 正确做法

```bash
# 1. 修改源头文件
vim theme-profiles/study/layouts/home.html
vim theme-profiles/study/layouts/archives.html
vim theme-profiles/study/layouts/page/search.html

# 2. 修改 i18n 文件（项目级别，不被覆盖）
vim i18n/zh-cn.toml

# 3. 运行 theme-select 应用更改
./theme-select study
```

### ❌ 错误做法

```bash
# 1. 修改 layouts/（会被 theme-select 删除！）
vim layouts/home.html  # ❌ 下次切换主题会丢失

# 2. 忘记同步到 theme-profiles
# 只修改了 layouts/，没有修改 theme-profiles/
```

## 验证修改是否持久化

运行以下命令验证：

```bash
# 1. 切换到其他主题
./theme-select dark-blue

# 2. 切换回 study 主题
./theme-select study

# 3. 验证修改是否保留
grep "createElement" layouts/page/search.html
grep "最近的文章" layouts/home.html
```

## 检查清单

每次修改主题文件后，确认：

- [ ] 修改了 `theme-profiles/<theme>/layouts/` 中的源文件
- [ ] i18n 文件名与 `defaultContentLanguage` 匹配
- [ ] 运行 `./theme-select <theme>` 应用更改
- [ ] 测试功能是否正常
- [ ] 切换主题后再切换回来，验证修改持久化

## 相关文件

```
hugo.stack/
├── theme-select                    # 主题切换脚本
├── theme-profiles/                 # 主题配置源文件（修改这里！）
│   ├── study/
│   │   ├── config.toml
│   │   └── layouts/               # ← 源头文件
│   │       ├── home.html
│   │       ├── archives.html
│   │       └── page/
│   │           └── search.html
│   └── dark-blue/
│       ├── config.toml
│       └── layouts/
├── layouts/                       # 副本（由 theme-select 生成）
├── i18n/                          # 不被覆盖（修改这里）
│   └── zh-cn.toml
└── hugo.toml                      # 被 theme-select 覆盖
```

