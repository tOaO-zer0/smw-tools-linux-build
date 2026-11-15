#!/usr/bin/env bash
set -e

echo "Preparing Callisto build..."

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="${RUNNER_TEMP:-/tmp}/callisto"
ARTIFACT_DIR="$ROOT_DIR/artifacts/callisto"

mkdir -p "$WORK_DIR"
mkdir -p "$ARTIFACT_DIR"

# Build Boost 1.84 if not already present
if [ ! -d "/usr/local/include/boost" ]; then
    echo "Building Boost 1.84..."

    cd /tmp

  echo "Downloading boost..."
    wget -O boost_1_84_0.tar.gz \
        https://archives.boost.io/release/1.84.0/source/boost_1_84_0.tar.gz

    tar xzf boost_1_84_0.tar.gz

    cd boost_1_84_0

    ./bootstrap.sh --prefix=/usr/local

    sudo ./b2 install \
        --with-system \
        --with-filesystem \
        --with-thread \
        --with-program_options \
        -j"$(nproc)"

    sudo ldconfig

    echo "Boost 1.84 installed."

    cd /tmp
    sudo rm -rf boost_1_84_0 boost_1_84_0.tar.gz
fi

echo "Building Callisto..."

git clone https://github.com/tOaO-zer0/callisto.git "$WORK_DIR/callisto"
cd "$WORK_DIR/callisto"
git checkout all-linux-fixes

cmake -B build -S .
cmake --build build --parallel "$(nproc)"

cd build/callisto
cp callisto "$ARTIFACT_DIR/"

for DIR in \
    config \
    initial_patches
do
    cp -r "./$DIR" "$ARTIFACT_DIR/"
done

for FILE in \
    LICENSE \
    ASAR_LICENSE
do
    if [ -f "$FILE" ]; then
        cp "$FILE" "$ARTIFACT_DIR/"
    fi
done


echo "Callisto build done."