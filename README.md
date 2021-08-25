# imgui-cs

Automatically updated C# bindings for https://github.com/ocornut/imgui with native dynamic link libraries.

## How to use

### From source

1. Download and install [.NET 5](https://dotnet.microsoft.com/download).
2. Fork the repository using GitHub or clone the repository manually with submodules: `git clone --recurse-submodules git@github.com:lithiumtoast/imgui-cs.git`.
3. Build the native library by running `./library.sh` on macOS or Linux and `.\library.sh` on Windows.
4. Add the C# project `./src/cs/production/imgui-cs/imgui-cs.csproj` to your solution:
```xml
<ItemGroup>
    <ProjectReference Include="path/to/sdl-cs/src/cs/production/SDL-cs/SDL-cs.csproj" />
</ItemGroup>
```

#### Bindgen

If you wish to re-generate the bindings, simple run `./bindgen.sh` on macOS or Linux and `.\bindgen.cmd` on Windows.

## Developers: Documentation

For more information on how C# bindings work, see [`C2CS`](https://github.com/lithiumtoast/c2cs), the tool that generates the bindings for `imgui` and other C libraries.

To learn how to use `imgui`, check out the [official wiki](https://github.com/ocornut/imgui/wiki).

## License

`imgui-cs` is licensed under the MIT License (`MIT`) - see the [LICENSE file](LICENSE) for details.

`imgui` itself is licensed under MIT License (`MIT`) - see https://github.com/ocornut/imgui/blob/master/LICENSE.txt for more details.

