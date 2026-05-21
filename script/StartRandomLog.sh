#!/bin/bash

LOG_DIR="/home/huangxingke/下载"
COMMAND_DIR="/home/huangxingke/commands"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="${LOG_DIR}/log_${TIMESTAMP}.log"
PID_FILE="${LOG_DIR}/logcat.pid"
STOP_SCRIPT="${COMMAND_DIR}/StopRandomLog.sh"

echo "========================================="
echo "清除日志缓存，开始抓日志..."
echo "日志文件 → ${LOG_FILE}"
echo "========================================="

adb logcat -c

echo "==================== 开始抓取 $(date +"%Y-%m-%d %H:%M:%S") ====================" > "${LOG_FILE}"

adb logcat -v time >> "${LOG_FILE}" 2>&1 &
LOG_PID=$!
echo $LOG_PID > "${PID_FILE}"

echo "✅ 日志抓取已启动！(PID: $LOG_PID)"

# 生成/更新停止脚本（更简洁版）
cat > "${STOP_SCRIPT}" << 'EOF'
#!/bin/bash
PID_FILE="/home/huangxingke/下载/logcat.pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 $PID 2>/dev/null; then
        echo "正在停止 logcat 进程..."
        kill $PID
        sleep 0.3
        rm -f "$PID_FILE"
        echo "✅ 日志抓取已停止"
    else
        echo "进程已不存在，清理残留文件"
        rm -f "$PID_FILE"
    fi
else
    echo "当前没有运行中的日志抓取进程"
fi
EOF

chmod +x "${STOP_SCRIPT}"
echo "停止命令： ./StopRandomLog.sh"
echo ""
