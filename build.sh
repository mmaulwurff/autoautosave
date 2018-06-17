#!/bin/bash

name=autoautosave

git log --pretty=format:"-%d %ai %s%n" > changelog.txt \
&& \
rm -f $name.pk3 \
&& \
./gen-voice.sh \
&& \
zip $name.pk3 \
    *.txt \
    *.md \
    sounds/*.ogg \
&& \
cp $name.pk3 $name-$(git describe --abbrev=0 --tags).pk3 \
&& \
gzdoom -glversion 3 \
       -file \
       $name.pk3 \
       ~/Programs/Games/wads/maps/DOOMTEST.wad \
       "$1" "$2" \
       +map test \
       -nomonsters
