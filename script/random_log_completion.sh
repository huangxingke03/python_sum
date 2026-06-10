#!/bin/bash

_random_log_device_completion() {
    local cur prev line serial state model device_name transport_id
    local -a prefix_suggestions fuzzy_suggestions
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    compopt +o default +o bashdefault 2>/dev/null

    if [ "$prev" = "-s" ]; then
        prefix_suggestions=()
        fuzzy_suggestions=()

        while IFS= read -r line; do
            [ -z "$line" ] && continue
            case "$line" in
                List\ of\ devices* ) continue ;;
            esac

            serial=$(awk '{print $1}' <<< "$line")
            state=$(awk '{print $2}' <<< "$line")
            [ "$state" != "device" ] && continue

            model=$(sed -n 's/.*model:\([^[:space:]]*\).*/\1/p' <<< "$line")
            device_name=$(sed -n 's/.*device:\([^[:space:]]*\).*/\1/p' <<< "$line")
            transport_id=$(sed -n 's/.*transport_id:\([^[:space:]]*\).*/\1/p' <<< "$line")

            if [[ "$serial" == "$cur"* ]] || [[ -n "$model" && "$model" == "$cur"* ]] || [[ -n "$device_name" && "$device_name" == "$cur"* ]] || [[ -n "$transport_id" && "$transport_id" == "$cur"* ]]; then
                prefix_suggestions+=("$serial")
            elif [[ "$serial" == *"$cur"* ]] || [[ -n "$model" && "$model" == *"$cur"* ]] || [[ -n "$device_name" && "$device_name" == *"$cur"* ]] || [[ -n "$transport_id" && "$transport_id" == *"$cur"* ]]; then
                fuzzy_suggestions+=("$serial")
            fi
        done < <(adb devices -l 2>/dev/null)

        if [ ${#prefix_suggestions[@]} -gt 0 ]; then
            COMPREPLY=( $(printf '%s\n' "${prefix_suggestions[@]}" | awk '!seen[$0]++') )
        else
            COMPREPLY=( $(printf '%s\n' "${fuzzy_suggestions[@]}" | awk '!seen[$0]++') )
        fi
        return 0
    fi

    COMPREPLY=( $(compgen -W "-s -h start stop" -- "$cur") )
}

random_log_completion_repair() {
    local command_name
    local -a commands=(
        ./start_random_log.sh
        ./stop_random_log.sh
        /usr/local/bin/startRandomLog
        /usr/local/bin/startrandomLog
        /usr/local/bin/startRandomlog
        /usr/local/bin/startrandomlog
        /usr/local/bin/stopRandomLog
        /usr/local/bin/stoprandomLog
        /usr/local/bin/stopRandomlog
        /usr/local/bin/stoprandomlog
        startRandomLog
        startrandomLog
        startRandomlog
        startrandomlog
        stopRandomLog
        stoprandomLog
        stopRandomlog
        stoprandomlog
        ./StartRandomLog.sh
        ./StopRandomLog.sh
        StartRandomLog.sh
        StopRandomLog.sh
    )

    local -a stale_commands=(
        start_random_log
        stop_random_log
        /usr/local/bin/start_random_log
        /usr/local/bin/stop_random_log
    )

    for command_name in "${commands[@]}"; do
        complete -r "$command_name" 2>/dev/null || true
    done

    for command_name in "${stale_commands[@]}"; do
        complete -r "$command_name" 2>/dev/null || true
    done

    for command_name in "${commands[@]}"; do
        complete -o nospace -F _random_log_device_completion "$command_name"
    done
}

random_log_completion_repair
