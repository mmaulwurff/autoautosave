#!/bin/bash

rm -f sounds/*
rm -f sounds_wav/*

mkdir -p sounds
mkdir -p sounds_wav

params="-s140 -p0 -g10 -v english"

espeak "All enemies eliminated." $params -w sounds_wav/m8faas1.wav
espeak "Boss eliminated." $params -w sounds_wav/m8faas2.wav
espeak "No more active enemies." $params -w sounds_wav/m8faas3.wav
espeak "New active enemies." $params -w sounds_wav/m8faas4.wav
espeak "Boss alerted." $params -w sounds_wav/m8faas5.wav
espeak "All items found." $params -w sounds_wav/m8faas6.wav
espeak "Time passed." $params -w sounds_wav/m8faas7.wav
espeak "You are moved to another place." $params -w sounds_wav/m8faas8.wav
espeak "Health low." $params -w sounds_wav/m8faas9.wav
espeak "Health high." $params -w sounds_wav/m8faas10.wav
espeak "Armor low." $params -w sounds_wav/m8faas11.wav
espeak "Armor high." $params -w sounds_wav/m8faas12.wav
espeak "Secret found." $params -w sounds_wav/m8faas13.wav
espeak "Powerup found." $params -w sounds_wav/m8faas14.wav
espeak "Weapon found." $params -w sounds_wav/m8faas15.wav
espeak "Key found." $params -w sounds_wav/m8faas16.wav
espeak "Backpack found." $params -w sounds_wav/m8faas17.wav
espeak "New armor type." $params -w sounds_wav/m8faas18.wav
espeak "Major healing." $params -w sounds_wav/m8faas19.wav

cd sounds_wav
for f in *;
do
    oggenc -Q -o ../sounds/${f%.*}.ogg $f
done
cd ..
