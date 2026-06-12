#!/bin/bash

set -e

TARGET_DIR="${HOME}/.local/bin"
SCRIPT_DIR="/home/huangxingke/project/Python/script"

mkdir -p "${TARGET_DIR}"

cp "${SCRIPT_DIR}/update_random_log_script.sh" "${TARGET_DIR}/update_random_log_script"
chmod +x "${TARGET_DIR}/update_random_log_script"

rm -f \
  "${TARGET_DIR}/start_random_log" \
  "${TARGET_DIR}/stop_random_log" \
  "${TARGET_DIR}/startRandomLog" \
  "${TARGET_DIR}/startrandomLog" \
  "${TARGET_DIR}/startRandomlog" \
  "${TARGET_DIR}/startrandomlog" \
  "${TARGET_DIR}/stopRandomLog" \
  "${TARGET_DIR}/stoprandomLog" \
  "${TARGET_DIR}/stopRandomlog" \
  "${TARGET_DIR}/stoprandomlog"

cp "${SCRIPT_DIR}/start_random_log.sh" "${TARGET_DIR}/startRandomLog"
chmod +x "${TARGET_DIR}/startRandomLog"
ln -sf "${TARGET_DIR}/startRandomLog" "${TARGET_DIR}/startrandomLog"
ln -sf "${TARGET_DIR}/startRandomLog" "${TARGET_DIR}/startRandomlog"
ln -sf "${TARGET_DIR}/startRandomLog" "${TARGET_DIR}/startrandomlog"
ln -sf "${TARGET_DIR}/startRandomLog" "${TARGET_DIR}/start_random_log"
echo "更新--- startRandomLog 快捷方式完成"

cp "${SCRIPT_DIR}/stop_random_log.sh" "${TARGET_DIR}/stopRandomLog"
chmod +x "${TARGET_DIR}/stopRandomLog"
ln -sf "${TARGET_DIR}/stopRandomLog" "${TARGET_DIR}/stoprandomLog"
ln -sf "${TARGET_DIR}/stopRandomLog" "${TARGET_DIR}/stopRandomlog"
ln -sf "${TARGET_DIR}/stopRandomLog" "${TARGET_DIR}/stoprandomlog"
ln -sf "${TARGET_DIR}/stopRandomLog" "${TARGET_DIR}/stop_random_log"
echo "更新--- stopRandomLog 快捷方式完成"
