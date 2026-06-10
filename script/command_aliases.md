# Command Aliases

## Voice Assistant D01
- Standard: `voiceAssistantD01`
- Variant: `voiceassistantD01`
- Variant: `voiceAssistantd01`
- Variant: `voiceassistantd01`

## Voice Assistant KP31
- Standard: `voiceAssistantKp31`
- Variant: `voiceassistantKp31`
- Variant: `voiceAssistantkp31`
- Variant: `voiceassistantkp31`

## Voice Setting D01
- Standard: `voiceSettingD01`
- Variant: `voicesettingD01`
- Variant: `voiceSettingd01`
- Variant: `voicesettingd01`

## Voice Setting KP31
- Standard: `voiceSettingKp31`
- Variant: `voicesettingKp31`
- Variant: `voiceSettingkp31`
- Variant: `voicesettingkp31`

## Random Log
- Standard: `startRandomLog`
- Variant: `startrandomLog`
- Variant: `startRandomlog`
- Variant: `startrandomlog`
- Standard: `stopRandomLog`
- Variant: `stoprandomLog`
- Variant: `stopRandomlog`
- Variant: `stoprandomlog`

## Jira Commands
- Standard: `updateDownloadJira`
- Variant: `updatedownloadJira`
- Variant: `updateDownloadjira`
- Variant: `updatedownloadjira`
- Standard: `downloadJira`
- Variant: `downloadjira`

## Iflytek System Update Commands
- Standard: `updateD01IntSys`
- Variant: `updated01IntSys`
- Variant: `updateD01intSys`
- Variant: `updated01intSys`
- Standard: `updateD01Sys`
- Variant: `updated01Sys`
- Variant: `updateD01sys`
- Variant: `updated01sys`
- Standard: `updateD01pIntSys`
- Variant: `updated01pIntSys`
- Variant: `updateD01pintSys`
- Variant: `updated01pintSys`
- Standard: `updateKp31IntSys`
- Variant: `updatekp31IntSys`
- Variant: `updateKp31intSys`
- Variant: `updatekp31intSys`
- Standard: `updateKp31Sys`
- Variant: `updatekp31Sys`
- Variant: `updateKp31sys`
- Variant: `updatekp31sys`

## Notes
- Voice command variants all support `-s` device selection and tab completion.
- Random log and Iflytek update command variants also support `-s` device selection and tab completion.
- Jira command variants are command-name aliases only; they do not need device completion.
- Legacy underscore-style shortcuts have been removed.

## Examples
```bash
voiceAssistantKp31 -s <device_serial>
voiceassistantkp31 -s <device_serial>
startRandomlog -s <device_serial>
updatekp31sys -s <device_serial>
updateDownloadjira
updatedownloadjira
```
