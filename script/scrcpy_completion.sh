#!/bin/bash

_scrcpy_device_completion() {
    local cur prev line serial state model device_name transport_id
    local -a prefix_suggestions fuzzy_suggestions
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [ "$prev" = "-s" ]; then
        prefix_suggestions=()
        fuzzy_suggestions=()

        while IFS= read -r line; do
            [ -z "$line" ] && continue
            case "$line" in
                List\ of\ devices* )
                    continue
                    ;;
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
}

complete -o nospace -F _scrcpy_device_completion scrcpy
complete -o nospace -F _scrcpy_device_completion scrn
complete -o nospace -F _scrcpy_device_completion scrv
complete -o nospace -F _scrcpy_device_completion scra
complete -o nospace -F _scrcpy_device_completion /home/huangxingke/.local/bin/scrn
complete -o nospace -F _scrcpy_device_completion /home/huangxingke/.local/bin/scrv
complete -o nospace -F _scrcpy_device_completion /home/huangxingke/.local/bin/scra
