cd /home/huangxingke/work/code/workCode/t12a/VoiceAssistant
echo "切换t12a项目根目录,开始打测试包"
chmod +x gradlew
./gradlew assembleD
echo "语音t12a测试包打包完成"
adb root
adb remount
adb push /home/huangxingke/work/code/workCode/t12a/VoiceAssistant/app/build/outputs/apk/debug/ALVoiceAssistant.apk /system/app/ALVoiceAssistant/ALVoiceAssistant.apk
echo "推送语音t12a最新测试包到台架成功"
sleep 1
echo "开始重启台架" 
adb reboot
