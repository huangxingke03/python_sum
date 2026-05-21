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
