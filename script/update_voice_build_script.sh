#!/bin/bash

set -e

sudo cp /home/huangxingke/project/Python/script/update_voice_build_script.sh /usr/local/bin/update_voice_build_script
sudo chmod +x /usr/local/bin/update_voice_build_script

sudo rm -f \
  /usr/local/bin/voice_assistant_d01 \
  /usr/local/bin/voice_setting_d01 \
  /usr/local/bin/voice_assistant_kp31 \
  /usr/local/bin/voice_setting_kp31 \
  /usr/local/bin/voiceassistantD01 \
  /usr/local/bin/voiceAssistantd01 \
  /usr/local/bin/voiceassistantd01 \
  /usr/local/bin/voiceassistantKp31 \
  /usr/local/bin/voiceAssistantkp31 \
  /usr/local/bin/voiceassistantkp31 \
  /usr/local/bin/voicesettingD01 \
  /usr/local/bin/voiceSettingd01 \
  /usr/local/bin/voicesettingd01 \
  /usr/local/bin/voicesettingKp31 \
  /usr/local/bin/voiceSettingkp31 \
  /usr/local/bin/voicesettingkp31

echo "更新--- 共享语音打包脚本"
sudo cp /home/huangxingke/project/Python/script/voice_build_common.sh /usr/local/bin/voice_build_common.sh
sudo chmod +x /usr/local/bin/voice_build_common.sh
echo "更新---共享语音打包脚本更新成功"

sudo cp /home/huangxingke/project/Python/script/voice_assistant_d01.sh /usr/local/bin/voiceAssistantD01
echo "更新--- D01语音助手打包推包脚本"
sudo chmod +x /usr/local/bin/voiceAssistantD01
sudo ln -sf /usr/local/bin/voiceAssistantD01 /usr/local/bin/voiceassistantD01
sudo ln -sf /usr/local/bin/voiceAssistantD01 /usr/local/bin/voiceAssistantd01
sudo ln -sf /usr/local/bin/voiceAssistantD01 /usr/local/bin/voiceassistantd01
echo "更新---D01语音助手打包推包脚本更新成功"

sudo cp /home/huangxingke/project/Python/script/voice_setting_d01.sh /usr/local/bin/voiceSettingD01
echo "更新--- D01语音设置打包推包脚本"
sudo chmod +x /usr/local/bin/voiceSettingD01
sudo ln -sf /usr/local/bin/voiceSettingD01 /usr/local/bin/voicesettingD01
sudo ln -sf /usr/local/bin/voiceSettingD01 /usr/local/bin/voiceSettingd01
sudo ln -sf /usr/local/bin/voiceSettingD01 /usr/local/bin/voicesettingd01
echo "更新---D01语音设置打包推包脚本更新成功"

sudo cp /home/huangxingke/project/Python/script/voice_assistant_kp31.sh /usr/local/bin/voiceAssistantKp31
echo "更新--- KP31语音助手打包推包脚本"
sudo chmod +x /usr/local/bin/voiceAssistantKp31
sudo ln -sf /usr/local/bin/voiceAssistantKp31 /usr/local/bin/voiceassistantKp31
sudo ln -sf /usr/local/bin/voiceAssistantKp31 /usr/local/bin/voiceAssistantkp31
sudo ln -sf /usr/local/bin/voiceAssistantKp31 /usr/local/bin/voiceassistantkp31
echo "更新---KP31语音助手打包推包脚本更新成功"

sudo cp /home/huangxingke/project/Python/script/voice_setting_kp31.sh /usr/local/bin/voiceSettingKp31
echo "更新--- KP31语音设置打包推包脚本"
sudo chmod +x /usr/local/bin/voiceSettingKp31
sudo ln -sf /usr/local/bin/voiceSettingKp31 /usr/local/bin/voicesettingKp31
sudo ln -sf /usr/local/bin/voiceSettingKp31 /usr/local/bin/voiceSettingkp31
sudo ln -sf /usr/local/bin/voiceSettingKp31 /usr/local/bin/voicesettingkp31
echo "更新---KP31语音设置打包推包脚本更新成功"
