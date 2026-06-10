#!/bin/bash

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
LOG_DIR="/home/huangxingke/下载"
COMMAND_DIR="/home/huangxingke/project/Python/script"
MAIN_SCRIPT="${COMMAND_DIR}/start_random_log.sh"
START_WRAPPER="${COMMAND_DIR}/StartRandomLog.sh"
STOP_WRAPPER="${COMMAND_DIR}/StopRandomLog.sh"
DEFAULT_ACTION="start"
ACTION="${DEFAULT_ACTION}"
CUSTOM_LOG_NAME=""
DEVICE_SERIAL=""
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

if [ ! -f "${MAIN_SCRIPT}" ]; then
    MAIN_SCRIPT="${SCRIPT_DIR}/start_random_log.sh"
fi

usage() {
    echo "用法: $0 [-s device_serial] [start [自定义文件名] | stop | 自定义文件名]"
    echo "  -s device_serial  指定 adb 设备序列号"
}

sanitize_device_tag() {
    local serial="$1"
    if [ -z "${serial}" ]; then
        echo "default"
    else
        echo "${serial}" | tr '/: ' '___'
    fi
}

ensure_single_target_device() {
    local device_count

    device_count=$(adb devices | sed '1d' | awk '$2 == "device" {count++} END {print count + 0}')
    if [ "${device_count}" -gt 1 ] && [ -z "${DEVICE_SERIAL}" ]; then
        echo "错误: 检测到多个在线设备，请使用 -s 指定设备序列号"
        exit 1
    fi
}

ensure_device_ready() {
    local device_status

    adb start-server >/dev/null
    if [ -z "${DEVICE_SERIAL}" ]; then
        ensure_single_target_device
        return 0
    fi

    device_status=$(adb devices | sed '1d' | awk -v serial="${DEVICE_SERIAL}" '$1 == serial {print $2}')
    if [ -z "${device_status}" ]; then
        echo "错误: adb devices 中未找到设备序列号 ${DEVICE_SERIAL}"
        exit 1
    fi

    if [ "${device_status}" != "device" ]; then
        echo "错误: 设备 ${DEVICE_SERIAL} 当前状态为 ${device_status}，必须为 device 才能继续"
        exit 1
    fi
}

while getopts ":s:h" opt; do
    case "${opt}" in
        s)
            DEVICE_SERIAL="${OPTARG}"
            ;;
        h)
            usage
            exit 0
            ;;
        :)
            echo "错误: -${OPTARG} 需要传入设备序列号"
            usage
            exit 1
            ;;
        \?)
            echo "错误: 不支持的参数 -${OPTARG}"
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND - 1))

if [ $# -gt 0 ]; then
    ACTION="$1"
    shift
fi

if [ -z "${ACTION}" ]; then
    ACTION="${DEFAULT_ACTION}"
elif [ "${ACTION}" = "start" ]; then
    if [ $# -gt 0 ]; then
        CUSTOM_LOG_NAME="$1"
    fi
elif [ "${ACTION}" = "stop" ]; then
    :
else
    CUSTOM_LOG_NAME="${ACTION}"
    ACTION="${DEFAULT_ACTION}"
fi

DEVICE_TAG=$(sanitize_device_tag "${DEVICE_SERIAL}")
PID_FILE="${LOG_DIR}/logcat_${DEVICE_TAG}.pid"

if [ -n "${CUSTOM_LOG_NAME}" ]; then
    LOG_FILE="${LOG_DIR}/${CUSTOM_LOG_NAME}"
else
    if [ -n "${DEVICE_SERIAL}" ]; then
        LOG_FILE="${LOG_DIR}/log_${DEVICE_TAG}_${TIMESTAMP}.log"
    else
        LOG_FILE="${LOG_DIR}/log_${TIMESTAMP}.log"
    fi
fi

is_logcat_capture_pid() {
    local pid="$1"
    local cmdline

    [ -n "${pid}" ] || return 1
    [ -r "/proc/${pid}/cmdline" ] || return 1

    cmdline=$(tr '\0' ' ' < "/proc/${pid}/cmdline" 2>/dev/null)
    [[ "${cmdline}" == *"adb"* && "${cmdline}" == *"logcat"* ]]
}

adb_cmd() {
    if [ -n "${DEVICE_SERIAL}" ]; then
        adb -s "${DEVICE_SERIAL}" "$@"
    else
        adb "$@"
    fi
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
    cat > "${STOP_WRAPPER}" <<EOF2
#!/bin/bash
"${MAIN_SCRIPT}" "\$@" stop
EOF2

    cat > "${START_WRAPPER}" <<EOF3
#!/bin/bash
"${MAIN_SCRIPT}" "\$@"
EOF3

    chmod +x "${STOP_WRAPPER}" "${START_WRAPPER}"
}

start_capture() {
    ensure_device_ready

    echo "========================================="
    echo "清除日志缓存，开始抓日志..."
    if [ -n "${DEVICE_SERIAL}" ]; then
        echo "目标设备 → ${DEVICE_SERIAL}"
    fi
    echo "日志文件 → ${LOG_FILE}"
    echo "========================================="

    if [ -f "${PID_FILE}" ]; then
        echo "检测到已有抓日志记录，先执行停止检查..."
    fi
    stop_capture

    adb_cmd logcat -c
    echo "==================== 开始抓取 $(date +"%Y-%m-%d %H:%M:%S") ====================" > "${LOG_FILE}"

    adb_cmd logcat -v time >> "${LOG_FILE}" 2>&1 &
    LOG_PID=$!
    echo "${LOG_PID}" > "${PID_FILE}"

    echo "✅ 日志抓取已启动！(PID: ${LOG_PID})"
    ensure_command_scripts
    echo "启动命令： ./StartRandomLog.sh [-s device_serial] [自定义文件名]"
    echo "停止命令： ./StopRandomLog.sh [-s device_serial]"
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
        usage
        exit 1
        ;;
esac
