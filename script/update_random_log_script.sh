#!/bin/bash

set -e

sudo cp /home/huangxingke/project/Python/script/update_random_log_script.sh /usr/local/bin/update_random_log_script
sudo chmod +x /usr/local/bin/update_random_log_script

sudo rm -f /usr/local/bin/start_random_log /usr/local/bin/stop_random_log

sudo cp /home/huangxingke/project/Python/script/start_random_log.sh /usr/local/bin/startRandomLog
sudo chmod +x /usr/local/bin/startRandomLog
echo "更新--- startRandomLog 快捷方式完成"

sudo cp /home/huangxingke/project/Python/script/stop_random_log.sh /usr/local/bin/stopRandomLog
sudo chmod +x /usr/local/bin/stopRandomLog
echo "更新--- stopRandomLog 快捷方式完成"
