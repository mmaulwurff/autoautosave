#!/bin/bash

set -e

name=autoautosave-$(git describe --abbrev=0 --tags).pk3

rm -f "$name"

git log --date=short --pretty=format:"-%d %ad %s%n" | \
    grep -v "^$" | \
    sed "s/HEAD -> master, //" | \
    sed "s/, origin\/master//" | \
    sed "s/ (HEAD -> master)//" | \
    sed "s/ (origin\/master)//"  |\
    sed "s/- (tag: \(v\?[0-9.]*\))/\n\1\n-/" \
    > changelog.txt

./scripts/gen-files.sh

zip -0 -R "$name" \
    "*.md"  \
    "*.ogg" \
    "*.txt" \
    "*.zs"

gzdoom -file "$name" "$@"
