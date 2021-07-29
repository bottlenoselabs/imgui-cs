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
    ./C2CS ast -i ./ext/cimgui/cimgui.h -o ./ast.json -s ./ext/cimgui -b 64 -d CIMGUI_DEFINE_ENUMS_AND_STRUCTS
    exitIfLastCommandFailed
    ./C2CS cs -i ./sokol.json -o ./src/cs/production/imgui-cs/imgui.cs -l "cimgui" -c "imgui"
    exitIfLastCommandFailed
    rm ./ast.json
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
