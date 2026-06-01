echo "=== 开始推送 系统配置文件（/home/huangxingke/work/file/讯飞切换版本/build_replace/sh/build.prop 到 /system/build.prop ） 到系统 ==="

adb root
if [ $? -ne 0 ]; then
    echo "❌ adb root 失败！请确认设备已 Root"
    exit 1
fi

adb remount
if [ $? -ne 0 ]; then
    echo "❌ adb remount 失败！"
    exit 1
fi

echo "🗑️   删除旧的DATA缓存数据..."
adb shell rm -rf /data/dalvik-cache/*
adb shell rm -rf /data/system/package_cache/*

echo "📤  推送新 系统配置文件..."
adb push /home/huangxingke/work/file/讯飞切换版本/build_replace/sh/build.prop /system/build.prop
adb shell sync

echo "=== 开始推送 讯飞资源 到系统 ==="

adb root
if [ $? -ne 0 ]; then
    echo "❌ adb root 失败！请确认设备已 Root"
    exit 1
fi

adb remount
if [ $? -ne 0 ]; then
    echo "❌ adb remount 失败！"
    exit 1
fi

echo "🗑️   删除旧 Iflytek 资源..."
adb shell rm -rf /iflytek/iflytek/res

echo "📤  推送新 Iflytek 资源..."
adb push /home/huangxingke/work/code/workCode/JETOUR_D01_IFLYTEK/D01/iflytek/res /iflytek/iflytek/res
adb shell chmod -R 777 /iflytek/iflytek/*

echo "更新 ：/iflytek/iflytek/res ---》成功"

echo "=== 开始推送 讯飞APK 到系统 ==="

adb root
if [ $? -ne 0 ]; then
    echo "❌ adb root 失败！请确认设备已 Root"
    exit 1
fi

adb remount
if [ $? -ne 0 ]; then
    echo "❌ adb remount 失败！"
    exit 1
fi

# 删除旧版本
echo "🗑️   删除旧 Iflytek 应用..."
adb shell rm -rf /system/app/Iflytek*

# 推送新版本
echo "📤  推送新 APK..."
adb push /home/huangxingke/work/code/workCode/JETOUR_D01_IFLYTEK/D01/system/app /system/

# echo "台架系统重启..."
# adb reboot

echo "清除语音设置，讯飞侧应用缓存..."

adb shell pm clear com.iflytek.cutefly.speechclient.hmi
adb shell pm clear com.autolink.voicesetting

echo  "清除语音设置，讯飞侧应用缓存后重启..."

adb reboot



