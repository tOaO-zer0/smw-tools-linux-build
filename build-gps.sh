#!/usr/bin/env bash
set -e

echo "Building GPS..."

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="${RUNNER_TEMP:-/tmp}/gps"
ARTIFACT_DIR="$ROOT_DIR/artifacts/gps"

mkdir -p "$WORK_DIR"
mkdir -p "$ARTIFACT_DIR"

cd "$WORK_DIR"

wget -O gps.zip https://dl.smwcentral.net/40056/GPS%28V1.4.5%29.zip
unzip gps.zip
unzip src.zip
g++ main.cpp asar/asardll.c -o gps
cp gps "$ARTIFACT_DIR/"

for DIR in \
    blocks \
    routines
do
    cp -r "./$DIR" "$ARTIFACT_DIR/"
done

for FILE in \
    list.txt \
    Changes.txt \
    defines.asm \
    main.asm \
    README.txt \
    CHANGELOG.md
do
    if [ -f "$FILE" ]; then
        cp "$FILE" "$ARTIFACT_DIR/"
    fi
done

echo "GPS build done."
