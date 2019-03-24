#!/bin/bash

name=autoautosave
#gzdoom=gzdoom
gzdoom=~/Documents/src/gzdoom-build/gzdoom

git log --date=short --pretty=format:"-%d %ad %s%n" | \
    grep -v "^$" | \
    sed "s/HEAD -> master, //" | \
    sed "s/, origin\/master//" | \
    sed "s/ (HEAD -> master)//" | \
    sed "s/ (origin\/master)//"  |\
    sed "s/- (tag: \(v\?[0-9.]*\))/\n\1\n-/" \
    > changelog.txt \
&& \
rm -f $name.pk3 \
&& \
./gen-files.sh \
&& \
zip $name.pk3 \
    *.txt \
    *.zs \
    *.md \
    sounds/*.ogg \
    zscript/*.zs \
&& \
cp -f $name.pk3 $name-$(git describe --abbrev=0 --tags).pk3 \
&& \
$gzdoom \
       -file \
       $name.pk3 \
       ~/Programs/Games/wads/maps/DOOMTEST.wad \
       "$1" "$2" \
       +map test \
       -nomonsters \
       +notarget
