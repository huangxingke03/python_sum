#!/bin/bash

set -e

TARGET_DIR="${HOME}/.local/bin"
SCRIPT_DIR="/home/huangxingke/project/Python/script"

mkdir -p "${TARGET_DIR}"

cp "${SCRIPT_DIR}/update_voice_build_script.sh" "${TARGET_DIR}/update_voice_build_script"
chmod +x "${TARGET_DIR}/update_voice_build_script"

rm -f \
  "${TARGET_DIR}/voice_assistant_d01" \
  "${TARGET_DIR}/voice_setting_d01" \
  "${TARGET_DIR}/voice_assistant_kp31" \
  "${TARGET_DIR}/voice_setting_kp31" \
  "${TARGET_DIR}/stwc" \
  "${TARGET_DIR}/stwc.sh" \
  "${TARGET_DIR}/Stwc" \
  "${TARGET_DIR}/STwc" \
  "${TARGET_DIR}/STWC" \
  "${TARGET_DIR}/StWc" \
  "${TARGET_DIR}/StWC" \
  "${TARGET_DIR}/StwC" \
  "${TARGET_DIR}/STWc" \
  "${TARGET_DIR}/STwC" \
  "${TARGET_DIR}/sTwc" \
  "${TARGET_DIR}/sTWc" \
  "${TARGET_DIR}/sTwC" \
  "${TARGET_DIR}/sTWC" \
  "${TARGET_DIR}/stWc" \
  "${TARGET_DIR}/stWC" \
  "${TARGET_DIR}/stwC" \
  "${TARGET_DIR}/voiceAssistantD01" \
  "${TARGET_DIR}/voiceassistantD01" \
  "${TARGET_DIR}/voiceAssistantd01" \
  "${TARGET_DIR}/voiceassistantd01" \
  "${TARGET_DIR}/voiceAssistantKp31" \
  "${TARGET_DIR}/voiceassistantKp31" \
  "${TARGET_DIR}/voiceAssistantkp31" \
  "${TARGET_DIR}/voiceassistantkp31" \
  "${TARGET_DIR}/voiceSettingD01" \
  "${TARGET_DIR}/voicesettingD01" \
  "${TARGET_DIR}/voiceSettingd01" \
  "${TARGET_DIR}/voicesettingd01" \
  "${TARGET_DIR}/voiceSettingKp31" \
  "${TARGET_DIR}/voicesettingKp31" \
  "${TARGET_DIR}/voiceSettingkp31" \
  "${TARGET_DIR}/voicesettingkp31" \
  "${TARGET_DIR}/voice_build_common.sh"

echo "更新--- 共享语音打包脚本"
cp "${SCRIPT_DIR}/voice_build_common.sh" "${TARGET_DIR}/voice_build_common.sh"
chmod +x "${TARGET_DIR}/voice_build_common.sh"
echo "更新---共享语音打包脚本更新成功"

echo "更新--- VoiceCommonService 快捷脚本"
cp "${SCRIPT_DIR}/stwc.sh" "${TARGET_DIR}/stwc"
chmod +x "${TARGET_DIR}/stwc"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/stwc.sh"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/Stwc"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/STwc"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/STWC"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/StWc"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/StWC"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/StwC"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/STWc"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/STwC"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/sTwc"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/sTWc"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/sTwC"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/sTWC"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/stWc"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/stWC"
ln -sf "${TARGET_DIR}/stwc" "${TARGET_DIR}/stwC"
echo "更新---VoiceCommonService 快捷脚本更新成功"

cp "${SCRIPT_DIR}/voice_assistant_d01.sh" "${TARGET_DIR}/voiceAssistantD01"
echo "更新--- D01语音助手打包推包脚本"
chmod +x "${TARGET_DIR}/voiceAssistantD01"
ln -sf "${TARGET_DIR}/voiceAssistantD01" "${TARGET_DIR}/voiceassistantD01"
ln -sf "${TARGET_DIR}/voiceAssistantD01" "${TARGET_DIR}/voiceAssistantd01"
ln -sf "${TARGET_DIR}/voiceAssistantD01" "${TARGET_DIR}/voiceassistantd01"
ln -sf "${TARGET_DIR}/voiceAssistantD01" "${TARGET_DIR}/voice_assistant_d01"
echo "更新---D01语音助手打包推包脚本更新成功"

cp "${SCRIPT_DIR}/voice_setting_d01.sh" "${TARGET_DIR}/voiceSettingD01"
echo "更新--- D01语音设置打包推包脚本"
chmod +x "${TARGET_DIR}/voiceSettingD01"
ln -sf "${TARGET_DIR}/voiceSettingD01" "${TARGET_DIR}/voicesettingD01"
ln -sf "${TARGET_DIR}/voiceSettingD01" "${TARGET_DIR}/voiceSettingd01"
ln -sf "${TARGET_DIR}/voiceSettingD01" "${TARGET_DIR}/voicesettingd01"
ln -sf "${TARGET_DIR}/voiceSettingD01" "${TARGET_DIR}/voice_setting_d01"
echo "更新---D01语音设置打包推包脚本更新成功"

cp "${SCRIPT_DIR}/voice_assistant_kp31.sh" "${TARGET_DIR}/voiceAssistantKp31"
echo "更新--- KP31语音助手打包推包脚本"
chmod +x "${TARGET_DIR}/voiceAssistantKp31"
ln -sf "${TARGET_DIR}/voiceAssistantKp31" "${TARGET_DIR}/voiceassistantKp31"
ln -sf "${TARGET_DIR}/voiceAssistantKp31" "${TARGET_DIR}/voiceAssistantkp31"
ln -sf "${TARGET_DIR}/voiceAssistantKp31" "${TARGET_DIR}/voiceassistantkp31"
ln -sf "${TARGET_DIR}/voiceAssistantKp31" "${TARGET_DIR}/voice_assistant_kp31"
echo "更新---KP31语音助手打包推包脚本更新成功"

cp "${SCRIPT_DIR}/voice_setting_kp31.sh" "${TARGET_DIR}/voiceSettingKp31"
echo "更新--- KP31语音设置打包推包脚本"
chmod +x "${TARGET_DIR}/voiceSettingKp31"
ln -sf "${TARGET_DIR}/voiceSettingKp31" "${TARGET_DIR}/voicesettingKp31"
ln -sf "${TARGET_DIR}/voiceSettingKp31" "${TARGET_DIR}/voiceSettingkp31"
ln -sf "${TARGET_DIR}/voiceSettingKp31" "${TARGET_DIR}/voicesettingkp31"
ln -sf "${TARGET_DIR}/voiceSettingKp31" "${TARGET_DIR}/voice_setting_kp31"
echo "更新---KP31语音设置打包推包脚本更新成功"
