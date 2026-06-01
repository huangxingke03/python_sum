cd /home/huangxingke/work/code/workCode/kp31/VoiceSetting
echo "切换项目根目录,开始打测试包"
chmod +x gradlew
./gradlew assembleD
echo "语音测试包打包完成"
adb root
adb remount
echo "覆盖安装语音设置最新包"
adb install -r -d /home/huangxingke/work/code/workCode/kp31/VoiceSetting/app/build/outputs/apk/debug/ALVoiceSetting-debug.apk
echo "安装完成"

