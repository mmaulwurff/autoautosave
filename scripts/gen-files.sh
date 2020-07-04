#!/bin/bash

# This script generates ZScript class to get event information (class_file),
# CVar definitions (cvar_file), sound definitions (sndinfo_file), and sounds
# (sounds/*.ogg).
#
# Dependencies:
# - espeak-ng
# - oggenc
#
# How to use:
# ./scripts/gen-files.sh

class_file=zscript/aas_event.zs
cvar_file=cvarinfo.toggles.txt
sndinfo_file=sndinfo.txt
precache_file=zscript/aas_precache_sounds.zs

filtered=$(grep -v "|--" event_types.org | grep "|" | grep -v "N |")

# Generate ZScript code ############################################################################
{
    echo "// This file is generated from event_types.org by gen-files.sh."
    echo "// All manual changes will be lost."
    echo
    echo "class aas_event"
    echo "{"
    echo
    echo "  enum event_type"
    echo "  {"
    echo "$filtered" | awk '{ printf("    %-16s = %3s,\n", $4, $2) }'
    echo "  }"
    echo
    echo "  static string message(int type)"
    echo "  {"
    echo "    switch (type)"
    echo "    {"
    echo "$filtered" | awk '{ printf("      case %-16s : return \"%s", $4, $10); for (i=11; i<NF; ++i) { printf(" %s", $i); }; printf("\";\n") }'
    echo "      default: return \"Unknown event type.\";"
    echo "    }"
    echo "  }"
    echo
    echo "  static string toggle_name(int type)"
    echo "  {"
    echo "    switch (type)"
    echo "    {"
    echo "$filtered" | awk '{ printf("      case %-16s : return \"%s\";\n", $4, $6) }'
    echo "      default: return \"m8f_aas_false\";"
    echo "    }"
    echo "  }"
    echo
    echo "  static string shot_toggle_name(int type)"
    echo "  {"
    echo "    switch (type)"
    echo "    {"
    echo "$filtered" | awk '{ printf("      case %-16s : return \"m8f_aas_shot_on_%s\";\n", $4, $4) }'
    echo "      default: return \"m8f_aas_false\";"
    echo "    }"
    echo "  }"
    echo
    echo "  static string voice_toggle_name(int type)"
    echo "  {"
    echo "    switch (type)"
    echo "    {"
    echo "$filtered" | awk '{ printf("      case %-16s : return \"m8f_aas_voice_on_%s\";\n", $4, $4) }'
    echo "      default: return \"m8f_aas_true\";"
    echo "    }"
    echo "  }"
    echo
    echo "} // class aas_event"
} > $class_file

# Generate cvarinfo
{
    echo "// This file is generated from event_types.org by gen-files.sh."
    echo "// All manual changes will be lost."
    echo
    echo "$filtered" | awk '{ printf("server bool %-32s = %s;\n", $6, $8) }' | sort | uniq
    echo
    echo "$filtered" | awk '{ printf("server bool m8f_aas_shot_on_%-16s = false;\n", $4) }' | sort | uniq
    echo
    echo "$filtered" | awk '{ printf("server bool m8f_aas_voice_on_%-16s = true;\n", $4) }' | sort | uniq
} > $cvar_file

# Generate sndinfo #################################################################################
{
    echo "// This file is generated automatically!"
    echo "// All changed will be lost!"
    echo "// see gen-files.sh for details."
    echo
    echo "\$pitchshiftrange 0"
    echo
    echo "$filtered" | awk '{ printf("aas/voice%s \"sounds/aas%s.ogg\"\n", $2, $2) }'
    echo
    echo "$filtered" | awk '{ printf("aas/voice-w%s \"sounds/aas-w%s.ogg\"\n", $2, $2) }'
    echo
    echo "$filtered" | awk '{ printf("aas/voice-f%s \"sounds/aas-f%s.ogg\"\n", $2, $2) }'
} > $sndinfo_file

# Generate code to precache sounds #################################################################

{
    echo "// This file is generated automatically!"
    echo "// All changed will be lost!"
    echo "// see gen-files.sh for details."
    echo
    echo "class aas_precache_sounds"
    echo "{"
    echo
    echo "  static"
    echo "  void precache_sounds()"
    echo "  {"
    echo "$filtered" | awk '{ printf("    MarkSound(\"aas/voice%s\");\n", $2) }'
    echo
    echo "$filtered" | awk '{ printf("    MarkSound(\"aas/voice-w%s\");\n", $2) }'
    echo
    echo "$filtered" | awk '{ printf("    MarkSound(\"aas/voice-f%s\");\n", $2) }'
    echo "  }"
    echo
    echo "} // class aas_precache_sounds"
} > $precache_file

# Generate ogg sounds ##############################################################################

rm -f sounds/*

mkdir -p sounds

params="        -s140 -p0 -g1 -v en"
params_whisper="-s140     -g1 -v whisper"
params_female=" -s140     -g1 -v f2"
filename="sounds/aas"

while read -r line; do
    voice_string=$(echo "$line" | awk '{ print $10; for (i=11; i<NF; ++i) { printf(" %s", $i); } }')
    i=$(echo "$line" | awk '{ print $2 }')
    #echo $voice_string
    espeak-ng "$voice_string" $params         -w "$filename$i.wav";
    espeak-ng "$voice_string" $params_whisper -w "$filename-w$i.wav";
    espeak-ng "$voice_string" $params_female  -w "$filename-f$i.wav";
done <<< "$filtered"

for f in sounds/*.wav;
do
    oggenc -s 0 -Q -o "${f%.*}.ogg" "$f"
    rm "$f"
done
