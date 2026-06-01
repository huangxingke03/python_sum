#!/bin/bash
# =============================================
# JIRA 最新日志/视频下载工具
# 用法: download_jira_new <JIRA单号> [-n 数量]
# 示例: download_jira_new CHYKP31-1028
#       download_jira_new CHYKP31-1028 -n 5   # 只下载最新5个
# =============================================

TICKET=""
LIMIT=0   # 0 = 不限数量

while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--limit) LIMIT="$2"; shift 2 ;;
        *) TICKET="$1"; shift ;;
    esac
done

if [ -z "$TICKET" ]; then
    echo "用法: download_jira_new <JIRA单号> [-n 数量]"
    echo "示例: download_jira_new CHYKP31-1028"
    echo "      download_jira_new CHYKP31-1028 -n 5"
    exit 1
fi

SAVE_DIR="/home/huangxingke/下载/${TICKET}"

# ==================== Cookie 配置（请保持最新） ====================
COOKIE="JSESSIONID=A7D88DC8C98F868132E9BF910603286B; atlassian.xsrf.token=BWB8-5DWA-IKRE-Q10M_c509c72f5e531dd5e7f86c25c3d5afb4d1f6c822_lin; seraph.rememberme.cookie=100954%3Aa5f6cd271708db6061fc8c4b615e02c6f794f0a5"

echo "🧹 正在清理旧文件..."
rm -rf "$SAVE_DIR"
mkdir -p "$SAVE_DIR"

echo "══════════════════════════════════════"
echo "🚀 开始下载 JIRA: $TICKET（仅最新日志/视频）"
echo "保存目录: $SAVE_DIR"
[ "$LIMIT" -gt 0 ] && echo "数量限制: 最新 $LIMIT 个"
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

TOTAL=$(echo "$JSON" | jq '.fields.attachment | length' 2>/dev/null || echo 0)
MATCHED=$(echo "$JSON" | jq '[.fields.attachment[]? | select(.filename | test("\\.(log|txt|mp4|mov|mkv|avi)$"; "i"))] | length' 2>/dev/null || echo 0)
echo "📎 附件总数: $TOTAL 个，符合条件（日志/视频）: $MATCHED 个"

# 按 created 降序，过滤日志和视频，可选数量截断
if [ "$LIMIT" -gt 0 ]; then
    JQ_FILTER='[.fields.attachment[]? | select(.filename | test("\\.(log|txt|mp4|mov|mkv|avi)$"; "i"))]
    | sort_by(.created) | reverse | .[:'"$LIMIT"'][]
    | "\(.created)|\(.content)|\(.filename)"'
else
    JQ_FILTER='[.fields.attachment[]? | select(.filename | test("\\.(log|txt|mp4|mov|mkv|avi)$"; "i"))]
    | sort_by(.created) | reverse[]
    | "\(.created)|\(.content)|\(.filename)"'
fi

echo "✅ 按时间倒序下载..."
echo ""

# 下载循环
echo "$JSON" | jq -r "$JQ_FILTER" 2>/dev/null | \
while IFS='|' read -r created url filename; do
    if [ -n "$url" ] && [ -n "$filename" ]; then
        ts=$(echo "$created" | sed 's/T/ /;s/\..*//')
        filepath="${SAVE_DIR}/${filename}"
        echo "⬇️  [$ts] $filename"
        curl -s -b "$COOKIE" -L -o "$filepath" "$url"
        if [ -s "$filepath" ]; then
            size=$(du -h "$filepath" | cut -f1)
            echo "   ✅ 下载完成 ($size)"
        else
            echo "   ❌ 下载失败"
        fi
    fi
done

echo ""
echo "🎉 下载完成！"
echo "📁 当前目录内容："
ls -lht "$SAVE_DIR" 2>/dev/null || echo "目录为空"
