import os

# 配置目标目录
THEME_DIR = "themes/jane"
# 扩展名范围：增加 .xml 以修复 rss.xml 等文件
EXTENSIONS = (".html", ".xml")

def fix_hugo_v2():
    if not os.path.exists(THEME_DIR):
        print(f"❌ 错误：找不到目录 {THEME_DIR}")
        return

    count = 0
    print(f"🛠️ 正在深度扫描 {THEME_DIR} 中的 HTML 和 XML 文件...")

    for root, dirs, files in os.walk(THEME_DIR):
        for file in files:
            if file.endswith(EXTENSIONS):
                file_path = os.path.join(root, file)
                
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()

                # 核心替换逻辑：直接将 .Site.Author 替换为 .Site.Params.author
                # 这样不论后面接的是 .name 还是 .email 都能一网打尽
                if ".Site.Author" in content:
                    new_content = content.replace(".Site.Author", ".Site.Params.author")
                    
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    
                    print(f"✅ 已修复: {file_path}")
                    count += 1

    print(f"\n✨ 修复完成！共清理了 {count} 个模板文件中的旧语法。")

if __name__ == "__main__":
    fix_hugo_v2()

