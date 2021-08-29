cmake_minimum_required(VERSION 3.16)

project(cimgui)

set(CMAKE_C_STANDARD 99)

get_filename_component(CIMGUI_PATH "../../../ext/cimgui" REALPATH BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
get_filename_component(CIMGUI_GEN_OUTPUT_PATH "../../../ext/cimgui/generator/output" REALPATH BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
include_directories(${CIMGUI_PATH} ${CIMGUI_GEN_OUTPUT_PATH})

set (CMAKE_SYSTEM_VERSION 10.0 (latest installed version))

set(SOURCES "cimgui_lib.c")

add_library(cimgui SHARED ${SOURCES})
add_library(cimgui_static STATIC ${SOURCES})
set_target_properties(cimgui_static PROPERTIES OUTPUT_NAME "cimgui")