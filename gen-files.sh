#!/bin/bash

class_file=m8f_aas_event.txt
cvar_file=cvarinfo.toggles.txt
filtered=$(cat event_types.org | grep -v "|--" | grep "|" | grep -v "N |")

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

echo "// This file is generated from event_types.org by gen-files.sh."                                                                        >  $cvar_file
echo "// All manual changes will be lost."                                                                                                    >> $cvar_file
echo ""                                                                                                                                       >> $cvar_file
echo "$filtered" | awk '{ printf("server bool %-32s = %s;\n", $6, $8) }' | sort | uniq                                                        >> $cvar_file
