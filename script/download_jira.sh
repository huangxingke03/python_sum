#!/bin/bash

if [ -z "${BASH_VERSION:-}" ]; then
    exec bash "$0" "$@"
fi

# =============================================
# JIRA 一键下载工具（全局版）
# 用法: download_jira <JIRA单号>
# 示例: download_jira CHYKP31-1028
#       download_jira DP-5927
# =============================================

if [ -z "$1" ]; then
    echo "用法: download_jira <JIRA单号>"
    echo "示例: download_jira CHYKP31-1028"
    exit 1
fi

TICKET=$1
SAVE_DIR="/home/huangxingke/下载/${TICKET}"

# ==================== 每次下载前清空旧文件 ====================
echo "🧹 正在清理旧文件..."
rm -rf "$SAVE_DIR"          # 删除旧文件夹及所有内容
mkdir -p "$SAVE_DIR"

# ==================== Cookie 配置（请保持最新） ====================
COOKIE="JSESSIONID=A7D88DC8C98F868132E9BF910603286B; atlassian.xsrf.token=BWB8-5DWA-IKRE-Q10M_c509c72f5e531dd5e7f86c25c3d5afb4d1f6c822_lin; seraph.rememberme.cookie=100954%3Aa5f6cd271708db6061fc8c4b615e02c6f794f0a5"

echo "══════════════════════════════════════"
echo "🚀 开始下载 JIRA: $TICKET"
echo "保存目录: $SAVE_DIR （旧文件已清理）"
echo "══════════════════════════════════════"

# 判断附件是否需要显示下载进度条
should_show_progress() {
    local lower_name="${1,,}"
    case "$lower_name" in
        *.zip|*.z[0-9][0-9]|*.tar.gz|*.tgz|*.7z|*.[0-9][0-9][0-9]|*.rar|*.r[0-9][0-9]|*.part[0-9]*.rar|*.log|*.mp4|*.mov|*.mkv|*.txt)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# 下载附件；压缩包、日志、视频显示 0-100 的进度条，其它文件静默下载
download_attachment() {
    local url="$1"
    local filepath="$2"
    local filename="$3"

    if should_show_progress "$filename"; then
        curl -f -b "$COOKIE" -L --progress-bar -o "$filepath" "$url"
    else
        curl -f -s -b "$COOKIE" -L -o "$filepath" "$url"
    fi
}

# 获取附件列表
JSON=$(curl -s -b "$COOKIE" \
  -H "Content-Type: application/json" \
  -H "X-Atlassian-Token: no-check" \
  "https://jira-shzj.auto-link.com.cn/rest/api/2/issue/${TICKET}?fields=attachment")

# 权限检查
if echo "$JSON" | grep -q "您没有查看特定问题的权限\|必须登录"; then
    echo "❌ Cookie 失效或无权限，请更新 Cookie 后重试"
    exit 1
fi

COUNT=$(echo "$JSON" | jq '.fields.attachment | length' 2>/dev/null || echo 0)
echo "✅ 找到 $COUNT 个附件，开始下载..."

# 下载循环
echo "$JSON" | jq -r '.fields.attachment[]? | "\(.content)|\(.filename)"' 2>/dev/null | \
while IFS='|' read -r url filename; do
    if [ -n "$url" ] && [ -n "$filename" ]; then
        filepath="${SAVE_DIR}/${filename}"
        echo "⬇️ 下载: $filename"

        if download_attachment "$url" "$filepath" "$filename" && [ -s "$filepath" ]; then
            size=$(du -h "$filepath" | cut -f1)
            echo "✅ 下载完成: $filename ($size)"
            case "$filename" in
                *.zip|*.z[0-9][0-9])
                    echo "   📦 检测到 ZIP 文件: $filename，等待全部文件下载完毕后统一解压"
                    ;;
                *.tar.gz|*.tgz)
                    echo "   📦 检测到 TAR.GZ 文件: $filename，等待全部文件下载完毕后统一解压"
                    ;;
                *.7z|*.[0-9][0-9][0-9])
                    echo "   📦 检测到 7z 文件: $filename，等待全部文件下载完毕后统一解压"
                    ;;
                *.rar|*.r[0-9][0-9])
                    echo "   📦 检测到 RAR 文件: $filename，等待全部文件下载完毕后统一解压"
                    ;;
                *.log|*.mp4|*.mov|*.mkv|*.txt)
                    echo "   📄 日志/视频文件，无需解压"
                    ;;
                *)
                    echo "   📎 其他格式，跳过解压"
                    ;;
            esac
        else
            echo "❌ 下载失败: $filename"
        fi
    fi
done

# ==================== 统一解压（全部文件下载完毕后执行）====================
cd "$SAVE_DIR" || exit 1
shopt -s nullglob

