#!/bin/bash

# Download and build TA-Lib
set -e

# set TALIB_C_VER=0.6.2
# set TALIB_PY_VER=0.6.0

CMAKE_GENERATOR="Unix Makefiles"
CMAKE_BUILD_TYPE="Release"
CMAKE_CONFIGURATION_TYPES="Release"

curl -L -o talib-c.zip https://github.com/TA-Lib/ta-lib/archive/refs/tags/v${TALIB_C_VER}.zip
if [ $? -ne 0 ]; then exit 1; fi

curl -L -o talib-python.zip https://github.com/TA-Lib/ta-lib-python/archive/refs/tags/TA_Lib-${TALIB_PY_VER}.zip
if [ $? -ne 0 ]; then exit 1; fi

unzip talib-c.zip
if [ $? -ne 0 ]; then exit 1; fi

unzip talib-python.zip
if [ $? -ne 0 ]; then exit 1; fi

# git apply --verbose --binary talib.diff
# if [ $? -ne 0 ]; then exit 1; fi

cd ta-lib-${TALIB_C_VER}

mkdir -p include/ta-lib
cp -r include/* include/ta-lib

mkdir _build
cd _build

cmake ..
if [ $? -ne 0 ]; then exit 1; fi

make -j$(nproc)
if [ $? -ne 0 ]; then exit 1; fi

cp -f libta_lib.a libta_lib.so

cd ../..
