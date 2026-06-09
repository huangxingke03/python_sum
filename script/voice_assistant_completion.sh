#!/bin/bash

_voice_device_completion() {
    local cur prev line serial state model device_name transport_id suggestions
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [ "$prev" = "-s" ]; then
        suggestions=()

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
                suggestions+=("$serial")
            fi
        done < <(adb devices -l 2>/dev/null)

        COMPREPLY=( $(printf '%s\n' "${suggestions[@]}" | awk '!seen[$0]++') )
        return 0
    fi

    COMPREPLY=( $(compgen -W "-s -h" -- "$cur") )
}

complete -F _voice_device_completion ./voice_assistant_d01.sh
complete -F _voice_device_completion ./voice_assistant_kp31.sh
complete -F _voice_device_completion ./voice_setting_d01.sh
complete -F _voice_device_completion ./voice_setting_kp31.sh
complete -F _voice_device_completion voice_assistant_d01.sh
complete -F _voice_device_completion voice_assistant_kp31.sh
complete -F _voice_device_completion voice_setting_d01.sh
complete -F _voice_device_completion voice_setting_kp31.sh
complete -F _voice_device_completion voice_assistant_d01
complete -F _voice_device_completion voice_assistant_kp31
complete -F _voice_device_completion voice_setting_d01
complete -F _voice_device_completion voice_setting_kp31
