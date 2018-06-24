#!/bin/bash

class_file=m8f_aas_event.txt
cvar_file=cvarinfo.toggles.txt
sndinfo_file=sndinfo.txt

filtered=$(cat event_types.org | grep -v "|--" | grep "|" | grep -v "N |")

# Generate ZScript code

echo "// This file is generated from event_types.org by gen-files.sh."                                                                        >  $class_file
echo "// All manual changes will be lost."                                                                                                    >> $class_file
echo ""                                                                                                                                       >> $class_file
echo "class m8f_aas_event"                                                                                                                    >> $class_file
echo "{"                                                                                                                                      >> $class_file
echo "  enum event_type"                                                                                                                      >> $class_file
echo "  {"                                                                                                                                    >> $class_file
echo "$filtered" | awk '{ printf("    %-16s = %3s,\n", $4, $2) }'                                                                             >> $class_file
echo "  }"                                                                                                                                    >> $class_file
echo ""                                                                                                                                       >> $class_file
echo "  static string message(int type)"                                                                                                      >> $class_file
echo "  {"                                                                                                                                    >> $class_file
echo "    switch (type)"                                                                                                                      >> $class_file
echo "      {"                                                                                                                                >> $class_file
echo "$filtered" | awk '{ printf("      case %-16s : return \"%s", $4, $10); for (i=11; i<NF; ++i) { printf(" %s", $i); }; printf("\";\n") }' >> $class_file
echo "      default: return \"Unknown event type.\";"                                                                                         >> $class_file
echo "      }"                                                                                                                                >> $class_file
echo "  }"                                                                                                                                    >> $class_file
echo ""                                                                                                                                       >> $class_file
echo "  static string toggle_name(int type)"                                                                                                  >> $class_file
echo "  {"                                                                                                                                    >> $class_file
echo "    switch (type)"                                                                                                                      >> $class_file
echo "      {"                                                                                                                                >> $class_file
echo "$filtered" | awk '{ printf("      case %-16s : return \"%s\";\n", $4, $6) }'                                                            >> $class_file
echo "      default: return \"m8f_aas_false\";"                                                                                               >> $class_file
echo "      }"                                                                                                                                >> $class_file
echo "  }"                                                                                                                                    >> $class_file
echo "}"                                                                                                                                      >> $class_file

# Generate cvarinfo

echo "// This file is generated from event_types.org by gen-files.sh."                                                                        >  $cvar_file
echo "// All manual changes will be lost."                                                                                                    >> $cvar_file
echo ""                                                                                                                                       >> $cvar_file
echo "$filtered" | awk '{ printf("server bool %-32s = %s;\n", $6, $8) }' | sort | uniq                                                        >> $cvar_file

# Generate sndinfo

echo "// This file is generated automatically!"                       >  $sndinfo_file
echo "// All changed will be lost!"                                   >> $sndinfo_file
echo "// see gen-files.sh for details."                               >> $sndinfo_file
echo ""                                                               >> $sndinfo_file
echo "$filtered" | awk '{ printf("ass/voice%s m8faas%s\n", $2, $2) }' >> $sndinfo_file

# Generate ogg sounds

rm -f sounds/*

mkdir -p sounds

params="-s140 -p0 -g1 -v english"
i="0"
filename="sounds/m8faas"

while read -r line; do
    voice_string=$(echo $line | awk '{ print $10; for (i=11; i<NF; ++i) { printf(" %s", $i); } }')
    #echo $voice_string
    espeak "$voice_string" $params -w $filename$i".wav";
    i=$(($i+1))
done <<< "$filtered"

for f in sounds/*.wav;
do
    oggenc -Q -o ${f%.*}.ogg $f
    rm $f
done