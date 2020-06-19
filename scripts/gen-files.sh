#!/bin/bash

class_file=zscript/aas_event.zs
cvar_file=cvarinfo.toggles.txt
sndinfo_file=sndinfo.txt

filtered=$(cat event_types.org | grep -v "|--" | grep "|" | grep -v "N |")

# Generate ZScript code

echo "// This file is generated from event_types.org by gen-files.sh."                                                                        >  $class_file
echo "// All manual changes will be lost."                                                                                                    >> $class_file
echo ""                                                                                                                                       >> $class_file
echo "class aas_event"                                                                                                                        >> $class_file
echo "{"                                                                                                                                      >> $class_file
echo ""                                                                                                                                       >> $class_file
echo "  enum event_type"                                                                                                                      >> $class_file
echo "  {"                                                                                                                                    >> $class_file
echo "$filtered" | awk '{ printf("    %-16s = %3s,\n", $4, $2) }'                                                                             >> $class_file
echo "  }"                                                                                                                                    >> $class_file
echo ""                                                                                                                                       >> $class_file
echo "  static string message(int type)"                                                                                                      >> $class_file
echo "  {"                                                                                                                                    >> $class_file
echo "    switch (type)"                                                                                                                      >> $class_file
echo "    {"                                                                                                                                  >> $class_file
echo "$filtered" | awk '{ printf("      case %-16s : return \"%s", $4, $10); for (i=11; i<NF; ++i) { printf(" %s", $i); }; printf("\";\n") }' >> $class_file
echo "      default: return \"Unknown event type.\";"                                                                                         >> $class_file
echo "    }"                                                                                                                                  >> $class_file
echo "  }"                                                                                                                                    >> $class_file
echo ""                                                                                                                                       >> $class_file
echo "  static string toggle_name(int type)"                                                                                                  >> $class_file
echo "  {"                                                                                                                                    >> $class_file
echo "    switch (type)"                                                                                                                      >> $class_file
echo "    {"                                                                                                                                  >> $class_file
echo "$filtered" | awk '{ printf("      case %-16s : return \"%s\";\n", $4, $6) }'                                                            >> $class_file
echo "      default: return \"m8f_aas_false\";"                                                                                               >> $class_file
echo "    }"                                                                                                                                  >> $class_file
echo "  }"                                                                                                                                    >> $class_file
echo ""                                                                                                                                       >> $class_file
echo "  static string shot_toggle_name(int type)"                                                                                             >> $class_file
echo "  {"                                                                                                                                    >> $class_file
echo "    switch (type)"                                                                                                                      >> $class_file
echo "    {"                                                                                                                                  >> $class_file
echo "$filtered" | awk '{ printf("      case %-16s : return \"m8f_aas_shot_on_%s\";\n", $4, $4) }'                                            >> $class_file
echo "      default: return \"m8f_aas_false\";"                                                                                               >> $class_file
echo "    }"                                                                                                                                  >> $class_file
echo "  }"                                                                                                                                    >> $class_file
echo ""                                                                                                                                       >> $class_file
echo "  static string voice_toggle_name(int type)"                                                                                             >> $class_file
echo "  {"                                                                                                                                    >> $class_file
echo "    switch (type)"                                                                                                                      >> $class_file
echo "    {"                                                                                                                                  >> $class_file
echo "$filtered" | awk '{ printf("      case %-16s : return \"m8f_aas_voice_on_%s\";\n", $4, $4) }'                                            >> $class_file
echo "      default: return \"m8f_aas_true\";"                                                                                               >> $class_file
echo "    }"                                                                                                                                  >> $class_file
echo "  }"                                                                                                                                    >> $class_file
echo ""                                                                                                                                       >> $class_file
echo "} // class m8f_aas_event"                                                                                                               >> $class_file

# Generate cvarinfo

echo "// This file is generated from event_types.org by gen-files.sh."                                                                        >  $cvar_file
echo "// All manual changes will be lost."                                                                                                    >> $cvar_file
echo ""                                                                                                                                       >> $cvar_file
echo "$filtered" | awk '{ printf("server bool %-32s = %s;\n", $6, $8) }' | sort | uniq                                                        >> $cvar_file
echo ""                                                                                                                                       >> $cvar_file
echo "$filtered" | awk '{ printf("server bool m8f_aas_shot_on_%-16s = false;\n", $4) }' | sort | uniq                                         >> $cvar_file
echo ""                                                                                                                                       >> $cvar_file
echo "$filtered" | awk '{ printf("server bool m8f_aas_voice_on_%-16s = true;\n", $4) }' | sort | uniq                                         >> $cvar_file

# Generate sndinfo

echo "// This file is generated automatically!"                       >  $sndinfo_file
echo "// All changed will be lost!"                                   >> $sndinfo_file
echo "// see gen-files.sh for details."                               >> $sndinfo_file
echo ""                                                               >> $sndinfo_file
echo "$filtered" | awk '{ printf("aas/voice%s \"sounds/aas%s.ogg\"\n", $2, $2) }' >> $sndinfo_file

# Generate ogg sounds

rm -f sounds/*

mkdir -p sounds

params="-s140 -p0 -g1 -v english"
filename="sounds/aas"

while read -r line; do
    voice_string=$(echo $line | awk '{ print $10; for (i=11; i<NF; ++i) { printf(" %s", $i); } }')
    i=$(echo $line | awk '{ print $2 }')
    #echo $voice_string
    espeak "$voice_string" $params -w $filename$i".wav";
done <<< "$filtered"

for f in sounds/*.wav;
do
    oggenc -Q -o ${f%.*}.ogg $f
    rm $f
done
