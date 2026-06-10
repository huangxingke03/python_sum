#!/bin/bash

set -e

sudo cp /home/huangxingke/project/Python/script/update_random_log_script.sh /usr/local/bin/update_random_log_script
sudo chmod +x /usr/local/bin/update_random_log_script

sudo rm -f \
  /usr/local/bin/start_random_log \
  /usr/local/bin/stop_random_log \
  /usr/local/bin/startrandomLog \
  /usr/local/bin/startRandomlog \
  /usr/local/bin/startrandomlog \
  /usr/local/bin/stoprandomLog \
  /usr/local/bin/stopRandomlog \
  /usr/local/bin/stoprandomlog

sudo cp /home/huangxingke/project/Python/script/start_random_log.sh /usr/local/bin/startRandomLog
sudo chmod +x /usr/local/bin/startRandomLog
sudo ln -sf /usr/local/bin/startRandomLog /usr/local/bin/startrandomLog
sudo ln -sf /usr/local/bin/startRandomLog /usr/local/bin/startRandomlog
sudo ln -sf /usr/local/bin/startRandomLog /usr/local/bin/startrandomlog
echo "更新--- startRandomLog 快捷方式完成"

sudo cp /home/huangxingke/project/Python/script/stop_random_log.sh /usr/local/bin/stopRandomLog
sudo chmod +x /usr/local/bin/stopRandomLog
sudo ln -sf /usr/local/bin/stopRandomLog /usr/local/bin/stoprandomLog
sudo ln -sf /usr/local/bin/stopRandomLog /usr/local/bin/stopRandomlog
sudo ln -sf /usr/local/bin/stopRandomLog /usr/local/bin/stoprandomlog
echo "更新--- stopRandomLog 快捷方式完成"
