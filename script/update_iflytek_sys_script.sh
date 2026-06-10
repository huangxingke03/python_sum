#!/bin/bash

set -e

SCRIPT_DIR="/home/huangxingke/project/Python/script"
COMPLETION_SCRIPT="${SCRIPT_DIR}/iflytek_sys_completion.sh"
BASHRC_FILE="${HOME}/.bashrc"
INPUTRC_FILE="${HOME}/.inputrc"
COMPLETION_SOURCE_LINE="[ -f \"${COMPLETION_SCRIPT}\" ] && source \"${COMPLETION_SCRIPT}\""

OLD_COMMANDS=(
  /usr/local/bin/update_d01_Int_sys
  /usr/local/bin/update_d01_Int_sys.sh
  /usr/local/bin/update_d01_sys
  /usr/local/bin/update_d01_sys.sh
  /usr/local/bin/update_d01p_int_sys
  /usr/local/bin/update_d01p_int_sys.sh
  /usr/local/bin/update_kp31_int_sys
  /usr/local/bin/update_kp31_int_sys.sh
  /usr/local/bin/update_kp31_sys
  /usr/local/bin/update_kp31_sys.sh
  /usr/local/bin/updated01IntSys
  /usr/local/bin/updateD01intSys
  /usr/local/bin/updated01intSys
  /usr/local/bin/updated01Sys
  /usr/local/bin/updateD01sys
  /usr/local/bin/updated01sys
  /usr/local/bin/updated01pIntSys
  /usr/local/bin/updateD01pintSys
  /usr/local/bin/updated01pintSys
  /usr/local/bin/updatekp31IntSys
  /usr/local/bin/updateKp31intSys
  /usr/local/bin/updatekp31intSys
  /usr/local/bin/updatekp31Sys
  /usr/local/bin/updateKp31sys
  /usr/local/bin/updatekp31sys
)

install_command() {
  local source_file="$1"
  local target_name="$2"

  sudo cp "${SCRIPT_DIR}/${source_file}" "/usr/local/bin/${target_name}"
  sudo chmod +x "/usr/local/bin/${target_name}"
  echo "更新--- /usr/local/bin/${target_name} 成功"
}

ensure_case_insensitive_completion() {
  touch "${INPUTRC_FILE}"
  if ! grep -qxF "set completion-ignore-case on" "${INPUTRC_FILE}"; then
    printf '\nset completion-ignore-case on\n' >> "${INPUTRC_FILE}"
    echo "更新--- 已开启 Bash 大小写不敏感补全，请重新打开终端或执行: bind 'set completion-ignore-case on'"
  else
    echo "更新--- Bash 大小写不敏感补全已开启"
  fi
}

ensure_completion_source() {
  touch "${BASHRC_FILE}"
  if ! grep -qxF "${COMPLETION_SOURCE_LINE}" "${BASHRC_FILE}"; then
    printf '\n%s\n' "${COMPLETION_SOURCE_LINE}" >> "${BASHRC_FILE}"
    echo "更新--- 已写入 Bash 补全加载配置"
  else
    echo "更新--- Bash 补全加载配置已存在"
  fi
}

sudo cp "${SCRIPT_DIR}/update_iflytek_sys_script.sh" /usr/local/bin/updateIflytekSysScript
sudo chmod +x /usr/local/bin/updateIflytekSysScript
echo "更新--- /usr/local/bin/updateIflytekSysScript 成功"

sudo rm -f "${OLD_COMMANDS[@]}"
echo "更新--- 已移除老快捷方式"

install_command update_d01_Int_sys.sh updateD01IntSys
sudo ln -sf /usr/local/bin/updateD01IntSys /usr/local/bin/updated01IntSys
sudo ln -sf /usr/local/bin/updateD01IntSys /usr/local/bin/updateD01intSys
sudo ln -sf /usr/local/bin/updateD01IntSys /usr/local/bin/updated01intSys

install_command update_d01_sys.sh updateD01Sys
sudo ln -sf /usr/local/bin/updateD01Sys /usr/local/bin/updated01Sys
sudo ln -sf /usr/local/bin/updateD01Sys /usr/local/bin/updateD01sys
sudo ln -sf /usr/local/bin/updateD01Sys /usr/local/bin/updated01sys

install_command update_d01p_int_sys.sh updateD01pIntSys
sudo ln -sf /usr/local/bin/updateD01pIntSys /usr/local/bin/updated01pIntSys
sudo ln -sf /usr/local/bin/updateD01pIntSys /usr/local/bin/updateD01pintSys
sudo ln -sf /usr/local/bin/updateD01pIntSys /usr/local/bin/updated01pintSys

install_command update_kp31_int_sys.sh updateKp31IntSys
sudo ln -sf /usr/local/bin/updateKp31IntSys /usr/local/bin/updatekp31IntSys
sudo ln -sf /usr/local/bin/updateKp31IntSys /usr/local/bin/updateKp31intSys
sudo ln -sf /usr/local/bin/updateKp31IntSys /usr/local/bin/updatekp31intSys

install_command update_kp31_sys.sh updateKp31Sys
sudo ln -sf /usr/local/bin/updateKp31Sys /usr/local/bin/updatekp31Sys
sudo ln -sf /usr/local/bin/updateKp31Sys /usr/local/bin/updateKp31sys
sudo ln -sf /usr/local/bin/updateKp31Sys /usr/local/bin/updatekp31sys

ensure_case_insensitive_completion
ensure_completion_source

# shellcheck disable=SC1090
source "${COMPLETION_SCRIPT}"
echo "更新--- 已注册 -s 设备补全"
