#!/usr/bin/env bash

mkdir -p build && cd build
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DBUILD_EXAMPLE=ON -DI2C_DEVICE_PATH="/dev/i2c-0" ..
cmake --build .
cp ./compile_commands.json ../

