#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
LIB_DIR="$DIR/lib"
mkdir -p $LIB_DIR

if [[ ! -z "$1" ]]; then
    TARGET_BUILD_PLATFORM="$1"
fi

echo "Started '$0' $1 $2 $3"

function set_target_build_platform_host() {
    uname_str="$(uname -a)"
    case "${uname_str}" in
        *Microsoft*)    TARGET_BUILD_PLATFORM="microsoft";;
        *microsoft*)    TARGET_BUILD_PLATFORM="microsoft";;
        Linux*)         TARGET_BUILD_PLATFORM="linux";;
        Darwin*)        TARGET_BUILD_PLATFORM="apple";;
        CYGWIN*)        TARGET_BUILD_PLATFORM="linux";;
        MINGW*)         TARGET_BUILD_PLATFORM="microsoft";;
        *Msys)          TARGET_BUILD_PLATFORM="microsoft";;
        *)              TARGET_BUILD_PLATFORM="UNKNOWN:${uname_str}"
    esac
}

function set_target_build_platform {
    if [[ ! -z "$TARGET_BUILD_PLATFORM" ]]; then
        if [[ $TARGET_BUILD_PLATFORM == "default" ]]; then
            set_target_build_platform_host
            echo "Build platform: '$TARGET_BUILD_PLATFORM' (host default)"
        else
            if [[ "$TARGET_BUILD_PLATFORM" == "microsoft" || "$TARGET_BUILD_PLATFORM" == "linux" || "$TARGET_BUILD_PLATFORM" == "apple" ]]; then
                echo "Build platform: '$TARGET_BUILD_PLATFORM' (cross-compile override)"
            else
                echo "Unknown '$TARGET_BUILD_PLATFORM' passed as first argument. Use 'default' to use the host build platform or use either: 'microsoft', 'linux', 'apple'."
                exit 1
            fi
        fi
    else
        set_target_build_platform_host
        echo "Build platform: '$TARGET_BUILD_PLATFORM' (host default)"
    fi
}

set_target_build_platform
if [[ "$TARGET_BUILD_PLATFORM" == "microsoft" ]]; then
    CMAKE_TOOLCHAIN_ARGS="-DCMAKE_TOOLCHAIN_FILE=$DIR/mingw-w64-x86_64.cmake"
elif [[ "$TARGET_BUILD_PLATFORM" == "linux" ]]; then
    CMAKE_TOOLCHAIN_ARGS=""
elif [[ "$TARGET_BUILD_PLATFORM" == "apple" ]]; then
    CMAKE_TOOLCHAIN_ARGS=""
else
    echo "Unknown: $TARGET_BUILD_PLATFORM"
    exit 1
fi

function exit_if_last_command_failed() {
    error=$?
    if [ $error -ne 0 ]; then
        echo "Last command failed: $error"
        exit $error
    fi
}

function build_imgui() {
    echo "Building cimgui..."
    CIMGUI_BUILD_DIR="$DIR/cmake-build-release"
    cmake $CMAKE_TOOLCHAIN_ARGS -S $DIR/ext/cimgui -B $CIMGUI_BUILD_DIR
    cmake --build $CIMGUI_BUILD_DIR --config Release

    if [[ "$TARGET_BUILD_PLATFORM" == "linux" ]]; then
        CIMGUI_LIBRARY_FILENAME="cimgui.so"
        CIMGUI_LIBRARY_FILE_PATH_BUILD="$(readlink -f $CIMGUI_BUILD_DIR/$CIMGUI_LIBRARY_FILENAME)"
    elif [[ "$TARGET_BUILD_PLATFORM" == "apple" ]]; then
        CIMGUI_LIBRARY_FILENAME="cimgui.dylib"
        CIMGUI_LIBRARY_FILE_PATH_BUILD="$CIMGUI_BUILD_DIR/$CIMGUI_LIBRARY_FILENAME"
    elif [[ "$TARGET_BUILD_PLATFORM" == "microsoft" ]]; then
        CIMGUI_LIBRARY_FILENAME="cimgui.dll"
        CIMGUI_LIBRARY_FILE_PATH_BUILD="$CIMGUI_BUILD_DIR/$CIMGUI_LIBRARY_FILENAME"
    fi
    CIMGUI_LIBRARY_FILE_PATH="$LIB_DIR/$CIMGUI_LIBRARY_FILENAME"

    if [[ ! -f "$CIMGUI_LIBRARY_FILE_PATH_BUILD" ]]; then
        echo "The file '$CIMGUI_LIBRARY_FILE_PATH_BUILD' does not exist!"
        exit 1
    fi

    mv "$CIMGUI_LIBRARY_FILE_PATH_BUILD" "$CIMGUI_LIBRARY_FILE_PATH"
    exit_if_last_command_failed
    echo "Copied '$CIMGUI_LIBRARY_FILE_PATH_BUILD' to '$CIMGUI_LIBRARY_FILE_PATH'"

    rm -r $CIMGUI_BUILD_DIR
    exit_if_last_command_failed
    echo "Building cimgui finished!"
}

build_imgui
ls -d "$LIB_DIR"/*

echo "Finished '$0'!"