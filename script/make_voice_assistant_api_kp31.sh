#!/bin/bash

cd ~/work/code/workCode/kp31/VoiceAssistant/VoiceAssistantApiService || exit 1
echo "切换API库根目录 ： /VoiceAssistant/VoiceAssistantApiService"

echo "========== 开始打包 VoiceAssistantApi =========="

SDK_NAME="VoiceAssistantApi"
DEFAULT_SDK_VERSION="1.8.5"
SDK_VERSION="${1:-$DEFAULT_SDK_VERSION}"
JAR_NAME="${SDK_NAME}_${SDK_VERSION}.jar"
OUTPUT_DIR="libs"
SOURCE_JAR="build/intermediates/aar_main_jar/release/classes.jar"
GRADLE_CMD="gradle"
BUILD_TASK="build"

if [ -x "../gradlew" ]; then
    GRADLE_CMD="../gradlew"
elif [ -x "./gradlew" ]; then
    GRADLE_CMD="./gradlew"
fi

if [ -n "$1" ]; then
    echo "使用自定义版本号：${SDK_VERSION}"
else
    echo "使用默认版本号：${SDK_VERSION}"
    echo "可通过以下方式自定义版本号：./make_voice_assistant_api_kp31.sh 1.8.6"
fi

echo "使用构建命令：${GRADLE_CMD} ${BUILD_TASK}"
echo "正在打包 class 文件..."

if ! "$GRADLE_CMD" "$BUILD_TASK" --quiet; then
    echo "❌ 打包失败，Gradle 构建未通过"
    exit 1
fi

if [ ! -f "$SOURCE_JAR" ]; then
    echo "❌ 打包失败，未找到源码 jar：${SOURCE_JAR}"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "打包完成，正在生成目标 jar..."

if [ -f "${OUTPUT_DIR}/${JAR_NAME}" ]; then
    echo "删除已有同名包：${OUTPUT_DIR}/${JAR_NAME}"
    rm -f "${OUTPUT_DIR}/${JAR_NAME}"
fi

cp "$SOURCE_JAR" "${OUTPUT_DIR}/${JAR_NAME}"

if [ $? -ne 0 ]; then
    echo "❌ 复制 jar 失败"
    exit 1
fi

echo "✅ 打包成功！"
echo "输出文件：${OUTPUT_DIR}/${JAR_NAME}"
ls -lh "$OUTPUT_DIR"
