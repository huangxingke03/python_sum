#!/bin/bash

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/voice_build_common.sh"

DEFAULT_DEVICE_SERIAL="f6e277ff"
DEVICE_SERIAL="$DEFAULT_DEVICE_SERIAL"

SYSTEMUI_PACKAGE="com.android.systemui"

print_device_usage() {
    echo "用法: $0 [-s device_serial]"
    echo "  -s device_serial  指定台架设备序列号，默认: $DEFAULT_DEVICE_SERIAL"
}

ensure_package_installed() {
    local package_name="$1"

    if ! adb -s "$DEVICE_SERIAL" shell pm list packages "$package_name" | grep -qx "package:$package_name"; then
        echo "错误: 设备 $DEVICE_SERIAL 上未安装 $package_name"
        exit 1
    fi
}

restart_package() {
    local package_name="$1"

    ensure_package_installed "$package_name"
    echo "重启: $package_name"
    adb -s "$DEVICE_SERIAL" shell am force-stop "$package_name"
}

parse_device_args "$@"
shift $((OPTIND - 1))

if [ "$#" -gt 0 ]; then
    echo "错误: 不支持的位置参数: $*"
    print_device_usage
    exit 1
fi

ensure_device_ready "$DEVICE_SERIAL"
DEVICE_NAME=$(get_device_display_name "$DEVICE_SERIAL")

echo "当前台架设备: $DEVICE_SERIAL ($DEVICE_NAME)"
restart_package "$SYSTEMUI_PACKAGE"
echo "完成: $SYSTEMUI_PACKAGE"
