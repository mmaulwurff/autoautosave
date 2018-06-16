acc source/autoautosave.acs acs/autoautosave.o \
&& \
rm -f autoautosave.pk3 \
&& \
zip autoautosave.pk3 \
    acs/autoautosave.o \
    *.txt \
    *.md \
    source/autoautosave.acs \
    sounds/*.wav \
&& \
gzdoom -glversion 3 \
       -file \
       autoautosave.pk3 \
       ~/Programs/Games/wads/maps/DOOMTEST.wad \
       "$1" "$2" \
       +map test \
       -nomonsters
