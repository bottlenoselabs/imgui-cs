# imgui-cs

Automatically updated C# bindings for https://github.com/cimgui/cimgui (and thus https://github.com/ocornut/imgui) with native dynamic link libraries.

## How to use

### From source

1. Download and install [.NET 7](https://dotnet.microsoft.com/download).
2. Fork the repository using GitHub or clone the repository manually with submodules: `git clone --recurse-submodules https://github.com/bottlenoselabs/imgui-cs`.
3. Build the native library by running `library.sh`. To execute `.sh` scripts on Windows, use Git Bash which can be installed with Git itself: https://git-scm.com/download/win. The `library.sh` script requires that CMake is installed and in your path.
4. Add the C# project to your solution: `./src/cs/production/ImGui/ImGui.csproj`.

## Developers: Documentation

For more information on how C# bindings work, see [`C2CS`](https://github.com/lithiumtoast/c2cs), the tool that generates the bindings for `cimgui` and other C libraries.

To learn how to use `imgui`, check out the [official wiki](https://github.com/ocornut/imgui/wiki).

## License

`imgui-cs` is licensed under the MIT License (`MIT`) - see the [LICENSE file](LICENSE) for details.

`imgui` itself is licensed under MIT License (`MIT`) - see https://github.com/ocornut/imgui/blob/master/LICENSE.txt for more details.

