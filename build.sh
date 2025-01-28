#!/bin/bash

# Stop on any error
set -e

# Set versions
TALIB_C_VER=0.6.2
TALIB_PY_VER=0.6.0

# Create a directory for the build
mkdir -p build
cd build

# Download TA-Lib C library
echo "Downloading TA-Lib C library..."
curl -L -o talib-c.zip https://github.com/TA-Lib/ta-lib/archive/refs/tags/v${TALIB_C_VER}.zip
unzip talib-c.zip
rm talib-c.zip

# Download TA-Lib Python binding
echo "Downloading TA-Lib Python binding..."
curl -L -o talib-python.zip https://github.com/TA-Lib/ta-lib-python/archive/refs/tags/TA_Lib-${TALIB_PY_VER}.zip
unzip talib-python.zip
rm talib-python.zip

# Build TA-Lib C library
echo "Building TA-Lib C library..."
cd ta-lib-${TALIB_C_VER}
mkdir -p include/ta-lib
cp -r include/* include/ta-lib/

mkdir _build
cd _build

cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)

# Copy the library to a standard location
sudo cp ta_lib.* /usr/local/lib/
sudo cp -r ../include/ta-lib /usr/local/include/

cd ../..

# Build TA-Lib Python binding
echo "Building TA-Lib Python binding..."
cd ta-lib-python-TA_Lib-${TALIB_PY_VER}

# Set environment variables for the Python binding
export TA_LIBRARY_PATH="/usr/local/lib"
export TA_INCLUDE_PATH="/usr/local/include"

python setup.py build
python setup.py install

echo "TA-Lib build and installation completed successfully."
