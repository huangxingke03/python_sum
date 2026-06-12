#!/bin/bash

set -e

TARGET_DIR="${HOME}/.local/bin"
SOURCE_DIR="/home/huangxingke/project/Python/script"

mkdir -p "${TARGET_DIR}"

rm -f \
  "${TARGET_DIR}/update_download_jira" \
  "${TARGET_DIR}/download_jira" \
  "${TARGET_DIR}/updateDownloadJira" \
  "${TARGET_DIR}/updatedownloadJira" \
  "${TARGET_DIR}/updateDownloadjira" \
  "${TARGET_DIR}/updatedownloadjira" \
  "${TARGET_DIR}/downloadJira" \
  "${TARGET_DIR}/downloadjira"

cp "${SOURCE_DIR}/update_download_jira.sh" "${TARGET_DIR}/updateDownloadJira"
chmod +x "${TARGET_DIR}/updateDownloadJira"
ln -sf "${TARGET_DIR}/updateDownloadJira" "${TARGET_DIR}/updatedownloadJira"
ln -sf "${TARGET_DIR}/updateDownloadJira" "${TARGET_DIR}/updateDownloadjira"
ln -sf "${TARGET_DIR}/updateDownloadJira" "${TARGET_DIR}/updatedownloadjira"
ln -sf "${TARGET_DIR}/updateDownloadJira" "${TARGET_DIR}/update_download_jira"
echo "更新--- ${TARGET_DIR}/updateDownloadJira 成功----"

cp "${SOURCE_DIR}/download_jira.sh" "${TARGET_DIR}/downloadJira"
chmod +x "${TARGET_DIR}/downloadJira"
ln -sf "${TARGET_DIR}/downloadJira" "${TARGET_DIR}/downloadjira"
ln -sf "${TARGET_DIR}/downloadJira" "${TARGET_DIR}/download_jira"
echo "更新--- ${TARGET_DIR}/downloadJira 成功----"

echo "提示: 当前 shell 如果还命中旧的 /usr/local/bin，可执行 hash -r 或重新开一个终端。"
