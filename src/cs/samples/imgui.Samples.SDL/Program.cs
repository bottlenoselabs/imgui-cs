using System;
using C2CS;
using static SDL;

#pragma warning disable CA1806

namespace imgui.Samples.SDL
{
    internal static unsafe class Program
    {
	    private static int Main()
        {
            string glslVersion;
            
            if (SDL_Init(SDL_INIT_VIDEO) != 0)
            {
                SDL_Log($"failed to init: {SDL_GetError()}");
                return -1;
            }

            var isApple = Runtime.OperatingSystem is
                RuntimeOperatingSystem.macOS or 
                RuntimeOperatingSystem.iOS or 
                RuntimeOperatingSystem.tvOS;
            if (isApple)
            {
                // GL 3.2 Core + GLSL 150
                glslVersion = "#version 150";
                SDL_GL_SetAttribute(SDL_GLattr.SDL_GL_CONTEXT_FLAGS, SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG);
                SDL_GL_SetAttribute(SDL_GLattr.SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
                SDL_GL_SetAttribute(SDL_GLattr.SDL_GL_CONTEXT_MAJOR_VERSION, 3);
                SDL_GL_SetAttribute(SDL_GLattr.SDL_GL_CONTEXT_MINOR_VERSION, 2);
            }
            else
            {
                // GL 3.0 + GLSL 130
                glslVersion = "#version 130";
                SDL_GL_SetAttribute(SDL_GLattr.SDL_GL_CONTEXT_FLAGS, 0);
                SDL_GL_SetAttribute(SDL_GLattr.SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
                SDL_GL_SetAttribute(SDL_GLattr.SDL_GL_CONTEXT_MAJOR_VERSION, 3);
                SDL_GL_SetAttribute(SDL_GLattr.SDL_GL_CONTEXT_MINOR_VERSION, 0);   
            }
            
            SDL_SetHint(SDL_HINT_RENDER_DRIVER, "opengl");
            SDL_GL_SetAttribute(SDL_GLattr.SDL_GL_DEPTH_SIZE, 24);
            SDL_GL_SetAttribute(SDL_GLattr.SDL_GL_STENCIL_SIZE, 8);
            SDL_GL_SetAttribute(SDL_GLattr.SDL_GL_DOUBLEBUFFER, 1);
            SDL_DisplayMode current;
            SDL_GetCurrentDisplayMode(0, &current);
  
            var window = SDL_CreateWindow(
                "Hello",
                0,
                0,
                1024,
                768,
                SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE
            );
            
            if (window == (void*)0)
            {
                SDL_Log($"Failed to create window: {SDL_GetError()}");
                return -1;
            }
            
            var glContext = SDL_GL_CreateContext(window);
            SDL_GL_SetSwapInterval(1); // attempt to enable vsync
            
            Console.WriteLine(glslVersion);

            return 0;
        }
    }
}