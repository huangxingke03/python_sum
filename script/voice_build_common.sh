#!/bin/bash

parse_device_args() {
    local opt

    while getopts ":s:h" opt; do
        case "$opt" in
            s)
                DEVICE_SERIAL="$OPTARG"
                ;;
            h)
                print_device_usage
                exit 0
                ;;
            :)
                echo "错误: -$OPTARG 需要传入设备序列号"
                print_device_usage
                exit 1
                ;;
            \?)
                echo "错误: 不支持的参数 -$OPTARG"
                print_device_usage
                exit 1
                ;;
        esac
    done
}

print_device_usage() {
    echo "用法: $0 [-s device_serial]"
    echo "  -s device_serial  指定台架设备序列号，默认: $DEFAULT_DEVICE_SERIAL"
}

ensure_device_ready() {
    local device_status

    adb start-server >/dev/null
    device_status=$(adb devices | sed '1d' | awk -v serial="$1" '$1 == serial {print $2}')
    if [ -z "$device_status" ]; then
        echo "错误: adb devices 中未找到设备序列号 $1"
        exit 1
    fi

    if [ "$device_status" != "device" ]; then
        echo "错误: 设备 $1 当前状态为 $device_status，必须为 device 才能继续"
        exit 1
    fi
}

prepare_gradle_build() {
    local project_dir="$1"

    cd "$project_dir"
    echo "切换项目根目录,开始打测试包"
    chmod +x gradlew
    ./gradlew assembleD
    echo "语音测试包打包完成"
}
