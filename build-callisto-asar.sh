#!/usr/bin/env bash
set -e

echo "Building ASAR..."

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="${RUNNER_TEMP:-/tmp}/callisto-asar"
ARTIFACT_DIR="$ROOT_DIR/artifacts/callisto-asar"

mkdir -p "$WORK_DIR"
mkdir -p "$ARTIFACT_DIR"

cd "$WORK_DIR"

git clone https://github.com/tOaO-zer0/callisto-asar
cd callisto-asar

git checkout v1.9-callisto
cd src

# 32-bit build
cmake -B build-32 -S . -DCMAKE_C_FLAGS="-m32" -DCMAKE_CXX_FLAGS="-m32" -DCMAKE_EXE_LINKER_FLAGS="-m32"
cmake --build build-32

cp build-32/asar/lib/libasar.so "$ARTIFACT_DIR/libasar-32.so"

# 64-bit build
cmake -B build-64 -S .
cmake --build build-64

cp build-64/asar/lib/libasar.so "$ARTIFACT_DIR/libasar-64.so"

echo "Callisto ASAR build done."
