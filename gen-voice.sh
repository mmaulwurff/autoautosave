#!/bin/bash

rm sounds/*

params="-s140 -p0 -g10 -v english"

espeak "All enemies eliminated." $params -w sounds/m8faas1.wav
espeak "Boss eliminated." $params -w sounds/m8faas2.wav
espeak "No more active enemies." $params -w sounds/m8faas3.wav
espeak "New active enemies." $params -w sounds/m8faas4.wav
espeak "Boss alerted." $params -w sounds/m8faas5.wav
espeak "All items found." $params -w sounds/m8faas6.wav
espeak "Time passed." $params -w sounds/m8faas7.wav
espeak "You are moved to another place." $params -w sounds/m8faas8.wav
espeak "Health low." $params -w sounds/m8faas9.wav
espeak "Health high." $params -w sounds/m8faas10.wav
espeak "Armor low." $params -w sounds/m8faas11.wav
espeak "Armor high." $params -w sounds/m8faas12.wav
espeak "Secret found." $params -w sounds/m8faas13.wav
espeak "Powerup found." $params -w sounds/m8faas14.wav
espeak "Weapon found." $params -w sounds/m8faas15.wav
espeak "Key found." $params -w sounds/m8faas16.wav
espeak "Backpack found." $params -w sounds/m8faas17.wav
espeak "New armor type." $params -w sounds/m8faas18.wav
espeak "Major healing." $params -w sounds/m8faas19.wav
