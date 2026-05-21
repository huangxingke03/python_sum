# =============================================
# JIRA 一键下载工具 - Windows PowerShell 版
# 用法: .\download_jira.ps1 <JIRA单号>
# 示例: .\download_jira.ps1 CHYKP31-1028
#       .\download_jira.ps1 DP-5927
# =============================================

param(
    [string]$TICKET = "CHYKP31-1028"
)

$SAVE_DIR = "C:\Users\$env:USERNAME\Downloads\$TICKET"
$COOKIE = "JSESSIONID=*****; atlassian.xsrf.token=****; seraph.rememberme.cookie=***"

# 创建目录并清理旧文件
if (Test-Path $SAVE_DIR) {
    Write-Host "🧹 正在清理旧文件..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $SAVE_DIR
}
New-Item -ItemType Directory -Path $SAVE_DIR -Force | Out-Null

Write-Host "══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "🚀 开始下载 JIRA: $TICKET" -ForegroundColor Cyan
Write-Host "保存目录: $SAVE_DIR （旧文件已清理）" -ForegroundColor Cyan
Write-Host "══════════════════════════════════════" -ForegroundColor Cyan

# 获取附件列表
$headers = @{
    "Content-Type" = "application/json"
    "X-Atlassian-Token" = "no-check"
}

$JSON = Invoke-RestMethod -Uri "https://jira-shzj.auto-link.com.cn/rest/api/2/issue/${TICKET}?fields=attachment" `
    -Method Get `
    -Headers $headers `
    -WebSession (New-Object Microsoft.PowerShell.Commands.WebRequestSession) `
    -UseBasicParsing `
    -ErrorAction Stop

# 权限检查
if ($JSON.errorMessages) {
    Write-Host "❌ 错误: $($JSON.errorMessages[0])" -ForegroundColor Red
    Write-Host "请更新 Cookie 或确认是否有权限" -ForegroundColor Yellow
    exit 1
}

$attachments = $JSON.fields.attachment
Write-Host "✅ 找到 $($attachments.Count) 个附件，开始下载..." -ForegroundColor Green

# 下载循环
foreach ($att in $attachments) {
    $filename = $att.filename
    $url = $att.content
    $filepath = Join-Path $SAVE_DIR $filename

    Write-Host "⬇️ 下载: $filename" -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $url -OutFile $filepath -UseBasicParsing -Headers $headers
        $size = "{0:N2} MB" -f ((Get-Item $filepath).Length / 1MB)
        Write-Host "✅ 下载完成: $filename ($size)" -ForegroundColor Green

        # 自动解压
        if ($filename -like "*.zip") {
            Expand-Archive -Path $filepath -DestinationPath $SAVE_DIR -Force
            Write-Host "   📦 ZIP 已解压" -ForegroundColor Magenta
        }
    }
    catch {
        Write-Host "❌ 下载失败: $filename" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🎉 下载完成！" -ForegroundColor Green
Write-Host "📁 目录内容：" -ForegroundColor Cyan
Get-ChildItem $SAVE_DIR | Select-Object Name, Length | Format-Table -AutoSize
