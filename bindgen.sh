#!/bin/bash

function exitIfLastCommandFailed() {
    error=$?
    if [ $error -ne 0 ]; then
        exit $error
    fi
}

function download_C2CS_ubuntu() {
    if [ ! -f "./C2CS" ]; then
        wget https://nightly.link/lithiumtoast/c2cs/workflows/build-test-deploy/develop/ubuntu.20.04-x64.zip
        unzip ./ubuntu.20.04-x64.zip
        rm ./ubuntu.20.04-x64.zip
        chmod +x ./C2CS
    fi
}

function download_C2CS_osx() {
    if [ ! -f "./C2CS" ]; then
        wget https://nightly.link/lithiumtoast/c2cs/workflows/build-test-deploy/develop/osx-x64.zip
        unzip ./osx-x64.zip
        rm ./osx-x64.zip
        chmod +x ./C2CS
    fi
}

function bindgen() {
    ./C2CS ast -i ./src/c/cimgui/cimgui_lib.h -o ./ast/cimgui.json -s ./ext/cimgui ./ext/cimgui/generator/output -b 64
    exitIfLastCommandFailed
    ./C2CS cs -i ./ast/cimgui.json -o ./src/cs/production/imgui-cs/imgui.cs -l "cimgui" -c "imgui" --namespaces "System.Numerics" -g ./ignored.txt -a \
"ImWchar -> char" \
"ImWchar16 -> char" \
"ImWchar32 -> uint" \
"ImVec4 -> Vector4" \
"ImVec3 -> Vector3" \
"ImVec2 -> Vector2" \
"ImVec1 -> float" \
"ImU64 -> ulong" \
"ImU32 -> uint" \
"ImU16 -> ushort" \
"ImU8 -> byte" \
"ImS64 -> long" \
"ImS32 -> int" \
"ImS16 -> short" \
"ImS8 -> sbyte"
    exitIfLastCommandFailed
}

unamestr="$(uname | tr '[:upper:]' '[:lower:]')"
if [[ "$unamestr" == "linux" ]]; then
    download_C2CS_ubuntu
elif [[ "$unamestr" == "darwin" ]]; then
    download_C2CS_osx
else
    echo "Unknown platform: '$unamestr'."
fi

bindgen
