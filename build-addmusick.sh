#!/usr/bin/env bash
set -e

echo "Building AddmusicK..."

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="${RUNNER_TEMP:-/tmp}/addmusick"
ARTIFACT_DIR="$ROOT_DIR/artifacts/addmusick"

mkdir -p "$WORK_DIR"
mkdir -p "$ARTIFACT_DIR"

cd "$WORK_DIR"

wget -O addmusick.zip https://dl.smwcentral.net/37906/AddmusicK%201.0.11.zip
unzip addmusick.zip
cd AddmusicK_1.0.11
unzip src.zip
make
cp AddmusicK "$ARTIFACT_DIR/"
cp AM4Batch "$ARTIFACT_DIR/"
cp AMMBatch "$ARTIFACT_DIR/"

cp Addmusic_list.txt "$ARTIFACT_DIR/"
cp "Addmusic_sample groups.txt" "$ARTIFACT_DIR/"
cp "Addmusic_sound effects.txt" "$ARTIFACT_DIR/"

cp -R 1DF9/ "$ARTIFACT_DIR/"
cp -R 1DFC/ "$ARTIFACT_DIR/"
cp -R asm/ "$ARTIFACT_DIR/"
cp -R music/ "$ARTIFACT_DIR/"
cp -R Visualizations/ "$ARTIFACT_DIR/"
cp -R stats/ "$ARTIFACT_DIR/"
cp -R SPCs/ "$ARTIFACT_DIR/"
cp -R samples/ "$ARTIFACT_DIR/"

echo "AddmusicK build done."
