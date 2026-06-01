#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
LOG_DIR="/home/huangxingke/下载"
COMMAND_DIR="/home/huangxingke/project/Python/script"
MAIN_SCRIPT="${COMMAND_DIR}/start_random_log.sh"
PID_FILE="${LOG_DIR}/logcat.pid"
STOP_SCRIPT="${COMMAND_DIR}/StopRandomLog.sh"
START_SCRIPT="${COMMAND_DIR}/StartRandomLog.sh"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ACTION="$1"
CUSTOM_LOG_NAME=""

if [ ! -f "${MAIN_SCRIPT}" ]; then
    MAIN_SCRIPT="${SCRIPT_DIR}/start_random_log.sh"
fi

if [ -z "${ACTION}" ]; then
    ACTION="start"
elif [ "${ACTION}" = "start" ]; then
    CUSTOM_LOG_NAME="$2"
elif [ "${ACTION}" != "stop" ]; then
    CUSTOM_LOG_NAME="${ACTION}"
    ACTION="start"
fi

if [ -n "${CUSTOM_LOG_NAME}" ]; then
    LOG_FILE="${LOG_DIR}/${CUSTOM_LOG_NAME}"
else
    LOG_FILE="${LOG_DIR}/log_${TIMESTAMP}.log"
fi

is_logcat_capture_pid() {
    local pid="$1"
    local cmdline

    [ -n "${pid}" ] || return 1
    [ -r "/proc/${pid}/cmdline" ] || return 1

    cmdline=$(tr '\0' ' ' < "/proc/${pid}/cmdline" 2>/dev/null)
    [[ "${cmdline}" == *"adb"* && "${cmdline}" == *"logcat"* ]]
}

stop_capture_by_pid() {
    local pid="$1"
    local attempt

    echo "正在停止 logcat 进程(PID: ${pid})..."
    kill "${pid}" 2>/dev/null

    for attempt in 1 2 3 4 5; do
        if ! is_logcat_capture_pid "${pid}"; then
            break
        fi
        sleep 0.2
    done

    if is_logcat_capture_pid "${pid}"; then
        echo "进程未在预期时间内退出，执行强制停止..."
        kill -9 "${pid}" 2>/dev/null
        sleep 0.1
    fi

    if is_logcat_capture_pid "${pid}"; then
        echo "❌ 停止失败，请手动检查进程状态"
        return 1
    fi

    rm -f "${PID_FILE}"
    echo "✅ 日志抓取已停止"
    return 0
}

stop_capture() {
    local pid=""

    if [ ! -f "${PID_FILE}" ]; then
        echo "当前没有运行中的日志抓取进程"
        return 0
    fi

    pid=$(cat "${PID_FILE}" 2>/dev/null)
    if is_logcat_capture_pid "${pid}"; then
        stop_capture_by_pid "${pid}"
        return $?
    fi

    if [ -n "${pid}" ]; then
        echo "PID 文件中的进程(PID: ${pid})不是 adb logcat，未执行停止，仅清理残留文件"
    else
        echo "PID 文件为空，清理残留文件"
    fi

    rm -f "${PID_FILE}"
    return 0
}

ensure_command_scripts() {
    cat > "${STOP_SCRIPT}" <<EOF2
#!/bin/bash
"${MAIN_SCRIPT}" stop
EOF2

    cat > "${START_SCRIPT}" <<EOF3
#!/bin/bash
"${MAIN_SCRIPT}" "\$@"
EOF3

    chmod +x "${STOP_SCRIPT}" "${START_SCRIPT}"
}

start_capture() {
    echo "========================================="
    echo "清除日志缓存，开始抓日志..."
    echo "日志文件 → ${LOG_FILE}"
    echo "========================================="

    if [ -f "${PID_FILE}" ]; then
        echo "检测到已有抓日志记录，先执行停止检查..."
    fi
    stop_capture

    adb logcat -c
    echo "==================== 开始抓取 $(date +"%Y-%m-%d %H:%M:%S") ====================" > "${LOG_FILE}"

    adb logcat -v time >> "${LOG_FILE}" 2>&1 &
    LOG_PID=$!
    echo "${LOG_PID}" > "${PID_FILE}"

    echo "✅ 日志抓取已启动！(PID: ${LOG_PID})"
    ensure_command_scripts
    echo "启动命令： ./StartRandomLog.sh [自定义文件名]"
    echo "停止命令： ./StopRandomLog.sh"
    echo ""
}

case "${ACTION}" in
    start)
        start_capture
        ;;
    stop)
        stop_capture
        ;;
    *)
        echo "用法: $0 [start [自定义文件名] | stop | 自定义文件名]"
        exit 1
        ;;
esac