# --- ZIP: 单文件(.zip) + 分卷(.zip + .z01/.z02/...) ---
for f in *.zip; do
    [ -f "$f" ] || continue
    base="${f%.zip}"
    companions=( "${base}".z[0-9][0-9] "${base}".Z[0-9][0-9] )
    has_companion=false
    for c in "${companions[@]}"; do [ -f "$c" ] && has_companion=true && break; done
    if $has_companion; then
        vol_count=$(ls "${base}".z[0-9][0-9] "${base}".Z[0-9][0-9] 2>/dev/null | wc -l)
        echo "📦 解压 ZIP 分卷: $f（共 $((vol_count + 1)) 个分卷）"
        7z x -y -aoa "$f" >/dev/null 2>&1 \
            && echo "   ✅ ZIP 分卷解压完成" \
            || { echo "   ❌ ZIP 分卷解压失败："; 7z x -y -aoa "$f" 2>&1 | tail -n 20; echo "   💡 手动：cd \"$SAVE_DIR\" && 7z x \"$f\""; }
    else
        echo "📦 解压 ZIP: $f"
        unzip -o "$f" -d . >/dev/null 2>&1 \
            && echo "   ✅ ZIP 解压完成" \
            || { echo "   ❌ ZIP 解压失败"; echo "   💡 手动：cd \"$SAVE_DIR\" && unzip \"$f\""; }
    fi
done

# --- TAR.GZ: 单文件 ---
for f in *.tar.gz *.tgz; do
    [ -f "$f" ] || continue
    echo "📦 解压 TAR.GZ: $f"
    tar -xzf "$f" -C . \
        && echo "   ✅ TAR.GZ 解压完成" \
        || { echo "   ❌ TAR.GZ 解压失败"; echo "   💡 手动：cd \"$SAVE_DIR\" && tar -xzf \"$f\""; }
done

# --- 7z: 单文件(.7z) + 分卷(*.001/*.002/...) ---
declare -A _7z_base_done
for first_vol in *.001; do
    [ -f "$first_vol" ] || continue
    base="${first_vol%.001}"
    vol_count=$(ls "${base}".[0-9][0-9][0-9] 2>/dev/null | wc -l)
    echo "📦 解压 7z 分卷: $first_vol（共 $vol_count 个分卷）"
    if 7z x -y -aoa "$first_vol" >/dev/null 2>&1; then
        echo "   ✅ 7z 分卷解压完成"
    elif command -v unar >/dev/null 2>&1 && unar -force-overwrite "$first_vol" >/dev/null 2>&1; then
        echo "   ✅ unar 解压完成"
    else
        echo "   ❌ 7z 分卷解压失败："; 7z x -y -aoa "$first_vol" 2>&1 | tail -n 20
        echo "   💡 手动：cd \"$SAVE_DIR\" && 7z x \"$first_vol\""
    fi
    _7z_base_done["$base"]=1
done
for f in *.7z; do
    [ -f "$f" ] || continue
    [[ -n "${_7z_base_done[$f]}" ]] && continue
    echo "📦 解压 7z: $f"
    if 7z x -y -aoa "$f" >/dev/null 2>&1; then
        echo "   ✅ 7z 解压完成"
    elif command -v unar >/dev/null 2>&1 && unar -force-overwrite "$f" >/dev/null 2>&1; then
        echo "   ✅ unar 解压完成"
    else
        echo "   ❌ 7z 解压失败："; 7z x -y -aoa "$f" 2>&1 | tail -n 20
        echo "   💡 手动：cd \"$SAVE_DIR\" && 7z x \"$f\""
    fi
done

# --- RAR: 单文件 + 新格式分卷(.part1.rar/.part2.rar/...) + 旧格式分卷(.rar/.r00/.r01/...) ---
if command -v unrar >/dev/null 2>&1; then
    # 新格式分卷首卷
    for f in *.part1.rar; do
        [ -f "$f" ] || continue
        base="${f%.part1.rar}"
        vol_count=$(ls "${base}".part[0-9]*.rar 2>/dev/null | wc -l)
        echo "📦 解压 RAR 分卷(新格式): $f（共 $vol_count 个分卷）"
        unrar x -o+ "$f" . >/dev/null 2>&1 \
            && echo "   ✅ RAR 分卷解压完成" \
            || { echo "   ❌ RAR 分卷解压失败"; echo "   💡 手动：cd \"$SAVE_DIR\" && unrar x \"$f\""; }
    done
    # 旧格式分卷 + 单文件（排除新格式非首卷）
    for f in *.rar; do
        [ -f "$f" ] || continue
        [[ "$f" == *.part1.rar ]] && continue
        [[ "$f" =~ \.part[0-9]+\.rar$ ]] && continue
        base="${f%.rar}"
        if ls "${base}".r[0-9][0-9] &>/dev/null; then
            vol_count=$(( $(ls "${base}".r[0-9][0-9] 2>/dev/null | wc -l) + 1 ))
            echo "📦 解压 RAR 分卷(旧格式): $f（共 $vol_count 个分卷）"
        else
            echo "📦 解压 RAR: $f"
        fi
        unrar x -o+ "$f" . >/dev/null 2>&1 \
            && echo "   ✅ RAR 解压完成" \
            || { echo "   ❌ RAR 解压失败"; echo "   💡 手动：cd \"$SAVE_DIR\" && unrar x \"$f\""; }
    done
else
    echo "⚠️ 未安装 unrar，RAR 文件跳过（安装：sudo apt install unrar）"
fi

shopt -u nullglob
cd - > /dev/null

echo ""
echo "🎉 下载完成！"
echo "📁 当前目录内容："
ls -lh "$SAVE_DIR" 2>/dev/null || echo "目录为空"
