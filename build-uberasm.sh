#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="${RUNNER_TEMP:-/tmp}/uberasm"
ARTIFACT_DIR="$ROOT_DIR/artifacts/uberasm"

echo "Building UberASM..."

rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR" "$ARTIFACT_DIR"

cd "$WORK_DIR"

git clone https://github.com/tOaO-zer0/UberASMTool.git

cd UberASMTool/UberASMTool

dotnet restore

cd ..

dotnet msbuild UberASMTool.sln \
    -t:Rebuild,publish \
    -p:Configuration=Release,PlatformTarget=AnyCPU,BootstrapperEnabled=false,TargetFramework=net8.0,SelfContained=true,PublishTrimmed=True,PublishSingleFile=True,RuntimeIdentifier=linux-x64

cd UberASMTool/bin/Release/net8.0/linux-x64/publish
cp UberASMTool "$ARTIFACT_DIR/"
cp UberASMTool.dll.config "$ARTIFACT_DIR/"
cp UberASMTool.pdb "$ARTIFACT_DIR/"

cd "$WORK_DIR/UberASMTool"
cp -r assets/. "$ARTIFACT_DIR/"

echo "UberASM build done."