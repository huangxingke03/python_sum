#!/bin/bash

set -e

sudo cp /home/huangxingke/project/Python/script/voice_build_common.sh /usr/local/bin/voice_build_common.sh
sudo chmod +x /usr/local/bin/voice_build_common.sh
echo "更新--- 共享语音打包脚本"
echo "更新---共享语音打包脚本更新成功"

sudo cp /home/huangxingke/project/Python/script/voice_assistant_d01.sh /usr/local/bin/voice_assistant_d01
echo "更新--- D01语音助手打包推包脚本"
sudo chmod +x /usr/local/bin/voice_assistant_d01
echo "更新---D01语音助手打包推包脚本更新成功"

sudo cp /home/huangxingke/project/Python/script/voice_setting_d01.sh /usr/local/bin/voice_setting_d01
echo "更新--- D01语音设置打包推包脚本"
sudo chmod +x /usr/local/bin/voice_setting_d01
echo "更新---D01语音设置打包推包脚本更新成功"

sudo cp /home/huangxingke/project/Python/script/voice_assistant_kp31.sh /usr/local/bin/voice_assistant_kp31
echo "更新--- KP31语音助手打包推包脚本"
sudo chmod +x /usr/local/bin/voice_assistant_kp31
echo "更新---KP31语音助手打包推包脚本更新成功"

sudo cp /home/huangxingke/project/Python/script/voice_setting_kp31.sh /usr/local/bin/voice_setting_kp31
echo "更新--- KP31语音设置打包推包脚本"
sudo chmod +x /usr/local/bin/voice_setting_kp31
echo "更新---KP31语音设置打包推包脚本更新成功"
