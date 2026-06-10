#!/bin/bash

set -e

sudo rm -f /usr/local/bin/update_download_jira /usr/local/bin/download_jira

sudo cp /home/huangxingke/project/Python/script/update_download_jira.sh /usr/local/bin/updateDownloadJira
echo "更新--- /usr/local/bin/updateDownloadJira ----"
sudo chmod +x /usr/local/bin/updateDownloadJira
echo "更新--- /usr/local/bin/updateDownloadJira 成功----"

sudo cp /home/huangxingke/project/Python/script/download_jira.sh /usr/local/bin/downloadJira
echo "更新--- /usr/local/bin/downloadJira ----"
sudo chmod +x /usr/local/bin/downloadJira
echo "更新--- /usr/local/bin/downloadJira 成功----"
