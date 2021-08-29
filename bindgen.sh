#!/bin/bash
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

function exitIfLastCommandFailed() {
    error=$?
    if [ $error -ne 0 ]; then
        exit $error
    fi
}

function download_C2CS_ubuntu() {
    if [ ! -f "$script_dir/C2CS" ]; then
        wget https://nightly.link/lithiumtoast/c2cs/workflows/build-test-deploy/develop/ubuntu.20.04-x64.zip -P $script_dir/
        unzip $script_dir/ubuntu.20.04-x64.zip -d $script_dir/
        rm $script_dir/ubuntu.20.04-x64.zip
        chmod +x $script_dir/C2CS
    fi
}

function download_C2CS_osx() {
    if [ ! -f "$script_dir/C2CS" ]; then
        wget https://nightly.link/lithiumtoast/c2cs/workflows/build-test-deploy/develop/osx-x64.zip -P $script_dir/
        unzip $script_dir/osx-x64.zip -d $script_dir/
        rm $script_dir/osx-x64.zip
        chmod +x $script_dir/C2CS
    fi
}

function bindgen() {
    $script_dir/C2CS ast -i $script_dir/src/c/cimgui/cimgui_lib.h -o $script_dir/ast/cimgui.json -s $script_dir/ext/cimgui $script_dir/ext/cimgui/generator/output -b 64
    exitIfLastCommandFailed
    $script_dir/C2CS cs -i $script_dir/ast/cimgui.json -o $script_dir/src/cs/production/imgui-cs/imgui.cs -l "cimgui" -c "imgui" --namespaces "System.Numerics" -g $script_dir/ignored.txt \
-a \
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
