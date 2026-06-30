#!/bin/bash

set -e

TARGET_DIR="${HOME}/.local/bin"
SOURCE_DIR="/home/huangxingke/project/Python/script"

mkdir -p "${TARGET_DIR}"

rm -f \
  "${TARGET_DIR}/update_rename_usb_dir" \
  "${TARGET_DIR}/rename_usb_dir" \
  "${TARGET_DIR}/updateRenameUsbDir" \
  "${TARGET_DIR}/updaterenameUsbDir" \
  "${TARGET_DIR}/updateRenameUsbdir" \
  "${TARGET_DIR}/updaterenameUsbdir" \
  "${TARGET_DIR}/renameUsbDir" \
  "${TARGET_DIR}/renameusbDir" \
  "${TARGET_DIR}/renameUsbdir" \
  "${TARGET_DIR}/renameusbdir"

cp "${SOURCE_DIR}/update_rename_usb_dir.sh" "${TARGET_DIR}/updateRenameUsbDir"
chmod +x "${TARGET_DIR}/updateRenameUsbDir"
ln -sf "${TARGET_DIR}/updateRenameUsbDir" "${TARGET_DIR}/updaterenameUsbDir"
ln -sf "${TARGET_DIR}/updateRenameUsbDir" "${TARGET_DIR}/updateRenameUsbdir"
ln -sf "${TARGET_DIR}/updateRenameUsbDir" "${TARGET_DIR}/updaterenameUsbdir"
ln -sf "${TARGET_DIR}/updateRenameUsbDir" "${TARGET_DIR}/update_rename_usb_dir"
echo "更新--- ${TARGET_DIR}/updateRenameUsbDir 成功----"

cp "${SOURCE_DIR}/rename_usb_dir.sh" "${TARGET_DIR}/renameUsbDir"
chmod +x "${TARGET_DIR}/renameUsbDir"
ln -sf "${TARGET_DIR}/renameUsbDir" "${TARGET_DIR}/renameusbDir"
ln -sf "${TARGET_DIR}/renameUsbDir" "${TARGET_DIR}/renameUsbdir"
ln -sf "${TARGET_DIR}/renameUsbDir" "${TARGET_DIR}/renameusbdir"
ln -sf "${TARGET_DIR}/renameUsbDir" "${TARGET_DIR}/rename_usb_dir"
echo "更新--- ${TARGET_DIR}/renameUsbDir 成功----"

echo "提示: 当前 shell 如果还命中旧路径，可执行 hash -r 或重新开一个终端。"
echo "用法: renameUsbDir <修改前目录名> <修改后目录名>"
