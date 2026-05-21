#!/bin/bash
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
        
        curl -s -b "$COOKIE" -L -o "$filepath" "$url"
        
        if [ -s "$filepath" ]; then
            size=$(du -h "$filepath" | cut -f1)
            echo "✅ 下载完成: $filename ($size)"
            
            # 自动解压
                        # ==================== 自动解压 ====================
            case "$filename" in
                *.zip)
                    echo "   📦 解压 ZIP..."
                    unzip -o "$filepath" -d "$SAVE_DIR/" >/dev/null 2>&1 && echo "   ✅ ZIP 已解压"
                    ;;
                *.tar.gz|*.tgz)
                    echo "   📦 解压 TAR.GZ..."
                    tar -xzf "$filepath" -C "$SAVE_DIR/" && echo "   ✅ TAR.GZ 已解压"
                    ;;
                *.7z)
                    echo "   📦 解压 7z..."
                    7z x "$filepath" -o"$SAVE_DIR/" >/dev/null 2>&1 && echo "   ✅ 7z 已解压"
                    ;;
                *.rar)
                    echo "   📦 解压 RAR..."
                    if command -v unrar >/dev/null 2>&1; then
                        unrar x -o+ "$filepath" "$SAVE_DIR/" >/dev/null 2>&1 && echo "   ✅ RAR 已解压"
                    elif command -v unar >/dev/null 2>&1; then
                        unar -force-overwrite -output-directory "$SAVE_DIR/" "$filepath" >/dev/null 2>&1 && echo "   ✅ RAR 已解压 (unar)"
                    else
                        echo "   ⚠️  未安装 RAR 解压工具，跳过解压"
                        echo "   💡 建议安装: sudo apt install unrar"
                    fi
                    ;;
                *.log|*.mp4|*.mov|*.mkv|*.txt)
                    echo "   📄 日志/视频文件，无需解压"
                    ;;
                *)
                    echo "   📎 其他格式文件，跳过解压"
                    ;;
            esac
        else
            echo "❌ 下载失败: $filename"
        fi
    fi
done

echo ""
echo "🎉 下载完成！"
echo "📁 当前目录内容："
ls -lh "$SAVE_DIR" 2>/dev/null || echo "目录为空"
