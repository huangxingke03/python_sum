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
install_command update_d01_sys.sh updateD01Sys
install_command update_d01p_int_sys.sh updateD01pIntSys
install_command update_kp31_int_sys.sh updateKp31IntSys
install_command update_kp31_sys.sh updateKp31Sys

ensure_case_insensitive_completion
ensure_completion_source

# 让当前 shell 也立即注册一次补全；新终端会走 ~/.bashrc 自动加载。
# shellcheck disable=SC1090
source "${COMPLETION_SCRIPT}"
echo "更新--- 已注册 -s 设备补全"
