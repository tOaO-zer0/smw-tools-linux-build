#!/usr/bin/env bash
set -e

echo "Building PIXI..."

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="${RUNNER_TEMP:-/tmp}/pixi"
ARTIFACT_DIR="$ROOT_DIR/artifacts/pixi"

mkdir -p "$WORK_DIR"
mkdir -p "$ARTIFACT_DIR"

cd "$WORK_DIR"

git clone https://github.com/JackTheSpades/SpriteToolSuperDelux.git
cd SpriteToolSuperDelux

cmake -B build -S . -DASAR_USE_DLL=ON
cmake --build build --config Release

cd build/src/
cp pixi "$ARTIFACT_DIR/"


cd "$WORK_DIR"/SpriteToolSuperDelux
for DIR in \
    asm \
    cluster \
    extended \
    generators \
    misc_sprites \
    routines \
    shooters \
    sprites
do
    cp -r "./$DIR" "$ARTIFACT_DIR/"
done

for FILE in \
    list.txt \
    LICENSE \
    README.md \
    CHANGELOG.md
do
    if [ -f "$FILE" ]; then
        cp "$FILE" "$ARTIFACT_DIR/"
    fi
done



echo "pixi build done."
