#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
COMMAND_DIR="/home/huangxingke/project/Python/script"
MAIN_SCRIPT="${COMMAND_DIR}/start_random_log.sh"

if [ ! -f "${MAIN_SCRIPT}" ]; then
    MAIN_SCRIPT="${SCRIPT_DIR}/start_random_log.sh"
fi

"${MAIN_SCRIPT}" "$@" stop
