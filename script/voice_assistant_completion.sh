#!/bin/bash

_voice_device_completion() {
    local cur prev line serial state model device_name transport_id
    local -a prefix_suggestions fuzzy_suggestions
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Never fall back to filename completion for -s device suggestions.
    compopt +o default +o bashdefault 2>/dev/null

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

    COMPREPLY=( $(compgen -W "-s -h" -- "$cur") )
}

_voice_completion_reset() {
    local command_name
    local -a all_commands=(
        ./voice_assistant_d01.sh
        ./voice_assistant_kp31.sh
        ./voice_setting_d01.sh
        ./voice_setting_kp31.sh
        voice_assistant_d01.sh
        voice_assistant_kp31.sh
        voice_setting_d01.sh
        voice_setting_kp31.sh
        /usr/local/bin/voiceAssistantD01
        /usr/local/bin/voiceAssistantKp31
        /usr/local/bin/voiceSettingD01
        /usr/local/bin/voiceSettingKp31
        voiceAssistantD01
        voiceAssistantKp31
        voiceSettingD01
        voiceSettingKp31
    )

    for command_name in "${all_commands[@]}"; do
        complete -r "$command_name" 2>/dev/null || true
    done
}

_voice_completion_bind() {
    local command_name
    local -a supported_commands=(
        ./voice_assistant_d01.sh
        ./voice_assistant_kp31.sh
        ./voice_setting_d01.sh
        ./voice_setting_kp31.sh
        voice_assistant_d01.sh
        voice_assistant_kp31.sh
        voice_setting_d01.sh
        voice_setting_kp31.sh
        /usr/local/bin/voiceAssistantD01
        /usr/local/bin/voiceAssistantKp31
        /usr/local/bin/voiceSettingD01
        /usr/local/bin/voiceSettingKp31
        voiceAssistantD01
        voiceAssistantKp31
        voiceSettingD01
        voiceSettingKp31
    )

    for command_name in "${supported_commands[@]}"; do
        complete -o nospace -F _voice_device_completion "$command_name"
    done
}

voice_completion_repair() {
    _voice_completion_reset
    _voice_completion_bind
}

voice_completion_repair
