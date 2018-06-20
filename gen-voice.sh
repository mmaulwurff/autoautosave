#!/bin/bash

rm -f sounds/*
rm -f sounds_wav/*

mkdir -p sounds
mkdir -p sounds_wav

params="-s140 -p0 -g10 -v english"
i="-1"
filename="sounds_wav/m8faas"

echo "// This file is generated automatically!" >  sndinfo.txt
echo "// All changed will be lost!"             >> sndinfo.txt
echo "// see gen-voice.sh for details."         >> sndinfo.txt
echo "" >> sndinfo.txt

i=$(($i+1)); espeak "All enemies eliminated."         $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Boss eliminated."                $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "No more active enemies."         $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "New active enemies."             $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Boss alerted."                   $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "All items found."                $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Tick."                           $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Time passed."                    $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "You are moved to another place." $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Health low."                     $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Health high."                    $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Armor low."                      $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Armor high."                     $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Secret found."                   $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Powerup found."                  $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Weapon found."                   $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Key found."                      $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Backpack found."                 $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "New armor type."                 $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Major healing."                  $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt
i=$(($i+1)); espeak "Manual save."                    $params -w $filename$i".wav"; echo "aas/voice$i m8faas$i" >> sndinfo.txt

cd sounds_wav
for f in *;
do
    oggenc -Q -o ../sounds/${f%.*}.ogg $f
done
cd ..
