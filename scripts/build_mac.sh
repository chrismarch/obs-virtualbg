#!/bin/bash

set -xe
pushd $(dirname $0)/..

OBS_VERSION=$(brew info --json=v2 --cask obs | jq -r .casks[0].version)
LLVM_VERSION=$(brew info --json=v2 llvm | jq -r .formulae[0].installed[0].version)

[ -d deps ] || mkdir deps
[ -d deps/obs-studio ] && rm -rf deps/obs-studio
git -C deps clone --single-branch --depth 1 -b ${OBS_VERSION} https://github.com/obsproject/obs-studio.git
[ -d build ] && rm -rf build
mkdir build
pushd build
  # cmake .. -DobsPath=../deps/obs-studio -DLLVM_DIR=/usr/local/Cellar/llvm/12.0.1/lib/cmake/llvm
  cmake .. -DobsLibPath=/Applications/OBS.app/Contents/Frameworks -DobsIncludePath=$(cd ../deps/obs-studio/libobs; pwd) -DOnnxRuntimePath=$(cd ../deps/onnxruntime; pwd) -DLLVM_DIR=/usr/local/Cellar/llvm/${LLVM_VERSION}/lib/cmake/llvm
  cmake --build . --config Release
  cpack
popd