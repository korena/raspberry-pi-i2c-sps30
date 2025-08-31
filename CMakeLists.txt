cmake_minimum_required(VERSION 3.10)

project(sps30_i2c C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

option(BUILD_EXAMPLE "Build example program" OFF)
set(I2C_DEVICE_PATH "/dev/i2c-1" CACHE STRING "path to SPS30 i2c device")

set(SOURCES sensirion_common.c sensirion_i2c.c sensirion_i2c_hal.c sps30_i2c.c)
set(HEADERS sensirion_common.h sensirion_i2c.h sensirion_i2c_hal.h sps30_i2c.h)
add_library(sps30_i2c STATIC ${SOURCES})
target_include_directories(sps30_i2c PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_definitions(sps30_i2c PUBLIC I2C_DEVICE_PATH="${I2C_DEVICE_PATH}")
install(FILES ${HEADERS} DESTINATION include)
set_target_properties(sps30_i2c PROPERTIES PUBLIC_HEADER "${HEADERS}")

if(BUILD_EXAMPLE)
  add_subdirectory(example-usage)
endif()
