#!/bin/bash
# ==============================================================================
# 博客样式配置辅助脚本
# 用法: ./bin/style.sh <command> [args]
# ==============================================================================

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目路径
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$PROJECT_DIR/hugo.toml"

# 帮助信息
show_help() {
    cat << EOF
${BLUE}Hugo 博客样式配置工具${NC}

用法: ./bin/style.sh <command> [args]

命令:
  ${GREEN}color${NC} <name> <hex>        设置颜色 (primary/accent/success等)
  ${GREEN}font-size${NC} <name> <value>  设置字体大小 (xs/sm/lg/xl/2xl/3xl/4xl)
  ${GREEN}spacing${NC} <name> <value>    设置间距 (xs/sm/md/lg/xl/2xl/3xl)
  ${GREEN}radius${NC} <name> <value>     设置圆角 (sm/md/lg/xl/full)
  ${GREEN}shadow${NC} <name> <value>     设置阴影 (sm/md/lg/xl)
  ${GREEN}preset${NC} <theme>            应用预设主题 (ocean/forest/sunset/monochrome)
  ${GREEN}preview${NC}                   预览当前配置
  ${GREEN}list${NC}                      列出所有可配置项

示例:
  ./bin/style.sh color primary "#ff6b6b"
  ./bin/style.sh font-size xl "1.3rem"
  ./bin/style.sh preset ocean
  ./bin/style.sh preview

EOF
}

# 检查配置文件
check_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo -e "${RED}错误: 找不到配置文件 $CONFIG_FILE${NC}"
        exit 1
    fi
}

# 更新配置值
update_config() {
    local key="$1"
    local value="$2"

    # 使用 sed 更新配置
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s|$key = .*|$key = \"$value\"|" "$CONFIG_FILE"
    else
        # Linux
        sed -i "s|$key = .*|$key = \"$value\"|" "$CONFIG_FILE"
    fi

    echo -e "${GREEN}✓ 已更新: $key = $value${NC}"
}

# 设置颜色
set_color() {
    local name="$1"
    local value="$2"

    # 验证颜色格式
    if [[ ! "$value" =~ ^#[0-9a-fA-F]{6}$ ]]; then
        echo -e "${RED}错误: 颜色格式应为 #hex 格式，例如 #3b82f6${NC}"
        exit 1
    fi

    local key="params.style.colors.$name"
    update_config "$key" "$value"
}

# 设置字体大小
set_font_size() {
    local name="$1"
    local value="$2"
    local key="params.style.fonts.$name"
    update_config "$key" "$value"
}

# 设置间距
set_spacing() {
    local name="$1"
    local value="$2"
    local key="params.style.spacing.$name"
    update_config "$key" "$value"
}

# 设置圆角
set_radius() {
    local name="$1"
    local value="$2"
    local key="params.style.effects.radius$name"
    update_config "$key" "$value"
}

# 设置阴影
set_shadow() {
    local name="$1"
    local value="$2"
    local key="params.style.effects.shadow$name"
    update_config "$key" "$value"
}

# 应用预设主题
apply_preset() {
    local theme="$1"

    case "$theme" in
        ocean)
            echo -e "${BLUE}应用海洋主题...${NC}"
            update_config "params.style.colors.primary" "#0ea5e9"
            update_config "params.style.colors.primaryHover" "#0284c7"
            update_config "params.style.colors.accent" "#06b6d4"
            ;;
        forest)
            echo -e "${BLUE}应用森林主题...${NC}"
            update_config "params.style.colors.primary" "#22c55e"
            update_config "params.style.colors.primaryHover" "#16a34a"
            update_config "params.style.colors.accent" "#84cc16"
            ;;
        sunset)
            echo -e "${BLUE}应用日落主题...${NC}"
            update_config "params.style.colors.primary" "#f97316"
            update_config "params.style.colors.primaryHover" "#ea580c"
            update_config "params.style.colors.accent" "#ec4899"
            ;;
        monochrome)
            echo -e "${BLUE}应用单色主题...${NC}"
            update_config "params.style.colors.primary" "#64748b"
            update_config "params.style.colors.primaryHover" "#475569"
            update_config "params.style.colors.accent" "#334155"
            ;;
        *)
            echo -e "${RED}错误: 未知预设主题 '$theme'${NC}"
            echo "可用预设: ocean, forest, sunset, monochrome"
            exit 1
            ;;
    esac

    echo -e "${GREEN}✓ 预设主题已应用${NC}"
}

# 预览当前配置
preview_config() {
    echo -e "${BLUE}当前样式配置:${NC}"
    echo ""

    # 提取颜色配置
    echo -e "${YELLOW}颜色:${NC}"
    grep -A 20 "\[params.style.colors\]" "$CONFIG_FILE" | grep "=" | grep -v "^#" | sed 's/^[[:space:]]*/  /'

    echo ""
    echo -e "${YELLOW}字体大小:${NC}"
    grep -A 10 "\[params.style.fonts\]" "$CONFIG_FILE" | grep -E "(xs|sm|lg|xl|2xl|3xl|4xl) =" | grep -v "^#" | sed 's/^[[:space:]]*/  /'
}

# 列出所有可配置项
list_config() {
    cat << EOF
${BLUE}可配置项列表:${NC}

${YELLOW}颜色 (color):${NC}
  primary, primaryHover, primaryLight
  accent, accentHover
  success, warning, error, info
  bgPrimary, bgSecondary, bgTertiary
  textPrimary, textSecondary, textMuted
  border, divider
  darkBgPrimary, darkBgSecondary, darkTextPrimary, darkTextSecondary, darkBorder

${YELLOW}字体大小 (font-size):${NC}
  xs, sm, lg, xl, 2xl, 3xl, 4xl

${YELLOW}间距 (spacing):${NC}
  xs, sm, md, lg, xl, 2xl, 3xl

${YELLOW}圆角 (radius):${NC}
  sm, md, lg, xl, full

${YELLOW}阴影 (shadow):${NC}
  sm, md, lg, xl

${YELLOW}预设主题 (preset):${NC}
  ocean, forest, sunset, monochrome

EOF
}

# 主函数
main() {
    check_config

    if [[ $# -eq 0 ]]; then
        show_help
        exit 0
    fi

    local command="$1"
    shift

    case "$command" in
        help|--help|-h)
            show_help
            ;;
        color)
            set_color "$@"
            ;;
        font-size)
            set_font_size "$@"
            ;;
        spacing)
            set_spacing "$@"
            ;;
        radius)
            set_radius "$@"
            ;;
        shadow)
            set_shadow "$@"
            ;;
        preset)
            apply_preset "$@"
            ;;
        preview)
            preview_config
            ;;
        list)
            list_config
            ;;
        *)
            echo -e "${RED}错误: 未知命令 '$command'${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"
