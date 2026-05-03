# 主题切换说明

## 文件说明

| 文件 | 说明 |
|------|------|
| `custom.html` | 当前使用的样式文件（按系统主题自动切换） |
| `custom-dark-forced.html` | **强制深色模式**备份（始终深色，不管系统主题） |
| `custom-backup-light-normal.html` | **正常模式**备份（浅色时浅色，深色时深色） |

## 切换方法

### 切换到正常模式（按系统主题自动切换）
```bash
cd /Users/fengh/Documents/RDS/BLOG/hugo.stack/layouts/partials/head/
cp custom-backup-light-normal.html custom.html
```

### 切换到强制深色模式（始终深色）
```bash
cd /Users/fengh/Documents/RDS/BLOG/hugo.stack/layouts/partials/head/
cp custom-dark-forced.html custom.html
```

## 当前状态
**按系统主题自动切换** - 网站跟随系统深浅模式，支持手动切换
