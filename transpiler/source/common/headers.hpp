/**
 * @brief 
 * Commnly used headers
**/

#pragma once

// Basic configurations
// #pragma execution_character_set("utf-8") (NOT STANDARD)

// Basic C++ headers
//#include <iostream>
//#include <fstream>
//#include <sstream>
#include <string>
#include <iostream>
#include <ostream>
#include <vector>
#include <array>

// Include platform headers
#ifdef _WIN32
    #include <Windows.h>
#elif __linux__ // Linux
    #include <unistd.h>
#elif __APPLE__ // macOS (and other Apple platforms)
    #include <mach/mach_time.h>
//#elif __EMSCRIPTEN__ // WASM (maybe? It'd be useful but it requires a lot of effort to implement)
//    #include <emscripten.h>
#else
  // ???
#endif

// If you decide to support WASM, expose library members like this:
//#if __EMSCRIPTEN__ // WASM
//#   define FRANKIE_BASE_API "C" EMSCRIPTEN_KEEPALIVE
//#endif
// Then you could compile the dynamic libraries into WASM side modules!
// For more info, check https://developer.mozilla.org/en-US/docs/WebAssembly/Guides/C_to_Wasm
// (side note: as of now, I am not sure if the preferred compiler supports dynamic library linking or the
// imported external libraries)
